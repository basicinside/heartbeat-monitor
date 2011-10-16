--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: antennas; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE antennas (
    id integer NOT NULL,
    name character varying(255),
    vendor character varying(255),
    polarity character varying(255),
    type character varying(255),
    height integer,
    direction integer,
    gain integer,
    angle_horizontal integer,
    angle_vertical integer,
    created_at date,
    updated_at date
);


ALTER TABLE public.antennas OWNER TO robin;

--
-- Name: antennas_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE antennas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.antennas_id_seq OWNER TO robin;

--
-- Name: antennas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE antennas_id_seq OWNED BY antennas.id;


--
-- Name: authentications; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE authentications (
    id integer NOT NULL,
    provider character varying(255),
    user_id integer,
    uid character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.authentications OWNER TO robin;

--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.authentications_id_seq OWNER TO robin;

--
-- Name: authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE authentications_id_seq OWNED BY authentications.id;


--
-- Name: bugreports; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE bugreports (
    id integer NOT NULL,
    name character varying(255),
    version character varying(255),
    device_id integer,
    beschreibung text,
    uci text,
    created_at date,
    updated_at date
);


ALTER TABLE public.bugreports OWNER TO robin;

--
-- Name: bugreports_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE bugreports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.bugreports_id_seq OWNER TO robin;

--
-- Name: bugreports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE bugreports_id_seq OWNED BY bugreports.id;


--
-- Name: nodes; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE nodes (
    id integer NOT NULL,
    name character varying(255),
    node_id character varying(255),
    lat numeric,
    lon numeric,
    version character varying(255),
    uci text,
    last_seen date,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at date,
    user_id integer,
    device_id integer,
    created_at date,
    updated_at date,
    default_ipv4 character varying(16),
    description text,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    photo_file_size integer,
    model character varying(255) DEFAULT NULL::character varying,
    default_ipv6 character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.nodes OWNER TO robin;

--
-- Name: traffic_byte_ipv4s; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE traffic_byte_ipv4s (
    id integer,
    node_id integer,
    input integer,
    input_udp integer,
    input_olsr integer,
    input_tcp integer,
    input_ftp integer,
    input_ssh integer,
    input_smtp integer,
    input_http integer,
    input_https integer,
    input_icmp integer,
    forward integer,
    forward_udp integer,
    forward_olsr integer,
    forward_tcp integer,
    forward_ftp integer,
    forward_ssh integer,
    forward_smtp integer,
    forward_http integer,
    forward_https integer,
    forward_icmp integer,
    output integer,
    output_udp integer,
    output_olsr integer,
    output_tcp integer,
    output_ftp integer,
    output_ssh integer,
    output_smtp integer,
    output_http integer,
    output_https integer,
    output_icmp integer,
    created_at date,
    updated_at timestamp without time zone
);


ALTER TABLE public.traffic_byte_ipv4s OWNER TO robin;

--
-- Name: byte_count_per_node; Type: VIEW; Schema: public; Owner: robin
--

CREATE VIEW byte_count_per_node AS
    SELECT nodes.name, count(*) AS bytes FROM (traffic_byte_ipv4s b JOIN nodes ON ((b.node_id = nodes.id))) GROUP BY nodes.name;


ALTER TABLE public.byte_count_per_node OWNER TO robin;

--
-- Name: byte_data_per_node; Type: VIEW; Schema: public; Owner: robin
--

CREATE VIEW byte_data_per_node AS
    SELECT nodes.name, sum(p.input) AS input, sum(p.forward) AS forward, sum(p.output) AS output FROM (traffic_byte_ipv4s p JOIN nodes ON ((p.node_id = nodes.id))) GROUP BY nodes.name;


ALTER TABLE public.byte_data_per_node OWNER TO robin;

--
-- Name: byte_input_per_node; Type: VIEW; Schema: public; Owner: robin
--

CREATE VIEW byte_input_per_node AS
    SELECT nodes.name, sum(p.input) AS input_bytes FROM (traffic_byte_ipv4s p JOIN nodes ON ((p.node_id = nodes.id))) GROUP BY nodes.name;


ALTER TABLE public.byte_input_per_node OWNER TO robin;

--
-- Name: byte_output_per_node; Type: VIEW; Schema: public; Owner: robin
--

CREATE VIEW byte_output_per_node AS
    SELECT nodes.name, sum(p.output) AS bytes FROM (traffic_byte_ipv4s p JOIN nodes ON ((p.node_id = nodes.id))) GROUP BY nodes.name;


ALTER TABLE public.byte_output_per_node OWNER TO robin;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    name character varying(255),
    description text,
    created_at date,
    updated_at date
);


ALTER TABLE public.countries OWNER TO robin;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO robin;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE devices (
    id integer NOT NULL,
    name character varying(255),
    hersteller character varying(255),
    beschreibung text,
    link character varying(255),
    created_at date,
    updated_at date
);


ALTER TABLE public.devices OWNER TO robin;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devices_id_seq OWNER TO robin;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE devices_id_seq OWNED BY devices.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    name character varying(255),
    description text,
    homepage character varying(255),
    created_at date,
    updated_at date
);


