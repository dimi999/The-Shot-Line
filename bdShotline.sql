--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

-- Started on 2022-04-14 13:45:20

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
-- TOC entry 832 (class 1247 OID 16404)
-- Name: categ_basket; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.categ_basket AS ENUM (
    'teren',
    'mingi',
    'adidasi',
    'cosuri'
);


ALTER TYPE public.categ_basket OWNER TO postgres;

--
-- TOC entry 841 (class 1247 OID 16436)
-- Name: roluri; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.roluri AS ENUM (
    'admin',
    'moderator',
    'comun'
);


ALTER TYPE public.roluri OWNER TO postgres;

--
-- TOC entry 835 (class 1247 OID 16414)
-- Name: tipuri_produse; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipuri_produse AS ENUM (
    'indoor',
    'outdoor'
);


ALTER TYPE public.tipuri_produse OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16458)
-- Name: accesari; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accesari (
    id integer NOT NULL,
    ip character varying(100) NOT NULL,
    user_id integer,
    pagina character varying(500) NOT NULL,
    data_accesare timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.accesari OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16457)
-- Name: accesari_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accesari_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accesari_id_seq OWNER TO postgres;

--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 215
-- Name: accesari_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accesari_id_seq OWNED BY public.accesari.id;


--
-- TOC entry 210 (class 1259 OID 16396)
-- Name: model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model (
    id integer NOT NULL,
    nume character varying(100) NOT NULL,
    pret integer DEFAULT 100 NOT NULL
);


ALTER TABLE public.model OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16395)
-- Name: model_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.model ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.model_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 212 (class 1259 OID 16420)
-- Name: produse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produse (
    id integer NOT NULL,
    nume character varying(50) NOT NULL,
    descriere text,
    pret numeric(8,2) NOT NULL,
    marime integer NOT NULL,
    tip_produs public.tipuri_produse DEFAULT 'indoor'::public.tipuri_produse,
    categorie public.categ_basket,
    materiale character varying[],
    pt_copii boolean DEFAULT false NOT NULL,
    imagine character varying(300),
    data_adaugare timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT produse_marime_check CHECK ((marime >= 0))
);


ALTER TABLE public.produse OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16419)
-- Name: produse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produse_id_seq OWNER TO postgres;

--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 211
-- Name: produse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produse_id_seq OWNED BY public.produse.id;


--
-- TOC entry 214 (class 1259 OID 16444)
-- Name: utilizatori; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilizatori (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    nume character varying(100) NOT NULL,
    prenume character varying(100) NOT NULL,
    parola character varying(500) NOT NULL,
    rol public.roluri DEFAULT 'comun'::public.roluri NOT NULL,
    email character varying(100) NOT NULL,
    culoare_chat character varying(50) NOT NULL,
    data_adaugare timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cod character varying(200),
    confirmat_mail boolean DEFAULT false
);


ALTER TABLE public.utilizatori OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16443)
-- Name: utilizatori_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utilizatori_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.utilizatori_id_seq OWNER TO postgres;

--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 213
-- Name: utilizatori_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.utilizatori_id_seq OWNED BY public.utilizatori.id;


--
-- TOC entry 3198 (class 2604 OID 16461)
-- Name: accesari id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accesari ALTER COLUMN id SET DEFAULT nextval('public.accesari_id_seq'::regclass);


--
-- TOC entry 3189 (class 2604 OID 16423)
-- Name: produse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produse ALTER COLUMN id SET DEFAULT nextval('public.produse_id_seq'::regclass);


--
-- TOC entry 3194 (class 2604 OID 16447)
-- Name: utilizatori id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilizatori ALTER COLUMN id SET DEFAULT nextval('public.utilizatori_id_seq'::regclass);


