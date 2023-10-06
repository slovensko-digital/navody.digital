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
-- Name: upvs; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA upvs;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: public_authority_edesks; Type: TABLE; Schema: upvs; Owner: -
--

CREATE TABLE upvs.public_authority_edesks (
    id integer NOT NULL,
    cin bigint NOT NULL,
    uri character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: public_authority_edesks_id_seq; Type: SEQUENCE; Schema: upvs; Owner: -
--

CREATE SEQUENCE upvs.public_authority_edesks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_authority_edesks_id_seq; Type: SEQUENCE OWNED BY; Schema: upvs; Owner: -
--

ALTER SEQUENCE upvs.public_authority_edesks_id_seq OWNED BY upvs.public_authority_edesks.id;


--
-- Name: services_with_forms; Type: TABLE; Schema: upvs; Owner: -
--

CREATE TABLE upvs.services_with_forms (
    id integer NOT NULL,
    instance_id integer NOT NULL,
    external_code character varying,
    meta_is_code character varying,
    name character varying,
    type character varying,
    institution_uri character varying NOT NULL,
    institution_name character varying,
    valid_from timestamp without time zone,
    valid_to timestamp without time zone,
    url character varying,
    info_url character varying,
    schema_url character varying,
    changed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: services_with_forms_id_seq; Type: SEQUENCE; Schema: upvs; Owner: -
--

CREATE SEQUENCE upvs.services_with_forms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_with_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: upvs; Owner: -
--

ALTER SEQUENCE upvs.services_with_forms_id_seq OWNED BY upvs.services_with_forms.id;

--
-- Name: public_authority_edesks id; Type: DEFAULT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.public_authority_edesks ALTER COLUMN id SET DEFAULT nextval('upvs.public_authority_edesks_id_seq'::regclass);


--
-- Name: services_with_forms id; Type: DEFAULT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.services_with_forms ALTER COLUMN id SET DEFAULT nextval('upvs.services_with_forms_id_seq'::regclass);


--
-- Name: public_authority_edesks public_authority_edesks_pkey; Type: CONSTRAINT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.public_authority_edesks
    ADD CONSTRAINT public_authority_edesks_pkey PRIMARY KEY (id);


--
-- Name: services_with_forms services_with_forms_pkey; Type: CONSTRAINT; Schema: upvs; Owner: -
--

ALTER TABLE ONLY upvs.services_with_forms
    ADD CONSTRAINT services_with_forms_pkey PRIMARY KEY (id);


--
-- Name: index_upvs.public_authority_edesks_on_cin; Type: INDEX; Schema: upvs; Owner: -
--

CREATE INDEX "index_upvs.public_authority_edesks_on_cin" ON upvs.public_authority_edesks USING btree (cin);


--
-- Name: index_upvs.public_authority_edesks_on_uri; Type: INDEX; Schema: upvs; Owner: -
--

CREATE UNIQUE INDEX "index_upvs.public_authority_edesks_on_uri" ON upvs.public_authority_edesks USING btree (uri);


--
-- Name: index_upvs.services_with_forms_on_instance_id; Type: INDEX; Schema: upvs; Owner: -
--

CREATE UNIQUE INDEX "index_upvs.services_with_forms_on_instance_id" ON upvs.services_with_forms USING btree (instance_id);


--
-- Name: index_upvs.services_with_forms_on_institution_uri; Type: INDEX; Schema: upvs; Owner: -
--

CREATE INDEX "index_upvs.services_with_forms_on_institution_uri" ON upvs.services_with_forms USING btree (institution_uri);


--
-- Name: index_upvs.services_with_forms_on_schema_url; Type: INDEX; Schema: upvs; Owner: -
--

CREATE INDEX "index_upvs.services_with_forms_on_schema_url" ON upvs.services_with_forms USING btree (schema_url);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;