ALTER TABLE public.groups OWNER TO robin;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO robin;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: heartbeats; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE heartbeats (
    id integer NOT NULL,
    date date,
    node_id integer,
    neighbors integer,
    clients integer,
    created_at date,
    updated_at date
);


ALTER TABLE public.heartbeats OWNER TO robin;

--
-- Name: heartbeats_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE heartbeats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.heartbeats_id_seq OWNER TO robin;

--
-- Name: heartbeats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE heartbeats_id_seq OWNED BY heartbeats.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE links (
    id integer NOT NULL,
    node1 integer,
    node2 integer,
    quality numeric,
    last_seen date
);


ALTER TABLE public.links OWNER TO robin;

--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq OWNER TO robin;

--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying(255),
    description text,
    plz character varying(255),
    province_id integer,
    created_at date,
    updated_at date
);


ALTER TABLE public.locations OWNER TO robin;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.locations_id_seq OWNER TO robin;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nodes_id_seq OWNER TO robin;

--
-- Name: nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE nodes_id_seq OWNED BY nodes.id;


--
-- Name: open_id_authentication_nonces; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE open_id_authentication_nonces (
    id integer NOT NULL,
    nonce character varying(255),
    created integer
);


ALTER TABLE public.open_id_authentication_nonces OWNER TO robin;

--
-- Name: open_id_authentication_nonces_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE open_id_authentication_nonces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.open_id_authentication_nonces_id_seq OWNER TO robin;

--
-- Name: open_id_authentication_nonces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE open_id_authentication_nonces_id_seq OWNED BY open_id_authentication_nonces.id;


--
-- Name: traffic_packet_ipv4s; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE traffic_packet_ipv4s (
    id integer,
    node_id integer,
    input integer,
    input_udp integer,
    input_olsr integer,
    input_tcp integer,
    input_ftp integer,
    input_ssh integer,
    input_smtp integer,
    input_http integer,
    input_https integer,
    input_icmp integer,
    forward integer,
    forward_udp integer,
    forward_olsr integer,
    forward_tcp integer,
    forward_ftp integer,
    forward_ssh integer,
    forward_smtp integer,
    forward_http integer,
    forward_https integer,
    forward_icmp integer,
    output integer,
    output_udp integer,
    output_olsr integer,
    output_tcp integer,
    output_ftp integer,
    output_ssh integer,
    output_smtp integer,
    output_http integer,
    output_https integer,
    output_icmp integer,
    created_at date,
    updated_at timestamp without time zone
);


ALTER TABLE public.traffic_packet_ipv4s OWNER TO robin;

--
-- Name: packet_count_per_node; Type: VIEW; Schema: public; Owner: robin
--

CREATE VIEW packet_count_per_node AS
    SELECT nodes.name, count(*) AS packets FROM (traffic_packet_ipv4s p JOIN nodes ON ((p.node_id = nodes.id))) GROUP BY nodes.name;


ALTER TABLE public.packet_count_per_node OWNER TO robin;

--
-- Name: packet_data_per_node; Type: VIEW; Schema: public; Owner: robin
--

CREATE VIEW packet_data_per_node AS
    SELECT nodes.name, sum(p.input) AS input, sum(p.forward) AS forward, sum(p.output) AS output FROM (traffic_packet_ipv4s p JOIN nodes ON ((p.node_id = nodes.id))) GROUP BY nodes.name;


ALTER TABLE public.packet_data_per_node OWNER TO robin;

--
-- Name: packet_output_per_node; Type: VIEW; Schema: public; Owner: robin
--

