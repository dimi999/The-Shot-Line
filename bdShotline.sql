--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

-- Started on 2022-06-08 16:17:21

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
-- TOC entry 3366 (class 0 OID 0)
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
-- TOC entry 3370 (class 0 OID 0)
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
    nume character varying(100),
    prenume character varying(100),
    parola character varying(500) NOT NULL,
    rol public.roluri DEFAULT 'comun'::public.roluri NOT NULL,
    email character varying(100) NOT NULL,
    culoare_chat character varying(50) NOT NULL,
    data_adaugare timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cod character varying(200),
    confirmat_mail boolean DEFAULT false,
    blocat boolean,
    poza character varying(50),
    reset_pass boolean DEFAULT false
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
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 213
-- Name: utilizatori_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.utilizatori_id_seq OWNED BY public.utilizatori.id;


--
-- TOC entry 3199 (class 2604 OID 16461)
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
-- TOC entry 3360 (class 0 OID 16458)
-- Dependencies: 216
-- Data for Name: accesari; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3354 (class 0 OID 16396)
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
-- TOC entry 3356 (class 0 OID 16420)
-- Dependencies: 212
-- Data for Name: produse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (1, 'Minge', 'Minge de baschet super', 80.00, 5, 'indoor', 'mingi', '{Cauciuc,plastic}', true, 'imag1.jpg', '2022-03-28 17:00:43.05787');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (2, 'Cos', 'Cos de baschet
', 250.00, 250, 'outdoor', 'cosuri', '{fier}', false, 'imag2.jpg', '2022-03-28 17:00:43.05787');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (3, 'Teren', 'Teren de baschet
', 1250.00, 750, 'outdoor', 'teren', '{zgura}', false, 'imag3.jpg', '2022-03-28 17:00:43.05787');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (4, 'Minge Select', 'Minge de baschet outdoor', 150.00, 6, 'outdoor', 'mingi', '{Cauciuc}', false, 'imag4.jpg', '2022-03-31 12:20:55.98025');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (5, 'Minge FIBA', 'Minge de baschet', 70.00, 5, 'indoor', 'mingi', '{Cauciuc}', false, 'imag5.jpg', '2022-03-31 12:20:55.98025');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (6, 'Minge FIBA 2020', 'Mingea de baschet a CE 2020', 150.00, 6, 'indoor', 'mingi', '{Cauciuc,plastic}', true, 'imag6.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (7, 'Adidasi Nike', 'Adidasi Nike', 350.00, 42, 'indoor', 'adidasi', '{plastic,cauciuc}', false, 'imag7.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (8, 'Adidasi Adidas', 'Adidasi oficilai de joc adidas', 350.00, 43, 'outdoor', 'adidasi', '{plastic,cauciuc}', false, 'imag8.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (9, 'Minge FIBA 2022', 'Mingea oficiala de joc a CM 2022', 150.00, 7, 'indoor', 'mingi', '{cauciuc,plastic}', false, 'imag9.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (10, 'Cos Alamrox', 'Cos de baschet mobil', 250.00, 250, 'outdoor', 'cosuri', '{fier}', false, 'imag10.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (11, 'Minge Select fete', 'Minge de baschet pt baschet feminin', 100.00, 6, 'indoor', 'mingi', '{Cauciuc,plastic}', true, 'imag11.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (12, 'Adidasi NIKE albastri', 'Adidasi NIKE pentru baschet ', 350.00, 44, 'indoor', 'adidasi', '{Cauciuc,plastic}', true, 'imag12.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (13, 'Teren 3vs3', 'Teren 3 vs 3 pentru copii', 1500.00, 850, 'outdoor', 'teren', '{zgura,fier}', true, 'imag13.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (14, 'Adidasi Adidas NBA 2021', 'Adidasi ALL-STAR NBA 2021 editie speciala
', 450.00, 44, 'indoor', 'adidasi', '{plastic,cauciuc}', false, 'imag14.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (15, 'Teren 5 vs 5', 'Teren oficial de joc 5 vs 5 pentru gradina
', 2500.00, 1500, 'outdoor', 'teren', '{plastic,fier,zgura}', false, 'imag15.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (16, 'Minge Baschet JORDAN Nike', 'Minge de baschet editie speciala in parteneriat cu Michael Jordan', 440.00, 7, 'indoor', 'mingi', '{cauciuc}', false, 'imag16.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (17, 'Adidasi Under Armour', 'Adidasi pentru baschetul de afara', 330.00, 44, 'outdoor', 'adidasi', '{cauciuc,plastic}', false, 'imag17.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (18, 'Adidasi CM 2022', 'Adidasii oficiali de joc ai CM 2022 ', 450.00, 43, 'indoor', 'adidasi', '{plastic,cauciuc}', true, 'imag18.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (19, 'Cos Protouch', 'Cos de baschet protouch pentru copii
', 150.00, 150, 'outdoor', 'cosuri', '{plastic}', true, 'imag19.jpg', '2022-05-11 13:17:47.013768');
INSERT INTO public.produse (id, nume, descriere, pret, marime, tip_produs, categorie, materiale, pt_copii, imagine, data_adaugare) VALUES (20, 'Cos Tarmak', 'Cos Tarmak pentru copii', 130.00, 150, 'outdoor', 'cosuri', '{plastic}', false, 'imag20.jpg', '2022-05-11 13:17:47.013768');


--
-- TOC entry 3358 (class 0 OID 16444)
-- Dependencies: 214
-- Data for Name: utilizatori; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (1, 'catag', 'Gheroghe', 'Catalin', '6896a01882fb107cddb0027b7aa38467fb58daf50fff2ae4cd6c37f5a9ede20a53931e04f7f2aec19f3154abfac8ca33ad42ae2234a4976bedf14dc34e3d0501', 'comun', 'profprofprof007@gmail.com', 'red', '2022-04-11 18:08:09.666243', NULL, false, NULL, NULL, false);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (2, 'dimi0402', 'Gogulescu', 'Gogu', '36c46a5f25a14a126560ed7f98418526cdd0320da26b7d50673c7965d63f3c79db042e3c9108d6f50fe1525668fea6778cae52c0f8c0456b3435d277a8282e6a', 'admin', 'profprofprof007@gmail.com', 'red', '2022-05-05 12:14:15.182384', NULL, false, NULL, NULL, false);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (3, 'mihai145', 'Oprea', 'Mihai', '701108e87d07feb6beeba265891d6a6aaed175cd06e7f0b14b93359e6e40a7e6a5253d99ce906acaf47e1d653ccbce78e9071d39764220ad937660e6849a2774', 'comun', 'profprofprof007@gmail.com', 'red', '2022-05-15 12:14:15.486904', NULL, false, NULL, NULL, false);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (10, 'testpoza', '', '', '6bc4f4a0c69cc4f761bda9b3c8efcbdd52031f0ad5743c6e2cb8027d1192b012ff2d66a1e785d002591fdee8242a760848c6e0afb6b0953e02043e31ad407c5b', 'comun', 'dimitriu.andrei@yahoo.com', 'black', '2022-05-17 14:34:35.845946', '7164898638testpoza-KNMGEJLCHGPHDDOFKEADLCEEFDDDANIFOFKFMPHFONMGDIKHOOLEMMDPEPMFJC', true, NULL, 'FRF.png', false);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (11, 'testpoza2', '', '', '9f2bd238d585a387609869aa526047e3369ca17b9986559706d1cd1fe327b723e6cfe6d1d575c3d1a72a6dbf096a2635ed621ff252f90d6f931a6d476216fc4c', 'comun', 'dimitriu.andrei@yahoo.com', 'black', '2022-05-17 14:43:49.217172', '4596981328testpoza2-DBHMOHEIOJMDAJDGDBHLKGHKDAOJJOBOFMCENLDOIDDKJEHDCCLNEGOIDKPOM', false, NULL, 'cardsdisk.PNG', true);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (12, 'testpoza3', '', '', '93929ad7df60dc23112ff2b8a7b2e26dd2f9f5ef766a6851b3612667bf0e530d6ceb014b13bda420681099512b715e37615a2e621faf951f1f25c67d11a00a23', 'comun', 'dimitriu.andrei@yahoo.com', 'black', '2022-05-17 14:46:53.393144', '2788486336testpoza3-EOGPJBIPIELLECAICLHDFBMOOJLMOBLODEEJDHAGHDKHBLBNDNPBCFJJFDBCN', false, NULL, 'audiodisk.PNG', true);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (13, 'testpoza4', '', '', 'b3af06a7bd191eb24a9c6794d843695460f5f3df98040ec8d071b643384e48a24a62fecb9154a849c55a6426faaec8efeaa71d4e87b6b8e7ce4f427ba07049a4', 'comun', 'dimitriu.andrei@yahoo.com', 'black', '2022-05-17 14:50:23.346468', '7959837183testpoza4-IDAPBGCAGELAAFKNJOGEALIKHBNJNENNFMHBNIBCCLAPNOJHABNNPGNKCFFNF', false, NULL, '2BD.PNG', true);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (14, 'testpoza6', '', '', 'afead375284f9e5a92eedf264f10cf119e5c955ac5d5329af193870c2a121b451094fcbaae3aecbdbaa553a4dd392bf1e1f3546cf2046656e3a490e120b0bb57', 'comun', 'dimitriu.andrei@yahoo.com', 'black', '2022-05-17 14:54:18.107593', '4487844889testpoza6-JPJKKINMPFCMCNEKHLFFGOKKKOPLBEBODBKGGLBGLEPBFFDCNGGJGFLJEBDPJ', false, NULL, 'audiodisk.PNG', true);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (15, 'testjpgpng', '', '', '358f4eac57a2efd366c8b39904cc7077bbddd1de91fd1fb3d795cd08e07ffc2f03cf3e1d4d89b5ff2d4d6908a4e15226882def95307a095b0919ee6dcba20171', 'comun', 'dimitriu.andrei@yahoo.com', 'black', '2022-05-17 14:56:51.410924', '6837445291testjpgpng-OACFCNIGPLDNJDJEJOHFAFEEIKLJLBHBHLDJIGPIDCONAIGHELNKHCKODBAD', true, NULL, 'istockphoto-822871460-170667a.jpg', true);
INSERT INTO public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail, blocat, poza, reset_pass) VALUES (19, 'mircia', 'mircia', 'donciu', '7ef1aca30a5ce443ee929ffef796e622d31ec103ef9840c0349814c2ab5d428d10dcac8de45c378b2e3be69d10749a823c46dc4a074ce48160e7a85d2dc5f270', 'admin', 'dimitriu.andrei@yahoo.com', 'black', '2022-05-28 10:56:15.861038', '3034775140mircia-GOJBEKJLNPFBOLONEMGAHPLBEJOIGAJHHJGEJCCIGGBAJNIOCLAAHNEJJGEGPIEI', true, NULL, 'profil.png', true);


--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 215
-- Name: accesari_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accesari_id_seq', 1, false);


--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 209
-- Name: model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.model_id_seq', 3, true);


--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 211
-- Name: produse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produse_id_seq', 1, false);


--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 213
-- Name: utilizatori_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utilizatori_id_seq', 19, true);


--
-- TOC entry 3212 (class 2606 OID 16466)
-- Name: accesari accesari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accesari
    ADD CONSTRAINT accesari_pkey PRIMARY KEY (id);


--
-- TOC entry 3202 (class 2606 OID 16400)
-- Name: model model_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT model_pkey PRIMARY KEY (id);


--
-- TOC entry 3204 (class 2606 OID 16434)
-- Name: produse produse_nume_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produse
    ADD CONSTRAINT produse_nume_key UNIQUE (nume);


--
-- TOC entry 3206 (class 2606 OID 16432)
-- Name: produse produse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produse
    ADD CONSTRAINT produse_pkey PRIMARY KEY (id);


--
-- TOC entry 3208 (class 2606 OID 16454)
-- Name: utilizatori utilizatori_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilizatori
    ADD CONSTRAINT utilizatori_pkey PRIMARY KEY (id);


--
-- TOC entry 3210 (class 2606 OID 16456)
-- Name: utilizatori utilizatori_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilizatori
    ADD CONSTRAINT utilizatori_username_key UNIQUE (username);


--
-- TOC entry 3213 (class 2606 OID 16467)
-- Name: accesari accesari_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accesari
    ADD CONSTRAINT accesari_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.utilizatori(id);


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE model; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.model TO dimi999;


--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 209
-- Name: SEQUENCE model_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.model_id_seq TO dimi999;


--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE produse; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produse TO dimi999;


--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE produse_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produse_id_seq TO dimi999;


-- Completed on 2022-06-08 16:17:21

--
-- PostgreSQL database dump complete
--

