--
-- PostgreSQL database cluster dump
--

\restrict lKYIHGnUi78oN5gimBALml9TDl73nkR7y6SJ2slAtvpKIGfUvHy1SO3qkwsus7Q

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:ohICjP5D0U17fIOeEscE4w==$Wyh4t2ilizVzzYpP9lb1KGUf5BLlm/u5/iJ+pGKPPDo=:zMFviY+enTv9uOcstctoSKccccskCS287AIAAoAyOHQ=';

--
-- User Configurations
--








\unrestrict lKYIHGnUi78oN5gimBALml9TDl73nkR7y6SJ2slAtvpKIGfUvHy1SO3qkwsus7Q

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict P9CcVxxr4zHhZPSEOMtdCDulVZOcCEHbdM4SBYe78B00y4xTewdITlEPIc3U5Zb

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

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
-- PostgreSQL database dump complete
--

\unrestrict P9CcVxxr4zHhZPSEOMtdCDulVZOcCEHbdM4SBYe78B00y4xTewdITlEPIc3U5Zb

--
-- Database "ecommerce_ventas" dump
--

--
-- PostgreSQL database dump
--

\restrict OabxRkA0uofKOUQAzBgFK8W3XYfKzbumr9LRJlI4gZwxTQ6U6fElejeMULlsBgJ

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

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
-- Name: ecommerce_ventas; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE ecommerce_ventas WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE ecommerce_ventas OWNER TO postgres;

\unrestrict OabxRkA0uofKOUQAzBgFK8W3XYfKzbumr9LRJlI4gZwxTQ6U6fElejeMULlsBgJ
\connect ecommerce_ventas
\restrict OabxRkA0uofKOUQAzBgFK8W3XYfKzbumr9LRJlI4gZwxTQ6U6fElejeMULlsBgJ

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
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA drizzle;


ALTER SCHEMA drizzle OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: postgres
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


ALTER TABLE drizzle.__drizzle_migrations OWNER TO postgres;

--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: postgres
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNER TO postgres;