CREATE VIEW packet_output_per_node AS
    SELECT nodes.name, sum(p.output) AS packets FROM (traffic_packet_ipv4s p JOIN nodes ON ((p.node_id = nodes.id))) GROUP BY nodes.name;


ALTER TABLE public.packet_output_per_node OWNER TO robin;

--
-- Name: parties; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE parties (
    id integer NOT NULL,
    name character varying(255),
    description text,
    homepage character varying(255),
    created_at date,
    updated_at date
);


ALTER TABLE public.parties OWNER TO robin;

--
-- Name: parties_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE parties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.parties_id_seq OWNER TO robin;

--
-- Name: parties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE parties_id_seq OWNED BY parties.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    node_id integer,
    data_file_name character varying(255),
    data_content_type character varying(255),
    data_file_size integer,
    data_updated_at date,
    created_at date,
    updated_at date
);


ALTER TABLE public.photos OWNER TO robin;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.photos_id_seq OWNER TO robin;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: provinces; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE provinces (
    id integer NOT NULL,
    name character varying(255),
    description text,
    homepage character varying(255),
    country_id integer,
    created_at date,
    updated_at date
);


ALTER TABLE public.provinces OWNER TO robin;

--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.provinces_id_seq OWNER TO robin;

--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE provinces_id_seq OWNED BY provinces.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    created_at date,
    updated_at date
);


ALTER TABLE public.roles OWNER TO robin;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO robin;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO robin;

--
-- Name: scores; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE scores (
    id integer NOT NULL,
    node_id integer,
    score integer,
    variant integer,
    created_at date,
    updated_at date
);


ALTER TABLE public.scores OWNER TO robin;

--
-- Name: scores_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.scores_id_seq OWNER TO robin;

--
-- Name: scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE scores_id_seq OWNED BY scores.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE services (
    id integer NOT NULL,
    node_id integer,
    proto character varying(8),
    port integer,
    state character varying(10),
    name character varying(30),
    last_seen date
);


ALTER TABLE public.services OWNER TO robin;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.services_id_seq OWNER TO robin;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE services_id_seq OWNED BY services.id;


--
-- Name: traffic_byte_ipv6s; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE traffic_byte_ipv6s (
    id integer,
    node_id integer,
    input integer,
    input_udp integer,
    input_olsr integer,
    input_tcp integer,
    input_ftp integer,
    input_ssh integer,
    input_smtp integer,
    input_http integer,
    input_https integer,
    input_icmp integer,
    forward integer,
    forward_udp integer,
    forward_olsr integer,
    forward_tcp integer,
    forward_ftp integer,
    forward_ssh integer,
    forward_smtp integer,
    forward_http integer,
    forward_https integer,
    forward_icmp integer,
    output integer,
    output_udp integer,
    output_olsr integer,
    output_tcp integer,
    output_ftp integer,
    output_ssh integer,
    output_smtp integer,
    output_http integer,
    output_https integer,
    output_icmp integer,
    created_at date,
    updated_at timestamp without time zone
);


ALTER TABLE public.traffic_byte_ipv6s OWNER TO robin;

