SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: code_list; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA code_list;


--
-- Name: upvs; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA upvs;


--
-- Name: que_validate_tags(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_validate_tags(tags_array jsonb) RETURNS boolean
    LANGUAGE sql
    AS $$
  SELECT bool_and(
    jsonb_typeof(value) = 'string'
    AND
    char_length(value::text) <= 100
  )
  FROM jsonb_array_elements(tags_array)
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    id bigint NOT NULL,
    job_class text NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error_message text,
    queue text DEFAULT 'default'::text NOT NULL,
    last_error_backtrace text,
    finished_at timestamp with time zone,
    expired_at timestamp with time zone,
    args jsonb DEFAULT '[]'::jsonb NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    job_schema_version integer NOT NULL,
    kwargs jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT error_length CHECK (((char_length(last_error_message) <= 500) AND (char_length(last_error_backtrace) <= 10000))),
    CONSTRAINT job_class_length CHECK ((char_length(
CASE job_class
    WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'::text THEN ((args -> 0) ->> 'job_class'::text)
    ELSE job_class
END) <= 200)),
    CONSTRAINT queue_length CHECK ((char_length(queue) <= 100)),
    CONSTRAINT valid_args CHECK ((jsonb_typeof(args) = 'array'::text)),
    CONSTRAINT valid_data CHECK (((jsonb_typeof(data) = 'object'::text) AND ((NOT (data ? 'tags'::text)) OR ((jsonb_typeof((data -> 'tags'::text)) = 'array'::text) AND (jsonb_array_length((data -> 'tags'::text)) <= 5) AND public.que_validate_tags((data -> 'tags'::text))))))
)
WITH (fillfactor='90');


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.que_jobs IS '7';