--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: postgres
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    address text,
    tax_id text,
    is_trust_verified boolean DEFAULT false,
    trust_score text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: electronic_invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.electronic_invoices (
    id integer NOT NULL,
    order_id integer NOT NULL,
    invoice_number text NOT NULL,
    sdi_identifier text,
    status text DEFAULT 'issued'::text NOT NULL,
    recipient_vat text NOT NULL,
    recipient_pec text,
    xml_url text,
    pdf_url text,
    total_amount numeric(10,2) NOT NULL,
    tax_amount numeric(10,2) NOT NULL,
    issued_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.electronic_invoices OWNER TO postgres;

--
-- Name: electronic_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.electronic_invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.electronic_invoices_id_seq OWNER TO postgres;

--
-- Name: electronic_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.electronic_invoices_id_seq OWNED BY public.electronic_invoices.id;


--
-- Name: inventory_movements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_movements (
    id integer NOT NULL,
    product_id integer NOT NULL,
    type text NOT NULL,
    quantity integer NOT NULL,
    previous_stock integer NOT NULL,
    new_stock integer NOT NULL,
    reason text NOT NULL,
    reference text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.inventory_movements OWNER TO postgres;

--
-- Name: inventory_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_movements_id_seq OWNER TO postgres;

--
-- Name: inventory_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_movements_id_seq OWNED BY public.inventory_movements.id;


--
-- Name: notification_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_logs (
    id integer NOT NULL,
    order_id integer,
    recipient_phone text NOT NULL,
    channel text DEFAULT 'sms'::text NOT NULL,
    message_text text NOT NULL,
    status text DEFAULT 'sent'::text NOT NULL,
    external_message_id text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification_logs OWNER TO postgres;

--
-- Name: notification_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_logs_id_seq OWNER TO postgres;

--
-- Name: notification_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_logs_id_seq OWNED BY public.notification_logs.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    product_sku text NOT NULL,
    product_name text NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    order_number text NOT NULL,
    customer_id integer,
    customer_name text NOT NULL,
    customer_email text NOT NULL,
    customer_phone text,
    customer_tax_id text,
    total numeric(10,2) NOT NULL,
    status text DEFAULT 'completed'::text NOT NULL,
    payment_method text DEFAULT 'card'::text NOT NULL,
    invoice_issued boolean DEFAULT false,
    sms_notified boolean DEFAULT false,
    notes text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    sku text NOT NULL,
    name text NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    cost numeric(10,2) DEFAULT 0.00 NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    min_stock integer DEFAULT 5 NOT NULL,
    category_id integer,
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    user_agent text,
    ip_address text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.refresh_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.refresh_tokens_id_seq OWNER TO postgres;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.refresh_tokens_id_seq OWNED BY public.refresh_tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    name text NOT NULL,
    role text DEFAULT 'admin'::text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: postgres
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: electronic_invoices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.electronic_invoices ALTER COLUMN id SET DEFAULT nextval('public.electronic_invoices_id_seq'::regclass);


--
-- Name: inventory_movements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements ALTER COLUMN id SET DEFAULT nextval('public.inventory_movements_id_seq'::regclass);


--
-- Name: notification_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_logs ALTER COLUMN id SET DEFAULT nextval('public.notification_logs_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.refresh_tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: __drizzle_migrations; Type: TABLE DATA; Schema: drizzle; Owner: postgres
--

COPY drizzle.__drizzle_migrations (id, hash, created_at) FROM stdin;
1	584dd097f6c7fff5be5104a190cc768446ad1683c7e922f442b4bc2b4e91a7ab	1790687040571
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, description, created_at) FROM stdin;
2	Electrónica	Gadgets, computadoras y componentes	2026-09-30 21:30:26.399748
3	Ropa & Moda	Prendas de vestir y calzado de temporada	2026-09-30 21:30:26.399748
4	Hogar & Cocina	Accesorios, muebles y electrodomésticos	2026-09-30 21:30:26.399748
5	Accesorios	Mochilas, relojes y complementos	2026-09-30 21:30:26.399748
6	Audio Profesional	Monitores de estudio, micrófonos e interfaces	2026-10-16 20:26:45.39308
7	Oficina & Ergonomía	Sillas ergonómicas, escritorios elevables y soportes	2026-10-16 20:26:45.472382
8	Gaming & Periféricos	Mandos, ratones ultraligeros y pads gaming	2026-10-16 20:26:45.475789
9	Smart Home & Domótica	Aspiradores robot, purificadores y luces IoT	2026-10-16 20:26:45.478866
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, name, email, phone, address, tax_id, is_trust_verified, trust_score, created_at) FROM stdin;
1	Carlos Mendoza	carlos.mendoza@email.com	+51 987654321	Av. Las Palmeras 450, Lima	\N	f	\N	2026-09-30 21:30:26.399748
2	Lucía Fernández	lucia.fernandez@email.com	+51 912345678	Calle Los Pinos 120, Miraflores	\N	f	\N	2026-09-30 21:30:26.399748
3	Rodrigo Silva	rodrigo.silva@email.com	+51 998877665	Jr. San Martín 880, San Isidro	\N	f	\N	2026-09-30 21:30:26.399748
4	Mateo Rossi	mateo.rossi@nexuscorp.it	+39 02 8945 1201	Via Montenapoleone 18, 20121 Milano, MI, Italia	IT08923450961	t	0.98	2026-10-16 20:26:45.506747
5	Valentina Morales	valentina.morales@designstudio.pe	+51 981 234 567	Calle Los Robles 340, San Isidro, Lima, Perú	PE20601234567	t	0.95	2026-10-16 20:26:45.506747
6	Alessandro Bianchi	alessandro.bianchi@techconsult.it	+39 06 6789 3322	Corso Vittorio Emanuele II 84, 00186 Roma, RM, Italia	IT01234560588	t	0.92	2026-10-16 20:26:45.506747
7	Gabriela Silva	gabriela.silva@innovacion.es	+34 91 555 4321	Paseo de la Castellana 110, 28046 Madrid, España	ESB87654321	t	0.96	2026-10-16 20:26:45.506747
8	Marco Bellini	marco.bellini@logistica-norte.it	+39 011 234 7788	Via Garibaldi 42, 10122 Torino, TO, Italia	IT04567890012	t	0.91	2026-10-16 20:26:45.506747
9	Camila Benítez	camila.benitez@agenciadigital.com	+51 945 678 123	Av. Larco 880 Of. 502, Miraflores, Lima, Perú	PE10456789012	t	0.89	2026-10-16 20:26:45.506747
10	Davide Colombo	davide.colombo@fintechgroup.eu	+39 051 445 9900	Via dell Indipendenza 25, 40121 Bologna, BO, Italia	IT09876540371	t	0.97	2026-10-16 20:26:45.506747
11	Sofia Alarcón	sofia.alarcon@ecoretail.cl	+56 9 8765 4321	Av. Providencia 1760, Santiago, Chile	CL76543210-K	t	0.93	2026-10-16 20:26:45.506747
12	Luca Ferrari	luca.ferrari@automotive-labs.it	+39 059 887 6655	Via Emilia Est 450, 41122 Modena, MO, Italia	IT06543210368	t	0.99	2026-10-16 20:26:45.506747
13	Esteban Navarro	esteban.navarro@cloudservices.co	+57 310 987 6543	Carrera 7 # 71-21 Torre B, Bogotá, Colombia	CO901234567-1	t	0.94	2026-10-16 20:26:45.506747
\.


--
-- Data for Name: electronic_invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.electronic_invoices (id, order_id, invoice_number, sdi_identifier, status, recipient_vat, recipient_pec, xml_url, pdf_url, total_amount, tax_amount, issued_at) FROM stdin;
1	3	FAC-2026-00003	SDI_1791972550953	issued	IT00000000000	rodrigo.silva@email.com.pec@legalmail.it	/api/openapi/invoices/FAC-2026-00003/xml	/api/openapi/invoices/FAC-2026-00003/pdf	349.00	62.93	2026-10-14 10:09:10.973489
2	4	INV-2026-0004	SDI-IT-8840004438	issued	IT08923450961	pec.mateo.rossi@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0004.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0004.pdf	667.50	146.85	2026-09-21 14:26:45.514
3	5	INV-2026-0005	SDI-IT-8840005878	issued	PE20601234567	pec.valentina.morales@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0005.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0005.pdf	588.80	129.54	2026-09-25 18:26:45.514
4	6	INV-2026-0006	SDI-IT-8840006270	issued	IT01234560588	pec.alessandro.bianchi@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0006.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0006.pdf	828.40	182.25	2026-09-28 16:26:45.514
5	7	INV-2026-0007	SDI-IT-8840007822	issued	ESB87654321	pec.gabriela.silva@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0007.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0007.pdf	648.80	142.74	2026-10-02 15:26:45.514
6	8	INV-2026-0008	SDI-IT-8840008188	issued	IT04567890012	pec.marco.bellini@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0008.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0008.pdf	768.00	168.96	2026-10-05 13:26:45.514
7	9	INV-2026-0009	SDI-IT-8840009865	issued	PE10456789012	pec.camila.benitez@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0009.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0009.pdf	457.00	100.54	2026-10-08 17:26:45.514
8	10	INV-2026-0010	SDI-IT-8840010946	issued	IT09876540371	pec.davide.colombo@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0010.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0010.pdf	728.00	160.16	2026-10-10 14:26:45.514
9	11	INV-2026-0011	SDI-IT-8840011924	issued	CL76543210-K	pec.sofia.alarcon@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0011.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0011.pdf	389.60	85.71	2026-10-12 16:26:45.514
10	12	INV-2026-0012	SDI-IT-8840012576	issued	IT06543210368	pec.luca.ferrari@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0012.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0012.pdf	688.90	151.56	2026-10-14 10:26:45.514
11	13	INV-2026-0013	SDI-IT-8840013613	issued	CO901234567-1	pec.esteban.navarro@legalmail.it	https://nexus-sdi.storage.googleapis.com/xml/2026/INV-2026-0013.xml	https://nexus-sdi.storage.googleapis.com/pdf/2026/INV-2026-0013.pdf	579.00	127.38	2026-10-15 10:26:45.514
\.


--
-- Data for Name: inventory_movements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_movements (id, product_id, type, quantity, previous_stock, new_stock, reason, reference, created_at) FROM stdin;
1	1	IN	18	0	18	Carga inicial de inventario	INV-INIT-001	2026-09-30 21:30:26.399748
2	2	IN	45	0	45	Carga inicial de inventario	INV-INIT-001	2026-09-30 21:30:26.399748
3	3	IN	3	0	3	Carga inicial de inventario	INV-INIT-001	2026-09-30 21:30:26.399748
4	4	IN	25	0	25	Carga inicial de inventario	INV-INIT-001	2026-09-30 21:30:26.399748
5	5	IN	12	0	12	Carga inicial de inventario	INV-INIT-001	2026-09-30 21:30:26.399748
6	6	IN	8	0	8	Carga inicial de inventario	INV-INIT-001	2026-09-30 21:30:26.399748
7	7	IN	50	0	50	Carga inicial de inventario	INV-INIT-001	2026-09-30 21:30:26.399748
8	9	IN	10	0	10	Recepción lote inicial importación Asia L-902	INV-LOT-902	2026-09-18 20:26:45.514
9	12	IN	25	0	25	Ingreso pallet sillas fábrica europea	INV-PAL-441	2026-09-19 20:26:45.514
10	14	IN	40	0	40	Reposición programada distribuidor GamingTech	INV-REP-778	2026-09-22 20:26:45.514
11	16	IN	12	0	12	Carga lote robot aspirador SmartClean	INV-LOT-303	2026-09-26 20:26:45.514
12	18	IN	70	0	70	Recepción masiva cargadores GaN alta rotación	INV-LOT-889	2026-10-01 20:26:45.514
13	9	OUT	2	10	8	Asignación de unidades a Showroom tecnológico principal	MOV-SHOW-01	2026-09-24 20:26:45.514
14	13	OUT	1	12	11	Baja técnica por daño estético en embalaje de transporte	MOV-DAM-08	2026-09-30 20:26:45.514
15	17	OUT	2	25	23	Pruebas de laboratorio y certificación ambiental HEPA	MOV-QA-104	2026-10-04 20:26:45.514
16	3	OUT	1	13	12	Demostración en evento gamer presencial	MOV-EVT-03	2026-10-09 20:26:45.514
17	4	RETURN	1	24	25	Devolución conforme de cliente por cambio de talla (M -> L)	RMA-RET-201	2026-10-03 20:26:45.514
18	5	RETURN	1	11	12	Retorno por garantía comercial revisada y aprobada	RMA-RET-202	2026-10-07 20:26:45.514
19	15	RETURN	1	15	16	Reingreso a inventario: cliente desistió antes de entrega	RMA-RET-203	2026-10-11 20:26:45.514
20	12	SALE	2	20	18	Despacho orden ecommerce ref ORD-2026-004	ORD-2026-004	2026-09-21 20:26:45.514
21	9	SALE	1	6	5	Despacho orden ecommerce ref ORD-2026-006	ORD-2026-006	2026-09-28 20:26:45.514
22	16	SALE	1	10	9	Despacho orden ecommerce ref ORD-2026-008	ORD-2026-008	2026-10-05 20:26:45.514
23	14	SALE	3	35	32	Despacho orden ecommerce ref ORD-2026-011	ORD-2026-011	2026-10-12 20:26:45.514
24	9	IN	10	2	12	Reposición rápida de unidades bajas de seguridad	REP-URG-5114	2026-10-17 16:33:35.805346
25	3	IN	10	3	13	Reposición rápida de unidades bajas de seguridad	REP-URG-0922	2026-10-17 16:34:21.062231
26	10	IN	10	3	13	Reposición rápida de unidades bajas de seguridad	REP-URG-1297	2026-10-17 17:39:21.445454
27	11	IN	10	4	14	Reposición rápida de unidades bajas de seguridad	REP-URG-2722	2026-10-17 17:39:22.802559
\.


--
-- Data for Name: notification_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_logs (id, order_id, recipient_phone, channel, message_text, status, external_message_id, created_at) FROM stdin;
1	3	+51987654321	sms	NexusSales: Su pedido ORD-2026-003 por $349.00 fue despachado.	sent	MSG_SMS_1791994612534	2026-10-14 16:16:52.536118
2	4	+39 02 8945 1201	sms	NexusSales: Su pedido ORD-2026-004 por $667.50 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-004.	delivered	TEL-MSG-88401690	2026-09-21 14:26:45.514
3	5	+51 981 234 567	whatsapp	NexusSales: Su pedido ORD-2026-005 por $588.80 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-005.	delivered	TEL-MSG-88415116	2026-09-25 18:26:45.514
4	6	+39 06 6789 3322	sms	NexusSales: Su pedido ORD-2026-006 por $828.40 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-006.	delivered	TEL-MSG-88427646	2026-09-28 16:26:45.514
5	7	+34 91 555 4321	whatsapp	NexusSales: Su pedido ORD-2026-007 por $648.80 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-007.	delivered	TEL-MSG-88433146	2026-10-02 15:26:45.514
6	8	+39 011 234 7788	sms	NexusSales: Su pedido ORD-2026-008 por $768.00 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-008.	delivered	TEL-MSG-88442367	2026-10-05 13:26:45.514
7	9	+51 945 678 123	whatsapp	NexusSales: Su pedido ORD-2026-009 por $457.00 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-009.	delivered	TEL-MSG-88453489	2026-10-08 17:26:45.514
8	10	+39 051 445 9900	sms	NexusSales: Su pedido ORD-2026-010 por $728.00 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-010.	delivered	TEL-MSG-88461925	2026-10-10 14:26:45.514
9	11	+56 9 8765 4321	whatsapp	NexusSales: Su pedido ORD-2026-011 por $389.60 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-011.	delivered	TEL-MSG-88478673	2026-10-12 16:26:45.514
10	12	+39 059 887 6655	sms	NexusSales: Su pedido ORD-2026-012 por $688.90 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-012.	delivered	TEL-MSG-88483249	2026-10-14 10:26:45.514
11	13	+57 310 987 6543	whatsapp	NexusSales: Su pedido ORD-2026-013 por $579.00 fue confirmado con éxito. Guía de seguimiento: TRK-ORD-2026-013.	delivered	TEL-MSG-88493683	2026-10-15 10:26:45.514
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, product_sku, product_name, quantity, unit_price, subtotal, created_at) FROM stdin;
1	1	1	ELEC-LAP-001	Laptop Ultra Pro 16"	1	1499.99	1499.99	2026-09-30 21:30:26.399748
2	1	2	ELEC-AUR-002	Auriculares Noise-Cancelling Wireless	1	189.50	189.50	2026-09-30 21:30:26.399748
3	2	4	MODA-CHA-001	Chaqueta Bomber Impermeable	1	89.90	89.90	2026-09-30 21:30:26.399748
4	2	3	ELEC-TEC-003	Teclado Mecánico Custom RGB	1	115.00	115.00	2026-09-30 21:30:26.399748
5	3	6	HOG-CAF-001	Cafetera Espresso Barista Touch	1	349.00	349.00	2026-09-30 21:30:26.399748
6	4	12	ERG-SIL-001	Silla Ergonómica Nexus Ergoflex Pro	2	299.00	598.00	2026-09-21 14:26:45.514
7	4	18	ACC-CAR-002	Cargador Rápido GaN 140W Quad-Port USB-C	1	69.50	69.50	2026-09-21 14:26:45.514
8	5	13	ERG-ESC-002	Escritorio Elevable Eléctrico Standing Desk 140x70	1	429.00	429.00	2026-09-25 18:26:45.514
9	5	14	GAM-MAN-001	Mando Inalámbrico Pro Wireless Hall Effect	2	79.90	159.80	2026-09-25 18:26:45.514
10	6	9	ELEC-MON-005	Monitor Curvo UltraWide 34" QHD 165Hz	1	489.00	489.00	2026-09-28 16:26:45.514
11	6	10	AUD-MIC-001	Micrófono Condensador Broadcast USB-C	1	139.50	139.50	2026-09-28 16:26:45.514
12	6	11	ELEC-CAM-006	Cámara Web Profesional 4K 60FPS AI	1	199.90	199.90	2026-09-28 16:26:45.514
13	7	15	AUD-BAR-002	Barra de Sonido Dolby Atmos Spatial 5.1	1	349.00	349.00	2026-10-02 15:26:45.514
14	7	20	ELEC-SSD-007	Unidad SSD NVMe PCIe 4.0 2TB 7400MB/s	2	149.90	299.80	2026-10-02 15:26:45.514
15	8	16	HOG-ASP-002	Robot Aspirador Láser LiDAR LaserSweep X9	1	579.00	579.00	2026-10-05 13:26:45.514
16	8	17	HOG-PUR-003	Purificador de Aire Inteligente PureAir HEPA H13	1	189.00	189.00	2026-10-05 13:26:45.514
17	9	19	MODA-PAR-003	Parka Térmica Impermeable Arctic Shield	2	159.00	318.00	2026-10-08 17:26:45.514
18	9	18	ACC-CAR-002	Cargador Rápido GaN 140W Quad-Port USB-C	2	69.50	139.00	2026-10-08 17:26:45.514
19	10	12	ERG-SIL-001	Silla Ergonómica Nexus Ergoflex Pro	1	299.00	299.00	2026-10-10 14:26:45.514
20	10	13	ERG-ESC-002	Escritorio Elevable Eléctrico Standing Desk 140x70	1	429.00	429.00	2026-10-10 14:26:45.514
21	11	14	GAM-MAN-001	Mando Inalámbrico Pro Wireless Hall Effect	3	79.90	239.70	2026-10-12 16:26:45.514
22	11	20	ELEC-SSD-007	Unidad SSD NVMe PCIe 4.0 2TB 7400MB/s	1	149.90	149.90	2026-10-12 16:26:45.514
23	12	9	ELEC-MON-005	Monitor Curvo UltraWide 34" QHD 165Hz	1	489.00	489.00	2026-10-14 10:26:45.514
24	12	11	ELEC-CAM-006	Cámara Web Profesional 4K 60FPS AI	1	199.90	199.90	2026-10-14 10:26:45.514
25	13	16	HOG-ASP-002	Robot Aspirador Láser LiDAR LaserSweep X9	1	579.00	579.00	2026-10-15 10:26:45.514
26	14	10	AUD-MIC-001	Micrófono Condensador Broadcast USB-C	2	139.50	279.00	2026-10-16 19:26:45.514
27	14	18	ACC-CAR-002	Cargador Rápido GaN 140W Quad-Port USB-C	1	69.50	69.50	2026-10-16 19:26:45.514
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, order_number, customer_id, customer_name, customer_email, customer_phone, customer_tax_id, total, status, payment_method, invoice_issued, sms_notified, notes, created_at, updated_at) FROM stdin;
1	ORD-2026-001	1	Carlos Mendoza	carlos.mendoza@email.com	\N	\N	1689.49	completed	card	f	f	Entrega prioritaria	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
2	ORD-2026-002	2	Lucía Fernández	lucia.fernandez@email.com	\N	\N	204.90	completed	transfer	f	f	Confirmación de pago validada	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
3	ORD-2026-003	3	Rodrigo Silva	rodrigo.silva@email.com	\N	\N	349.00	processing	card	t	t	En proceso de preparación en almacén	2026-09-30 21:30:26.399748	2026-10-14 15:03:01.748
4	ORD-2026-004	4	Mateo Rossi	mateo.rossi@nexuscorp.it	+39 02 8945 1201	IT08923450961	667.50	completed	card	t	t	Envío express corporativo a oficina Milán	2026-09-21 14:26:45.514	2026-09-21 14:26:45.514
5	ORD-2026-005	5	Valentina Morales	valentina.morales@designstudio.pe	+51 981 234 567	PE20601234567	588.80	completed	transfer	t	t	Transferencia bancaria internacional confirmada	2026-09-25 18:26:45.514	2026-09-25 18:26:45.514
6	ORD-2026-006	6	Alessandro Bianchi	alessandro.bianchi@techconsult.it	+39 06 6789 3322	IT01234560588	828.40	completed	card	t	t	Pack streamer profesional completo	2026-09-28 16:26:45.514	2026-09-28 16:26:45.514
7	ORD-2026-007	7	Gabriela Silva	gabriela.silva@innovacion.es	+34 91 555 4321	ESB87654321	648.80	completed	paypal	t	t	Pago verificado vía PayPal Express	2026-10-02 15:26:45.514	2026-10-02 15:26:45.514
8	ORD-2026-008	8	Marco Bellini	marco.bellini@logistica-norte.it	+39 011 234 7788	IT04567890012	768.00	completed	card	t	t	Promoción Hogar Inteligente aplicada	2026-10-05 13:26:45.514	2026-10-05 13:26:45.514
9	ORD-2026-009	9	Camila Benítez	camila.benitez@agenciadigital.com	+51 945 678 123	PE10456789012	457.00	completed	transfer	t	t	Factura B2B requerida con retención	2026-10-08 17:26:45.514	2026-10-08 17:26:45.514
10	ORD-2026-010	10	Davide Colombo	davide.colombo@fintechgroup.eu	+39 051 445 9900	IT09876540371	728.00	completed	card	t	t	Armado en destino programado para viernes	2026-10-10 14:26:45.514	2026-10-10 14:26:45.514
11	ORD-2026-011	11	Sofia Alarcón	sofia.alarcon@ecoretail.cl	+56 9 8765 4321	CL76543210-K	389.60	completed	card	t	t	Cliente VIP Club Nexus Gaming	2026-10-12 16:26:45.514	2026-10-12 16:26:45.514
12	ORD-2026-012	12	Luca Ferrari	luca.ferrari@automotive-labs.it	+39 059 887 6655	IT06543210368	688.90	processing	transfer	f	t	En preparación en muelle de expedición 2	2026-10-14 10:26:45.514	2026-10-14 10:26:45.514
13	ORD-2026-013	13	Esteban Navarro	esteban.navarro@cloudservices.co	+57 310 987 6543	CO901234567-1	579.00	completed	card	t	t	Entrega prioritaria courier Same-Day	2026-10-15 10:26:45.514	2026-10-15 10:26:45.514
14	ORD-2026-014	4	Mateo Rossi	mateo.rossi@nexuscorp.it	+39 02 8945 1201	IT08923450961	348.50	processing	card	f	t	Pedido reciente en validación de empaque	2026-10-16 19:26:45.514	2026-10-16 19:26:45.514
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, sku, name, description, price, cost, stock, min_stock, category_id, status, created_at, updated_at) FROM stdin;
1	ELEC-LAP-001	Laptop Ultra Pro 16"	32GB RAM, 1TB SSD, Procesador M3 Max / Intel i9	1499.99	1100.00	18	5	2	active	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
2	ELEC-AUR-002	Auriculares Noise-Cancelling Wireless	Cancelación activa de ruido, 40h de batería, audio Hi-Res	189.50	115.00	45	10	2	active	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
4	MODA-CHA-001	Chaqueta Bomber Impermeable	Material reciclado, corte moderno slim, resistencia al viento	89.90	42.00	25	5	3	active	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
5	MODA-ZAP-002	Zapatillas Urban Runner Pro	Suela ergonómica amortiguada, tejido transpirable	115.00	60.00	12	6	3	active	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
6	HOG-CAF-001	Cafetera Espresso Barista Touch	15 bares de presión, molinillo integrado y vaporizador de leche	349.00	230.00	8	4	4	active	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
7	ACC-MOC-001	Mochila Antirrobo Tech 25L	Puerto USB de carga, compartimento acolchado para laptop 16"	59.99	28.00	50	15	5	active	2026-09-30 21:30:26.399748	2026-09-30 21:30:26.399748
8	ELEC-MOU-004	Ratón Ergonómico Inalámbrico Pro	Sensor óptico 4000 DPI, batería recargable, conexión Bluetooth y 2.4GHz	79.99	38.50	30	10	2	active	2026-10-01 16:50:33.99791	2026-10-01 16:50:33.99791
12	ERG-SIL-001	Silla Ergonómica Nexus Ergoflex Pro	Malla transpirable 3D, soporte lumbar dinámico autoajustable, reposabrazos 4D	299.00	175.00	16	5	7	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
13	ERG-ESC-002	Escritorio Elevable Eléctrico Standing Desk 140x70	Doble motor ultrasilencioso, memoria digital 4 alturas, tablero nogal macizo	429.00	260.00	9	4	7	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
14	GAM-MAN-001	Mando Inalámbrico Pro Wireless Hall Effect	Joysticks de efecto Hall antidesgaste, gatillos analógicos con parada corta	79.90	39.00	32	10	8	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
15	AUD-BAR-002	Barra de Sonido Dolby Atmos Spatial 5.1	Subwoofer inalámbrico 200W, HDMI eARC, Bluetooth 5.3 y AirPlay 2	349.00	210.00	14	5	6	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
16	HOG-ASP-002	Robot Aspirador Láser LiDAR LaserSweep X9	Succión 6000Pa, fregado sónico vibratorio, estación de autovaciado 60 días	579.00	380.00	8	4	9	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
17	HOG-PUR-003	Purificador de Aire Inteligente PureAir HEPA H13	Filtración de 4 capas, sensor láser PM2.5, cobertura 65m², control por app	189.00	110.00	22	8	9	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
18	ACC-CAR-002	Cargador Rápido GaN 140W Quad-Port USB-C	Tecnología Nitruro de Galio, soporta PD 3.1, carga simultánea laptop + tablet + 2 móviles	69.50	32.00	58	15	9	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
19	MODA-PAR-003	Parka Térmica Impermeable Arctic Shield	Aislamiento térmico Primaloft, costuras selladas, reflectores nocturnos	159.00	78.00	24	6	3	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
20	ELEC-SSD-007	Unidad SSD NVMe PCIe 4.0 2TB 7400MB/s	Disipador térmico de grafeno, ideal para PS5 y workstations de edición	149.90	89.00	42	12	2	active	2026-10-16 20:26:45.494671	2026-10-16 20:26:45.494671
11	ELEC-CAM-006	Cámara Web Profesional 4K 60FPS AI	Sensor Sony Starvis, autoenfoque láser, micrófono estéreo beamforming	199.90	115.00	4	12	6	active	2026-10-16 20:26:45.494671	2026-10-17 17:39:41.972
10	AUD-MIC-001	Micrófono Condensador Broadcast USB-C	Cápsula cardioide 24-bit/96kHz, filtro pop magnético y brazo articulado	139.50	72.00	3	10	6	active	2026-10-16 20:26:45.494671	2026-10-17 17:39:55.327
3	ELEC-TEC-003	Teclado Mecánico Custom RGB	Switches lubricados, keycaps PBT, conectividad Bluetooth 5.2 y 2.4G	129.00	75.00	3	8	2	active	2026-09-30 21:30:26.399748	2026-10-17 17:59:41.95
9	ELEC-MON-005	Monitor Curvo UltraWide 34" QHD 165Hz	Panel IPS HDR400, 1ms MPRT, USB-C 90W PD, sRGB 120%	489.00	310.00	2	8	8	active	2026-10-16 20:26:45.494671	2026-10-17 18:00:09.637
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, user_id, token_hash, expires_at, revoked_at, user_agent, ip_address, created_at) FROM stdin;
1	1	1ac9acdd747e492917db4bbe31ffd3ad8c55212578662222b134f09bae860d28	2026-10-07 21:26:53.803	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.1	2026-09-30 21:26:53.833997
2	1	25ece2f42c41975c7b0bff3365edf43936f59569b80b56820588ce787f2aaea9	2026-10-07 21:30:46.521	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.1	2026-09-30 21:30:46.522445
3	1	a5182a19bdb3fda1febc9a4fe604da2768a9f1c0a4e043584cb32bfbbf0f0c7d	2026-10-07 22:16:30.628	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.1	2026-09-30 22:16:30.630019
4	1	2df7ecafd8b96403a819b0547d6ac92e906ef8408fa98f4fc82241c0e6c01bc7	2026-10-07 22:47:19.777	\N	Mozilla/5.0 (Android 14; Mobile; rv:156.0) Gecko/156.0 Firefox/156.0	::ffff:172.18.0.1	2026-09-30 22:47:19.778103
6	1	cc304cfe2a7a830c496068181a3951610ab81600bd76fa9cc41e6a2801ec207e	2026-10-08 00:44:37.51	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 00:44:37.511484
5	1	82ff16f50f17c102a254577f02ac4ad55a291a6c4187ba207ff111f4a0e78bb7	2026-10-08 00:42:29.51	2026-10-01 00:56:35.747	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 00:42:29.512578
7	1	d170c4bad64365a27f2f6e247a297d5ae4414cae4514d6a51929d7d68048d33d	2026-10-08 00:56:35.854	2026-10-01 00:56:48.479	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 00:56:35.855572
8	1	9c350cc1cd45f60a6b15155164abf9832ae56671d31de7405bc961a3ebeed1c0	2026-10-08 00:56:48.499	2026-10-01 00:56:52.808	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 00:56:48.500411
9	1	e7d1b736be9ccc5f287c19feccbc608b3b06343e36a2ed44fe3ecde395cd121b	2026-10-08 00:56:56.929	2026-10-01 00:57:26.848	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 00:56:56.929839
10	1	8c76799451da2ff24d90f3f81b109a1431daf3dc798b2356d38d21b3f102c635	2026-10-08 02:02:47.308	2026-10-01 02:14:08.858	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 02:02:47.309093
11	1	4c9691f8c1bb04b192ccf2af11d78911245580a9295f43df5e77b7aaf254b8c6	2026-10-08 02:14:08.973	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 02:14:08.974352
12	1	71e07d379b52d1ebd1524230df0b6529eede939b41c65705753e7133eba39851	2026-10-08 02:19:31.381	2026-10-01 02:22:33.322	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 02:19:31.382515
13	1	26318f095d005cc0fa4021275975e5eefff13d6cf3df1bc96d0a7f09c08872e6	2026-10-08 02:22:33.346	2026-10-01 02:22:37.856	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 02:22:33.347678
14	1	a34f280c2c7cdfc37c847b8e24bfec7f3e3c8323563858e80c114de062fb560f	2026-10-08 14:47:07.024	2026-10-01 16:33:24.008	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 14:47:07.025843
15	1	98c7a37554bb549ae0d8d1b5db2e1c1b0a6c7fac8a372c697c31074df6cb8085	2026-10-08 16:33:24.449	2026-10-01 16:33:27.367	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:33:24.451281
17	1	5ccfc8ebd00f6d02fa1a38d1e3920cf31087e0109bc90abae1de654bce23b5be	2026-10-08 16:35:08.302	2026-10-01 16:35:14.493	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:35:08.303065
16	1	f939e22e17021e48e46379f9ebf0879d216b41945999d3cac4c924095e80c1ec	2026-10-08 16:33:29.048	2026-10-01 16:41:59.752	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:33:29.049825
19	1	2644a28ccf1e6ba924bb8cda7cbb44e92c0644c46300ea4de829d7309c7282a5	2026-10-08 16:42:00.037	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:42:00.038863
20	1	94510ddac2fe2657ee1fa064088b1953254cbfcf12316a792e6ea576f922870a	2026-10-08 16:42:37.652	2026-10-01 16:46:08.801	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:42:37.653792
21	1	895cdc7b313a8e4b772f702ba3024e601fdb2ce1d91f96833d2b2759cc8b07cc	2026-10-08 16:46:08.822	2026-10-01 16:52:09.348	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:46:08.82326
22	1	8c3516ee2607ee2da0afb59638faf77468f61c33998151f8c178dff930450167	2026-10-08 16:52:09.377	2026-10-01 16:52:13.491	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:52:09.377721
23	1	522e434c9b72f1d7ab8014b17bd5c3ed6fba04b1cf5145da43f5a7cf6f23a994	2026-10-08 16:52:13.501	2026-10-01 17:00:32.23	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:52:13.502186
24	1	a4041901faffdc75eedaee3ae6fd39e1dc19a4c5024bf5df148f353a82059948	2026-10-08 17:00:32.251	2026-10-01 17:00:34.704	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 17:00:32.251777
26	1	705fb1b8ad9d82d2ed931e70d30c912af6606b4e7cf87c4c99578929494c2ae1	2026-10-08 17:06:56.95	2026-10-01 17:07:05.917	Mozilla/5.0 (Android 14; Mobile; rv:156.0) Gecko/156.0 Firefox/156.0	::ffff:172.18.0.4	2026-10-01 17:06:56.951132
18	1	cefdfc81f305301c4f6d25ee4b8e6b89c0a42927762d70697ed981ec41c373b2	2026-10-08 16:35:14.503	2026-10-01 17:35:54.256	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 16:35:14.504172
27	1	57b9526a4005bf367835262e12928eda2e9de47a2dbeb6d62630ba36d394e652	2026-10-08 17:35:54.312	2026-10-01 18:48:31.819	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 17:35:54.313022
28	1	8e66344d1bb1fd1fbc719b9a08a75d6eb90086ffe81ee98b4020354f8b50bf0a	2026-10-08 18:48:31.86	2026-10-01 18:48:36.915	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 18:48:31.861917
29	1	3d8bba2a67a5de52dccc7b16882ed5d6a129c0854001354d003e120e2fc22205	2026-10-08 18:48:45	2026-10-01 18:48:54.026	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 18:48:45.001164
30	1	5ebbc49b4bcaef0fa88ee5098fe430e973aa12a95fc55fe1c37140b317a82de6	2026-10-08 18:48:54.035	2026-10-01 18:48:58.087	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 18:48:54.035771
25	1	1f47f6fd01cc6a061ff22b8fbbbe3d8781a67655a478d1602bb850c08e96c879	2026-10-08 17:00:50.693	2026-10-03 12:49:04.4	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-01 17:00:50.69432
31	1	4bdb65e8acac51a5aa6bb4ed8fac75e80126b3a5f7c662d5a66c22f70c88e02b	2026-10-08 18:48:58.096	2026-10-01 18:49:00.802	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 18:48:58.096667
32	1	10bc51db87eaae763ae5718b95c3cb0a978081690d344176c6a0f9ad7249b7d8	2026-10-08 18:49:02.013	2026-10-02 00:47:13.975	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-01 18:49:02.013806
33	1	a3137fdc3f49ddbf7b9df26b1b8337a46537fc668f5269834f1b3822f130a81f	2026-10-09 00:47:14.229	2026-10-02 16:16:23.402	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-02 00:47:14.230751
34	1	765bdea01937fe8b8d951a394654b1495d51d3d1e447ccef8ffafa2f7fa535cd	2026-10-09 16:16:25.394	2026-10-02 16:16:31.415	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.3	2026-10-02 16:16:25.398269
36	1	a2bdfd73143c0f570d1408336e88c9155d89412fc9ba7dde3fad9c7e04e2b570	2026-10-10 12:49:05.647	2026-10-03 15:09:07.587	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.3	2026-10-03 12:49:05.649335
37	1	63b43063196ebc07d8ddff62fa6ae37b7d7a54361ed354eb5a99e40cb7122eb6	2026-10-10 15:09:08.051	2026-10-03 15:24:11.01	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-03 15:09:08.05351
38	1	03f791d62cf312c96134a9527fb21d42dcc9e028f01dcdd0f429d3cb0898a8d5	2026-10-10 15:24:11.046	2026-10-03 15:24:13.897	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-03 15:24:11.049586
35	1	cef477be6ed49640baa142c9619c9e2dc024e2757a2d1f99c0c78a0cbac78396	2026-10-10 00:12:44.216	2026-10-03 17:59:30.912	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.3	2026-10-03 00:12:44.218175
39	1	f24445c64b08464c9cfecbc6750de52ced031328aeb0a961726c77b390adea17	2026-10-10 17:59:32.152	2026-10-03 17:59:36.126	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-03 17:59:32.154609
40	1	a6bf50ecf31f07de4e245d14a20dfd7d9d732825e9d809af740b365edef4aa46	2026-10-10 17:59:43.513	2026-10-04 00:05:47.857	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-03 17:59:43.514317
41	1	391270bd78f593714d4a62d616f194aabe0455b0e0e194b38d64cc41ce7a7c23	2026-10-11 00:05:48.725	2026-10-04 00:05:57.325	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 00:05:48.726632
42	1	3e82b9b1c141e13c97c9fcc35da4efa4590694ddcfb61185b9dc7ce25c2e241b	2026-10-11 00:05:57.338	2026-10-04 00:08:20.221	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 00:05:57.339403
43	1	a550eac56f40ab700218d28f3df3919b3d17feb67021244a0efa6071a8b7a677	2026-10-11 00:08:20.245	2026-10-04 00:08:26.897	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 00:08:20.246664
44	1	a4a37fa6a4f5efc22b77903b7e053d40817eb3dd4c67ba9512ea36bcbd1b25fa	2026-10-11 00:08:33.562	2026-10-04 00:08:40.243	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 00:08:33.563462
45	1	c15694dcbfcd500a83641d2c45abbe4d175a0d0dfbe66a38791f95be1f37ffee	2026-10-11 00:08:40.254	2026-10-04 00:08:41.139	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 00:08:40.25522
46	1	750817597140dbb76146dc0df7e8fc981f17c52542a443feeb3572b57764318b	2026-10-11 00:08:41.149	2026-10-04 06:53:50.181	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 00:08:41.150645
47	1	514e39432e584ced875857c4adf2e7b7a756a5b86b76267492a2291e651a91e0	2026-10-11 06:53:51.583	2026-10-04 06:58:44.999	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 06:53:51.587332
48	1	d3854879013b7edbeb9755a394d14f92008316460e37c7eb1a0f7817b7eaa1e1	2026-10-11 06:58:45.071	2026-10-04 06:58:57.377	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 06:58:45.073433
50	1	1b65b1cd42034cad0127020160e144a435c693230e3158491b60a840a0ea93a6	2026-10-13 00:50:51.843	2026-10-06 00:52:38.988	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 00:50:51.845239
49	1	c425f77c33a7b4c273c5fb3f86279718fbdd6863bf99b91a82f41c45ed3b2f7d	2026-10-11 06:58:57.402	2026-10-06 16:40:39.867	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-04 06:58:57.403017
52	1	dc00d3fc2b0cad3c9cd74e0d0dce7d41eccb3396e58f55c9bc8d08009a8851ca	2026-10-13 18:17:03.828	2026-10-06 19:39:31.703	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 18:17:03.830004
53	1	6c5d5b368ec60e3e121bb0459469206614cec4363dbdb7b3da717ac76f96e026	2026-10-13 19:39:32.192	2026-10-06 19:39:45.468	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 19:39:32.194899
54	1	ec0234e9ac8a77347f789ddb1fb9da0476004ba8de731c7a558d47861b1e5cf5	2026-10-13 19:39:45.492	2026-10-06 19:40:09.326	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 19:39:45.493288
55	1	963c604fec87cd103f04e4ef61369e4d2c6e548e56494cfba4eda74967b878d3	2026-10-13 19:40:09.353	2026-10-06 19:40:36.699	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 19:40:09.354238
56	1	06b613ab33e88034ffecdc33d7f51ca6a5fb630fcd954b9e5c40ff9a86b3f8d4	2026-10-13 19:40:36.709	2026-10-06 19:41:28.565	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 19:40:36.710435
57	1	be476c0a07a527cf7907ab3fe435a98765a24bc343583d3225a816588adfd7c1	2026-10-13 19:42:06.18	2026-10-06 19:43:34.892	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 19:42:06.181496
58	1	2899ace301e299808aee87caebcd550abb30e9cbf5ed2d6be826a9ddf5b485a9	2026-10-13 19:43:35.019	2026-10-06 19:52:53.636	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 19:43:35.020288
51	1	9b1800c8bfec8fe8fdb982e0f12de2b18a145b7c6024d32a56ac72bd70188e15	2026-10-13 16:40:40.26	2026-10-06 23:26:02.191	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-06 16:40:40.261666
59	1	d290a7130b38ece4fffb3ca2961b93c69bf1beba11649da3b5972d1b8fa4ff3e	2026-10-13 19:52:53.994	2026-10-07 19:34:32.411	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-06 19:52:53.995221
60	1	b1e207356729df5a8f52cd304943caf45e800ccb630803b336cae36b33224796	2026-10-13 23:26:02.544	2026-10-06 23:26:09.075	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-06 23:26:02.546329
62	1	fc97f389147812715be04a0ada544cff45f80144047998e8d59ed170640c6b10	2026-10-14 19:34:33.621	2026-10-07 20:59:40.083	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-07 19:34:33.653117
64	1	02fcc0a9215d7a98207bd72dd1b1479c5bee3ff52b46b2811c68c587df2664af	2026-10-14 21:51:08.02	2026-10-07 21:51:20.254	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-07 21:51:08.022183
65	1	5655d38057a9d4b83f1fae7f8c7a6594865de568ba78e07d05f97315bf8ecca0	2026-10-14 21:51:20.28	2026-10-07 21:51:28.062	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-07 21:51:20.281332
66	1	ca3ad895df84c81fcda915c32aaaee2ec3ee214a782492733a26537e5e1182bd	2026-10-14 21:51:28.072	2026-10-07 21:51:31.61	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-07 21:51:28.072754
67	1	7deb23cafb812cafe28aed1b37079dab5cf300ae1b88a7a4a0709c7bfdf68f40	2026-10-14 21:51:31.62	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-07 21:51:31.621728
61	1	ee824b340c42bb6af57f57c0bdca35f3b3f34bddcec28de657c5c32ec735098a	2026-10-13 23:26:09.087	2026-10-08 11:47:03.63	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-06 23:26:09.08783
68	1	42728ad7bc8a70e59a357685ccddfac5e330b90082ac4fd78061a967fa998e26	2026-10-15 11:47:04.563	2026-10-08 11:47:30.124	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-08 11:47:04.565129
69	1	85b8686d107876dd8173331e294762bf13f29fa116ca559a1bf696a96c810fc1	2026-10-15 11:47:30.147	2026-10-08 11:47:40.45	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-08 11:47:30.148496
63	1	c68cb0b662c91df2ea2d46400e7a0bcb4c0e04a78ab228ca4e2300d1690c2bda	2026-10-14 20:59:41.77	2026-10-08 16:46:29.523	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.2	2026-10-07 20:59:41.774443
70	1	6cd20d487b8607e490edf1c3226f791b28fb2922706a8b25e960fb869be27c09	2026-10-15 11:47:40.475	2026-10-09 12:54:12.159	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-08 11:47:40.475703
71	1	615d51b3658b7b02c6c9ccd90aa696f43f1b30f3874b53937fce5104cd361b96	2026-10-15 16:46:29.608	2026-10-09 15:12:07.725	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.2	2026-10-08 16:46:29.610082
73	1	9fa5e74283b93b227dd33c9dc6240bbbf8ccae7bb8bf8c8c6478f737f460d56c	2026-10-16 15:12:08.817	2026-10-09 15:12:20.266	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.2	2026-10-09 15:12:08.819435
74	1	1d27820b52226dffdb00c7ec4d941a87316eb8f4b2ace2f594999687cf275354	2026-10-16 15:12:20.296	2026-10-09 15:12:41.141	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.2	2026-10-09 15:12:20.29701
76	1	0ac2a40a624f0de4a5e80ca0ede3a7b2f04c13cd0bfbdf229964cf281738f889	2026-10-16 21:25:08.088	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-09 21:25:08.09564
72	1	94a44f9a7b5953556b1986d9d1a7253794b11cb110fa3f45f51a93cbf65e785d	2026-10-16 12:54:13.846	2026-10-09 21:35:23.188	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-09 12:54:13.851152
77	1	aba64cf8fa25956ee2e0721342e1bb1b63579663c8a44dd3128298a967d7665a	2026-10-16 21:35:23.234	2026-10-09 21:35:44.449	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-09 21:35:23.23486
78	1	2d52927569e32c59f78d704836109914694e2e435edd585ad4bad295d11cd010	2026-10-16 21:35:44.477	2026-10-09 21:35:54.569	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-09 21:35:44.478689
75	1	989b6d0bfc1dcdb874d51eccbe945a779385eee0e37d51bb10415def2d2a8271	2026-10-16 15:13:08.651	2026-10-10 20:05:06.757	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.2	2026-10-09 15:13:08.652758
80	1	d04643e012b60b80321eb573444a44cba1e5949528f6a09a9bcee77f4bb2d1c4	2026-10-17 20:05:07.587	2026-10-10 20:06:21.145	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.3	2026-10-10 20:05:07.588979
81	1	c50ddc9015172e2ae1520c2d15baf7ac5acc3d7c993e91a4c5e2abea38afde0d	2026-10-20 23:03:33.504	2026-10-14 01:45:58.25	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-13 23:03:33.508378
82	1	586d13a7d585aa92c6548311963dcb014be0eee9df656e71a9a6a2457b89efdb	2026-10-21 01:45:58.778	2026-10-14 01:46:05.872	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:45:58.780991
83	1	9b6d2b31ece5be5e3d73a1d4796db3547760abe6765912c883726cc36271f7d9	2026-10-21 01:46:05.885	2026-10-14 01:46:15.045	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:46:05.886821
84	1	86f3de67e912a7b0ec7ad93f8ed17eafbb2a5946af4f0dfbf4fd56eca70d196a	2026-10-21 01:46:15.057	2026-10-14 01:46:23.843	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:46:15.058281
85	1	de679341923d634d80879c06755db44ce30cf1c92c2c9dfce2611f1642e7f043	2026-10-21 01:46:23.85	2026-10-14 01:46:39.536	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:46:23.851651
86	1	39737930d397b374020d129be4eda03a71a6aecae7e973baa3bc1cc03e39a8cc	2026-10-21 01:46:39.561	2026-10-14 01:46:52.849	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:46:39.562486
87	1	06f67c604e62d60a98406193fb633817aa7ccb70b5cb31bac1c76f9ab083a88f	2026-10-21 01:46:52.86	2026-10-14 01:47:44.84	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:46:52.860857
88	1	d5301aa77f7aa50f2586badf51dec349629b1125e19dfeb4935db5ed1fbb861c	2026-10-21 01:47:44.863	2026-10-14 01:50:23.434	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:47:44.864596
79	1	e5a9ae8e4b2c465eb436bae184333df475ef13cea1ce69d531ef456059024f2f	2026-10-16 21:35:54.578	2026-10-14 10:08:25.387	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.2	2026-10-09 21:35:54.579456
89	1	291e9fee9acc1f55d57ff3acb7e76a7d605c6cba0256e35ac15cf7a71e0cda42	2026-10-21 01:50:23.462	2026-10-14 14:15:55.622	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 01:50:23.463649
91	1	e7ad40b04528bcafb79c0cb8ce0d9f8e4017913db5aa63d300604bfa6dee0b29	2026-10-21 14:15:56.307	2026-10-14 15:01:02.836	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 14:15:56.311786
92	1	fcce996683abfdbf1973ff9570119d53cda29b87aed28e6eb83a8f0ed1714618	2026-10-21 15:01:03.112	2026-10-14 15:01:14.16	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:01:03.115999
93	1	03df2fd428e44a7d45560696135efecfb9f27a313188215fff8943a3671ccb01	2026-10-21 15:01:14.172	2026-10-14 15:02:01.256	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:01:14.173772
94	1	9b2a9f32c941ae5f3514d343b0ae711ab6fbf3ac7f3d74db8b50be090c951c14	2026-10-21 15:02:01.295	2026-10-14 15:02:15.929	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:02:01.296085
95	1	2a550bdcae800e6ffff00318cb431f885093a1513ef6b24a6ba3e0a7d31ef76f	2026-10-21 15:02:15.939	2026-10-14 15:02:38.147	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:02:15.940073
96	1	8aecee3d81098a1448119cc68f8b69ba3d089742357fb2463140686b314ab565	2026-10-21 15:02:38.173	2026-10-14 15:04:15.949	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:02:38.174317
97	1	7145a88375456be7b6e4e136883873e65d0c034e4bb183523a04b00843f25007	2026-10-21 15:04:15.982	2026-10-14 15:55:18.604	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:04:15.983157
90	1	1fbf7dcce18afc4f9fdaf49726fd41211fd1105048641f6108c527031b246e9d	2026-10-21 10:08:25.735	2026-10-14 15:56:41.855	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-14 10:08:25.737883
98	1	02f03518e0d3aa078408e3ebceff1e0b9b88f8aa5246fcdfa85d811f0a29c316	2026-10-21 15:55:19.103	2026-10-14 16:15:55.409	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:55:19.103977
100	1	7b6852b514b2b88ba3814aaaeada42342d7a5de49d0b4aa99a70aea6e97bfc06	2026-10-21 16:16:47.743	2026-10-14 16:17:14.342	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 16:16:47.744029
99	1	da51bc31288401072f36bdd064a628dda258562e339185d5d12715698dbe32aa	2026-10-21 15:56:41.88	2026-10-15 20:47:59.763	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-14 15:56:41.881048
102	1	696b4a2d65f62a8620a400dadbd30c75f5823aeb5708607d2c64efc1d544f40b	2026-10-22 20:48:01.288	2026-10-15 20:48:04.968	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-15 20:48:01.292249
101	1	02fb92a71c62460674d7724f9d21acb28508702d5a2b39abdf79c554f6a73044	2026-10-21 16:17:14.354	2026-10-15 21:37:41.575	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-14 16:17:14.356084
104	1	bced9669b5acae2c591effbe6befaf0421da106f1a9fd214797ddca6dc098196	2026-10-22 21:37:42.07	2026-10-15 21:37:56.059	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-15 21:37:42.070823
105	1	be000e00a477ebb6af0e7e6a4de135ec6f124a2cdb066881f7d86d98e2d2dd07	2026-10-22 21:37:56.071	2026-10-15 21:38:21.093	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-15 21:37:56.072455
103	1	3e5464043b531730bf8316b73d0263f081e245c742beea92636cd73fcac5cd87	2026-10-22 20:48:11.68	2026-10-16 01:02:45.493	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-15 20:48:11.681558
107	1	484f0dbe4138829e206cad97499dc9df637c65c6012c97808137b842824ef598	2026-10-23 01:02:46.729	2026-10-16 01:10:26.9	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	::ffff:172.18.0.4	2026-10-16 01:02:46.73074
106	1	bb64d8a2168885284eac3dda07b3798c8611461540bb655d7bdf38254daf5d11	2026-10-22 21:38:21.103	2026-10-16 17:40:14.262	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-15 21:38:21.103737
108	1	763c6c87844a05e00d70a54d59c8852f278522c3d45e3fb6dfed766ef761f3e9	2026-10-23 17:40:14.723	2026-10-16 17:41:47.437	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-16 17:40:14.725008
109	1	79aa3c699e6f3cb07f8d5b64a374760e95990178778892a42bf88603c229396c	2026-10-23 17:48:01.241	2026-10-16 20:22:54.008	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-16 17:48:01.242585
110	1	115fd56771aef13b965662819c5fe75c3555e963d63d4d1a019e8da92527bb3a	2026-10-23 20:22:54.114	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	::ffff:172.18.0.4	2026-10-16 20:22:54.116068
111	1	cbac9ec5dcf485c1bb9bda25dd05c7aeb8d0a06275237d93d3a205899552eb8a	2026-10-23 20:26:26.194	2026-10-16 20:43:05.888	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 172.68.12.63, 172.18.0.1	2026-10-16 20:26:26.336339
112	1	6b76280cf9a5a376cd5d8ed6709b4847f3cd69acd458dcd3e3a9085f2e901490	2026-10-23 20:43:05.933	2026-10-16 23:26:14.838	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 172.70.83.11, 172.18.0.1	2026-10-16 20:43:05.934345
113	1	4e017f6e12f45f47eb3dfaf59dd8d6419418ad11fa525ffaf0e3644dcefe0aa8	2026-10-23 23:20:12.906	2026-10-17 00:45:08.655	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	181.141.25.210, 104.23.248.27, 172.18.0.1	2026-10-16 23:20:13.00421
115	1	96f91a6d261ba74f7571d71886161015465d417eabe9d4c051dc5b812301c06d	2026-10-24 00:45:09.624	2026-10-17 00:47:55.833	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	181.141.25.210, 172.69.132.186, 172.18.0.1	2026-10-17 00:45:09.626776
116	1	2ab4fffcb90dea0a5815fad2fc463a8e5bcda67c87bf7ab2ec4c87385fcaab4c	2026-10-24 00:47:59.891	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36	181.141.25.210, 172.69.132.146, 172.18.0.1	2026-10-17 00:47:59.893292
114	1	6c33cf5470dcbe6a125079c9bd1698870f97ce20928de875a38d4a816a45fd65	2026-10-23 23:26:15.056	2026-10-17 16:19:01.954	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 104.23.248.26, 172.18.0.1	2026-10-16 23:26:15.056955
117	1	66a1900d50ab2a0602544e26cfd94900d8229aa67c3eb7519f309ae9bebdbe55	2026-10-24 16:19:02.114	2026-10-17 17:09:59.054	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 172.68.12.81, 172.18.0.1	2026-10-17 16:19:02.115533
118	1	cb720fdbcaa0ad6e7765a6527fd593e5681d377123634867ec4361264a6ba32b	2026-10-24 17:09:59.07	2026-10-17 17:31:09.435	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 172.69.132.187, 172.18.0.1	2026-10-17 17:09:59.070998
119	1	cb8d1b6557dbd6a732237f0ee28b318517218a401c354d7018cc67256552d968	2026-10-24 17:31:09.451	2026-10-17 17:55:36.056	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 172.71.156.252, 172.18.0.1	2026-10-17 17:31:09.451832
120	1	e8e62b5bb0e0df0a6952d9e07f61d853a97d5b4d7cad2952338f85b96f0b4a3b	2026-10-24 17:55:36.355	2026-10-17 17:56:30.361	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 172.68.12.63, 172.18.0.1	2026-10-17 17:55:36.356305
121	1	e3d34edfc5c790a312f9fedfabe60d54634097e3cfa5fab11c59fad176679fdb	2026-10-24 17:58:08.209	2026-10-17 18:09:22.716	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 108.162.210.214, 172.18.0.1	2026-10-17 17:58:08.210236
122	1	81ae5f7ac852067fb0f1e12c9539b2ec3053002161762853ec488b56317a2278	2026-10-24 21:12:52.254	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	181.141.25.210, 172.68.12.62, 172.18.0.1	2026-10-17 21:12:52.255829
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, name, role, is_active, created_at, updated_at) FROM stdin;
1	admin@ecommerce.com	$2a$10$hithdcLg6nosTCUqIUH3DukJHFChdq/Clo4U5ZJOCCMPijDq.4aVm	Admin Ventas	admin	t	2026-09-30 21:26:37.587454	2026-09-30 21:26:37.587454
\.


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE SET; Schema: drizzle; Owner: postgres
--