--
-- Name: traffic_bytes; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE traffic_bytes (
    id integer NOT NULL,
    node_id integer,
    input integer,
    input_udp integer,
    input_olsr integer,
    input_tcp integer,
    input_ftp integer,
    input_ssh integer,
    input_smtp integer,
    input_http integer,
    input_https integer,
    input_icmp integer,
    forward integer,
    forward_udp integer,
    forward_olsr integer,
    forward_tcp integer,
    forward_ftp integer,
    forward_ssh integer,
    forward_smtp integer,
    forward_http integer,
    forward_https integer,
    forward_icmp integer,
    output integer,
    output_udp integer,
    output_olsr integer,
    output_tcp integer,
    output_ftp integer,
    output_ssh integer,
    output_smtp integer,
    output_http integer,
    output_https integer,
    output_icmp integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.traffic_bytes OWNER TO robin;

--
-- Name: traffic_bytes_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE traffic_bytes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.traffic_bytes_id_seq OWNER TO robin;

--
-- Name: traffic_bytes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE traffic_bytes_id_seq OWNED BY traffic_bytes.id;


--
-- Name: traffic_packet_ipv6s; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE traffic_packet_ipv6s (
    id integer,
    node_id integer,
    input integer,
    input_udp integer,
    input_olsr integer,
    input_tcp integer,
    input_ftp integer,
    input_ssh integer,
    input_smtp integer,
    input_http integer,
    input_https integer,
    input_icmp integer,
    forward integer,
    forward_udp integer,
    forward_olsr integer,
    forward_tcp integer,
    forward_ftp integer,
    forward_ssh integer,
    forward_smtp integer,
    forward_http integer,
    forward_https integer,
    forward_icmp integer,
    output integer,
    output_udp integer,
    output_olsr integer,
    output_tcp integer,
    output_ftp integer,
    output_ssh integer,
    output_smtp integer,
    output_http integer,
    output_https integer,
    output_icmp integer,
    created_at date,
    updated_at timestamp without time zone
);


ALTER TABLE public.traffic_packet_ipv6s OWNER TO robin;

--
-- Name: traffic_packets; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE traffic_packets (
    id integer NOT NULL,
    node_id integer,
    input integer,
    input_udp integer,
    input_olsr integer,
    input_tcp integer,
    input_ftp integer,
    input_ssh integer,
    input_smtp integer,
    input_http integer,
    input_https integer,
    input_icmp integer,
    forward integer,
    forward_udp integer,
    forward_olsr integer,
    forward_tcp integer,
    forward_ftp integer,
    forward_ssh integer,
    forward_smtp integer,
    forward_http integer,
    forward_https integer,
    forward_icmp integer,
    output integer,
    output_udp integer,
    output_olsr integer,
    output_tcp integer,
    output_ftp integer,
    output_ssh integer,
    output_smtp integer,
    output_http integer,
    output_https integer,
    output_icmp integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.traffic_packets OWNER TO robin;

--
-- Name: traffic_packets_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE traffic_packets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.traffic_packets_id_seq OWNER TO robin;

--
-- Name: traffic_packets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE traffic_packets_id_seq OWNED BY traffic_packets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: robin; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    group_id integer,
    party_id integer,
    location_id integer,
    username character varying(255)
);


ALTER TABLE public.users OWNER TO robin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: robin
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO robin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robin
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE antennas ALTER COLUMN id SET DEFAULT nextval('antennas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE authentications ALTER COLUMN id SET DEFAULT nextval('authentications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE bugreports ALTER COLUMN id SET DEFAULT nextval('bugreports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE devices ALTER COLUMN id SET DEFAULT nextval('devices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE heartbeats ALTER COLUMN id SET DEFAULT nextval('heartbeats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE nodes ALTER COLUMN id SET DEFAULT nextval('nodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE open_id_authentication_nonces ALTER COLUMN id SET DEFAULT nextval('open_id_authentication_nonces_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE parties ALTER COLUMN id SET DEFAULT nextval('parties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE provinces ALTER COLUMN id SET DEFAULT nextval('provinces_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE scores ALTER COLUMN id SET DEFAULT nextval('scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE services ALTER COLUMN id SET DEFAULT nextval('services_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE traffic_bytes ALTER COLUMN id SET DEFAULT nextval('traffic_bytes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE traffic_packets ALTER COLUMN id SET DEFAULT nextval('traffic_packets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: robin
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: antennas_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY antennas
    ADD CONSTRAINT antennas_pkey PRIMARY KEY (id);


--
-- Name: authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


--
-- Name: bugreports_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY bugreports
    ADD CONSTRAINT bugreports_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: devices_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: heartbeats_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY heartbeats
    ADD CONSTRAINT heartbeats_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- Name: open_id_authentication_nonces_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY open_id_authentication_nonces
    ADD CONSTRAINT open_id_authentication_nonces_pkey PRIMARY KEY (id);


--
-- Name: parties_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY parties
    ADD CONSTRAINT parties_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: scores_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY scores
    ADD CONSTRAINT scores_pkey PRIMARY KEY (id);


--
-- Name: services_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: traffic_bytes_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY traffic_bytes
    ADD CONSTRAINT traffic_bytes_pkey PRIMARY KEY (id);


--
-- Name: traffic_packets_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY traffic_packets
    ADD CONSTRAINT traffic_packets_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: robin; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_photos_on_node_id; Type: INDEX; Schema: public; Owner: robin; Tablespace: 
--

CREATE INDEX index_photos_on_node_id ON photos USING btree (node_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: robin; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: robin; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: robin; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

