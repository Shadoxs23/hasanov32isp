--
-- PostgreSQL database cluster dump
--

-- Started on 2026-10-28 14:17:00

\restrict OCtiPysOtyI4lzHuqZGLbabmBTmSwcD8gsShwSvRuze1XbeWVqinSJ2Acnh3Tdy

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE user1;
ALTER ROLE user1 WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:avCZgdlVvb4k/F6huDITMg==$lRzMFKg2y4KFbkWlYFYArXaMboL1MwY1hFqatdx1SQQ=:6StHVhvziG/jBD1EnzZC5sfKHJBU9l8blz78I22NcBU=';

--
-- User Configurations
--








\unrestrict OCtiPysOtyI4lzHuqZGLbabmBTmSwcD8gsShwSvRuze1XbeWVqinSJ2Acnh3Tdy

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

\restrict ateUIZJ4I0izvVnCwuIQgoTboCAEOmViMDSBPXUNyk3V8XzyPG5SIpdpvD8iJSg

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-28 14:17:00

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-10-28 14:17:01

--
-- PostgreSQL database dump complete
--

\unrestrict ateUIZJ4I0izvVnCwuIQgoTboCAEOmViMDSBPXUNyk3V8XzyPG5SIpdpvD8iJSg

--
-- Database "MyDataBase" dump
--

--
-- PostgreSQL database dump
--

\restrict np035M1zQg3gfCugDYgeLlZRxHadxrChW0KduTHXLceX5c9I7RPWXn5k04kVedy

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-28 14:17:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3514 (class 1262 OID 16384)
-- Name: MyDataBase; Type: DATABASE; Schema: -; Owner: user1
--

CREATE DATABASE "MyDataBase" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE "MyDataBase" OWNER TO user1;

\unrestrict np035M1zQg3gfCugDYgeLlZRxHadxrChW0KduTHXLceX5c9I7RPWXn5k04kVedy
\connect "MyDataBase"
\restrict np035M1zQg3gfCugDYgeLlZRxHadxrChW0KduTHXLceX5c9I7RPWXn5k04kVedy

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 16504)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.audit_log (
    id bigint NOT NULL,
    user_id bigint,
    action character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    details text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.audit_log OWNER TO user1;

--
-- TOC entry 221 (class 1259 OID 16421)
-- Name: categories; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(10) NOT NULL,
    description text,
    CONSTRAINT categories_type_check CHECK (((type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying])::text[])))
);


ALTER TABLE public.categories OWNER TO user1;