--
-- TOC entry 3359 (class 0 OID 16458)
-- Dependencies: 216
-- Data for Name: accesari; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3353 (class 0 OID 16396)
-- Dependencies: 210
-- Data for Name: model; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.model (id, nume, pret) OVERRIDING SYSTEM VALUE VALUES (1, 'Adidasi
', 200);
INSERT INTO public.model (id, nume, pret) OVERRIDING SYSTEM VALUE VALUES (2, 'Minge
', 100);
INSERT INTO public.model (id, nume, pret) OVERRIDING SYSTEM VALUE VALUES (3, 'Cos
', 550);


--
-- TOC entry 3355 (class 0 OID 16420)
-- Dependencies: 212
-- Data for Name: produse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (1, 'Minge', 'Minge de baschet super', 80.00, 5, 'indoor', 'mingi', '{Cauciuc}', true, NULL, '2022-03-28 17:00:43.05787');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (2, 'Cos', 'Cos de baschet
', 250.00, 250, 'outdoor', 'cosuri', '{fier}', false, NULL, '2022-03-28 17:00:43.05787');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (3, 'Teren', 'Teren de baschet
', 1250.00, 750, 'outdoor', 'teren', '{zgura}', false, NULL, '2022-03-28 17:00:43.05787');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (4, 'Minge Select', 'Minge de baschet outdoor', 150.00, 6, 'outdoor', 'mingi', '{Cauciuc}', false, NULL, '2022-03-31 12:20:55.98025');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (5, 'Minge FIBA', 'Minge de baschet', 70.00, 5, 'indoor', 'mingi', '{Cauciuc}', false, NULL, '2022-03-31 12:20:55.98025');


--
-- TOC entry 3357 (class 0 OID 16444)
-- Dependencies: 214
-- Data for Name: utilizatori; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail) VALUES (1, 'catag', 'Gheroghe', 'Catalin', '6896a01882fb107cddb0027b7aa38467fb58daf50fff2ae4cd6c37f5a9ede20a53931e04f7f2aec19f3154abfac8ca33ad42ae2234a4976bedf14dc34e3d0501', 'comun', 'profprofprof007@gmail.com', 'red', '2022-04-11 18:08:09.666243', NULL, false);


--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 215
-- Name: accesari_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accesari_id_seq', 1, false);


--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 209
-- Name: model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.model_id_seq', 3, true);


--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 211
-- Name: produse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produse_id_seq', 1, false);


--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 213
-- Name: utilizatori_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utilizatori_id_seq', 1, true);


--
-- TOC entry 3211 (class 2606 OID 16466)
-- Name: accesari accesari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accesari
    ADD CONSTRAINT accesari_pkey PRIMARY KEY (id);


--
-- TOC entry 3201 (class 2606 OID 16400)
-- Name: model model_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT model_pkey PRIMARY KEY (id);


--
-- TOC entry 3203 (class 2606 OID 16434)
-- Name: produse produse_nume_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produse
    ADD CONSTRAINT produse_nume_key UNIQUE (nume);


--
-- TOC entry 3205 (class 2606 OID 16432)
-- Name: produse produse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produse
    ADD CONSTRAINT produse_pkey PRIMARY KEY (id);


--
-- TOC entry 3207 (class 2606 OID 16454)
-- Name: utilizatori utilizatori_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilizatori
    ADD CONSTRAINT utilizatori_pkey PRIMARY KEY (id);


--
-- TOC entry 3209 (class 2606 OID 16456)
-- Name: utilizatori utilizatori_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilizatori
    ADD CONSTRAINT utilizatori_username_key UNIQUE (username);


--
-- TOC entry 3212 (class 2606 OID 16467)
-- Name: accesari accesari_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accesari
    ADD CONSTRAINT accesari_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.utilizatori(id);


--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE model; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.model TO dimi999;


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 209
-- Name: SEQUENCE model_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.model_id_seq TO dimi999;


--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE produse; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produse TO dimi999;


--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE produse_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produse_id_seq TO dimi999;


-- Completed on 2022-04-14 13:45:20

--
-- PostgreSQL database dump complete
--