--
-- Name: que_determine_job_state(public.que_jobs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_determine_job_state(job public.que_jobs) RETURNS text
    LANGUAGE sql
    AS $$
  SELECT
    CASE
    WHEN job.expired_at  IS NOT NULL    THEN 'expired'
    WHEN job.finished_at IS NOT NULL    THEN 'finished'
    WHEN job.error_count > 0            THEN 'errored'
    WHEN job.run_at > CURRENT_TIMESTAMP THEN 'scheduled'
    ELSE                                     'ready'
    END
$$;


--
-- Name: que_job_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_job_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    locker_pid integer;
    sort_key json;
  BEGIN
    -- Don't do anything if the job is scheduled for a future time.
    IF NEW.run_at IS NOT NULL AND NEW.run_at > now() THEN
      RETURN null;
    END IF;

    -- Pick a locker to notify of the job's insertion, weighted by their number
    -- of workers. Should bounce pseudorandomly between lockers on each
    -- invocation, hence the md5-ordering, but still touch each one equally,
    -- hence the modulo using the job_id.
    SELECT pid
    INTO locker_pid
    FROM (
      SELECT *, last_value(row_number) OVER () + 1 AS count
      FROM (
        SELECT *, row_number() OVER () - 1 AS row_number
        FROM (
          SELECT *
          FROM public.que_lockers ql, generate_series(1, ql.worker_count) AS id
          WHERE
            listening AND
            queues @> ARRAY[NEW.queue] AND
            ql.job_schema_version = NEW.job_schema_version
          ORDER BY md5(pid::text || id::text)
        ) t1
      ) t2
    ) t3
    WHERE NEW.id % count = row_number;

    IF locker_pid IS NOT NULL THEN
      -- There's a size limit to what can be broadcast via LISTEN/NOTIFY, so
      -- rather than throw errors when someone enqueues a big job, just
      -- broadcast the most pertinent information, and let the locker query for
      -- the record after it's taken the lock. The worker will have to hit the
      -- DB in order to make sure the job is still visible anyway.
      SELECT row_to_json(t)
      INTO sort_key
      FROM (
        SELECT
          'job_available' AS message_type,
          NEW.queue       AS queue,
          NEW.priority    AS priority,
          NEW.id          AS id,
          -- Make sure we output timestamps as UTC ISO 8601
          to_char(NEW.run_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS run_at
      ) t;

      PERFORM pg_notify('que_listener_' || locker_pid::text, sort_key::text);
    END IF;

    RETURN null;
  END
$$;


--
-- Name: que_state_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_state_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    row record;
    message json;
    previous_state text;
    current_state text;
  BEGIN
    IF TG_OP = 'INSERT' THEN
      previous_state := 'nonexistent';
      current_state  := public.que_determine_job_state(NEW);
      row            := NEW;
    ELSIF TG_OP = 'DELETE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := 'nonexistent';
      row            := OLD;
    ELSIF TG_OP = 'UPDATE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := public.que_determine_job_state(NEW);

      -- If the state didn't change, short-circuit.
      IF previous_state = current_state THEN
        RETURN null;
      END IF;

      row := NEW;
    ELSE
      RAISE EXCEPTION 'Unrecognized TG_OP: %', TG_OP;
    END IF;

    SELECT row_to_json(t)
    INTO message
    FROM (
      SELECT
        'job_change' AS message_type,
        row.id       AS id,
        row.queue    AS queue,

        coalesce(row.data->'tags', '[]'::jsonb) AS tags,

        to_char(row.run_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS run_at,
        to_char(now()      AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS time,

        CASE row.job_class
        WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper' THEN
          coalesce(
            row.args->0->>'job_class',
            'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'
          )
        ELSE
          row.job_class
        END AS job_class,

        previous_state AS previous_state,
        current_state  AS current_state
    ) t;

    PERFORM pg_notify('que_state', message::text);

    RETURN null;
  END
$$;


--
-- Name: countries; Type: TABLE; Schema: code_list; Owner: -
--

CREATE TABLE code_list.countries (
    id bigint NOT NULL,
    identifier integer,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: code_list; Owner: -
--

CREATE SEQUENCE code_list.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: code_list; Owner: -
--

ALTER SEQUENCE code_list.countries_id_seq OWNED BY code_list.countries.id;


--
-- Name: courts; Type: TABLE; Schema: code_list; Owner: -
--

CREATE TABLE code_list.courts (
    id bigint NOT NULL,
    name character varying,
    street character varying,
    number character varying,
    postal_code character varying,
    municipality character varying,
    identifier integer,
    code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: courts_id_seq; Type: SEQUENCE; Schema: code_list; Owner: -
--

CREATE SEQUENCE code_list.courts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courts_id_seq; Type: SEQUENCE OWNED BY; Schema: code_list; Owner: -
--

ALTER SEQUENCE code_list.courts_id_seq OWNED BY code_list.courts.id;


--
-- Name: currencies; Type: TABLE; Schema: code_list; Owner: -
--

CREATE TABLE code_list.currencies (
    id bigint NOT NULL,
    identifier integer,
    value character varying,
    code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: currencies_id_seq; Type: SEQUENCE; Schema: code_list; Owner: -
--

CREATE SEQUENCE code_list.currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: code_list; Owner: -
--

ALTER SEQUENCE code_list.currencies_id_seq OWNED BY code_list.currencies.id;


--
-- Name: municipalities; Type: TABLE; Schema: code_list; Owner: -
--

CREATE TABLE code_list.municipalities (
    id bigint NOT NULL,
    identifier integer,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: municipalities_id_seq; Type: SEQUENCE; Schema: code_list; Owner: -
--

CREATE SEQUENCE code_list.municipalities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: municipalities_id_seq; Type: SEQUENCE OWNED BY; Schema: code_list; Owner: -
--

ALTER SEQUENCE code_list.municipalities_id_seq OWNED BY code_list.municipalities.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: apps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.apps (
    id bigint NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    image_name text NOT NULL,
    published_status text NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    short_description text
);


--
-- Name: apps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.apps_id_seq OWNED BY public.apps.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    featured boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    featured_position integer DEFAULT 0
);


--
-- Name: categories_categorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories_categorizations (
    category_id bigint NOT NULL,
    categorization_id bigint NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: categorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorizations (
    id bigint NOT NULL,
    categorizable_type character varying,
    categorizable_id bigint
);


--
-- Name: categorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorizations_id_seq OWNED BY public.categorizations.id;


--
-- Name: current_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.current_topics (
    id bigint NOT NULL,
    body character varying,
    enabled boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: current_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.current_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: current_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.current_topics_id_seq OWNED BY public.current_topics.id;


--
-- Name: journey_legal_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.journey_legal_definitions (
    id bigint NOT NULL,
    journey_id bigint NOT NULL,
    law_id bigint NOT NULL,
    link character varying,
    note text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: journey_legal_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.journey_legal_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journey_legal_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.journey_legal_definitions_id_seq OWNED BY public.journey_legal_definitions.id;


--
-- Name: journeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.journeys (
    id bigint NOT NULL,
    title text NOT NULL,
    keywords text,
    published_status text NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    "position" integer DEFAULT 0 NOT NULL,
    image_name text,
    custom_title character varying,
    last_checked_on date,
    short_description text
);


--
-- Name: journeys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.journeys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.journeys_id_seq OWNED BY public.journeys.id;


--
-- Name: law_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.law_versions (
    id bigint NOT NULL,
    law_id bigint NOT NULL,
    identifier character varying,
    valid_from date NOT NULL,
    valid_to date,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: law_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.law_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: law_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.law_versions_id_seq OWNED BY public.law_versions.id;


--
-- Name: laws; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.laws (
    id bigint NOT NULL,
    identifier character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: laws_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.laws_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: laws_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.laws_id_seq OWNED BY public.laws.id;


--
-- Name: notification_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_subscriptions (
    id bigint NOT NULL,
    user_id bigint,
    email character varying,
    type character varying NOT NULL,
    confirmation_token uuid,
    confirmation_sent_at timestamp without time zone,
    confirmed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    journey_id bigint
);


--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_subscriptions_id_seq OWNED BY public.notification_subscriptions.id;


--
-- Name: or_sr_company_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.or_sr_company_records (
    id bigint NOT NULL,
    cin bigint,
    identifiers_ok boolean DEFAULT false,
    email character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying
);


--
-- Name: or_sr_company_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.or_sr_company_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: or_sr_company_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.or_sr_company_records_id_seq OWNED BY public.or_sr_company_records.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    slug text NOT NULL,
    is_faq boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    keywords text,
    image_name character varying,
    is_searchable boolean DEFAULT false NOT NULL,
    short_description text
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id bigint NOT NULL,
    content text,
    tsv_content tsvector,
    searchable_type character varying,
    searchable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    keywords character varying,
    title character varying,
    tsv_keywords tsvector,
    tsv_title tsvector,
    featured_position integer DEFAULT 0,
    published boolean DEFAULT false,
    featured boolean DEFAULT false NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: que_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.que_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.que_jobs_id_seq OWNED BY public.que_jobs.id;


--
-- Name: que_lockers; Type: TABLE; Schema: public; Owner: -
--

CREATE UNLOGGED TABLE public.que_lockers (
    pid integer NOT NULL,
    worker_count integer NOT NULL,
    worker_priorities integer[] NOT NULL,
    ruby_pid integer NOT NULL,
    ruby_hostname text NOT NULL,
    queues text[] NOT NULL,
    listening boolean NOT NULL,
    job_schema_version integer DEFAULT 1,
    CONSTRAINT valid_queues CHECK (((array_ndims(queues) = 1) AND (array_length(queues, 1) IS NOT NULL))),
    CONSTRAINT valid_worker_priorities CHECK (((array_ndims(worker_priorities) = 1) AND (array_length(worker_priorities, 1) IS NOT NULL)))
);


--
-- Name: que_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_values (
    key text NOT NULL,
    value jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT valid_value CHECK ((jsonb_typeof(value) = 'object'::text))
)
WITH (fillfactor='90');


--
-- Name: quick_tips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_tips (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    title character varying NOT NULL,
    body character varying,
    journey_id bigint,
    step_id bigint,
    application_slug character varying,
    application_title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: quick_tips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quick_tips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quick_tips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quick_tips_id_seq OWNED BY public.quick_tips.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.steps (
    id bigint NOT NULL,
    journey_id bigint NOT NULL,
    title text NOT NULL,
    keywords text,
    is_waiting_step boolean DEFAULT false NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    app_url character varying,
    type character varying DEFAULT 'BasicStep'::character varying NOT NULL,
    app_link_text character varying,
    custom_title character varying,
    waiting_time integer DEFAULT 0
);


--
-- Name: steps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.steps_id_seq OWNED BY public.steps.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submissions (
    id bigint NOT NULL,
    uuid uuid NOT NULL,
    user_id bigint,
    anonymous_user_uuid uuid,
    email character varying,
    callback_url character varying NOT NULL,
    callback_step_id bigint,
    callback_step_status character varying,
    selected_subscription_types character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    attachments jsonb,
    extra jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    expires_at timestamp without time zone
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submissions_id_seq OWNED BY public.submissions.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    step_id bigint NOT NULL,
    title text NOT NULL,
    type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    url text,
    "position" integer DEFAULT 0 NOT NULL,
    url_title character varying
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: user_journeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_journeys (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    journey_id bigint NOT NULL,
    started_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_journeys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_journeys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_journeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_journeys_id_seq OWNED BY public.user_journeys.id;


--
-- Name: user_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_steps (
    id bigint NOT NULL,
    user_journey_id bigint NOT NULL,
    step_id bigint NOT NULL,
    status character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submitted_at date,
    to_be_notified_at date
);


--
-- Name: user_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_steps_id_seq OWNED BY public.user_steps.id;


--
-- Name: user_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_tasks (
    id bigint NOT NULL,
    user_step_id bigint NOT NULL,
    task_id bigint NOT NULL,
    completed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_tasks_id_seq OWNED BY public.user_tasks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    eid_sub character varying,
    subject_name character varying,
    subject_cin character varying,
    subject_edesk_number character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: egov_application_allow_rules; Type: TABLE; Schema: upvs; Owner: -
--

CREATE TABLE upvs.egov_application_allow_rules (
    id bigint NOT NULL,
    recipient_uri character varying NOT NULL,
    posp_id character varying NOT NULL,
    posp_version character varying NOT NULL,
    message_type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: egov_application_allow_rules_id_seq; Type: SEQUENCE; Schema: upvs; Owner: -
--

CREATE SEQUENCE upvs.egov_application_allow_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: egov_application_allow_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: upvs; Owner: -
--

ALTER SEQUENCE upvs.egov_application_allow_rules_id_seq OWNED BY upvs.egov_application_allow_rules.id;


--
-- Name: form_template_related_documents; Type: TABLE; Schema: upvs; Owner: -
--

CREATE TABLE upvs.form_template_related_documents (
    id bigint NOT NULL,
    posp_id character varying NOT NULL,
    posp_version character varying NOT NULL,
    message_type character varying NOT NULL,
    xsd_schema text,
    xslt_transformation text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: form_template_related_documents_id_seq; Type: SEQUENCE; Schema: upvs; Owner: -
--

CREATE SEQUENCE upvs.form_template_related_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_template_related_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: upvs; Owner: -
--

ALTER SEQUENCE upvs.form_template_related_documents_id_seq OWNED BY upvs.form_template_related_documents.id;


--
-- Name: submissions; Type: TABLE; Schema: upvs; Owner: -
--

CREATE TABLE upvs.submissions (
    id bigint NOT NULL,
    uuid uuid NOT NULL,
    title character varying NOT NULL,
    posp_id character varying NOT NULL,
    posp_version character varying NOT NULL,
    message_type character varying NOT NULL,
    message_subject character varying NOT NULL,
    recipient_uri character varying NOT NULL,
    sender_business_reference character varying,
    recipient_business_reference character varying,
    form text NOT NULL,
    callback_url character varying,
    callback_step_id bigint,
    callback_step_status character varying,
    expires_at timestamp without time zone,
    user_id bigint,
    anonymous_user_uuid uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: upvs; Owner: -
--

CREATE SEQUENCE upvs.submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: upvs; Owner: -
--

ALTER SEQUENCE upvs.submissions_id_seq OWNED BY upvs.submissions.id;


--
-- Name: countries id; Type: DEFAULT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.countries ALTER COLUMN id SET DEFAULT nextval('code_list.countries_id_seq'::regclass);


--
-- Name: courts id; Type: DEFAULT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.courts ALTER COLUMN id SET DEFAULT nextval('code_list.courts_id_seq'::regclass);


--
-- Name: currencies id; Type: DEFAULT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.currencies ALTER COLUMN id SET DEFAULT nextval('code_list.currencies_id_seq'::regclass);


--
-- Name: municipalities id; Type: DEFAULT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.municipalities ALTER COLUMN id SET DEFAULT nextval('code_list.municipalities_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: apps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apps ALTER COLUMN id SET DEFAULT nextval('public.apps_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: categorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations ALTER COLUMN id SET DEFAULT nextval('public.categorizations_id_seq'::regclass);


--
-- Name: current_topics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.current_topics ALTER COLUMN id SET DEFAULT nextval('public.current_topics_id_seq'::regclass);


--
-- Name: journey_legal_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journey_legal_definitions ALTER COLUMN id SET DEFAULT nextval('public.journey_legal_definitions_id_seq'::regclass);


--
-- Name: journeys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journeys ALTER COLUMN id SET DEFAULT nextval('public.journeys_id_seq'::regclass);


--
-- Name: law_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.law_versions ALTER COLUMN id SET DEFAULT nextval('public.law_versions_id_seq'::regclass);


--
-- Name: laws id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.laws ALTER COLUMN id SET DEFAULT nextval('public.laws_id_seq'::regclass);


--
-- Name: notification_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.notification_subscriptions_id_seq'::regclass);


--
-- Name: or_sr_company_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.or_sr_company_records ALTER COLUMN id SET DEFAULT nextval('public.or_sr_company_records_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: que_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs ALTER COLUMN id SET DEFAULT nextval('public.que_jobs_id_seq'::regclass);


--
-- Name: quick_tips id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tips ALTER COLUMN id SET DEFAULT nextval('public.quick_tips_id_seq'::regclass);


--
-- Name: steps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.steps ALTER COLUMN id SET DEFAULT nextval('public.steps_id_seq'::regclass);


--
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: user_journeys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys ALTER COLUMN id SET DEFAULT nextval('public.user_journeys_id_seq'::regclass);


--
-- Name: user_steps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps ALTER COLUMN id SET DEFAULT nextval('public.user_steps_id_seq'::regclass);


--
-- Name: user_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks ALTER COLUMN id SET DEFAULT nextval('public.user_tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: egov_application_allow_rules id; Type: DEFAULT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.egov_application_allow_rules ALTER COLUMN id SET DEFAULT nextval('upvs.egov_application_allow_rules_id_seq'::regclass);


--
-- Name: form_template_related_documents id; Type: DEFAULT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.form_template_related_documents ALTER COLUMN id SET DEFAULT nextval('upvs.form_template_related_documents_id_seq'::regclass);


--
-- Name: submissions id; Type: DEFAULT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.submissions ALTER COLUMN id SET DEFAULT nextval('upvs.submissions_id_seq'::regclass);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: courts courts_pkey; Type: CONSTRAINT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.courts
    ADD CONSTRAINT courts_pkey PRIMARY KEY (id);


--
-- Name: currencies currencies_pkey; Type: CONSTRAINT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.currencies
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (id);


--
-- Name: municipalities municipalities_pkey; Type: CONSTRAINT; Schema: code_list; Owner: -
--

ALTER TABLE ONLY code_list.municipalities
    ADD CONSTRAINT municipalities_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categorizations categorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations
    ADD CONSTRAINT categorizations_pkey PRIMARY KEY (id);


--
-- Name: current_topics current_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.current_topics
    ADD CONSTRAINT current_topics_pkey PRIMARY KEY (id);


--
-- Name: journey_legal_definitions journey_legal_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journey_legal_definitions
    ADD CONSTRAINT journey_legal_definitions_pkey PRIMARY KEY (id);


--
-- Name: journeys journeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_pkey PRIMARY KEY (id);


--
-- Name: law_versions law_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.law_versions
    ADD CONSTRAINT law_versions_pkey PRIMARY KEY (id);


--
-- Name: laws laws_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_pkey PRIMARY KEY (id);


--
-- Name: notification_subscriptions notification_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_subscriptions
    ADD CONSTRAINT notification_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: or_sr_company_records or_sr_company_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.or_sr_company_records
    ADD CONSTRAINT or_sr_company_records_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: que_jobs que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (id);


--
-- Name: que_lockers que_lockers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_lockers
    ADD CONSTRAINT que_lockers_pkey PRIMARY KEY (pid);


--
-- Name: que_values que_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_values
    ADD CONSTRAINT que_values_pkey PRIMARY KEY (key);


--
-- Name: quick_tips quick_tips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tips
    ADD CONSTRAINT quick_tips_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: steps steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: user_journeys user_journeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys
    ADD CONSTRAINT user_journeys_pkey PRIMARY KEY (id);


--
-- Name: user_steps user_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps
    ADD CONSTRAINT user_steps_pkey PRIMARY KEY (id);


--
-- Name: user_tasks user_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT user_tasks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: egov_application_allow_rules egov_application_allow_rules_pkey; Type: CONSTRAINT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.egov_application_allow_rules
    ADD CONSTRAINT egov_application_allow_rules_pkey PRIMARY KEY (id);


--
-- Name: form_template_related_documents form_template_related_documents_pkey; Type: CONSTRAINT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.form_template_related_documents
    ADD CONSTRAINT form_template_related_documents_pkey PRIMARY KEY (id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_categories_categorizations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_categorizations ON public.categories_categorizations USING btree (category_id, categorization_id);


--
-- Name: index_categorizations_on_categorizable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categorizations_on_categorizable ON public.categorizations USING btree (categorizable_type, categorizable_id);


--
-- Name: index_journey_legal_definitions_on_journey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_journey_legal_definitions_on_journey_id ON public.journey_legal_definitions USING btree (journey_id);


--
-- Name: index_journey_legal_definitions_on_law_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_journey_legal_definitions_on_law_id ON public.journey_legal_definitions USING btree (law_id);


--
-- Name: index_law_versions_on_law_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_law_versions_on_law_id ON public.law_versions USING btree (law_id);


--
-- Name: index_notification_subscriptions_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notification_subscriptions_on_confirmation_token ON public.notification_subscriptions USING btree (confirmation_token);


--
-- Name: index_notification_subscriptions_on_journey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notification_subscriptions_on_journey_id ON public.notification_subscriptions USING btree (journey_id);


--
-- Name: index_notification_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notification_subscriptions_on_user_id ON public.notification_subscriptions USING btree (user_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_pg_search_documents_on_tsv_content; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_tsv_content ON public.pg_search_documents USING gin (tsv_content);


--
-- Name: index_pg_search_documents_on_tsv_keywords; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_tsv_keywords ON public.pg_search_documents USING gin (tsv_keywords);


--
-- Name: index_pg_search_documents_on_tsv_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_tsv_title ON public.pg_search_documents USING gin (tsv_title);


--
-- Name: index_quick_tips_on_journey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quick_tips_on_journey_id ON public.quick_tips USING btree (journey_id);


--
-- Name: index_quick_tips_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_quick_tips_on_slug ON public.quick_tips USING btree (slug);


--
-- Name: index_quick_tips_on_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quick_tips_on_step_id ON public.quick_tips USING btree (step_id);


--
-- Name: index_steps_on_journey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_steps_on_journey_id ON public.steps USING btree (journey_id);


--
-- Name: index_submissions_on_anonymous_user_uuid_and_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_submissions_on_anonymous_user_uuid_and_uuid ON public.submissions USING btree (anonymous_user_uuid, uuid);


--
-- Name: index_submissions_on_callback_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_callback_step_id ON public.submissions USING btree (callback_step_id);


--
-- Name: index_submissions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_user_id ON public.submissions USING btree (user_id);


--
-- Name: index_submissions_on_user_id_and_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_submissions_on_user_id_and_uuid ON public.submissions USING btree (user_id, uuid);


--
-- Name: index_tasks_on_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_step_id ON public.tasks USING btree (step_id);


--
-- Name: index_user_journeys_on_journey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_journeys_on_journey_id ON public.user_journeys USING btree (journey_id);


--
-- Name: index_user_journeys_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_journeys_on_user_id ON public.user_journeys USING btree (user_id);


--
-- Name: index_user_steps_on_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_steps_on_step_id ON public.user_steps USING btree (step_id);


--
-- Name: index_user_steps_on_user_journey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_steps_on_user_journey_id ON public.user_steps USING btree (user_journey_id);


--
-- Name: index_user_tasks_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_tasks_on_task_id ON public.user_tasks USING btree (task_id);


--
-- Name: index_user_tasks_on_user_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_tasks_on_user_step_id ON public.user_tasks USING btree (user_step_id);


--
-- Name: index_users_on_eid_sub; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_eid_sub ON public.users USING btree (eid_sub);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_email_lower_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email_lower_unique ON public.users USING btree (lower(email));


--
-- Name: que_jobs_args_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_args_gin_idx ON public.que_jobs USING gin (args jsonb_path_ops);


--
-- Name: que_jobs_data_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_data_gin_idx ON public.que_jobs USING gin (data jsonb_path_ops);


--
-- Name: que_jobs_kwargs_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_kwargs_gin_idx ON public.que_jobs USING gin (kwargs jsonb_path_ops);


--
-- Name: que_poll_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_poll_idx ON public.que_jobs USING btree (job_schema_version, queue, priority, run_at, id) WHERE ((finished_at IS NULL) AND (expired_at IS NULL));


--
-- Name: index_upvs.submissions_on_anonymous_user_uuid_and_uuid; Type: INDEX; Schema: upvs; Owner: -
--

CREATE UNIQUE INDEX "index_upvs.submissions_on_anonymous_user_uuid_and_uuid" ON upvs.submissions USING btree (anonymous_user_uuid, uuid);


--
-- Name: index_upvs.submissions_on_callback_step_id; Type: INDEX; Schema: upvs; Owner: -
--

CREATE INDEX "index_upvs.submissions_on_callback_step_id" ON upvs.submissions USING btree (callback_step_id);


--
-- Name: index_upvs.submissions_on_user_id; Type: INDEX; Schema: upvs; Owner: -
--

CREATE INDEX "index_upvs.submissions_on_user_id" ON upvs.submissions USING btree (user_id);


--
-- Name: index_upvs.submissions_on_user_id_and_uuid; Type: INDEX; Schema: upvs; Owner: -
--

CREATE UNIQUE INDEX "index_upvs.submissions_on_user_id_and_uuid" ON upvs.submissions USING btree (user_id, uuid);


--
-- Name: que_jobs que_job_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER que_job_notify AFTER INSERT ON public.que_jobs FOR EACH ROW WHEN ((NOT (COALESCE(current_setting('que.skip_notify'::text, true), ''::text) = 'true'::text))) EXECUTE FUNCTION public.que_job_notify();


--
-- Name: que_jobs que_state_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER que_state_notify AFTER INSERT OR DELETE OR UPDATE ON public.que_jobs FOR EACH ROW WHEN ((NOT (COALESCE(current_setting('que.skip_notify'::text, true), ''::text) = 'true'::text))) EXECUTE FUNCTION public.que_state_notify();


--
-- Name: pg_search_documents tsv_keywords_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsv_keywords_update BEFORE INSERT OR UPDATE ON public.pg_search_documents FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv_keywords', 'pg_catalog.simple', 'keywords');


--
-- Name: pg_search_documents tsv_title_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsv_title_update BEFORE INSERT OR UPDATE ON public.pg_search_documents FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv_title', 'pg_catalog.simple', 'title');


--
-- Name: pg_search_documents tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.pg_search_documents FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv_content', 'pg_catalog.simple', 'content');


--
-- Name: quick_tips fk_rails_0a21363dd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tips
    ADD CONSTRAINT fk_rails_0a21363dd0 FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: journey_legal_definitions fk_rails_26f32722ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journey_legal_definitions
    ADD CONSTRAINT fk_rails_26f32722ea FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: user_steps fk_rails_270661d7b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps
    ADD CONSTRAINT fk_rails_270661d7b7 FOREIGN KEY (user_journey_id) REFERENCES public.user_journeys(id);


--
-- Name: notification_subscriptions fk_rails_2bf71acda7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_subscriptions
    ADD CONSTRAINT fk_rails_2bf71acda7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: notification_subscriptions fk_rails_2fb637afd2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_subscriptions
    ADD CONSTRAINT fk_rails_2fb637afd2 FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: user_steps fk_rails_56d22858e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps
    ADD CONSTRAINT fk_rails_56d22858e3 FOREIGN KEY (step_id) REFERENCES public.steps(id);


--
-- Name: user_tasks fk_rails_5a3f03c742; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT fk_rails_5a3f03c742 FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: journey_legal_definitions fk_rails_690d321c6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journey_legal_definitions
    ADD CONSTRAINT fk_rails_690d321c6a FOREIGN KEY (law_id) REFERENCES public.laws(id);


--
-- Name: user_journeys fk_rails_70185eaf12; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys
    ADD CONSTRAINT fk_rails_70185eaf12 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: law_versions fk_rails_852992ee31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.law_versions
    ADD CONSTRAINT fk_rails_852992ee31 FOREIGN KEY (law_id) REFERENCES public.laws(id);


--
-- Name: submissions fk_rails_8999639afc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_8999639afc FOREIGN KEY (callback_step_id) REFERENCES public.steps(id) ON DELETE SET NULL;


--
-- Name: quick_tips fk_rails_8c50350cb1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tips
    ADD CONSTRAINT fk_rails_8c50350cb1 FOREIGN KEY (step_id) REFERENCES public.steps(id);


--
-- Name: submissions fk_rails_8d85741475; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_8d85741475 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: tasks fk_rails_bed40c4f02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_bed40c4f02 FOREIGN KEY (step_id) REFERENCES public.steps(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: user_tasks fk_rails_eef61d1fdc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT fk_rails_eef61d1fdc FOREIGN KEY (user_step_id) REFERENCES public.user_steps(id);


--
-- Name: user_journeys fk_rails_fb72d96772; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys
    ADD CONSTRAINT fk_rails_fb72d96772 FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: steps fk_rails_fc12f91020; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT fk_rails_fc12f91020 FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: submissions fk_rails_35f0013109; Type: FK CONSTRAINT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.submissions
    ADD CONSTRAINT fk_rails_35f0013109 FOREIGN KEY (callback_step_id) REFERENCES public.steps(id);


--
-- Name: submissions fk_rails_7026efca7d; Type: FK CONSTRAINT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.submissions
    ADD CONSTRAINT fk_rails_7026efca7d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181201094003'),
('20181201104550'),
('20181201110114'),
('20181201114726'),
('20181201121129'),
('20181201121130'),
('20181201130356'),
('20181201131820'),
('20181201145710'),
('20181201173440'),
('20181201173548'),
('20181201174333'),
('20190116201226'),
('20190117171028'),
('20190118111308'),
('20190122112950'),
('20190301173059'),
('20190321100731'),
('20190411095826'),
('20190411104731'),
('20190423124647'),
('20190423214925'),
('20190424074855'),
('20190529210530'),
('20190529210630'),
('20190608102251'),
('20190608130459'),
('20190608135807'),
('20190608201245'),
('20190914143708'),
('20190914164512'),
('20190915104202'),
('20191209121011'),
('20200316102804'),
('20200316104715'),
('20200919092214'),
('20201029122539'),
('20210314221503'),
('20210318070336'),
('20210321133303'),
('20210321172132'),
('20210321181737'),
('20220322180237'),
('20220323214831'),
('20220407131258'),
('20220623200232'),
('20220624185928'),
('20220624204655'),
('20220715194212'),
('20220727160233'),
('20220815153512'),
('20220815153557'),
('20220815155429'),
('20220815155542'),
('20220815211829'),
('20220907210125'),
('20220914073624'),
('20220914073645'),
('20220914073653'),
('20220921082415'),
('20221022121113'),
('20221022143119'),
('20230325092744'),
('20230325095737'),
('20230325151049'),
('20240427124856'),
('20230627134435'),
('20231007072828');