SELECT pg_catalog.setval('drizzle.__drizzle_migrations_id_seq', 1, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 9, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 13, true);


--
-- Name: electronic_invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.electronic_invoices_id_seq', 11, true);


--
-- Name: inventory_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_movements_id_seq', 27, true);


--
-- Name: notification_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_logs_id_seq', 11, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 27, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 14, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 20, true);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refresh_tokens_id_seq', 122, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: postgres
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: customers customers_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_unique UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: electronic_invoices electronic_invoices_invoice_number_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.electronic_invoices
    ADD CONSTRAINT electronic_invoices_invoice_number_unique UNIQUE (invoice_number);


--
-- Name: electronic_invoices electronic_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.electronic_invoices
    ADD CONSTRAINT electronic_invoices_pkey PRIMARY KEY (id);


--
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- Name: notification_logs notification_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_logs
    ADD CONSTRAINT notification_logs_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_unique UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_sku_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_unique UNIQUE (sku);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: inventory_movements_created_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX inventory_movements_created_idx ON public.inventory_movements USING btree (created_at);


--
-- Name: inventory_movements_product_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX inventory_movements_product_idx ON public.inventory_movements USING btree (product_id);


--
-- Name: orders_created_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_created_idx ON public.orders USING btree (created_at);


--
-- Name: orders_number_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_number_idx ON public.orders USING btree (order_number);


--
-- Name: products_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_category_idx ON public.products USING btree (category_id);


--
-- Name: products_sku_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_sku_idx ON public.products USING btree (sku);


--
-- Name: refresh_tokens_hash_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX refresh_tokens_hash_idx ON public.refresh_tokens USING btree (token_hash);


--
-- Name: refresh_tokens_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX refresh_tokens_user_id_idx ON public.refresh_tokens USING btree (user_id);


--
-- Name: inventory_movements inventory_movements_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: orders orders_customer_id_customers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_customers_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: products products_category_id_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: refresh_tokens refresh_tokens_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict OabxRkA0uofKOUQAzBgFK8W3XYfKzbumr9LRJlI4gZwxTQ6U6fElejeMULlsBgJ

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict vLA0NM9dFC5F1lV45eGgUtXoBR2FR59SAHplrofrUpK5hmArGe2hvvjqQqbb32x

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

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
-- PostgreSQL database dump complete
--

\unrestrict vLA0NM9dFC5F1lV45eGgUtXoBR2FR59SAHplrofrUpK5hmArGe2hvvjqQqbb32x

--
-- PostgreSQL database cluster dump complete
--

