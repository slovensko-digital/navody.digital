SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


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
    description text NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    featured_position integer DEFAULT 0 NOT NULL,
    image_name text
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
    updated_at timestamp without time zone NOT NULL
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
    keywords text
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
    tsv_title tsvector
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
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.que_jobs_job_id_seq OWNED BY public.que_jobs.job_id;


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
    app_link_text character varying
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
    updated_at timestamp without time zone NOT NULL
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
    updated_at timestamp without time zone NOT NULL
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journeys ALTER COLUMN id SET DEFAULT nextval('public.journeys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.notification_subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs ALTER COLUMN job_id SET DEFAULT nextval('public.que_jobs_job_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.steps ALTER COLUMN id SET DEFAULT nextval('public.steps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys ALTER COLUMN id SET DEFAULT nextval('public.user_journeys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps ALTER COLUMN id SET DEFAULT nextval('public.user_steps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks ALTER COLUMN id SET DEFAULT nextval('public.user_tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: journeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_pkey PRIMARY KEY (id);


--
-- Name: notification_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_subscriptions
    ADD CONSTRAINT notification_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: user_journeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys
    ADD CONSTRAINT user_journeys_pkey PRIMARY KEY (id);


--
-- Name: user_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps
    ADD CONSTRAINT user_steps_pkey PRIMARY KEY (id);


--
-- Name: user_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT user_tasks_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_notification_subscriptions_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notification_subscriptions_on_confirmation_token ON public.notification_subscriptions USING btree (confirmation_token);


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
-- Name: index_steps_on_journey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_steps_on_journey_id ON public.steps USING btree (journey_id);


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
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_email_lower_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email_lower_unique ON public.users USING btree (lower(email));


--
-- Name: tsv_keywords_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsv_keywords_update BEFORE INSERT OR UPDATE ON public.pg_search_documents FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_keywords', 'pg_catalog.simple', 'keywords');


--
-- Name: tsv_title_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsv_title_update BEFORE INSERT OR UPDATE ON public.pg_search_documents FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_title', 'pg_catalog.simple', 'title');


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.pg_search_documents FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.simple', 'content');


--
-- Name: fk_rails_270661d7b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps
    ADD CONSTRAINT fk_rails_270661d7b7 FOREIGN KEY (user_journey_id) REFERENCES public.user_journeys(id);


--
-- Name: fk_rails_2bf71acda7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_subscriptions
    ADD CONSTRAINT fk_rails_2bf71acda7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_56d22858e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_steps
    ADD CONSTRAINT fk_rails_56d22858e3 FOREIGN KEY (step_id) REFERENCES public.steps(id);


--
-- Name: fk_rails_5a3f03c742; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT fk_rails_5a3f03c742 FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: fk_rails_70185eaf12; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys
    ADD CONSTRAINT fk_rails_70185eaf12 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_bed40c4f02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_bed40c4f02 FOREIGN KEY (step_id) REFERENCES public.steps(id);


--
-- Name: fk_rails_eef61d1fdc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT fk_rails_eef61d1fdc FOREIGN KEY (user_step_id) REFERENCES public.user_steps(id);


--
-- Name: fk_rails_fb72d96772; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journeys
    ADD CONSTRAINT fk_rails_fb72d96772 FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: fk_rails_fc12f91020; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT fk_rails_fc12f91020 FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


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
('20190424074855');