--
-- TOC entry 224 (class 1259 OID 16473)
-- Name: change_requests; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.change_requests (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    user_id bigint NOT NULL,
    request_text text NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reviewed_by bigint,
    reviewed_at timestamp with time zone,
    CONSTRAINT change_requests_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.change_requests OWNER TO user1;

--
-- TOC entry 222 (class 1259 OID 16432)
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.payment_methods (
    id bigint NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.payment_methods OWNER TO user1;

--
-- TOC entry 226 (class 1259 OID 16524)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO user1;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: roles; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.roles (
    id bigint DEFAULT nextval('public.roles_id_seq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO user1;

--
-- TOC entry 223 (class 1259 OID 16441)
-- Name: transactions; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    payment_method_id bigint,
    category_id bigint NOT NULL,
    type character varying(10) NOT NULL,
    amount numeric(12,2) NOT NULL,
    description text,
    transaction_date date NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO user1;

--
-- TOC entry 220 (class 1259 OID 16400)
-- Name: users; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(254) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO user1;

--
-- TOC entry 3507 (class 0 OID 16504)
-- Dependencies: 225
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.audit_log (id, user_id, action, name, details, created_at) FROM stdin;
\.


--
-- TOC entry 3503 (class 0 OID 16421)
-- Dependencies: 221
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.categories (id, name, type, description) FROM stdin;
1	Категория 1	income	Тестовая категория 1
2	Категория 2	expense	Тестовая категория 2
3	Категория 3	income	Тестовая категория 3
4	Категория 4	expense	Тестовая категория 4
5	Категория 5	income	Тестовая категория 5
6	Категория 6	expense	Тестовая категория 6
7	Категория 7	income	Тестовая категория 7
8	Категория 8	expense	Тестовая категория 8
9	Категория 9	income	Тестовая категория 9
10	Категория 10	expense	Тестовая категория 10
11	Категория 11	income	Тестовая категория 11
12	Категория 12	expense	Тестовая категория 12
13	Категория 13	income	Тестовая категория 13
14	Категория 14	expense	Тестовая категория 14
15	Категория 15	income	Тестовая категория 15
16	Категория 16	expense	Тестовая категория 16
17	Категория 17	income	Тестовая категория 17
18	Категория 18	expense	Тестовая категория 18
19	Категория 19	income	Тестовая категория 19
20	Категория 20	expense	Тестовая категория 20
21	Категория 21	income	Тестовая категория 21
22	Категория 22	expense	Тестовая категория 22
23	Категория 23	income	Тестовая категория 23
24	Категория 24	expense	Тестовая категория 24
25	Категория 25	income	Тестовая категория 25
26	Категория 26	expense	Тестовая категория 26
27	Категория 27	income	Тестовая категория 27
28	Категория 28	expense	Тестовая категория 28
29	Категория 29	income	Тестовая категория 29
30	Категория 30	expense	Тестовая категория 30
31	Категория 31	income	Тестовая категория 31
32	Категория 32	expense	Тестовая категория 32
33	Категория 33	income	Тестовая категория 33
34	Категория 34	expense	Тестовая категория 34
35	Категория 35	income	Тестовая категория 35
36	Категория 36	expense	Тестовая категория 36
37	Категория 37	income	Тестовая категория 37
38	Категория 38	expense	Тестовая категория 38
39	Категория 39	income	Тестовая категория 39
40	Категория 40	expense	Тестовая категория 40
41	Категория 41	income	Тестовая категория 41
42	Категория 42	expense	Тестовая категория 42
43	Категория 43	income	Тестовая категория 43
44	Категория 44	expense	Тестовая категория 44
45	Категория 45	income	Тестовая категория 45
46	Категория 46	expense	Тестовая категория 46
47	Категория 47	income	Тестовая категория 47
48	Категория 48	expense	Тестовая категория 48
49	Категория 49	income	Тестовая категория 49
50	Категория 50	expense	Тестовая категория 50
51	Категория 51	income	Тестовая категория 51
52	Категория 52	expense	Тестовая категория 52
53	Категория 53	income	Тестовая категория 53
54	Категория 54	expense	Тестовая категория 54
55	Категория 55	income	Тестовая категория 55
56	Категория 56	expense	Тестовая категория 56
57	Категория 57	income	Тестовая категория 57
58	Категория 58	expense	Тестовая категория 58
59	Категория 59	income	Тестовая категория 59
60	Категория 60	expense	Тестовая категория 60
61	Категория 61	income	Тестовая категория 61
62	Категория 62	expense	Тестовая категория 62
63	Категория 63	income	Тестовая категория 63
64	Категория 64	expense	Тестовая категория 64
65	Категория 65	income	Тестовая категория 65
66	Категория 66	expense	Тестовая категория 66
67	Категория 67	income	Тестовая категория 67
68	Категория 68	expense	Тестовая категория 68
69	Категория 69	income	Тестовая категория 69
70	Категория 70	expense	Тестовая категория 70
71	Категория 71	income	Тестовая категория 71
72	Категория 72	expense	Тестовая категория 72
73	Категория 73	income	Тестовая категория 73
74	Категория 74	expense	Тестовая категория 74
75	Категория 75	income	Тестовая категория 75
76	Категория 76	expense	Тестовая категория 76
77	Категория 77	income	Тестовая категория 77
78	Категория 78	expense	Тестовая категория 78
79	Категория 79	income	Тестовая категория 79
80	Категория 80	expense	Тестовая категория 80
81	Категория 81	income	Тестовая категория 81
82	Категория 82	expense	Тестовая категория 82
83	Категория 83	income	Тестовая категория 83
84	Категория 84	expense	Тестовая категория 84
85	Категория 85	income	Тестовая категория 85
86	Категория 86	expense	Тестовая категория 86
87	Категория 87	income	Тестовая категория 87
88	Категория 88	expense	Тестовая категория 88
89	Категория 89	income	Тестовая категория 89
90	Категория 90	expense	Тестовая категория 90
91	Категория 91	income	Тестовая категория 91
92	Категория 92	expense	Тестовая категория 92
93	Категория 93	income	Тестовая категория 93
94	Категория 94	expense	Тестовая категория 94
95	Категория 95	income	Тестовая категория 95
96	Категория 96	expense	Тестовая категория 96
97	Категория 97	income	Тестовая категория 97
98	Категория 98	expense	Тестовая категория 98
99	Категория 99	income	Тестовая категория 99
100	Категория 100	expense	Тестовая категория 100
\.


--
-- TOC entry 3506 (class 0 OID 16473)
-- Dependencies: 224
-- Data for Name: change_requests; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.change_requests (id, transaction_id, user_id, request_text, status, created_at, reviewed_by, reviewed_at) FROM stdin;
\.


--
-- TOC entry 3504 (class 0 OID 16432)
-- Dependencies: 222
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.payment_methods (id, name) FROM stdin;
1	Способ оплаты 1
2	Способ оплаты 2
3	Способ оплаты 3
4	Способ оплаты 4
5	Способ оплаты 5
6	Способ оплаты 6
7	Способ оплаты 7
8	Способ оплаты 8
9	Способ оплаты 9
10	Способ оплаты 10
11	Способ оплаты 11
12	Способ оплаты 12
13	Способ оплаты 13
14	Способ оплаты 14
15	Способ оплаты 15
16	Способ оплаты 16
17	Способ оплаты 17
18	Способ оплаты 18
19	Способ оплаты 19
20	Способ оплаты 20
21	Способ оплаты 21
22	Способ оплаты 22
23	Способ оплаты 23
24	Способ оплаты 24
25	Способ оплаты 25
26	Способ оплаты 26
27	Способ оплаты 27
28	Способ оплаты 28
29	Способ оплаты 29
30	Способ оплаты 30
31	Способ оплаты 31
32	Способ оплаты 32
33	Способ оплаты 33
34	Способ оплаты 34
35	Способ оплаты 35
36	Способ оплаты 36
37	Способ оплаты 37
38	Способ оплаты 38
39	Способ оплаты 39
40	Способ оплаты 40
41	Способ оплаты 41
42	Способ оплаты 42
43	Способ оплаты 43
44	Способ оплаты 44
45	Способ оплаты 45
46	Способ оплаты 46
47	Способ оплаты 47
48	Способ оплаты 48
49	Способ оплаты 49
50	Способ оплаты 50
51	Способ оплаты 51
52	Способ оплаты 52
53	Способ оплаты 53
54	Способ оплаты 54
55	Способ оплаты 55
56	Способ оплаты 56
57	Способ оплаты 57
58	Способ оплаты 58
59	Способ оплаты 59
60	Способ оплаты 60
61	Способ оплаты 61
62	Способ оплаты 62
63	Способ оплаты 63
64	Способ оплаты 64
65	Способ оплаты 65
66	Способ оплаты 66
67	Способ оплаты 67
68	Способ оплаты 68
69	Способ оплаты 69
70	Способ оплаты 70
71	Способ оплаты 71
72	Способ оплаты 72
73	Способ оплаты 73
74	Способ оплаты 74
75	Способ оплаты 75
76	Способ оплаты 76
77	Способ оплаты 77
78	Способ оплаты 78
79	Способ оплаты 79
80	Способ оплаты 80
81	Способ оплаты 81
82	Способ оплаты 82
83	Способ оплаты 83
84	Способ оплаты 84
85	Способ оплаты 85
86	Способ оплаты 86
87	Способ оплаты 87
88	Способ оплаты 88
89	Способ оплаты 89
90	Способ оплаты 90
91	Способ оплаты 91
92	Способ оплаты 92
93	Способ оплаты 93
94	Способ оплаты 94
95	Способ оплаты 95
96	Способ оплаты 96
97	Способ оплаты 97
98	Способ оплаты 98
99	Способ оплаты 99
100	Способ оплаты 100
101	Банковская карта
102	СБП
\.


--
-- TOC entry 3501 (class 0 OID 16389)
-- Dependencies: 219
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.roles (id, name, description) FROM stdin;
1	Role 1	Тестовая роль 1
2	Role 2	Тестовая роль 2
3	Role 3	Тестовая роль 3
4	Role 4	Тестовая роль 4
5	Role 5	Тестовая роль 5
6	Role 6	Тестовая роль 6
7	Role 7	Тестовая роль 7
8	Role 8	Тестовая роль 8
9	Role 9	Тестовая роль 9
10	Role 10	Тестовая роль 10
11	Role 11	Тестовая роль 11
12	Role 12	Тестовая роль 12
13	Role 13	Тестовая роль 13
14	Role 14	Тестовая роль 14
15	Role 15	Тестовая роль 15
16	Role 16	Тестовая роль 16
17	Role 17	Тестовая роль 17
18	Role 18	Тестовая роль 18
19	Role 19	Тестовая роль 19
20	Role 20	Тестовая роль 20
21	Role 21	Тестовая роль 21
22	Role 22	Тестовая роль 22
23	Role 23	Тестовая роль 23
24	Role 24	Тестовая роль 24
25	Role 25	Тестовая роль 25
26	Role 26	Тестовая роль 26
27	Role 27	Тестовая роль 27
28	Role 28	Тестовая роль 28
29	Role 29	Тестовая роль 29
30	Role 30	Тестовая роль 30
31	Role 31	Тестовая роль 31
32	Role 32	Тестовая роль 32
33	Role 33	Тестовая роль 33
34	Role 34	Тестовая роль 34
35	Role 35	Тестовая роль 35
36	Role 36	Тестовая роль 36
37	Role 37	Тестовая роль 37
38	Role 38	Тестовая роль 38
39	Role 39	Тестовая роль 39
40	Role 40	Тестовая роль 40
41	Role 41	Тестовая роль 41
42	Role 42	Тестовая роль 42
43	Role 43	Тестовая роль 43
44	Role 44	Тестовая роль 44
45	Role 45	Тестовая роль 45
46	Role 46	Тестовая роль 46
47	Role 47	Тестовая роль 47
48	Role 48	Тестовая роль 48
49	Role 49	Тестовая роль 49
50	Role 50	Тестовая роль 50
51	Role 51	Тестовая роль 51
52	Role 52	Тестовая роль 52
53	Role 53	Тестовая роль 53
54	Role 54	Тестовая роль 54
55	Role 55	Тестовая роль 55
56	Role 56	Тестовая роль 56
57	Role 57	Тестовая роль 57
58	Role 58	Тестовая роль 58
59	Role 59	Тестовая роль 59
60	Role 60	Тестовая роль 60
61	Role 61	Тестовая роль 61
62	Role 62	Тестовая роль 62
63	Role 63	Тестовая роль 63
64	Role 64	Тестовая роль 64
65	Role 65	Тестовая роль 65
66	Role 66	Тестовая роль 66
67	Role 67	Тестовая роль 67
68	Role 68	Тестовая роль 68
69	Role 69	Тестовая роль 69
70	Role 70	Тестовая роль 70
71	Role 71	Тестовая роль 71
72	Role 72	Тестовая роль 72
73	Role 73	Тестовая роль 73
74	Role 74	Тестовая роль 74
75	Role 75	Тестовая роль 75
76	Role 76	Тестовая роль 76
77	Role 77	Тестовая роль 77
78	Role 78	Тестовая роль 78
79	Role 79	Тестовая роль 79
80	Role 80	Тестовая роль 80
81	Role 81	Тестовая роль 81
82	Role 82	Тестовая роль 82
83	Role 83	Тестовая роль 83
84	Role 84	Тестовая роль 84
85	Role 85	Тестовая роль 85
86	Role 86	Тестовая роль 86
87	Role 87	Тестовая роль 87
88	Role 88	Тестовая роль 88
89	Role 89	Тестовая роль 89
90	Role 90	Тестовая роль 90
91	Role 91	Тестовая роль 91
92	Role 92	Тестовая роль 92
93	Role 93	Тестовая роль 93
94	Role 94	Тестовая роль 94
95	Role 95	Тестовая роль 95
96	Role 96	Тестовая роль 96
97	Role 97	Тестовая роль 97
98	Role 98	Тестовая роль 98
99	Role 99	Тестовая роль 99
100	Role 100	Тестовая роль 100
\.


--
-- TOC entry 3505 (class 0 OID 16441)
-- Dependencies: 223
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.transactions (id, user_id, payment_method_id, category_id, type, amount, description, transaction_date, created_at) FROM stdin;
1	1	1	2	expense	117.00	Тестовая операция 1	2026-10-27	2026-10-28 09:06:36.746471+00
2	1	1	2	expense	134.00	Тестовая операция 2	2026-10-26	2026-10-28 09:06:36.746471+00
3	1	1	2	expense	151.00	Тестовая операция 3	2026-10-25	2026-10-28 09:06:36.746471+00
4	1	1	2	expense	168.00	Тестовая операция 4	2026-10-24	2026-10-28 09:06:36.746471+00
5	1	1	1	income	185.00	Тестовая операция 5	2026-10-23	2026-10-28 09:06:36.746471+00
6	1	1	2	expense	202.00	Тестовая операция 6	2026-10-22	2026-10-28 09:06:36.746471+00
7	1	1	2	expense	219.00	Тестовая операция 7	2026-10-21	2026-10-28 09:06:36.746471+00
8	1	1	2	expense	236.00	Тестовая операция 8	2026-10-20	2026-10-28 09:06:36.746471+00
9	1	1	2	expense	253.00	Тестовая операция 9	2026-10-19	2026-10-28 09:06:36.746471+00
10	1	1	1	income	270.00	Тестовая операция 10	2026-10-18	2026-10-28 09:06:36.746471+00
11	1	1	2	expense	287.00	Тестовая операция 11	2026-10-17	2026-10-28 09:06:36.746471+00
12	1	1	2	expense	304.00	Тестовая операция 12	2026-10-16	2026-10-28 09:06:36.746471+00
13	1	1	2	expense	321.00	Тестовая операция 13	2026-10-15	2026-10-28 09:06:36.746471+00
14	1	1	2	expense	338.00	Тестовая операция 14	2026-10-14	2026-10-28 09:06:36.746471+00
15	1	1	1	income	355.00	Тестовая операция 15	2026-10-13	2026-10-28 09:06:36.746471+00
16	1	1	2	expense	372.00	Тестовая операция 16	2026-10-12	2026-10-28 09:06:36.746471+00
17	1	1	2	expense	389.00	Тестовая операция 17	2026-10-11	2026-10-28 09:06:36.746471+00
18	1	1	2	expense	406.00	Тестовая операция 18	2026-10-10	2026-10-28 09:06:36.746471+00
19	1	1	2	expense	423.00	Тестовая операция 19	2026-10-09	2026-10-28 09:06:36.746471+00
20	1	1	1	income	440.00	Тестовая операция 20	2026-10-08	2026-10-28 09:06:36.746471+00
21	1	1	2	expense	457.00	Тестовая операция 21	2026-10-07	2026-10-28 09:06:36.746471+00
22	1	1	2	expense	474.00	Тестовая операция 22	2026-10-06	2026-10-28 09:06:36.746471+00
23	1	1	2	expense	491.00	Тестовая операция 23	2026-10-05	2026-10-28 09:06:36.746471+00
24	1	1	2	expense	508.00	Тестовая операция 24	2026-10-04	2026-10-28 09:06:36.746471+00
25	1	1	1	income	525.00	Тестовая операция 25	2026-10-03	2026-10-28 09:06:36.746471+00
26	1	1	2	expense	542.00	Тестовая операция 26	2026-10-02	2026-10-28 09:06:36.746471+00
27	1	1	2	expense	559.00	Тестовая операция 27	2026-10-01	2026-10-28 09:06:36.746471+00
28	1	1	2	expense	576.00	Тестовая операция 28	2026-09-30	2026-10-28 09:06:36.746471+00
29	1	1	2	expense	593.00	Тестовая операция 29	2026-09-29	2026-10-28 09:06:36.746471+00
30	1	1	1	income	610.00	Тестовая операция 30	2026-09-28	2026-10-28 09:06:36.746471+00
31	1	1	2	expense	627.00	Тестовая операция 31	2026-09-27	2026-10-28 09:06:36.746471+00
32	1	1	2	expense	644.00	Тестовая операция 32	2026-09-26	2026-10-28 09:06:36.746471+00
33	1	1	2	expense	661.00	Тестовая операция 33	2026-09-25	2026-10-28 09:06:36.746471+00
34	1	1	2	expense	678.00	Тестовая операция 34	2026-09-24	2026-10-28 09:06:36.746471+00
35	1	1	1	income	695.00	Тестовая операция 35	2026-09-23	2026-10-28 09:06:36.746471+00
36	1	1	2	expense	712.00	Тестовая операция 36	2026-09-22	2026-10-28 09:06:36.746471+00
37	1	1	2	expense	729.00	Тестовая операция 37	2026-09-21	2026-10-28 09:06:36.746471+00
38	1	1	2	expense	746.00	Тестовая операция 38	2026-09-20	2026-10-28 09:06:36.746471+00
39	1	1	2	expense	763.00	Тестовая операция 39	2026-09-19	2026-10-28 09:06:36.746471+00
40	1	1	1	income	780.00	Тестовая операция 40	2026-09-18	2026-10-28 09:06:36.746471+00
41	1	1	2	expense	797.00	Тестовая операция 41	2026-09-17	2026-10-28 09:06:36.746471+00
42	1	1	2	expense	814.00	Тестовая операция 42	2026-09-16	2026-10-28 09:06:36.746471+00
43	1	1	2	expense	831.00	Тестовая операция 43	2026-09-15	2026-10-28 09:06:36.746471+00
44	1	1	2	expense	848.00	Тестовая операция 44	2026-09-14	2026-10-28 09:06:36.746471+00
45	1	1	1	income	865.00	Тестовая операция 45	2026-09-13	2026-10-28 09:06:36.746471+00
46	1	1	2	expense	882.00	Тестовая операция 46	2026-09-12	2026-10-28 09:06:36.746471+00
47	1	1	2	expense	899.00	Тестовая операция 47	2026-09-11	2026-10-28 09:06:36.746471+00
48	1	1	2	expense	916.00	Тестовая операция 48	2026-09-10	2026-10-28 09:06:36.746471+00
49	1	1	2	expense	933.00	Тестовая операция 49	2026-09-09	2026-10-28 09:06:36.746471+00
50	1	1	1	income	950.00	Тестовая операция 50	2026-09-08	2026-10-28 09:06:36.746471+00
51	1	1	2	expense	967.00	Тестовая операция 51	2026-09-07	2026-10-28 09:06:36.746471+00
52	1	1	2	expense	984.00	Тестовая операция 52	2026-09-06	2026-10-28 09:06:36.746471+00
53	1	1	2	expense	1001.00	Тестовая операция 53	2026-09-05	2026-10-28 09:06:36.746471+00
54	1	1	2	expense	1018.00	Тестовая операция 54	2026-09-04	2026-10-28 09:06:36.746471+00
55	1	1	1	income	1035.00	Тестовая операция 55	2026-09-03	2026-10-28 09:06:36.746471+00
56	1	1	2	expense	1052.00	Тестовая операция 56	2026-09-02	2026-10-28 09:06:36.746471+00
57	1	1	2	expense	1069.00	Тестовая операция 57	2026-09-01	2026-10-28 09:06:36.746471+00
58	1	1	2	expense	1086.00	Тестовая операция 58	2026-08-31	2026-10-28 09:06:36.746471+00
59	1	1	2	expense	1103.00	Тестовая операция 59	2026-08-30	2026-10-28 09:06:36.746471+00
60	1	1	1	income	1120.00	Тестовая операция 60	2026-08-29	2026-10-28 09:06:36.746471+00
61	1	1	2	expense	1137.00	Тестовая операция 61	2026-08-28	2026-10-28 09:06:36.746471+00
62	1	1	2	expense	1154.00	Тестовая операция 62	2026-08-27	2026-10-28 09:06:36.746471+00
63	1	1	2	expense	1171.00	Тестовая операция 63	2026-08-26	2026-10-28 09:06:36.746471+00
64	1	1	2	expense	1188.00	Тестовая операция 64	2026-08-25	2026-10-28 09:06:36.746471+00
65	1	1	1	income	1205.00	Тестовая операция 65	2026-08-24	2026-10-28 09:06:36.746471+00
66	1	1	2	expense	1222.00	Тестовая операция 66	2026-08-23	2026-10-28 09:06:36.746471+00
67	1	1	2	expense	1239.00	Тестовая операция 67	2026-08-22	2026-10-28 09:06:36.746471+00
68	1	1	2	expense	1256.00	Тестовая операция 68	2026-08-21	2026-10-28 09:06:36.746471+00
69	1	1	2	expense	1273.00	Тестовая операция 69	2026-08-20	2026-10-28 09:06:36.746471+00
70	1	1	1	income	1290.00	Тестовая операция 70	2026-08-19	2026-10-28 09:06:36.746471+00
71	1	1	2	expense	1307.00	Тестовая операция 71	2026-08-18	2026-10-28 09:06:36.746471+00
72	1	1	2	expense	1324.00	Тестовая операция 72	2026-08-17	2026-10-28 09:06:36.746471+00
73	1	1	2	expense	1341.00	Тестовая операция 73	2026-08-16	2026-10-28 09:06:36.746471+00
74	1	1	2	expense	1358.00	Тестовая операция 74	2026-08-15	2026-10-28 09:06:36.746471+00
75	1	1	1	income	1375.00	Тестовая операция 75	2026-08-14	2026-10-28 09:06:36.746471+00
76	1	1	2	expense	1392.00	Тестовая операция 76	2026-08-13	2026-10-28 09:06:36.746471+00
77	1	1	2	expense	1409.00	Тестовая операция 77	2026-08-12	2026-10-28 09:06:36.746471+00
78	1	1	2	expense	1426.00	Тестовая операция 78	2026-08-11	2026-10-28 09:06:36.746471+00
79	1	1	2	expense	1443.00	Тестовая операция 79	2026-08-10	2026-10-28 09:06:36.746471+00
80	1	1	1	income	1460.00	Тестовая операция 80	2026-08-09	2026-10-28 09:06:36.746471+00
81	1	1	2	expense	1477.00	Тестовая операция 81	2026-08-08	2026-10-28 09:06:36.746471+00
82	1	1	2	expense	1494.00	Тестовая операция 82	2026-08-07	2026-10-28 09:06:36.746471+00
83	1	1	2	expense	1511.00	Тестовая операция 83	2026-08-06	2026-10-28 09:06:36.746471+00
84	1	1	2	expense	1528.00	Тестовая операция 84	2026-08-05	2026-10-28 09:06:36.746471+00
85	1	1	1	income	1545.00	Тестовая операция 85	2026-08-04	2026-10-28 09:06:36.746471+00
86	1	1	2	expense	1562.00	Тестовая операция 86	2026-08-03	2026-10-28 09:06:36.746471+00
87	1	1	2	expense	1579.00	Тестовая операция 87	2026-08-02	2026-10-28 09:06:36.746471+00
88	1	1	2	expense	1596.00	Тестовая операция 88	2026-08-01	2026-10-28 09:06:36.746471+00
89	1	1	2	expense	1613.00	Тестовая операция 89	2026-07-31	2026-10-28 09:06:36.746471+00
90	1	1	1	income	1630.00	Тестовая операция 90	2026-07-30	2026-10-28 09:06:36.746471+00
91	1	1	2	expense	1647.00	Тестовая операция 91	2026-07-29	2026-10-28 09:06:36.746471+00
92	1	1	2	expense	1664.00	Тестовая операция 92	2026-07-28	2026-10-28 09:06:36.746471+00
93	1	1	2	expense	1681.00	Тестовая операция 93	2026-07-27	2026-10-28 09:06:36.746471+00
94	1	1	2	expense	1698.00	Тестовая операция 94	2026-07-26	2026-10-28 09:06:36.746471+00
95	1	1	1	income	1715.00	Тестовая операция 95	2026-07-25	2026-10-28 09:06:36.746471+00
96	1	1	2	expense	1732.00	Тестовая операция 96	2026-07-24	2026-10-28 09:06:36.746471+00
97	1	1	2	expense	1749.00	Тестовая операция 97	2026-07-23	2026-10-28 09:06:36.746471+00
98	1	1	2	expense	1766.00	Тестовая операция 98	2026-07-22	2026-10-28 09:06:36.746471+00
99	1	1	2	expense	1783.00	Тестовая операция 99	2026-07-21	2026-10-28 09:06:36.746471+00
100	1	1	1	income	1800.00	Тестовая операция 100	2026-07-20	2026-10-28 09:06:36.746471+00
\.


--
-- TOC entry 3502 (class 0 OID 16400)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.users (id, role_id, full_name, email, password_hash, created_at) FROM stdin;
1	1	Пользователь 1	user1@example.com	test_hash_1	2026-10-28 08:52:35.613652+00
2	1	Пользователь 2	user2@example.com	test_hash_2	2026-10-28 08:52:35.613652+00
3	1	Пользователь 3	user3@example.com	test_hash_3	2026-10-28 08:52:35.613652+00
4	1	Пользователь 4	user4@example.com	test_hash_4	2026-10-28 08:52:35.613652+00
5	1	Пользователь 5	user5@example.com	test_hash_5	2026-10-28 08:52:35.613652+00
6	1	Пользователь 6	user6@example.com	test_hash_6	2026-10-28 08:52:35.613652+00
7	1	Пользователь 7	user7@example.com	test_hash_7	2026-10-28 08:52:35.613652+00
8	1	Пользователь 8	user8@example.com	test_hash_8	2026-10-28 08:52:35.613652+00
9	1	Пользователь 9	user9@example.com	test_hash_9	2026-10-28 08:52:35.613652+00
10	1	Пользователь 10	user10@example.com	test_hash_10	2026-10-28 08:52:35.613652+00
11	1	Пользователь 11	user11@example.com	test_hash_11	2026-10-28 08:52:35.613652+00
12	1	Пользователь 12	user12@example.com	test_hash_12	2026-10-28 08:52:35.613652+00
13	1	Пользователь 13	user13@example.com	test_hash_13	2026-10-28 08:52:35.613652+00
14	1	Пользователь 14	user14@example.com	test_hash_14	2026-10-28 08:52:35.613652+00
15	1	Пользователь 15	user15@example.com	test_hash_15	2026-10-28 08:52:35.613652+00
16	1	Пользователь 16	user16@example.com	test_hash_16	2026-10-28 08:52:35.613652+00
17	1	Пользователь 17	user17@example.com	test_hash_17	2026-10-28 08:52:35.613652+00
18	1	Пользователь 18	user18@example.com	test_hash_18	2026-10-28 08:52:35.613652+00
19	1	Пользователь 19	user19@example.com	test_hash_19	2026-10-28 08:52:35.613652+00
20	1	Пользователь 20	user20@example.com	test_hash_20	2026-10-28 08:52:35.613652+00
21	1	Пользователь 21	user21@example.com	test_hash_21	2026-10-28 08:52:35.613652+00
22	1	Пользователь 22	user22@example.com	test_hash_22	2026-10-28 08:52:35.613652+00
23	1	Пользователь 23	user23@example.com	test_hash_23	2026-10-28 08:52:35.613652+00
24	1	Пользователь 24	user24@example.com	test_hash_24	2026-10-28 08:52:35.613652+00
25	1	Пользователь 25	user25@example.com	test_hash_25	2026-10-28 08:52:35.613652+00
26	1	Пользователь 26	user26@example.com	test_hash_26	2026-10-28 08:52:35.613652+00
27	1	Пользователь 27	user27@example.com	test_hash_27	2026-10-28 08:52:35.613652+00
28	1	Пользователь 28	user28@example.com	test_hash_28	2026-10-28 08:52:35.613652+00
29	1	Пользователь 29	user29@example.com	test_hash_29	2026-10-28 08:52:35.613652+00
30	1	Пользователь 30	user30@example.com	test_hash_30	2026-10-28 08:52:35.613652+00
31	1	Пользователь 31	user31@example.com	test_hash_31	2026-10-28 08:52:35.613652+00
32	1	Пользователь 32	user32@example.com	test_hash_32	2026-10-28 08:52:35.613652+00
33	1	Пользователь 33	user33@example.com	test_hash_33	2026-10-28 08:52:35.613652+00
34	1	Пользователь 34	user34@example.com	test_hash_34	2026-10-28 08:52:35.613652+00
35	1	Пользователь 35	user35@example.com	test_hash_35	2026-10-28 08:52:35.613652+00
36	1	Пользователь 36	user36@example.com	test_hash_36	2026-10-28 08:52:35.613652+00
37	1	Пользователь 37	user37@example.com	test_hash_37	2026-10-28 08:52:35.613652+00
38	1	Пользователь 38	user38@example.com	test_hash_38	2026-10-28 08:52:35.613652+00
39	1	Пользователь 39	user39@example.com	test_hash_39	2026-10-28 08:52:35.613652+00
40	1	Пользователь 40	user40@example.com	test_hash_40	2026-10-28 08:52:35.613652+00
41	1	Пользователь 41	user41@example.com	test_hash_41	2026-10-28 08:52:35.613652+00
42	1	Пользователь 42	user42@example.com	test_hash_42	2026-10-28 08:52:35.613652+00
43	1	Пользователь 43	user43@example.com	test_hash_43	2026-10-28 08:52:35.613652+00
44	1	Пользователь 44	user44@example.com	test_hash_44	2026-10-28 08:52:35.613652+00
45	1	Пользователь 45	user45@example.com	test_hash_45	2026-10-28 08:52:35.613652+00
46	1	Пользователь 46	user46@example.com	test_hash_46	2026-10-28 08:52:35.613652+00
47	1	Пользователь 47	user47@example.com	test_hash_47	2026-10-28 08:52:35.613652+00
48	1	Пользователь 48	user48@example.com	test_hash_48	2026-10-28 08:52:35.613652+00
49	1	Пользователь 49	user49@example.com	test_hash_49	2026-10-28 08:52:35.613652+00
50	1	Пользователь 50	user50@example.com	test_hash_50	2026-10-28 08:52:35.613652+00
51	1	Пользователь 51	user51@example.com	test_hash_51	2026-10-28 08:52:35.613652+00
52	1	Пользователь 52	user52@example.com	test_hash_52	2026-10-28 08:52:35.613652+00
53	1	Пользователь 53	user53@example.com	test_hash_53	2026-10-28 08:52:35.613652+00
54	1	Пользователь 54	user54@example.com	test_hash_54	2026-10-28 08:52:35.613652+00
55	1	Пользователь 55	user55@example.com	test_hash_55	2026-10-28 08:52:35.613652+00
56	1	Пользователь 56	user56@example.com	test_hash_56	2026-10-28 08:52:35.613652+00
57	1	Пользователь 57	user57@example.com	test_hash_57	2026-10-28 08:52:35.613652+00
58	1	Пользователь 58	user58@example.com	test_hash_58	2026-10-28 08:52:35.613652+00
59	1	Пользователь 59	user59@example.com	test_hash_59	2026-10-28 08:52:35.613652+00
60	1	Пользователь 60	user60@example.com	test_hash_60	2026-10-28 08:52:35.613652+00
61	1	Пользователь 61	user61@example.com	test_hash_61	2026-10-28 08:52:35.613652+00
62	1	Пользователь 62	user62@example.com	test_hash_62	2026-10-28 08:52:35.613652+00
63	1	Пользователь 63	user63@example.com	test_hash_63	2026-10-28 08:52:35.613652+00
64	1	Пользователь 64	user64@example.com	test_hash_64	2026-10-28 08:52:35.613652+00
65	1	Пользователь 65	user65@example.com	test_hash_65	2026-10-28 08:52:35.613652+00
66	1	Пользователь 66	user66@example.com	test_hash_66	2026-10-28 08:52:35.613652+00
67	1	Пользователь 67	user67@example.com	test_hash_67	2026-10-28 08:52:35.613652+00
68	1	Пользователь 68	user68@example.com	test_hash_68	2026-10-28 08:52:35.613652+00
69	1	Пользователь 69	user69@example.com	test_hash_69	2026-10-28 08:52:35.613652+00
70	1	Пользователь 70	user70@example.com	test_hash_70	2026-10-28 08:52:35.613652+00
71	1	Пользователь 71	user71@example.com	test_hash_71	2026-10-28 08:52:35.613652+00
72	1	Пользователь 72	user72@example.com	test_hash_72	2026-10-28 08:52:35.613652+00
73	1	Пользователь 73	user73@example.com	test_hash_73	2026-10-28 08:52:35.613652+00
74	1	Пользователь 74	user74@example.com	test_hash_74	2026-10-28 08:52:35.613652+00
75	1	Пользователь 75	user75@example.com	test_hash_75	2026-10-28 08:52:35.613652+00
76	1	Пользователь 76	user76@example.com	test_hash_76	2026-10-28 08:52:35.613652+00
77	1	Пользователь 77	user77@example.com	test_hash_77	2026-10-28 08:52:35.613652+00
78	1	Пользователь 78	user78@example.com	test_hash_78	2026-10-28 08:52:35.613652+00
79	1	Пользователь 79	user79@example.com	test_hash_79	2026-10-28 08:52:35.613652+00
80	1	Пользователь 80	user80@example.com	test_hash_80	2026-10-28 08:52:35.613652+00
81	1	Пользователь 81	user81@example.com	test_hash_81	2026-10-28 08:52:35.613652+00
82	1	Пользователь 82	user82@example.com	test_hash_82	2026-10-28 08:52:35.613652+00
83	1	Пользователь 83	user83@example.com	test_hash_83	2026-10-28 08:52:35.613652+00
84	1	Пользователь 84	user84@example.com	test_hash_84	2026-10-28 08:52:35.613652+00
85	1	Пользователь 85	user85@example.com	test_hash_85	2026-10-28 08:52:35.613652+00
86	1	Пользователь 86	user86@example.com	test_hash_86	2026-10-28 08:52:35.613652+00
87	1	Пользователь 87	user87@example.com	test_hash_87	2026-10-28 08:52:35.613652+00
88	1	Пользователь 88	user88@example.com	test_hash_88	2026-10-28 08:52:35.613652+00
89	1	Пользователь 89	user89@example.com	test_hash_89	2026-10-28 08:52:35.613652+00
90	1	Пользователь 90	user90@example.com	test_hash_90	2026-10-28 08:52:35.613652+00
91	1	Пользователь 91	user91@example.com	test_hash_91	2026-10-28 08:52:35.613652+00
92	1	Пользователь 92	user92@example.com	test_hash_92	2026-10-28 08:52:35.613652+00
93	1	Пользователь 93	user93@example.com	test_hash_93	2026-10-28 08:52:35.613652+00
94	1	Пользователь 94	user94@example.com	test_hash_94	2026-10-28 08:52:35.613652+00
95	1	Пользователь 95	user95@example.com	test_hash_95	2026-10-28 08:52:35.613652+00
96	1	Пользователь 96	user96@example.com	test_hash_96	2026-10-28 08:52:35.613652+00
97	1	Пользователь 97	user97@example.com	test_hash_97	2026-10-28 08:52:35.613652+00
98	1	Пользователь 98	user98@example.com	test_hash_98	2026-10-28 08:52:35.613652+00
99	1	Пользователь 99	user99@example.com	test_hash_99	2026-10-28 08:52:35.613652+00
100	1	Пользователь 100	user100@example.com	test_hash_100	2026-10-28 08:52:35.613652+00
\.


--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 226
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.roles_id_seq', 103, true);


--
-- TOC entry 3344 (class 2606 OID 16515)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 16431)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3341 (class 2606 OID 16488)
-- Name: change_requests change_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.change_requests
    ADD CONSTRAINT change_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 16440)
-- Name: payment_methods payment_methods_name_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_name_key UNIQUE (name);


--
-- TOC entry 3336 (class 2606 OID 16438)
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- TOC entry 3324 (class 2606 OID 16399)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 3326 (class 2606 OID 16397)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3339 (class 2606 OID 16457)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 3328 (class 2606 OID 16415)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3330 (class 2606 OID 16413)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3345 (class 1259 OID 16523)
-- Name: idx_audit_log_created_at; Type: INDEX; Schema: public; Owner: user1
--

CREATE INDEX idx_audit_log_created_at ON public.audit_log USING btree (created_at);


--
-- TOC entry 3342 (class 1259 OID 16522)
-- Name: idx_change_requests_status; Type: INDEX; Schema: public; Owner: user1
--

CREATE INDEX idx_change_requests_status ON public.change_requests USING btree (status);


--
-- TOC entry 3337 (class 1259 OID 16521)
-- Name: idx_transactions_user_date; Type: INDEX; Schema: public; Owner: user1
--

CREATE INDEX idx_transactions_user_date ON public.transactions USING btree (user_id, transaction_date);


--
-- TOC entry 3353 (class 2606 OID 16516)
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3350 (class 2606 OID 16499)
-- Name: change_requests change_requests_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.change_requests
    ADD CONSTRAINT change_requests_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- TOC entry 3351 (class 2606 OID 16489)
-- Name: change_requests change_requests_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.change_requests
    ADD CONSTRAINT change_requests_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- TOC entry 3352 (class 2606 OID 16494)
-- Name: change_requests change_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.change_requests
    ADD CONSTRAINT change_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3347 (class 2606 OID 16468)
-- Name: transactions transactions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 3348 (class 2606 OID 16463)
-- Name: transactions transactions_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- TOC entry 3349 (class 2606 OID 16458)
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3346 (class 2606 OID 16416)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-10-28 14:17:01

--
-- PostgreSQL database dump complete
--

\unrestrict np035M1zQg3gfCugDYgeLlZRxHadxrChW0KduTHXLceX5c9I7RPWXn5k04kVedy

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict pwcfV8KvByQCPjJJQUgbcaLLaZzxeuPRWfb5LCKJ92xGQd2N1tZid7Uh4wKlZ9j

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-28 14:17:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-10-28 14:17:01

--
-- PostgreSQL database dump complete
--

\unrestrict pwcfV8KvByQCPjJJQUgbcaLLaZzxeuPRWfb5LCKJ92xGQd2N1tZid7Uh4wKlZ9j

-- Completed on 2026-10-28 14:17:01

--
-- PostgreSQL database cluster dump complete
--

