--
-- PostgreSQL database dump
--

-- Dumped from database version 10.12
-- Dumped by pg_dump version 10.12

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: day(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: limbasuser
--

CREATE FUNCTION public.day(val timestamp without time zone) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
BEGIN

RETURN extract(day from val);

END; $$;


ALTER FUNCTION public.day(val timestamp without time zone) OWNER TO limbasuser;

--
-- Name: lmb_lastmodified(); Type: FUNCTION; Schema: public; Owner: limbasuser
--

CREATE FUNCTION public.lmb_lastmodified() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

statement VARCHAR(200);

BEGIN

statement = 'UPDATE LMB_CONF_TABLES SET LASTMODIFIED = CURRENT_TIMESTAMP WHERE TAB_ID = ' || TG_ARGV[0];
EXECUTE statement;

return new;

END; $$;


ALTER FUNCTION public.lmb_lastmodified() OWNER TO limbasuser;

--
-- Name: lmb_vkn(); Type: FUNCTION; Schema: public; Owner: limbasuser
--

CREATE FUNCTION public.lmb_vkn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

statement VARCHAR(1000);
nid INTEGER;

BEGIN

IF TG_ARGV[2] = '+' THEN
     nid = new.id;
END IF;
IF TG_ARGV[2] = '-' THEN
    nid = old.id;
END IF;

statement = 'update ' || TG_ARGV[0] || ' set ' || TG_ARGV[1] || ' = (select count(*) from ' || TG_RELNAME || ' where id = ' || nid || ') where id = ' || nid;
IF TG_ARGV[5] = '2' THEN
statement = 'update ' || TG_ARGV[0] || ' set ' || TG_ARGV[1] || ' = (select count(*) from ' || TG_RELNAME || ',' || TG_ARGV[3] || ' where ' || TG_RELNAME || '.id = ' || nid || ' and ' || TG_ARGV[3] || '.id = ' || TG_RELNAME || '.verkn_id and ' || TG_ARGV[3] || '.del = false) where id = ' || nid;
END IF;

EXECUTE statement;

IF TG_ARGV[4] = '' THEN
    return new;
END IF;

IF TG_ARGV[2] = '+' THEN
     nid = new.verkn_id;
END IF;
IF TG_ARGV[2] = '-' THEN
    nid = old.verkn_id;
END IF;


statement = 'update ' || TG_ARGV[3] || ' set ' || TG_ARGV[4] || ' = (select count(*) from ' || TG_RELNAME || ' where verkn_id = ' || nid || ') where id = ' || nid;
IF TG_ARGV[5] = '2' THEN
statement = 'update ' || TG_ARGV[3] || ' set ' || TG_ARGV[4] || ' = (select count(*) from ' || TG_RELNAME || ',' || TG_ARGV[0] || ' where ' || TG_RELNAME || '.verkn_id = ' || nid || ' and ' || TG_ARGV[0] || '.id = ' || TG_RELNAME || '.id and ' || TG_ARGV[0] || '.del = false) where id = ' || nid;
END IF;

EXECUTE statement;


return new;

END;
$$;


ALTER FUNCTION public.lmb_vkn() OWNER TO limbasuser;

--
-- Name: month(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: limbasuser
--

CREATE FUNCTION public.month(val timestamp without time zone) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
BEGIN

RETURN extract(month from val);

END; $$;


ALTER FUNCTION public.month(val timestamp without time zone) OWNER TO limbasuser;

--
-- Name: year(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: limbasuser
--

CREATE FUNCTION public.year(val timestamp without time zone) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
BEGIN

RETURN extract(year from val);

END; $$;


ALTER FUNCTION public.year(val timestamp without time zone) OWNER TO limbasuser;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ldms_favorites; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.ldms_favorites (
    id numeric(16,0) NOT NULL,
    user_id smallint,
    group_id smallint,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    file_id numeric(5,0),
    folder boolean DEFAULT false
);


ALTER TABLE public.ldms_favorites OWNER TO limbasuser;

--
-- Name: ldms_files; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.ldms_files (
    id numeric(18,0) NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    edituser smallint,
    erstuser smallint DEFAULT 1,
    inuse_time timestamp without time zone,
    inuse_user smallint,
    del boolean DEFAULT false,
    erstgroup numeric(5,0),
    level numeric(10,0),
    typ numeric(5,0),
    sort numeric(8,0),
    datid numeric(18,0),
    tabid numeric(5,0),
    fieldid numeric(5,0),
    name character varying(128),
    secname character varying(20),
    mimetype numeric(5,0),
    size numeric(16,0),
    checked boolean DEFAULT false,
    perm boolean DEFAULT false,
    lmlock boolean DEFAULT false,
    lockuser numeric(5,0),
    checkuser numeric(5,0),
    permuser numeric(5,0),
    permdate timestamp without time zone,
    checkdate timestamp without time zone,
    lockdate timestamp without time zone,
    vid numeric(5,0) DEFAULT 1,
    vact boolean DEFAULT false,
    vdesc character varying(128),
    vpid numeric(18,0),
    thumb_ok boolean DEFAULT false,
    meta boolean DEFAULT false,
    info boolean DEFAULT false,
    content boolean DEFAULT false,
    md5 character varying(50),
    storage_id numeric(10,0),
    download_link character varying(255),
    ind boolean DEFAULT false,
    indd timestamp without time zone,
    indt smallint,
    indm boolean DEFAULT false,
    indc numeric(16,0),
    ocr boolean DEFAULT false,
    ocrd timestamp without time zone,
    ocrt smallint,
    ocrs numeric(16,0)
);


ALTER TABLE public.ldms_files OWNER TO limbasuser;

--
-- Name: ldms_meta; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.ldms_meta (
    id numeric(18,0) NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    edituser smallint,
    erstuser smallint DEFAULT 1,
    inuse_time timestamp without time zone,
    inuse_user smallint,
    del boolean DEFAULT false,
    type character varying(20),
    ftype character varying(20),
    name2 character varying(250),
    format character varying(128),
    geometry character varying(20),
    resolution character varying(30),
    depth character varying(30),
    colors numeric(10,0),
    creator character varying(30),
    subject character varying(399),
    classification character varying(128),
    description character varying(399),
    publisher character varying(30),
    contributors character varying(250),
    identifier character varying(50),
    source character varying(30),
    language character varying(30),
    instructions character varying(50),
    urgency numeric(5,0),
    category character varying(8),
    title character varying(30),
    credit character varying(30),
    city character varying(30),
    state character varying(30),
    country character varying(50),
    transmission character varying(30),
    originname character varying(50),
    copyright character varying(128),
    createdate character varying(30),
    subcategory character varying(399)
);


ALTER TABLE public.ldms_meta OWNER TO limbasuser;

--
-- Name: ldms_rules; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.ldms_rules (
    id integer NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    group_id smallint,
    file_id numeric(16,0),
    file_typ smallint,
    lmview boolean DEFAULT true,
    lmadd boolean DEFAULT false,
    del boolean DEFAULT false,
    addf boolean,
    edit boolean DEFAULT false,
    lmlock boolean DEFAULT false
);


ALTER TABLE public.ldms_rules OWNER TO limbasuser;

--
-- Name: ldms_structure; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.ldms_structure (
    id integer NOT NULL,
    name character varying(50),
    level integer,
    erstuser smallint,
    typ smallint,
    fix boolean DEFAULT false,
    mail_level smallint,
    tabgroup_id smallint,
    tab_id smallint,
    field_id smallint,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    readonly boolean DEFAULT false,
    erstgroup smallint,
    editdatum timestamp without time zone,
    sort integer,
    path character varying(160),
    storage_id smallint
);


ALTER TABLE public.ldms_structure OWNER TO limbasuser;

--
-- Name: lmb_action; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_action (
    id integer NOT NULL,
    action character varying(50),
    link_name integer,
    beschreibung integer,
    link_url character varying(240),
    icon_url character varying(128),
    sort smallint,
    subgroup smallint,
    maingroup smallint,
    extension character varying(160),
    target character varying(20),
    help_url character varying(60)
);


ALTER TABLE public.lmb_action OWNER TO limbasuser;

--
-- Name: lmb_action_depend; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_action_depend (
    id integer NOT NULL,
    action character varying(50),
    link_name integer,
    beschreibung integer,
    link_url character varying(240),
    icon_url character varying(128),
    sort smallint,
    subgroup smallint,
    maingroup smallint,
    extension character varying(50),
    target character varying(20),
    help_url character varying(60)
);


ALTER TABLE public.lmb_action_depend OWNER TO limbasuser;

--
-- Name: lmb_attribute_d; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_attribute_d (
    id numeric(16,0) NOT NULL,
    erstuser smallint,
    w_id integer,
    tab_id smallint,
    field_id smallint,
    dat_id numeric(16,0),
    value_num double precision,
    value_string character varying(255),
    value_date timestamp without time zone
);


ALTER TABLE public.lmb_attribute_d OWNER TO limbasuser;

--
-- Name: lmb_attribute_p; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_attribute_p (
    id smallint NOT NULL,
    erstdatum timestamp without time zone,
    erstuser smallint,
    name character varying(60),
    snum smallint,
    tagmode boolean,
    multimode boolean
);


ALTER TABLE public.lmb_attribute_p OWNER TO limbasuser;

--
-- Name: lmb_attribute_w; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_attribute_w (
    id numeric(16,0) NOT NULL,
    erstuser smallint,
    pool smallint,
    wert character varying(255),
    keywords character varying(255),
    def boolean DEFAULT false,
    hide boolean DEFAULT false,
    sort smallint,
    type smallint,
    level integer DEFAULT 0,
    haslevel boolean DEFAULT false,
    color character varying(7),
    attrpool smallint,
    hidetag boolean,
    mandatory boolean
);


ALTER TABLE public.lmb_attribute_w OWNER TO limbasuser;

--
-- Name: lmb_auth_token; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_auth_token (
    token character varying(255) NOT NULL,
    user_id integer,
    lifespan smallint,
    expirestamp timestamp without time zone
);


ALTER TABLE public.lmb_auth_token OWNER TO limbasuser;

--
-- Name: lmb_chart_list; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_chart_list (
    id integer NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    erstuser smallint,
    diag_id smallint,
    diag_name character varying(50),
    diag_desc character varying(50),
    template character varying(255),
    tab_id smallint,
    noheader boolean,
    diag_type character varying(50),
    diag_width smallint DEFAULT 800,
    diag_height smallint DEFAULT 600,
    text_x character varying(100),
    text_y character varying(100),
    font_size smallint DEFAULT 12,
    padding_left smallint,
    padding_top smallint,
    padding_right smallint,
    padding_bottom smallint,
    legend_x smallint,
    legend_y smallint,
    legend_mode character varying(50),
    pie_write_values character varying(50),
    pie_radius smallint,
    transposed boolean
);


ALTER TABLE public.lmb_chart_list OWNER TO limbasuser;

--
-- Name: lmb_charts; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_charts (
    id numeric(10,0) NOT NULL,
    chart_id smallint,
    field_id smallint,
    axis smallint,
    function smallint,
    color character varying(8)
);


ALTER TABLE public.lmb_charts OWNER TO limbasuser;

--
-- Name: lmb_code_favorites; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_code_favorites (
    id smallint NOT NULL,
    name character varying(50),
    statement text,
    type smallint DEFAULT 0
);


ALTER TABLE public.lmb_code_favorites OWNER TO limbasuser;

--
-- Name: lmb_colorschemes; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_colorschemes (
    id integer NOT NULL,
    name character varying(50),
    web1 character varying(10),
    web2 character varying(10),
    web3 character varying(10),
    web4 character varying(10),
    web5 character varying(10),
    web6 character varying(10),
    web7 character varying(10),
    web8 character varying(10),
    norm boolean,
    web9 character varying(10),
    web10 character varying(10),
    web11 character varying(10),
    web12 character varying(10),
    web13 character varying(10),
    web14 character varying(10)
);


ALTER TABLE public.lmb_colorschemes OWNER TO limbasuser;

--
-- Name: lmb_conf_fields; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_conf_fields (
    id integer NOT NULL,
    field_id integer,
    tab_id smallint,
    tab_group smallint,
    sort integer,
    data_type smallint,
    field_type smallint,
    field_name character varying(50),
    form_name character varying(50),
    fieldkey boolean DEFAULT false,
    need boolean DEFAULT false,
    artleiste boolean DEFAULT false,
    genlink character varying(150),
    argument character varying(500),
    verkngroup smallint,
    isunique boolean DEFAULT false,
    argument_edit boolean DEFAULT false,
    refint boolean DEFAULT false,
    verkntabid integer,
    md5tab character varying(20),
    verknfieldid smallint,
    select_sort character varying(20),
    groupable boolean DEFAULT false,
    indize boolean DEFAULT false,
    nformat character varying(30),
    currency character varying(5),
    wysiwyg boolean DEFAULT false,
    verknsearch character varying(50),
    dynsearch boolean DEFAULT false,
    select_pool smallint,
    select_cut character varying(8),
    indexed boolean DEFAULT false,
    inherit_tab smallint,
    inherit_field smallint,
    ext_type character varying(50),
    verkntabletype smallint DEFAULT 1,
    argument_typ smallint,
    mainfield boolean DEFAULT false,
    beschreibung smallint,
    spelling smallint,
    lmtrigger character varying(20),
    defaultvalue character varying(25),
    hasrecverkn smallint,
    quicksearch boolean DEFAULT false,
    relext text,
    viewrule character varying(250),
    editrule character varying(250),
    potency smallint,
    inherit_search boolean,
    inherit_eval boolean,
    inherit_filter character varying(250),
    inherit_group smallint,
    verknview character varying(50),
    verknfind character varying(50),
    ajaxpost boolean,
    field_size smallint,
    collreplace boolean DEFAULT false,
    datetime numeric(1,0),
    aggregate character varying(10),
    scale smallint,
    verknparams smallint,
    listing_cut character varying(15),
    listing_viewmode numeric(1,0),
    verkntree character varying(32),
    multilang boolean DEFAULT false,
    popupdefault boolean,
    fullsearch boolean DEFAULT false
);


ALTER TABLE public.lmb_conf_fields OWNER TO limbasuser;

--
-- Name: lmb_conf_groups; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_conf_groups (
    id smallint NOT NULL,
    sort smallint,
    beschreibung smallint,
    name smallint,
    level smallint DEFAULT 0,
    icon character varying(250)
);


ALTER TABLE public.lmb_conf_groups OWNER TO limbasuser;

--
-- Name: lmb_conf_tables; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_conf_tables (
    id smallint NOT NULL,
    tab_id smallint,
    tab_group smallint,
    sort smallint,
    tabelle character varying(32),
    lockable boolean DEFAULT false,
    markcolor character varying(7),
    groupable numeric(1,0) DEFAULT 0,
    verkn smallint,
    linecolor boolean DEFAULT false,
    logging boolean DEFAULT false,
    typ integer DEFAULT 1,
    versioning smallint,
    ver_desc boolean DEFAULT false,
    beschreibung smallint,
    userrules boolean DEFAULT false,
    lmtrigger character varying(20),
    indicator character varying(250),
    ajaxpost boolean DEFAULT false,
    numrowcalc smallint,
    reserveid boolean,
    event character varying(500),
    lastmodified timestamp without time zone,
    keyfield character varying(15),
    params1 numeric(5,0),
    params2 character varying(500),
    datasync boolean,
    multitenant boolean
);


ALTER TABLE public.lmb_conf_tables OWNER TO limbasuser;

--
-- Name: lmb_conf_viewfields; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_conf_viewfields (
    id numeric,
    viewid integer,
    tablename character varying(50),
    qfield text,
    qfilter text,
    qorder smallint,
    qalias character varying(50),
    sort smallint,
    qshow boolean DEFAULT true,
    qfunc smallint
);


ALTER TABLE public.lmb_conf_viewfields OWNER TO limbasuser;

--
-- Name: lmb_conf_views; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_conf_views (
    id smallint NOT NULL,
    viewdef text,
    ispublic boolean DEFAULT false,
    hasid boolean DEFAULT false,
    relation text,
    usesystabs boolean DEFAULT false,
    viewtype smallint,
    isvalid boolean,
    setmanually boolean
);


ALTER TABLE public.lmb_conf_views OWNER TO limbasuser;

--
-- Name: lmb_crontab; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_crontab (
    id smallint NOT NULL,
    kategory character varying(20),
    start character varying(30),
    val character varying(250),
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activ boolean DEFAULT true,
    description character varying(60),
    alive integer,
    job_user smallint
);


ALTER TABLE public.lmb_crontab OWNER TO limbasuser;

--
-- Name: lmb_currency; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_currency (
    id smallint,
    currency character varying(50),
    code character varying(5) NOT NULL,
    symbol character varying(2)
);


ALTER TABLE public.lmb_currency OWNER TO limbasuser;

--
-- Name: lmb_currency_rate; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_currency_rate (
    id smallint NOT NULL,
    curfrom integer,
    curto integer,
    rate numeric(20,4),
    rday date
);


ALTER TABLE public.lmb_currency_rate OWNER TO limbasuser;

--
-- Name: lmb_custmenu; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_custmenu (
    id smallint NOT NULL,
    parent smallint,
    name smallint,
    title smallint,
    linkid smallint,
    typ smallint,
    url character varying(150),
    icon character varying(60),
    bg character varying(7),
    sort smallint
);


ALTER TABLE public.lmb_custmenu OWNER TO limbasuser;

--
-- Name: lmb_custmenu_list; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_custmenu_list (
    id smallint NOT NULL,
    name smallint,
    tabid smallint,
    fieldid smallint,
    type smallint,
    inactive character varying(150),
    disabled character varying(150)
);


ALTER TABLE public.lmb_custmenu_list OWNER TO limbasuser;

--
-- Name: lmb_custvar; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_custvar (
    id smallint NOT NULL,
    ckey character varying(50),
    cvalue character varying(200),
    description character varying(240),
    overridable boolean,
    active boolean
);


ALTER TABLE public.lmb_custvar OWNER TO limbasuser;

--
-- Name: lmb_custvar_depend; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_custvar_depend (
    id numeric(18,0) NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    edituser smallint,
    erstuser smallint DEFAULT 1,
    inuse_time timestamp without time zone,
    inuse_user smallint,
    del boolean DEFAULT false,
    erstgroup numeric(5,0),
    ckey character varying(50),
    cvalue character varying(200),
    description character varying(240),
    overridable boolean DEFAULT false,
    active boolean DEFAULT false
);


ALTER TABLE public.lmb_custvar_depend OWNER TO limbasuser;

--
-- Name: lmb_dbpatch; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_dbpatch (
    id smallint NOT NULL,
    status boolean DEFAULT false,
    revision smallint,
    description character varying(250),
    major smallint,
    version smallint
);


ALTER TABLE public.lmb_dbpatch OWNER TO limbasuser;

--
-- Name: lmb_external_storage; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_external_storage (
    id smallint NOT NULL,
    descr character varying(255),
    classname character varying(50),
    config text,
    externalaccessurl character varying(255),
    publiccloud boolean
);


ALTER TABLE public.lmb_external_storage OWNER TO limbasuser;

--
-- Name: lmb_field_types; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_field_types (
    id integer NOT NULL,
    field_type smallint,
    data_type smallint,
    data_type_exp character varying(50),
    datentyp character varying(20),
    size integer,
    lmrule character varying(300),
    sort numeric(5,0),
    format character varying(50),
    parse_type smallint,
    funcid smallint,
    hassize boolean DEFAULT false
);


ALTER TABLE public.lmb_field_types OWNER TO limbasuser;

--
-- Name: lmb_field_types_depend; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_field_types_depend (
    id integer,
    field_type smallint,
    data_type smallint,
    data_type_exp character varying(50),
    datentyp character varying(20),
    size integer,
    lmrule character varying(300),
    sort numeric(5,0),
    format character varying(50),
    parse_type smallint,
    funcid smallint,
    hassize boolean DEFAULT false
);


ALTER TABLE public.lmb_field_types_depend OWNER TO limbasuser;

--
-- Name: lmb_fonts; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_fonts (
    id smallint NOT NULL,
    family character varying(30),
    name character varying(30),
    style character varying(10)
);


ALTER TABLE public.lmb_fonts OWNER TO limbasuser;

--
-- Name: lmb_form_list; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_form_list (
    id integer NOT NULL,
    name character varying(160),
    beschreibung character varying(250),
    referenz_tab character varying(25),
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    erstuser smallint,
    edituser smallint,
    form_typ smallint,
    frame_size character varying(20),
    redirect smallint,
    css character varying(120),
    extension character varying(250),
    dimension character varying(10)
);


ALTER TABLE public.lmb_form_list OWNER TO limbasuser;

--
-- Name: lmb_forms; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_forms (
    keyid smallint,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    erstuser smallint,
    edituser smallint DEFAULT 0,
    form_id smallint DEFAULT 0,
    typ character varying(10),
    posx integer DEFAULT 0,
    posy smallint DEFAULT 0,
    height smallint DEFAULT 0,
    width smallint DEFAULT 0,
    style character varying(254),
    tab_group integer DEFAULT 0,
    tab_id integer DEFAULT 0,
    field_id integer DEFAULT 0,
    z_index smallint DEFAULT 0,
    uform_typ smallint DEFAULT 0,
    uform_vtyp smallint DEFAULT 0,
    pic_typ character varying(3),
    pic_style character varying(250),
    pic_size character varying(50),
    tab smallint DEFAULT 0,
    tab_size character varying(25),
    tab_el_col smallint DEFAULT 0,
    tab_el_row smallint DEFAULT 0,
    tab_el_col_size smallint DEFAULT 0,
    title character varying(250),
    event_click character varying(180),
    event_over character varying(180),
    event_out character varying(180),
    event_dblclick character varying(180),
    event_change character varying(180),
    inhalt text,
    class character varying(50),
    parentrel character varying(100),
    id integer NOT NULL,
    subelement smallint,
    categorie smallint DEFAULT 0,
    tab_el smallint,
    parameters text
);


ALTER TABLE public.lmb_forms OWNER TO limbasuser;

--
-- Name: lmb_groups; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_groups (
    group_id integer NOT NULL,
    name character varying(50),
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    level integer,
    del boolean DEFAULT false,
    redirect character varying(160),
    multiframelist character varying(250),
    description character varying(1000)
);


ALTER TABLE public.lmb_groups OWNER TO limbasuser;

--
-- Name: lmb_gtab_groupdat; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_gtab_groupdat (
    id double precision NOT NULL,
    group_id smallint,
    tab_id smallint,
    dat_id double precision,
    color character varying(7)
);


ALTER TABLE public.lmb_gtab_groupdat OWNER TO limbasuser;

--
-- Name: lmb_gtab_pattern; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_gtab_pattern (
    id integer NOT NULL,
    erstuser smallint,
    patid smallint,
    tabid character varying(50),
    posx smallint,
    posy smallint,
    width smallint,
    height smallint,
    visible boolean DEFAULT true,
    viewid smallint DEFAULT 0
);


ALTER TABLE public.lmb_gtab_pattern OWNER TO limbasuser;

--
-- Name: lmb_gtab_rowsize; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_gtab_rowsize (
    id smallint NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_id smallint,
    tab_id smallint,
    row_size character varying(2000)
);


ALTER TABLE public.lmb_gtab_rowsize OWNER TO limbasuser;

--
-- Name: lmb_gtab_status_save; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_gtab_status_save (
    id integer NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    erstuser smallint,
    tab_id smallint,
    formel character varying(1000),
    bezeichnung character varying(30),
    group_id smallint,
    typ smallint DEFAULT 1,
    beschreibung character varying(160),
    dssdsd boolean DEFAULT false
);


ALTER TABLE public.lmb_gtab_status_save OWNER TO limbasuser;

--
-- Name: lmb_history_action; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_history_action (
    id numeric(16,0) NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    userid smallint,
    tab smallint,
    dataid numeric(16,0),
    action smallint,
    loglevel smallint DEFAULT 1,
    lwf_id numeric(2,0) DEFAULT 0,
    lwf_inid numeric(16,0) DEFAULT 0,
    lwf_prid numeric(2,0) DEFAULT 0
);


ALTER TABLE public.lmb_history_action OWNER TO limbasuser;

--
-- Name: lmb_history_backup; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_history_backup (
    id numeric(16,0) NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    label character varying(50),
    action character varying(20),
    result boolean,
    medium character varying(20),
    size integer,
    nextlogpage integer,
    server character varying(20),
    location character varying(160),
    message character varying(250),
    cron_id integer
);


ALTER TABLE public.lmb_history_backup OWNER TO limbasuser;

--
-- Name: lmb_history_update; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_history_update (
    id numeric(16,0) NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    userid smallint,
    tab smallint,
    field smallint,
    dataid numeric(16,0),
    fieldvalue character varying(1000),
    action_id numeric(16,0),
    lwf_id numeric(2,0) DEFAULT 0,
    lwf_inid numeric(16,0) DEFAULT 0,
    lwf_prid numeric(2,0) DEFAULT 0
);


ALTER TABLE public.lmb_history_update OWNER TO limbasuser;

--
-- Name: lmb_history_user; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_history_user (
    id integer NOT NULL,
    userid integer,
    sessionid character varying(128),
    login_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_date timestamp without time zone,
    ip character varying(15),
    host character varying(254),
    login_time numeric(12,0)
);


ALTER TABLE public.lmb_history_user OWNER TO limbasuser;

--
-- Name: lmb_indize_d; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_indize_d (
    id numeric(16,0) NOT NULL,
    sid integer,
    wid numeric(16,0),
    ref numeric(16,0),
    tabid smallint,
    fieldid smallint
);


ALTER TABLE public.lmb_indize_d OWNER TO limbasuser;

--
-- Name: lmb_indize_ds; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_indize_ds (
    id numeric(16,0) NOT NULL,
    sid integer,
    wid numeric(16,0),
    ref numeric(16,0),
    tabid smallint,
    fieldid smallint
);


ALTER TABLE public.lmb_indize_ds OWNER TO limbasuser;

--
-- Name: lmb_indize_f; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_indize_f (
    id numeric(16,0) NOT NULL,
    sid integer,
    wid numeric(16,0),
    fid numeric(16,0),
    meta boolean DEFAULT false
);


ALTER TABLE public.lmb_indize_f OWNER TO limbasuser;

--
-- Name: lmb_indize_fs; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_indize_fs (
    id numeric(16,0) NOT NULL,
    sid integer,
    wid numeric(16,0),
    fid numeric(16,0),
    meta boolean DEFAULT false
);


ALTER TABLE public.lmb_indize_fs OWNER TO limbasuser;

--
-- Name: lmb_indize_history; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_indize_history (
    id numeric(16,0) NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    result boolean DEFAULT false,
    used_time double precision,
    message character varying(120),
    action character varying(20),
    inum integer,
    job integer,
    jnum smallint
);


ALTER TABLE public.lmb_indize_history OWNER TO limbasuser;

--
-- Name: lmb_indize_w; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_indize_w (
    id numeric(16,0) NOT NULL,
    val character varying(60),
    metaphone character varying(60),
    upperval character varying(60)
);


ALTER TABLE public.lmb_indize_w OWNER TO limbasuser;

--
-- Name: lmb_lang; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_lang (
    id integer NOT NULL,
    language_id smallint,
    element_id integer,
    typ smallint,
    wert character varying(250),
    language character varying(20),
    edit boolean DEFAULT false,
    lmfile character varying(250),
    js boolean DEFAULT false
);


ALTER TABLE public.lmb_lang OWNER TO limbasuser;

--
-- Name: lmb_lang_depend; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_lang_depend (
    id integer NOT NULL,
    language_id smallint,
    element_id integer,
    typ smallint,
    wert character varying(250),
    language character varying(20),
    edit boolean DEFAULT false,
    lmfile character varying(250),
    js boolean DEFAULT false
);


ALTER TABLE public.lmb_lang_depend OWNER TO limbasuser;

--
-- Name: lmb_mimetypes; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_mimetypes (
    id integer NOT NULL,
    mimetype character varying(255),
    ext character varying(255),
    pic character varying(50)
);


ALTER TABLE public.lmb_mimetypes OWNER TO limbasuser;

--
-- Name: lmb_multitenant; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_multitenant (
    id smallint NOT NULL,
    name character varying(50),
    mid integer,
    syncslave smallint
);


ALTER TABLE public.lmb_multitenant OWNER TO limbasuser;

--
-- Name: lmb_printers; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_printers (
    id smallint NOT NULL,
    name character varying(127),
    sysname character varying(127),
    config text,
    def boolean
);


ALTER TABLE public.lmb_printers OWNER TO limbasuser;

--
-- Name: lmb_reminder; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_reminder (
    id numeric(16,0) NOT NULL,
    user_id smallint,
    tab_id smallint,
    dat_id numeric(16,0),
    frist timestamp without time zone,
    typ smallint,
    description character varying(250),
    fromuser smallint,
    content character varying(160),
    category smallint DEFAULT 0,
    group_id smallint,
    wfl_inst numeric
);


ALTER TABLE public.lmb_reminder OWNER TO limbasuser;

--
-- Name: lmb_reminder_list; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_reminder_list (
    id smallint NOT NULL,
    erstuser smallint,
    erstdatum timestamp without time zone,
    name character varying(50),
    tab_id smallint,
    formd_id smallint,
    forml_id smallint,
    groupbased boolean,
    sort smallint
);


ALTER TABLE public.lmb_reminder_list OWNER TO limbasuser;

--
-- Name: lmb_report_list; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_report_list (
    id integer NOT NULL,
    name character varying(160),
    beschreibung character varying(250),
    page_style character varying(100),
    sql_statement character varying(255),
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    erstuser smallint,
    edituser smallint,
    referenz_tab smallint,
    grouplist character varying(50),
    target smallint,
    savename character varying(160),
    tagmod boolean DEFAULT false,
    extension character varying(160),
    indexorder character varying(15),
    odt_template numeric(18,0),
    defformat character varying(10) DEFAULT 'PDF'::character varying,
    listmode boolean,
    ods_template smallint,
    css character varying(120)
);


ALTER TABLE public.lmb_report_list OWNER TO limbasuser;

--
-- Name: lmb_reports; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_reports (
    el_id smallint,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    erstuser smallint,
    edituser smallint,
    typ character varying(10),
    posx smallint,
    posy smallint,
    height smallint,
    width smallint,
    inhalt character varying(1000),
    dbfield character varying(50),
    verkn_baum character varying(250),
    style character varying(254),
    db_data_type integer,
    show_all boolean,
    bericht_id integer,
    z_index smallint DEFAULT 0,
    liste boolean DEFAULT false,
    tab smallint,
    tab_size character varying(25),
    tab_el_col smallint,
    tab_el_row smallint,
    tab_el_col_size integer,
    header boolean DEFAULT false,
    footer boolean DEFAULT false,
    pic_typ character varying(3),
    pic_style character varying(250),
    pic_size character varying(50),
    pic_res smallint,
    pic_name character varying(20),
    bg smallint DEFAULT 0,
    extvalue character varying(1000),
    id integer NOT NULL,
    tab_el smallint
);


ALTER TABLE public.lmb_reports OWNER TO limbasuser;

--
-- Name: lmb_revision; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_revision (
    id smallint NOT NULL,
    erstuser smallint,
    erstdatum timestamp without time zone,
    revision smallint,
    version smallint,
    corev character varying(20),
    description text
);


ALTER TABLE public.lmb_revision OWNER TO limbasuser;

--
-- Name: lmb_rules_action; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_rules_action (
    id integer NOT NULL,
    group_id integer,
    link_id integer,
    perm integer,
    sort numeric(5,0)
);


ALTER TABLE public.lmb_rules_action OWNER TO limbasuser;

--
-- Name: lmb_rules_dataset; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_rules_dataset (
    keyid numeric(18,0) NOT NULL,
    edituser smallint,
    datid numeric(18,0),
    userid smallint,
    groupid smallint,
    tabid smallint,
    edit boolean DEFAULT false,
    del boolean DEFAULT false
);


ALTER TABLE public.lmb_rules_dataset OWNER TO limbasuser;

--
-- Name: lmb_rules_fields; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_rules_fields (
    id numeric(10,0) NOT NULL,
    tab_id smallint,
    field_id smallint,
    group_id smallint,
    tab_group smallint,
    lmview boolean DEFAULT false,
    edit boolean DEFAULT false,
    color character varying(7),
    filter character varying(499),
    sort smallint,
    need boolean DEFAULT false,
    filtertyp numeric(1,0) DEFAULT 0,
    nformat character varying(30),
    currency character varying(5),
    deflt character varying(250),
    copy boolean DEFAULT false,
    lmtrigger character varying(250),
    ext_type character varying(50),
    ver boolean DEFAULT false,
    editrule character varying(250),
    fieldoption boolean DEFAULT true,
    listedit boolean,
    speechrec boolean
);


ALTER TABLE public.lmb_rules_fields OWNER TO limbasuser;

--
-- Name: lmb_rules_repform; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_rules_repform (
    id numeric(6,0) NOT NULL,
    typ numeric(1,0),
    group_id smallint,
    repform_id smallint,
    lmview boolean,
    hidden boolean DEFAULT false
);


ALTER TABLE public.lmb_rules_repform OWNER TO limbasuser;

--
-- Name: lmb_rules_tables; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_rules_tables (
    id integer NOT NULL,
    group_id smallint,
    tab_id smallint,
    tab_group smallint,
    edit boolean DEFAULT false,
    lmview boolean DEFAULT true,
    view_period smallint,
    view_form smallint,
    del boolean DEFAULT false,
    hide boolean DEFAULT false,
    lmadd boolean DEFAULT false,
    need boolean DEFAULT false,
    lmtrigger character varying(20),
    view_tform smallint,
    ver smallint,
    editrule character varying(250),
    hidemenu boolean DEFAULT false,
    userrules boolean DEFAULT false,
    viewver boolean DEFAULT false,
    lmlock boolean DEFAULT false,
    userprivilege boolean DEFAULT false,
    hiraprivilege boolean DEFAULT false,
    specificprivilege character varying(250),
    indicator character varying(250),
    copy boolean DEFAULT false,
    view_lform smallint
);


ALTER TABLE public.lmb_rules_tables OWNER TO limbasuser;

--
-- Name: lmb_select_d; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_select_d (
    id integer NOT NULL,
    tab_id smallint,
    dat_id integer,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    erstuser smallint,
    field_id smallint,
    w_id integer
);


ALTER TABLE public.lmb_select_d OWNER TO limbasuser;

--
-- Name: lmb_select_p; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_select_p (
    id smallint NOT NULL,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    erstuser smallint,
    name character varying(60),
    snum integer,
    tagmode boolean,
    multimode boolean
);


ALTER TABLE public.lmb_select_p OWNER TO limbasuser;

--
-- Name: lmb_select_w; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_select_w (
    id integer NOT NULL,
    sort integer,
    wert character varying(255),
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    erstuser smallint,
    def boolean DEFAULT false,
    keywords character varying(250),
    pool smallint,
    hide boolean DEFAULT false,
    level integer DEFAULT 0,
    haslevel boolean DEFAULT false,
    lang2_wert character varying(255),
    color character varying(7)
);


ALTER TABLE public.lmb_select_w OWNER TO limbasuser;

--
-- Name: lmb_session; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_session (
    id character varying(128) NOT NULL,
    user_id integer,
    group_id integer,
    logout boolean DEFAULT false,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ip character varying(20),
    filestruct_changed boolean DEFAULT false,
    table_changed boolean DEFAULT false,
    snap_changed boolean DEFAULT false
);


ALTER TABLE public.lmb_session OWNER TO limbasuser;

--
-- Name: lmb_snap; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_snap (
    id integer NOT NULL,
    user_id smallint,
    tabid smallint,
    name character varying(30),
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    global boolean DEFAULT false,
    filter text,
    ext text
);


ALTER TABLE public.lmb_snap OWNER TO limbasuser;

--
-- Name: lmb_snap_shared; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_snap_shared (
    id smallint NOT NULL,
    entity_type character varying(1),
    entity_id smallint,
    snapshot_id smallint,
    edit boolean DEFAULT false,
    del boolean DEFAULT false
);


ALTER TABLE public.lmb_snap_shared OWNER TO limbasuser;

--
-- Name: lmb_sqlreserved; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_sqlreserved (
    id integer,
    sql_92 character varying(255)
);


ALTER TABLE public.lmb_sqlreserved OWNER TO limbasuser;

--
-- Name: lmb_sync_cache; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_sync_cache (
    id numeric(16,0) NOT NULL,
    tabid smallint,
    datid numeric(16,0),
    slave_id smallint,
    slave_datid numeric(16,0)
);


ALTER TABLE public.lmb_sync_cache OWNER TO limbasuser;

--
-- Name: lmb_sync_conf; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_sync_conf (
    id smallint NOT NULL,
    template smallint,
    tabid smallint,
    fieldid smallint,
    master boolean,
    slave boolean
);


ALTER TABLE public.lmb_sync_conf OWNER TO limbasuser;

--
-- Name: lmb_sync_log; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_sync_log (
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type character varying(50),
    tabid smallint,
    datid numeric,
    fieldid smallint,
    origin smallint,
    errorcode smallint,
    message character varying(100)
);


ALTER TABLE public.lmb_sync_log OWNER TO limbasuser;

--
-- Name: lmb_sync_slaves; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_sync_slaves (
    id smallint NOT NULL,
    erstuser smallint,
    erstdatum timestamp without time zone,
    name character varying(50),
    slave_url character varying(100),
    slave_username character varying(20),
    slave_pass character varying(20)
);


ALTER TABLE public.lmb_sync_slaves OWNER TO limbasuser;

--
-- Name: lmb_sync_template; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_sync_template (
    id smallint NOT NULL,
    name character varying(50),
    conflict_mode smallint,
    tabid smallint,
    setting text
);


ALTER TABLE public.lmb_sync_template OWNER TO limbasuser;

--
-- Name: lmb_tabletree; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_tabletree (
    id smallint NOT NULL,
    erstuser smallint,
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tabid smallint,
    target_formid smallint,
    display_field smallint,
    display_icon character varying(30),
    display_title smallint,
    poolname character varying(50),
    target_snap smallint,
    display boolean DEFAULT false,
    display_sort smallint,
    display_rule character varying(250),
    treeid smallint,
    relationid character varying(20),
    itemtab smallint
);


ALTER TABLE public.lmb_tabletree OWNER TO limbasuser;

--
-- Name: lmb_trigger; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_trigger (
    id smallint,
    erstdatum timestamp without time zone,
    editdatum timestamp without time zone,
    edituser smallint,
    erstuser smallint,
    table_name character varying(50),
    type character varying(50),
    trigger_value character varying(4000),
    description character varying(50),
    active boolean,
    intern boolean DEFAULT false,
    sort smallint,
    name character varying(25),
    dbvendor character varying(15),
    debvendor character varying(15),
    "position" character varying(6)
);


ALTER TABLE public.lmb_trigger OWNER TO limbasuser;

--
-- Name: lmb_uglst; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_uglst (
    ugid smallint,
    tabid smallint,
    fieldid smallint,
    datid numeric,
    typ character(1)
);


ALTER TABLE public.lmb_uglst OWNER TO limbasuser;

--
-- Name: lmb_umgvar; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_umgvar (
    id integer,
    sort integer,
    form_name character varying(50),
    norm character varying(200),
    beschreibung character varying(240),
    category smallint
);


ALTER TABLE public.lmb_umgvar OWNER TO limbasuser;

--
-- Name: lmb_user_colors; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_user_colors (
    id integer NOT NULL,
    userid integer,
    wert character varying(7)
);


ALTER TABLE public.lmb_user_colors OWNER TO limbasuser;

--
-- Name: lmb_userdb; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_userdb (
    user_id integer NOT NULL,
    group_id integer,
    username character varying(50),
    passwort character varying(255),
    vorname character varying(50),
    name character varying(50),
    email character varying(50),
    beschreibung character varying(100),
    erstdatum timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    editdatum timestamp without time zone,
    maxresult numeric(5,0),
    farbschema character varying(20),
    lmlock boolean DEFAULT false,
    data_hide smallint,
    language smallint,
    layout character varying(20),
    uploadsize integer,
    debug boolean DEFAULT false,
    sub_group character varying(160),
    data_display smallint,
    iprange character varying(150),
    soundlist character varying(150),
    change_pass boolean DEFAULT false,
    del boolean DEFAULT false,
    data_color boolean DEFAULT false,
    subadmin boolean DEFAULT false,
    logging smallint DEFAULT 1,
    validdate timestamp without time zone,
    valid boolean DEFAULT false,
    lock_txt character varying(500),
    ufile text,
    t_setting character varying(50),
    symbolbar boolean DEFAULT true,
    usercolor character varying(6),
    lockbackend boolean DEFAULT false,
    clearpass character varying(50),
    session text,
    gc_maxlifetime integer DEFAULT 0,
    id integer,
    static_ip boolean DEFAULT false,
    dateformat smallint,
    setlocal character varying(15),
    time_zone character varying(20),
    ugtab text,
    e_setting text,
    m_setting text,
    tel character varying(25),
    fax character varying(25),
    "position" character varying(50),
    superadmin boolean DEFAULT false,
    multitenant character varying(50),
    dlanguage smallint
);


ALTER TABLE public.lmb_userdb OWNER TO limbasuser;

--
-- Name: lmb_usrgrp_lst; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_usrgrp_lst (
    user_id smallint,
    entity_type character varying(1),
    entity_id smallint NOT NULL
);


ALTER TABLE public.lmb_usrgrp_lst OWNER TO limbasuser;

--
-- Name: lmb_wfl; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_wfl (
    id smallint NOT NULL,
    name character varying(50),
    descr character varying(250),
    startid smallint,
    params text
);


ALTER TABLE public.lmb_wfl OWNER TO limbasuser;

--
-- Name: lmb_wfl_history; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_wfl_history (
    id numeric NOT NULL,
    erstdatum timestamp without time zone,
    inst_id numeric,
    task_id smallint,
    user_id smallint,
    wfl_id smallint,
    tab_id smallint,
    dat_id numeric
);


ALTER TABLE public.lmb_wfl_history OWNER TO limbasuser;

--
-- Name: lmb_wfl_inst; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_wfl_inst (
    id numeric NOT NULL,
    tab_id smallint,
    dat_id numeric,
    task_id smallint,
    wfl_id smallint
);


ALTER TABLE public.lmb_wfl_inst OWNER TO limbasuser;

--
-- Name: lmb_wfl_task; Type: TABLE; Schema: public; Owner: limbasuser
--

CREATE TABLE public.lmb_wfl_task (
    id smallint NOT NULL,
    name character varying(50),
    descr character varying(250),
    wfl_id smallint,
    tab_id smallint,
    tasks_usable character varying(50),
    params text,
    sort smallint
);


ALTER TABLE public.lmb_wfl_task OWNER TO limbasuser;

--
-- Name: seq_adressen_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_adressen_id
    START WITH 10
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_adressen_id OWNER TO limbasuser;

--
-- Name: seq_artikel_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_artikel_id
    START WITH 83
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_artikel_id OWNER TO limbasuser;

--
-- Name: seq_aufgaben_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_aufgaben_id
    START WITH 23
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_aufgaben_id OWNER TO limbasuser;

--
-- Name: seq_auftraege_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_auftraege_id
    START WITH 33
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_auftraege_id OWNER TO limbasuser;

--
-- Name: seq_ausgaben_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_ausgaben_id
    START WITH 5
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_ausgaben_id OWNER TO limbasuser;

--
-- Name: seq_berichtstemplate_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_berichtstemplate_id
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_berichtstemplate_id OWNER TO limbasuser;

--
-- Name: seq_feldtypen_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_feldtypen_id
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_feldtypen_id OWNER TO limbasuser;

--
-- Name: seq_kontakte_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_kontakte_id
    START WITH 119
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_kontakte_id OWNER TO limbasuser;

--
-- Name: seq_korrespondenz_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_korrespondenz_id
    START WITH 188
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_korrespondenz_id OWNER TO limbasuser;

--
-- Name: seq_kunden_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_kunden_id
    START WITH 94
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_kunden_id OWNER TO limbasuser;

--
-- Name: seq_ldms_files_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_ldms_files_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_ldms_files_id OWNER TO limbasuser;

--
-- Name: seq_ldms_meta_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_ldms_meta_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_ldms_meta_id OWNER TO limbasuser;

--
-- Name: seq_lmb_custvar_depend_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_lmb_custvar_depend_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_lmb_custvar_depend_id OWNER TO limbasuser;

--
-- Name: seq_lmb_history_action_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_lmb_history_action_id
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_lmb_history_action_id OWNER TO limbasuser;

--
-- Name: seq_lmb_history_update_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_lmb_history_update_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_lmb_history_update_id OWNER TO limbasuser;

--
-- Name: seq_lmb_history_user_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_lmb_history_user_id
    START WITH 38
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_lmb_history_user_id OWNER TO limbasuser;

--
-- Name: seq_lmb_reminder_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_lmb_reminder_id
    START WITH 135
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_lmb_reminder_id OWNER TO limbasuser;

--
-- Name: seq_lmb_wfl_inst_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_lmb_wfl_inst_id
    START WITH 89
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_lmb_wfl_inst_id OWNER TO limbasuser;

--
-- Name: seq_meinkalender_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_meinkalender_id
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_meinkalender_id OWNER TO limbasuser;

--
-- Name: seq_mitarbeiter_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_mitarbeiter_id
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_mitarbeiter_id OWNER TO limbasuser;

--
-- Name: seq_nachrichten_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_nachrichten_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_nachrichten_id OWNER TO limbasuser;

--
-- Name: seq_positionen_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_positionen_id
    START WITH 99
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_positionen_id OWNER TO limbasuser;

--
-- Name: seq_projekte_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_projekte_id
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_projekte_id OWNER TO limbasuser;

--
-- Name: seq_raeume_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_raeume_id
    START WITH 12
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_raeume_id OWNER TO limbasuser;

--
-- Name: seq_raumverteilung_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_raumverteilung_id
    START WITH 33
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_raumverteilung_id OWNER TO limbasuser;

--
-- Name: seq_templates_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_templates_id
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_templates_id OWNER TO limbasuser;

--
-- Name: seq_verk_070140c2ecc06_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_070140c2ecc06_keyid
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_070140c2ecc06_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_07a6948db7d45_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_07a6948db7d45_keyid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_07a6948db7d45_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_10f25cf14fe63_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_10f25cf14fe63_keyid
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_10f25cf14fe63_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_17e64eb8914c6_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_17e64eb8914c6_keyid
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_17e64eb8914c6_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_1fb5ab7537f76_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_1fb5ab7537f76_keyid
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_1fb5ab7537f76_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_242f6cad318bb_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_242f6cad318bb_keyid
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_242f6cad318bb_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_3fcf4e1eb67e5_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_3fcf4e1eb67e5_keyid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_3fcf4e1eb67e5_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_442a8f1d8a126_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_442a8f1d8a126_keyid
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_442a8f1d8a126_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_4465a9d897b7f_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_4465a9d897b7f_keyid
    START WITH 92
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_4465a9d897b7f_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_5c73240091186_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_5c73240091186_keyid
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_5c73240091186_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_5ca376805922b_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_5ca376805922b_keyid
    START WITH 40
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_5ca376805922b_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_6f91ec1c8fa36_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_6f91ec1c8fa36_keyid
    START WITH 14
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_6f91ec1c8fa36_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_7a0c66d0b880b_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_7a0c66d0b880b_keyid
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_7a0c66d0b880b_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_7a74d69e7b5f2_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_7a74d69e7b5f2_keyid
    START WITH 184
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_7a74d69e7b5f2_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_865cb28dc0601_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_865cb28dc0601_keyid
    START WITH 5
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_865cb28dc0601_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_91fb8ff20bffc_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_91fb8ff20bffc_keyid
    START WITH 37
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_91fb8ff20bffc_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_9259d5b2c1857_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_9259d5b2c1857_keyid
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_9259d5b2c1857_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_9f0323be5cf4e_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_9f0323be5cf4e_id
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_9f0323be5cf4e_id OWNER TO limbasuser;

--
-- Name: seq_verk_9f0323be5cf4e_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_9f0323be5cf4e_keyid
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_9f0323be5cf4e_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_a01fc1e65ef75_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_a01fc1e65ef75_keyid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_a01fc1e65ef75_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_ab02c3dbf12e1_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_ab02c3dbf12e1_id
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_ab02c3dbf12e1_id OWNER TO limbasuser;

--
-- Name: seq_verk_ab02c3dbf12e1_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_ab02c3dbf12e1_keyid
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_ab02c3dbf12e1_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_ae2df1f3eb751_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_ae2df1f3eb751_keyid
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_ae2df1f3eb751_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_b549a745c24f3_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_b549a745c24f3_keyid
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_b549a745c24f3_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_ed4cbeb1c927c_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_ed4cbeb1c927c_keyid
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_ed4cbeb1c927c_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_f7bd3e7b4766a_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_f7bd3e7b4766a_keyid
    START WITH 14
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_f7bd3e7b4766a_keyid OWNER TO limbasuser;

--
-- Name: seq_verk_fcd12e02a5a6c_keyid; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_verk_fcd12e02a5a6c_keyid
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_verk_fcd12e02a5a6c_keyid OWNER TO limbasuser;

--
-- Name: seq_zahlungseingang_id; Type: SEQUENCE; Schema: public; Owner: limbasuser
--

CREATE SEQUENCE public.seq_zahlungseingang_id
    START WITH 16
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_zahlungseingang_id OWNER TO limbasuser;

--
-- Data for Name: ldms_favorites; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.ldms_favorites (id, user_id, group_id, erstdatum, file_id, folder) FROM stdin;
\.


--
-- Data for Name: ldms_files; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.ldms_files (id, erstdatum, editdatum, edituser, erstuser, inuse_time, inuse_user, del, erstgroup, level, typ, sort, datid, tabid, fieldid, name, secname, mimetype, size, checked, perm, lmlock, lockuser, checkuser, permuser, permdate, checkdate, lockdate, vid, vact, vdesc, vpid, thumb_ok, meta, info, content, md5, storage_id, download_link, ind, indd, indt, indm, indc, ocr, ocrd, ocrt, ocrs) FROM stdin;
\.


--
-- Data for Name: ldms_meta; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.ldms_meta (id, erstdatum, editdatum, edituser, erstuser, inuse_time, inuse_user, del, type, ftype, name2, format, geometry, resolution, depth, colors, creator, subject, classification, description, publisher, contributors, identifier, source, language, instructions, urgency, category, title, credit, city, state, country, transmission, originname, copyright, createdate, subcategory) FROM stdin;
\.


--
-- Data for Name: ldms_rules; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.ldms_rules (id, erstdatum, group_id, file_id, file_typ, lmview, lmadd, del, addf, edit, lmlock) FROM stdin;
1	2020-09-18 12:29:43.161517	1	1	\N	t	t	t	t	t	f
2	2020-09-18 12:29:43.161736	1	2	\N	t	t	t	t	t	f
3	2020-09-18 12:29:43.161933	1	3	\N	t	t	t	t	t	f
\.


--
-- Data for Name: ldms_structure; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.ldms_structure (id, name, level, erstuser, typ, fix, mail_level, tabgroup_id, tab_id, field_id, erstdatum, readonly, erstgroup, editdatum, sort, path, storage_id) FROM stdin;
1	öffentlicher Ordner	0	1	1	t	\N	\N	0	0	2020-09-18 12:29:43.161419	f	1	\N	\N	\N	\N
2	Dokumente	1	1	1	f	\N	\N	0	0	2020-09-18 12:29:43.161622	f	1	\N	\N	\N	\N
3	Bilder	1	1	1	f	\N	\N	0	0	2020-09-18 12:29:43.161833	f	1	\N	\N	\N	\N
4	Eigene Dateien	0	1	4	t	\N	\N	0	\N	2020-09-18 12:29:43.162131	f	1	\N	2	\N	\N
\.


--
-- Data for Name: lmb_action; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_action (id, action, link_name, beschreibung, link_url, icon_url, sort, subgroup, maingroup, extension, target, help_url) FROM stdin;
312	\N	3002	3003	limbasDivShow(this,'limbasDivMenuAnsicht','limbasDivMenuValidity','',1);	lmb-step-forward	10	3	3		\N	\N
239	\N	2162	2163	limbasDivShow(this,'limbasDivMenuAnsicht','limbasDivMenuVersionen');	lmb-icon-cus lmb-tables	13	3	3		\N	\N
240	\N	2165	2166	document.form1.view_symbolbar.value='1';send_form(1);	lmb-symbols	16	3	3		\N	\N
5	\N	355	356	\N	lmb-rel-comment	8	2	3		\N	\N
35	messages	415	416	f_2('messages');	lmb-mail	0	1	4		\N	\N
36	message_new	417	418	new_message();	lmb-mail-new	2	1	4		\N	\N
170	message_get	1422	1423	top.message.document.location.href=top.message.document.location.href;divclose();	lmb-icon-cus lmb-email-open 	3	1	4		\N	\N
38	message_find	421	422	\N	lmb-mail-search	4	1	4		\N	\N
123	\N	788	789	forward_message();	lmb-mail-forward	5	1	4		\N	\N
122	\N	786	787	answer_message();	lmb-mail-reply	6	1	4		\N	\N
121	\N	784	785	cache_file('m');	lmb-mail-reply	7	1	4		\N	\N
172	\N	1476	1477	del_message()	lmb-icon-cus lmb-email-del	9	1	4		\N	\N
142	explorer	1200	1201	f_2('explorer');	lmb-icon-cus lmb-folder-open	0	2	4		\N	\N
119	\N	777	778	LmEx_newfile();	lmb-icon-cus lmb-folder-add	2	2	4		\N	\N
129	\N	817	818	LmEx_cache_file('c');	lmb-page-copy	3	2	4		\N	\N
130	\N	819	820	LmEx_cache_file('m');	lmb-icon-cus lmb-page-cut 	4	2	4		\N	\N
171	\N	1470	1471	LmEx_delfile();LmEx_divclose();	lmb-icon-cus lmb-page-delete-fancy	7	2	4		\N	\N
124	\N	790	791	unview_message()	\N	10	1	4		\N	\N
29	user_change	403	404	f_2('user_change');	lmb-user-setting	0	3	4		\N	\N
169	kalender	1345	1346	f_2('kalender');	lmb-icon-cus lmb-cal-week	0	4	4		\N	\N
41	user_vorlage	427	428	f_2('user_vorlage');	lmb-icon-cus lmb-report-picture	0	5	4		\N	\N
189	user_snapshot	1604	1605	f_2('user_snapshot');	lmb-manage-snapshot	0	6	4		\N	\N
32	user_color	409	410	f_2('user_color');	lmb-color-swatch	0	9	4		\N	\N
54	setup_user	453	454	\N	lmb-user-alt	0	3	2		\N	Administrieren
87	setup_user_change_admin	495	496	f_3('setup_user_change_admin');	lmb-user-setting	1	3	2		\N	Administrieren
42	setup_user_neu	429	430	f_3('setup_user','setup_user_tree','setup_user_neu');	lmb-user-plus	3	3	2		\N	User_anlegen
53	setup_stat_user_dia	451	452	f_3('setup_stat_user_dia');	lmb-icon-cus lmb-user-chart	6	3	2		\N	Administrieren
167	setup_upload_editor	1319	1320	\N	lmb-pencil	6	4	2		\N	\N
196	message_copy	1698	1699	\N	lmb-icon-cus lmb-email-copy	8	1	4		\N	\N
199	\N	1711	1712	note_message();	\N	1	1	4		\N	\N
249	mini_explorer	2223	2224	LmEx_open_miniexplorer()	lmb-folder	0	2	4		\N	\N
205	\N	1782	1783	\N	lmb-exchange	9	2	4		\N	\N
194	download	1628	1629	\N	lmb-icon-cus lmb-page-go	11	2	4		\N	\N
195	explorer_detail	1632	1633	LmEx_file_detail();	lmb-file-info	13	2	4		\N	\N
217	\N	1891	1892	document.form2.submit();	lmb-reset	15	2	4		\N	\N
200	\N	1724	1725	LmEx_refresh_thumbs();	lmb-icon-cus lmb-pics	16	2	4		\N	\N
265	\N	2319	2320	\N	lmb-icon-cus lmb-dir-cam	17	2	4		\N	\N
218	\N	1910	1911	\N	lmb-icon-cus lmb-dir-cam	17	2	4		\N	\N
220	\N	1920	1921	document.form1.save_setting.value=1;LmEx_tdsize();document.form1.submit();	lmb-icon-cus lmb-save-dir-view	18	2	4		\N	\N
251	nav	2246	2247	\N	\N	2	1	1		\N	\N
252	top2	2248	2249	\N	\N	1	1	1		\N	\N
253	multiframe	2250	2251	\N	\N	3	1	1		\N	\N
254	intro	2252	2253	\N	\N	0	1	1		\N	\N
264	\N	2315	2316	document.form1.ffilter_viewmode.value='5';LmEx_send_form(1);	lmb-system-job	21	2	4		\N	\N
257	\N	2260	2261	document.form1.ffilter_viewmode.value='4';LmEx_send_form(1);	lmb-picture-icon	22	2	4		\N	\N
256	\N	2258	2259	document.form1.ffilter_viewmode.value='3';LmEx_send_form(1);	lmb-icon-cus lmb-pics	23	2	4		\N	\N
221	\N	1922	1923	document.form1.save_setting.value=2;LmEx_tdsize();document.form1.submit();	lmb-icon-cus lmb-save-search	24	2	4		\N	\N
202	\N	1735	1736	LmEx_open_newexplorer()	lmb-icon lmb-new-window	25	2	4		\N	\N
263	\N	2307	2308	document.form1.view_symbolbar.value='1';LmEx_send_form(1);	lmb-symbols	27	2	4		\N	\N
278	\N	2478	2479	document.form1.ffilter_dublicates.value='1';LmEx_send_form(1);	lmb-page-copy	28	2	4		\N	\N
269	explorer_dublicates	2364	2365	LmEx_open_dublicates()	lmb-page-copy	28	2	4		\N	\N
272	user_lock	2439	2440	f_2('user_lock');	lmb-lock	2	8	4		\N	\N
277	\N	2471	2472	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuSettings');	\N	1	7	3		\N	\N
135	setup_group_erg	834	835	f_3('setup_group_erg');	lmb-group-key	8	3	2		\N	Administrieren
192	setup_group_dateirechte	1617	1618	f_3('setup_group_dateirechte');	lmb-folder-key	11	3	2		\N	Administrieren
229	setup_workflow	2059	2060	f_3('setup_workflow');	lmb-cog-alt	0	9	2		\N	\N
197	\N	1700	1701	send_form(1);	lmb-page-save	2	1	3		\N	\N
201	gtab_copy	1729	1730	userecord('copy');	lmb-page-copy	5	1	3		\N	\N
235	gtab_versioning	2134	2135	userecord('versioning');	lmb-versioning	8	1	3		\N	\N
271	gtab_lock	2431	2432	userecord('unlock');	lmb-page-lock-green	15	1	3		\N	\N
204	edit_long	1769	1770	\N	lmb-icon-cus lmb-script-edit	4	2	3		\N	\N
212	\N	1869	1870	noLimit();	lmb-chain-broken	7	2	3		\N	\N
219	\N	1916	1917	LmEx_open_menu(this,'fieldlist');	lmb-icon-cus lmb-txt-ol-active	19	2	4		\N	\N
116	\N	771	772	if(LmEx_edit_id){LmEx_open_menu(this,'rename');}	lmb-icon-cus lmb-page-edit	8	2	4		\N	\N
246	nav_mylimbas	2203	2204	\N	lmb-house	9	3	1		\N	\N
274	\N	2443	2444	LmEx_send_form(1);	lmb-icon-cus lmb-page-save	1	2	4		\N	\N
222	\N	1935	1936	document.form1.ffilter_viewmode.value='1';LmEx_send_form(1);	lmb-icon-cus lmb-txt-col	20	2	4		\N	\N
223	\N	1937	1938	document.form1.ffilter_viewmode.value='2';LmEx_send_form(1);	lmb-icon-cus lmb-folder-magnify	21	2	4		\N	\N
224	\N	1940	1941	open_menu(event,this,'tzonemenu');	lmb-icon-cus lmb-cal-day	1	4	4		\N	\N
230	my_workflow	2084	2085	f_2('my_workflow');	lmb-icon-cus lmb-cog-add	0	7	4		\N	\N
40	user_w_vorlage	425	426	f_2('user_w_vorlage');	lmb-bell	1	8	4		\N	\N
268	setup_grouping_editor	2362	2363	\N	\N	0	4	2		\N	Tabellen
137	setup_user_admin	838	839	f_3('setup_user','setup_user_tree','setup_user_erg');	lmb-user-list	2	3	2		\N	Administrieren
270	gtab_lock	2429	2430	limbasDivShow(this,'','limbasDivMenuLock');	lmb-page-lock	14	1	3		\N	\N
151	setup_user_tracking	1266	1267	\N	lmb-icon-cus lmb-report-user	4	3	2		\N	Administrieren
250	setup_user_overview	2244	2245	f_3('setup_user_overview');	lmb-list-users	5	3	2		\N	Übersicht
55	setup_group_erg	455	456	f_3('setup_group_erg');	lmb-group	7	3	2		\N	Administrieren
100	setup_group_tab	497	498	f_3('setup_group_tab');	lmb-table-key	13	3	2		\N	Administrieren
291	setup_group_forms	2745	2746	f_3('setup_group_forms');	lmb-icon-cus lmb-application-form-key	14	3	2		\N	Administrieren
292	setup_group_diags	2747	2748	f_3('setup_group_diags');	lmb-chart-curve-key	15	3	2		\N	Administrieren
290	setup_group_reminder	2743	2744	f_3('setup_group_reminder');	lmb-bell-key	16	3	2		\N	Administrieren
260	setup_group_reportrechte	2277	2278	f_3('setup_group_reportrechte');	lmb-report-key	17	3	2		\N	Administrieren
156	setup_gtab_ftype	1276	1277	\N	lmb-cubes	2	4	2		\N	Tabellen
227	setup_gtab_view	2024	2025	\N	lmb-table-color	5	4	2		\N	Abfragen
107	setup_form	724	725	f_3('setup_form_select');	lmb-icon-cus lmb-form	0	6	2		\N	DOCLimbasForms
65	setup_report_select	465	466	f_3('setup_report_select');	lmb-icon-cus lmb-report-edit	0	8	2		\N	Berichte
114	setup_diag	752	753	f_3('setup_diag');	lmb-icon-cus lmb-chart-edit	0	7	2		\N	Diagramme
289	setup_reminder	2738	2739	f_3('setup_reminder');	lmb-bell	0	9	2		\N	\N
173	\N	1486	1487	newwin6();	lmb-history-alt	12	1	3		\N	\N
14	gtab_search	373	374	limbasDetailSearch(event,this,document.form1.gtabid.value,'');	lmb-page-find	3	2	3		\N	\N
288	\N	2679	2680	lmbNewwin();	lmb-application-double	0	3	3		\N	\N
10	gtab_erg	365	366	document.form1.action.value='gtab_erg';document.form1.form_id.value=document.form1.formlist_id.value;send_form('1');	lmb-list-ul-alt	1	3	3		\N	\N
286	\N	2668	2669	limbasDivShow(this,'limbasDivMenuAnsicht','limbasDivMenuFields','',1);	lmb-icon-cus lmb-select-list	7	3	3		\N	\N
276	\N	2469	2470	\N	lmb-minus-circle	10	7	3		\N	\N
296	\N	2774	2775	limbasDivShow(this,'extrasmenu','bulkmenu','',1);	\N	3	4	4		\N	\N
255	\N	2254	2255	lmb_calSearchFrame();	lmb-calendar-alt2	2	4	4		\N	\N
244	nav_summary	2199	2200	\N	lmb-monitor	1	2	1		\N	\N
20	nav_gtab	385	386	\N	lmb-table-alt	2	2	1		\N	\N
279	nav_tree	2489	2490	\N	lmb-list-ul	3	2	1		\N	\N
110	nav_form	731	732	\N	lmb-icon-cus lmb-form	5	2	1		\N	\N
245	nav_report	2201	2202	\N	lmb-icon-cus lmb-report-edit	6	2	1		\N	\N
113	nav_diag	750	751	\N	lmb-line-chart-alt	7	2	1		\N	\N
58	setup_setup	461	462	\N	lmb-cogs-alt	0	1	2		\N	DOCLimbasAdmin
43	setup_umgvar	431	432	f_3('setup_umgvar');	lmb-globe	1	1	2		\N	Umgvar
59	setup_tools	463	464	\N	lmb-wrench-alt	0	2	2		\N	DOCLimbasAdmin
180	setup_backup	1572	1573	\N	lmb-save	1	2	2		\N	Backup
182	setup_backup_cron	1577	1578	f_3('setup_backup_cron');	lmb-periodic	2	2	2		\N	Backup
183	setup_backup_man	1579	1580	f_3('setup_backup_man');	lmb-interactive	3	2	2		\N	Backup
181	setup_backup_hist	1575	1576	f_3('setup_backup_hist');	lmb-history	4	2	2		\N	Backup
184	setup_indize	1582	1583	\N	lmb-calendar	5	2	2		\N	System-Jobs
185	setup_indize_db	1584	1585	f_3('setup_indize_db');	lmb-system-job	5	2	2		\N	System-Jobs
187	setup_indize_hist	1588	1589	f_3('setup_indize_hist');	lmb-job-history	6	2	2		\N	System-Jobs
208	setup_index	1850	1851	f_3('setup_index');	lmb-chain	7	2	2		\N	Index
209	setup_jobs	1862	1863	\N	lmb-plugin	8	2	2		\N	System-Jobs
211	setup_jobs_hist	1866	1867	f_3('setup_jobs_hist');	lmb-history-alt-alt	10	2	2		\N	System-Jobs
48	setup_export	441	442	f_3('setup_export');	lmb-upload	11	2	2		\N	Export
49	setup_import	443	444	f_3('setup_import');	lmb-download	12	2	2		\N	Import
284	\N	2563	2564	LmEx_open_menu(this,'settingsmenu');	lmb-user-setting	29	2	4		\N	\N
215	setup_tabschema	1877	1878	f_3('setup_tabschema');	lmb-sitemap	17	2	2		\N	Tabellenschema
248	setup_sysarray	2221	2222	f_3('setup_sysarray');	lmb-code	18	2	2		\N	System_Arrays
50	setup_sysupdate	445	446	f_3('setup_sysupdate');	lmb-wrench	19	2	2		\N	System
283	setup_update	2527	2528	f_3('setup_update');	lmb-arrow-up	20	2	2		\N	Update
259	setup_trigger	2265	2266	f_3('setup_trigger');	lmb-database	21	2	2		\N	Trigger
285	setup_exteditor	2583	2584	f_3('setup_exteditor');	lmb-puzzle-piece	22	2	2		\N	Extension_Editor
226	setup_group_trigger	1988	1989	\N	lmb-database	6	3	2		\N	Administrieren
138	setup_group_neu	840	841	f_3('setup_user','setup_user_tree','setup_group_neu');	lmb-group-plus	9	3	2		\N	Gruppe_anlegen
76	setup_group_nutzrechte	483	484	f_3('setup_group_nutzrechte');	lmb-application-key	10	3	2		\N	Administrieren
210	setup_jobs_cron	1864	1865	f_3('setup_jobs_cron');	lmb-plugin-time	9	2	2		\N	System-Jobs
293	setup_group_workfl	2749	2750	f_3('setup_group_workfl');	lmb-icon-cus lmb-workflow-car	18	3	2		\N	\N
56	setup_tab	457	458	f_3('setup_tab');	lmb-icon-cus lmb-table-edit	1	4	2		\N	Tabellen
163	setup_verkn_editor	1301	1302	\N	lmb-icon-cus lmb-rel-edit	4	4	2		\N	Verknuepfungen
11	gtab_del	367	368	userecord('delete');	lmb-icon-cus lmb-page-delete-fancy	3	1	3		\N	\N
1	gtab_neu	349	350	create_new();	lmb-icon-cus lmb-page-new	4	1	3		\N	\N
157	\N	1281	1282	userecord('link');	lmb-icon-cus lmb-rel-add	6	1	3		\N	\N
9	\N	363	364	limbasDivShow(this,'','limbasDivMenuInfo');	lmb-info-circle-alt2	1	1	3		\N	\N
21	nav_user	387	388	\N	lmb-user	3	3	1		\N	\N
17	nav_admin	379	380	\N	lmb-cog-key	4	3	1		\N	\N
207	nav_info	1828	1829	f_3('nav_info');infos();	lmb-info-circle-alt2	5	3	1		\N	\N
18	nav_help	381	382	\N	lmb-help	6	3	1		\N	\N
158	\N	1283	1284	userecord('unlink');	lmb-icon-cus lmb-rel-del	7	1	3		\N	\N
164	gtab_del	1305	1306	userecord('hide');	lmb-page-key	9	1	3		\N	\N
166	gtab_del	1309	1310	userecord('unhide');	lmb-page-key-green	10	1	3		\N	\N
23	\N	391	392	divclose();print();	lmb-print	11	1	3		\N	\N
147	history	1232	1233	\N	lmb-history-alt	13	1	3		\N	\N
228	lwf_mytask	2038	2039	f_2('lwf_mytask');	lmb-icon-cus lmb-cog-edit	0	7	4		\N	\N
3	gtab_change	351	352	view_change();	lmb-icon-cus lmb-page-edit	0	2	3		\N	\N
6	gtab_deterg	357	358	view_detail();	lmb-detail	1	2	3		\N	\N
4	gtab_change_col	353	354	\N	lmb-icon-cus lmb-table-edit	2	2	3		\N	\N
28	\N	401	402	document.form1.filter_reset.value=1;send_form(1);	lmb-undo	5	2	3		\N	\N
8	add_select	361	362	\N	lmb-icon-cus lmb-txt-ol-add	6	2	3		\N	\N
236	\N	2136	2137	aktivateRows(1);divclose();	lmb-icon-cus lmb-select-all	9	2	3		\N	\N
287	gtab_replace	2670	2671	limbasCollectiveReplace(event,this);	lmb-icon-cus lmb-table-edit	10	2	3		\N	\N
160	\N	1288	1289	td_resize();	lmb-arrows-h	2	3	3		\N	\N
159	\N	1286	1287	limbasDivShow(this,'limbasDivMenuAnsicht','limbasDivMenuRahmen');	lmb-icon-cus lmb-center-shape	3	3	3		\N	\N
193	gtab_file	1621	1622	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuDateien');	lmb-icon-cus lmb-folder-table	5	3	3		\N	\N
161	\N	1290	1291	document.form1.filter_alter.value='change';send_form(1);	lmb-icon-cus lmb-list-edit	6	3	3		\N	\N
165	\N	1307	1308	document.form1.filter_unhide.value=1;send_form(1);	lmb-icon-cus lmb-view-archived	7	3	3		\N	\N
233	\N	2125	2126	document.form1.filter_hidelocked.value=1;send_form(1);	lmb-icon-cus lmb-view-locked	8	3	3		\N	\N
273	\N	2441	2442	document.form1.filter_locked.value=1;send_form(1);	lmb-icon-cus lmb-hide-locked	8	3	3		\N	\N
237	\N	2140	2141	document.form1.filter_version.value='1';send_form(1);	lmb-view-versioned	9	3	3		\N	\N
243	\N	2180	2181	if(document.form1.verkn_showonly.value){document.form1.verkn_showonly.value='';}else{document.form1.verkn_showonly.value=1;};send_form(1);	lmb-icon-cus lmb-rel-view	10	3	3		\N	\N
131	report	826	827	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuBericht');	lmb-report	1	4	3		\N	\N
175	\N	1500	1501	\N	lmb-icon-cus lmb-report-magnify	2	4	3		\N	\N
176	\N	1502	1503	\N	lmb-icon-cus lmb-report-save	3	4	3		\N	\N
174	\N	1498	1499	report_archiv();	lmb-icon-cus lmb-report-go	4	4	3		\N	\N
132	\N	828	829	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuFormulare');	lmb-icon-cus lmb-form	0	5	3		\N	\N
232	diag_erg	2117	2118	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuDiagramme');	lmb-line-chart-alt	0	6	3		\N	\N
133	\N	830	831	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuLink');	lmb-icon-cus lmb-door-out	2	7	3		\N	\N
7	gtab_exp	359	360	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuExport')	lmb-file-excel	3	7	3		\N	\N
109	gtab_wvorl	729	730	limbasDivShowReminder(event,this);	lmb-bell	4	7	3		\N	\N
238	\N	2160	2161	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuWorkflow')	lmb-icon-cus lmb-workflow-car	4	7	3		\N	\N
188	snapshot	1602	1603	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuSnapshot');	lmb-camera-plus	5	7	3		\N	\N
225	global_snapshot	1965	1966	\N	lmb-icon-cus lmb-cam-link	6	7	3		\N	\N
242	\N	2170	2171	limbasDivShow(this,'limbasDivMenuExtras','limbasDivMenuVersion');	lmb-clock	7	7	3		\N	\N
266	\N	2338	2339	limbasGetGtabRules(jsvar['gtabid'],this)	lmb-group-gear	8	7	3		\N	\N
267	\N	2341	2342	document.form1.filter_userrules.value='1';send_form(1);	lmb-group-gear	9	7	3		\N	\N
280	setup_tabletree	2493	2494	f_3('setup_tabletree');	lmb-tree	0	4	2		\N	Tabellen
247	\N	2217	2218	LmEx_favorite_file();	lmb-fav	0	2	4		\N	\N
262	explorer_ocr	2579	2580	LmEx_open_menu(this,'ocrmenu');	lmb-icon-cus lmb-style-go	0	2	4		\N	\N
203	explorer_convert	1759	1760	LmEx_open_menu(this,'previewmenu');	lmb-exchange	10	2	4		\N	\N
190	explorer_download	1612	1613	LmEx_open_menu(this,'downloadmenu');	lmb-download	12	2	4		\N	\N
241	\N	2168	2169	LmEx_open_menu(this,'searchmenu');	lmb-search	14	2	4		\N	\N
297	explorer_import	2797	2798	LmEx_open_menu(this,'importmenu');	lmb-download	30	2	4		\N	\N
298	setup_mimetypes	2905	2906	f_3('setup_mimetypes');	lmb-mimetype	0	2	2		\N	\N
299	setup_revisioner	2907	2908	f_3('setup_revisioner');	lmb-revisioner	23	2	2		\N	\N
57	setup_error_msg	459	460	f_3('setup_error_msg');	lmb-exclamation-triangle	24	2	2		\N	Fehlerreport
102	setup_tabtools	501	502	f_3('setup_tabtools');	lmb-terminal	14	2	2		\N	T-Tabellen
152	setup_grusrref	1268	1269	\N	lmb-icon-cus lmb-table-refresh	15	2	2		\N	System
300	setup_datasync	2914	2915	f_3('setup_datasync');	lmb-arrows-h	13	2	2		\N	\N
153	setup_linkref	1270	1271	\N	lmb-application-refresh	16	2	2		\N	System
191	\N	1615	1616	LmEx_create_cachelist(event);	lmb-paste	5	2	4		\N	\N
128	\N	815	816	LmEx_showUploadField();LmEx_divclose();	lmb-file-upload	12	2	4		\N	\N
304	print	2937	2938	\N	lmb-print	\N	7	3		\N	\N
140	\N	847	848	limbasDivShow(this,'','limbasDivMenuFarb');	lmb-table-color	4	3	3		\N	\N
214	nav_refresh	1875	1876	srefresh(this);	lmb-refresh	8	3	1		\N	\N
117	explorer_search	773	774	limbasDetailSearch(event,this,jsvar['gtabid'],null,null,null,'explorer_search');	lmb-search	14	2	4		\N	\N
177	setup_ftype	1514	1515	f_3('setup_ftype');	lmb-cubes	3	1	2		\N	Feldtypen
45	setup_links	435	436	f_3('setup_links');	lmb-menu	4	1	2		\N	Menupunkte
305	setup_menueditor	2952	2953	f_3('setup_menueditor');	lmb-indent	5	1	2		\N	\N
46	setup_color_schema	437	438	f_3('setup_color_schema');	lmb-color-swatch	6	1	2		\N	Schema
47	setup_color	439	440	f_3('setup_color');	lmb-picture	7	1	2		\N	Farben
108	setup_language	726	727	f_3('setup_language');	lmb-language	8	1	2		\N	Sprache
258	setup_language_local	2263	2264	\N	lmb-language	9	1	2		\N	Sprache
216	setup_fonts	1888	1889	f_3('setup_fonts');	lmb-font	10	1	2		\N	Schriftarten
294	setup_snap	2768	2769	f_3('setup_snap');	lmb-camera	11	1	2		\N	\N
295	setup_fieldselect	2771	2772	f_3('setup_fieldselect');	lmb-list-ul	12	1	2		\N	\N
302	setup_external_storage	2933	2934	f_3('setup_external_storage')	lmb-database	13	1	2		\N	\N
306	setup_custvar	2958	2959	f_3('setup_custvar');	lmb-globe	2	1	2		\N	Umgvar
303	setup_printers	2935	2936	f_3('setup_printers')	lmb-print	15	1	2		\N	\N
307	setup_multitenant	2965	2966	f_3('setup_multitenant');	lmb-user-circle-o	14	1	2		\N	\N
301	nav_favorites	2931	2932	\N	lmb-fav-filled	9	2	1		\N	\N
310	setup_currency	2977	2978	f_3('setup_currency');	lmb-money	16	1	2		\N	\N
308	nav_multitenant	2967	2968	selectMultitenant(this);	lmb-user-circle-o	2	3	1		\N	\N
213	user_logout	1873	1874	logout();	lmb-sign-out	7	3	1		\N	\N
311	setup_php_editor	2989	2990	f_3('setup_php_editor');	lmb-terminal	0	2	2		\N	\N
309	\N	2971	2972	document.form1.filter_multitenant.value=1;send_form(1);	lmb-user-circle-o	12	3	3		\N	\N
261	\N	2291	2292	document.form1.filter_nosverkn.value='1';send_form(1);	\N	14	3	3		\N	\N
275	\N	2465	2466	document.form1.filter_sum.value='1';send_form(1);	\N	15	3	3		\N	\N
281	\N	2495	2496	document.form1.filter_groupheader.value=1;send_form(1);	\N	17	3	3		\N	\N
282	\N	2499	2500	document.form1.filter_save.value='1';send_form(1);	\N	18	3	3		\N	\N
\.


--
-- Data for Name: lmb_action_depend; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_action_depend (id, action, link_name, beschreibung, link_url, icon_url, sort, subgroup, maingroup, extension, target, help_url) FROM stdin;
\.


--
-- Data for Name: lmb_attribute_d; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_attribute_d (id, erstuser, w_id, tab_id, field_id, dat_id, value_num, value_string, value_date) FROM stdin;
\.


--
-- Data for Name: lmb_attribute_p; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_attribute_p (id, erstdatum, erstuser, name, snum, tagmode, multimode) FROM stdin;
\.


--
-- Data for Name: lmb_attribute_w; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_attribute_w (id, erstuser, pool, wert, keywords, def, hide, sort, type, level, haslevel, color, attrpool, hidetag, mandatory) FROM stdin;
\.


--
-- Data for Name: lmb_auth_token; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_auth_token (token, user_id, lifespan, expirestamp) FROM stdin;
\.


--
-- Data for Name: lmb_chart_list; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_chart_list (id, erstdatum, erstuser, diag_id, diag_name, diag_desc, template, tab_id, noheader, diag_type, diag_width, diag_height, text_x, text_y, font_size, padding_left, padding_top, padding_right, padding_bottom, legend_x, legend_y, legend_mode, pie_write_values, pie_radius, transposed) FROM stdin;
1	2016-02-29 16:23:26	1	\N	Art der Positionen	\N	\N	10	\N	Pie-Chart	440	300	\N	\N	9	\N	\N	0	0	0	0	\N	value	\N	\N
3	2018-04-03 19:03:41	1	\N	Umsatz	\N	\N	12	\N	Line-Graph	800	600	\N	Umsatz in EUR	12	\N	\N	\N	\N	\N	\N	none	\N	0	\N
4	2018-04-05 12:30:20	1	\N	Versandart	\N	\N	13	\N	Pie-Chart	800	600	\N	\N	12	\N	\N	0	0	0	0	\N	percent	\N	\N
2	2016-02-29 16:28:08	1	\N	Anz Betr Positionen	\N	\N	10	\N	Bar-Chart	800	600	Produkt-Typ	Einnahmen gesamt (Eur)	12	\N	\N	\N	\N	\N	\N	none	\N	0	\N
\.


--
-- Data for Name: lmb_charts; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_charts (id, chart_id, field_id, axis, function, color) FROM stdin;
\.


--
-- Data for Name: lmb_code_favorites; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_code_favorites (id, name, statement, type) FROM stdin;
\.


--
-- Data for Name: lmb_colorschemes; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_colorschemes (id, name, web1, web2, web3, web4, web5, web6, web7, web8, norm, web9, web10, web11, web12, web13, web14) FROM stdin;
1	basic (skalar)	#D6D6CE	#BBBBBB	#C0C0C0	#BBBBBB	#C0C0C0	#C0C0C0	#FBE16B	#EEEEEE	\N	#EEEEEE	#FBE16B	#E6E6E6	#909090	#FFFFFF	#F5F5F5
2	basic (comet)	#d0d0d0	#444444	#C0C0C0	#BBBBBB	#EAF3EE	#C0C0C0	#97C5AB	#EEEEEE	t	#F5F5F5	#EAF3EE	#FDFEFD	#909090	#FFFFFF	#F5F5F5
3	dark (comet)	gray	#E3E3E3	gray	gray	gray	red	#74ba6a	#5a5a5a	\N	#545454	#383838	gray	#E3E3E3	#444444	#222222
\.


--
-- Data for Name: lmb_conf_fields; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_conf_fields (id, field_id, tab_id, tab_group, sort, data_type, field_type, field_name, form_name, fieldkey, need, artleiste, genlink, argument, verkngroup, isunique, argument_edit, refint, verkntabid, md5tab, verknfieldid, select_sort, groupable, indize, nformat, currency, wysiwyg, verknsearch, dynsearch, select_pool, select_cut, indexed, inherit_tab, inherit_field, ext_type, verkntabletype, argument_typ, mainfield, beschreibung, spelling, lmtrigger, defaultvalue, hasrecverkn, quicksearch, relext, viewrule, editrule, potency, inherit_search, inherit_eval, inherit_filter, inherit_group, verknview, verknfind, ajaxpost, field_size, collreplace, datetime, aggregate, scale, verknparams, listing_cut, listing_viewmode, verkntree, multilang, popupdefault, fullsearch) FROM stdin;
1	1	1	1	8	100	100	LMSECTION	lmsection	t	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10003	10004	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
2	2	1	1	9	16	5	ERSTGROUP	erstgroup	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10005	10006	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
3	3	1	1	4	36	15	ERSTDATUM	erstdatum	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10007	10008	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
4	4	1	1	5	34	14	ERSTUSER	erstuser	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10009	10010	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
5	5	1	1	10	16	5	LEVEL	level	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10011	10012	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
6	6	1	1	11	16	5	TYP	typ	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10013	10014	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
7	7	1	1	8	21	5	SORT	sort	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10015	10016	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	8	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
8	8	1	1	12	16	5	DATID	datid	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10017	10018	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
9	9	1	1	13	16	5	TABID	tabid	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10019	10020	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
10	10	1	1	14	16	5	FIELDID	fieldid	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10021	10022	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
11	11	1	1	15	1	1	NAME	name	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10023	10024	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	128	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
12	12	1	1	16	1	1	SECNAME	secname	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10025	10026	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	20	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
13	13	1	1	3	45	18	MIMETYPE	mimetype	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10027	10028	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
14	14	1	1	2	44	5	SIZE	size	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10029	10030	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
15	15	1	1	9	20	10	CHECKED	checked	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10031	10032	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
16	16	1	1	10	20	10	PERM	perm	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10033	10034	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
17	17	1	1	11	20	10	LMLOCK	lmlock	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10035	10036	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
18	18	1	1	17	16	5	LOCKUSER	lockuser	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10037	10038	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
19	19	1	1	18	16	5	CHECKUSER	checkuser	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10039	10040	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
20	20	1	1	19	16	5	PERMUSER	permuser	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10041	10042	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
21	21	1	1	20	11	2	PERMDATE	permdate	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10043	10044	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N	\N	\N	f	\N	f
22	22	1	1	21	11	2	CHECKDATE	checkdate	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10045	10046	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N	\N	\N	f	\N	f
23	23	1	1	22	11	2	LOCKDATE	lockdate	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10047	10048	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N	\N	\N	f	\N	f
24	24	1	1	23	16	5	VID	vid	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10049	10050	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
25	25	1	1	24	20	10	VACT	vact	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10051	10052	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
26	26	1	1	25	1	1	VDESC	vdesc	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10053	10054	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	128	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
27	27	1	1	26	16	5	VPID	vpid	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10055	10056	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
28	28	1	1	27	20	10	THUMB_OK	thumb_ok	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10057	10058	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
29	29	1	1	28	20	10	META	meta	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10059	10060	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
30	30	1	1	29	20	10	INFO	info	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10061	10062	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
31	31	1	1	30	48	20	CONTENT	content	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10063	10064	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
32	32	1	1	31	1	1	MD5	md5	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10065	10066	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	50	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
33	33	1	1	32	16	5	STORAGE_ID	storage_id	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10067	10068	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
34	34	1	1	33	1	1	DOWNLOAD_LINK	download_link	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10069	10070	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	255	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
35	1	2	1	12	100	100	LMSECTION	lmsection	t	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10072	10073	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
36	2	2	1	20	100	100	LMSECTION	lmsection	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10074	10075	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
37	3	2	1	28	100	100	LMSECTION	lmsection	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10076	10077	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
38	4	2	1	29	100	100	LMSECTION	lmsection	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10078	10079	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
39	5	2	1	32	100	100	LMSECTION	lmsection	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10080	10081	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
40	6	2	1	36	100	100	LMSECTION	lmsection	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10082	10083	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
41	7	2	1	43	100	100	LMSECTION	lmsection	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10084	10085	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
42	8	2	1	17	1	1	TYPE	type	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10086	10087	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	20	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
43	9	2	1	27	1	1	FTYPE	ftype	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10088	10089	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	20	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
44	10	2	1	23	1	1	NAME2	name2	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10090	10091	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	250	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
45	11	2	1	12	1	1	FORMAT	format	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10092	10093	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	128	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
46	12	2	1	13	1	1	GEOMETRY	geometry	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10094	10095	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	20	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
47	13	2	1	14	1	1	RESOLUTION	resolution	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10096	10097	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
48	14	2	1	15	1	1	DEPTH	depth	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10098	10099	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
49	15	2	1	16	16	5	COLORS	colors	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10100	10101	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
50	16	2	1	22	1	1	CREATOR	creator	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10102	10103	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
51	17	2	1	28	10	3	SUBJECT	subject	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10104	10105	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	399	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
52	18	2	1	31	1	1	CLASSIFICATION	classification	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10106	10107	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	128	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
53	19	2	1	21	10	3	DESCRIPTION	description	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10108	10109	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	399	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
54	20	2	1	32	1	1	PUBLISHER	publisher	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10110	10111	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
55	21	2	1	35	1	1	CONTRIBUTORS	contributors	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10112	10113	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	250	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
56	22	2	1	42	1	1	IDENTIFIER	identifier	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10114	10115	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	50	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
57	23	2	1	36	1	1	SOURCE	source	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10116	10117	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
58	24	2	1	26	1	1	LANGUAGE	language	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10118	10119	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
59	25	2	1	24	1	1	INSTRUCTIONS	instructions	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10120	10121	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	50	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
60	26	2	1	25	16	5	URGENCY	urgency	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10122	10123	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
61	27	2	1	29	1	1	CATEGORY	category	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10124	10125	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	8	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
62	28	2	1	33	1	1	TITLE	title	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10126	10127	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
63	29	2	1	34	1	1	CREDIT	credit	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10128	10129	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
64	30	2	1	38	1	1	CITY	city	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10130	10131	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
65	31	2	1	39	1	1	STATE	state	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10132	10133	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
66	32	2	1	40	1	1	COUNTRY	country	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10134	10135	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	50	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
67	33	2	1	41	1	1	TRANSMISSION	transmission	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10136	10137	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
68	34	2	1	20	1	1	ORIGINNAME	originname	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10138	10139	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	50	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
69	35	2	1	43	1	1	COPYRIGHT	copyright	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10140	10141	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	128	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
70	36	2	1	37	1	1	CREATEDATE	createdate	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10142	10143	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	30	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
71	37	2	1	30	10	3	SUBCATEGORY	subcategory	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10144	10145	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	399	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
72	1	3	1	1	22	5	ID	id	t	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10147	10148	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
73	2	3	1	2	36	15	ERSTDATUM	erstdatum	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10149	10150	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
74	3	3	1	3	34	14	ERSTUSER	erstuser	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10151	10152	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
75	4	3	1	4	16	5	ERSTGROUP	erstgroup	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10153	10154	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
76	5	3	1	5	37	15	EDITDATUM	editdatum	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10155	10156	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
77	6	3	1	6	35	14	EDITUSER	edituser	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10157	10158	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
78	7	3	1	7	1	1	CKEY	ckey	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10159	10160	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	50	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
79	8	3	1	8	1	1	CVALUE	cvalue	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10161	10162	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	200	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
80	9	3	1	9	1	1	DESCRIPTION	description	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10163	10164	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	240	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
81	10	3	1	10	20	10	OVERRIDABLE	overridable	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10165	10166	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
82	11	3	1	11	20	10	ACTIVE	active	f	f	f	\N		\N	f	f	f	\N		\N		f	f		\N	f	\N	f	0	\N	f	0	0		1	0	f	10167	10168	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	f	\N	f
\.


--
-- Data for Name: lmb_conf_groups; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_conf_groups (id, sort, beschreibung, name, level, icon) FROM stdin;
1	1	10001	10000	0	\N
\.


--
-- Data for Name: lmb_conf_tables; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_conf_tables (id, tab_id, tab_group, sort, tabelle, lockable, markcolor, groupable, verkn, linecolor, logging, typ, versioning, ver_desc, beschreibung, userrules, lmtrigger, indicator, ajaxpost, numrowcalc, reserveid, event, lastmodified, keyfield, params1, params2, datasync, multitenant) FROM stdin;
1	1	1	1	ldms_files	f		0	1	f	f	3	0	f	10002	f	\N	\N	f	\N	\N	\N	\N	ID	\N	\N	\N	\N
2	2	1	2	ldms_meta	f		0	1	f	f	3	0	f	10071	f	\N	\N	f	\N	\N	\N	\N	ID	\N	\N	\N	\N
3	3	1	3	lmb_custvar_depend	f		0	3	f	f	3	0	f	10146	f	\N	\N	f	\N	\N	\N	\N	ID	\N	\N	\N	\N
\.


--
-- Data for Name: lmb_conf_viewfields; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_conf_viewfields (id, viewid, tablename, qfield, qfilter, qorder, qalias, sort, qshow, qfunc) FROM stdin;
\.


--
-- Data for Name: lmb_conf_views; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_conf_views (id, viewdef, ispublic, hasid, relation, usesystabs, viewtype, isvalid, setmanually) FROM stdin;
\.


--
-- Data for Name: lmb_crontab; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_crontab (id, kategory, start, val, erstdatum, activ, description, alive, job_user) FROM stdin;
\.


--
-- Data for Name: lmb_currency; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_currency (id, currency, code, symbol) FROM stdin;
27	Swiss Franc	CHF	\N
150	US Dollar	USD	$
46	Euro	EUR	€
\.


--
-- Data for Name: lmb_currency_rate; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_currency_rate (id, curfrom, curto, rate, rday) FROM stdin;
\.


--
-- Data for Name: lmb_custmenu; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_custmenu (id, parent, name, title, linkid, typ, url, icon, bg, sort) FROM stdin;
2	1	11392	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=easy'	\N	\N	1
3	1	11393	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=relation1'	\N	\N	2
4	1	11394	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=relation2'	\N	\N	3
5	1	11395	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=relation3'	\N	\N	4
6	1	11396	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=criteria&actvar=1'	\N	\N	5
7	1	11397	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=criteria&actvar=2'	\N	\N	6
8	1	11398	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=criteria&actvar=3'	\N	\N	7
9	1	11399	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=criteria&actvar=4'	\N	\N	8
10	1	11400	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=create'	\N	\N	9
11	1	11401	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=delete'	\N	\N	10
12	1	11402	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=reload'	\N	\N	11
13	1	11403	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=mandatory'	\N	\N	12
14	1	11404	\N	1000	1	parent.main.document.location.href='main.php?action=lmbObject&actid=transaction'	\N	\N	13
15	0	11405	\N	1000	0	\N	\N	\N	2
16	15	11406	\N	1000	1	parent.main.document.location.href='public/data_access.php'	\N	\N	1
17	15	11407	\N	1000	1	parent.main.document.location.href='public/filesearch.php'	\N	\N	2
19	18	1002	\N	1000	7	\N	\N	\N	1
1	0	11391	\N	1000	0	\N	\N	\N	1
18	0	11436	\N	1000	0	\N	\N	\N	1
\.


--
-- Data for Name: lmb_custmenu_list; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_custmenu_list (id, name, tabid, fieldid, type, inactive, disabled) FROM stdin;
\.


--
-- Data for Name: lmb_custvar; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_custvar (id, ckey, cvalue, description, overridable, active) FROM stdin;
\.


--
-- Data for Name: lmb_custvar_depend; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_custvar_depend (id, erstdatum, editdatum, edituser, erstuser, inuse_time, inuse_user, del, erstgroup, ckey, cvalue, description, overridable, active) FROM stdin;
\.


--
-- Data for Name: lmb_dbpatch; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_dbpatch (id, status, revision, description, major, version) FROM stdin;
1	t	1	\N	1	10
3	t	3	\N	1	10
4	t	4	\N	1	10
5	t	5	\N	1	10
6	t	6	\N	1	10
7	t	7	\N	1	10
8	t	8	\N	1	10
9	t	9	\N	1	10
10	t	10	\N	1	10
11	t	11	\N	1	10
12	t	12	\N	1	10
14	t	14	\N	1	10
15	t	15	\N	1	10
16	t	16	\N	1	10
17	t	17	\N	1	10
18	t	18	\N	1	10
19	t	19	\N	1	10
20	t	20	\N	1	10
21	t	21	\N	1	10
22	t	22	\N	1	10
23	t	23	\N	1	10
25	t	25	\N	1	10
26	t	26	\N	1	10
27	f	27	\N	1	10
28	t	28	\N	1	10
29	t	29	\N	1	10
30	t	30	\N	1	10
31	t	31	\N	1	10
32	t	32	\N	1	10
33	t	33	\N	1	10
34	t	34	\N	1	10
37	t	2	prepare OCR support	1	11
38	t	3	prepare OCR support	1	11
39	t	4	prepare OCR support	1	11
40	t	5	prepare OCR support	1	11
41	t	6	hide system-fields from table FILES	1	11
42	t	7	Update table 'BERICHTE'	1	11
43	t	8	Files favorite extends folders	1	11
44	t	9	extends language-modul	1	11
45	t	10	extends language-modul	1	11
46	t	11	class definition for formulars	1	11
48	t	13	colorschema extension	1	11
49	t	1	userrules for single datasets	1	12
50	t	2	userrules for single datasets	1	12
51	t	3	userrules for single datasets	1	12
52	t	4	report extension order by element	1	12
53	t	5	userspezifdbpatchic IP handling	1	12
54	t	6	right for view old versions only	1	12
56	t	9	relation extension	1	12
57	t	10	relation extension	1	12
58	t	11	report background	1	12
59	t	12	report background	1	12
60	t	13	formular extension	1	12
61	t	14	limbas trigger	1	12
62	t	15	limbas trigger	1	12
63	t	16	limbas trigger	1	12
64	t	17	limbas trigger	1	12
65	t	18	limbas trigger	1	12
66	t	19	limbas trigger	1	12
67	t	20	limbas trigger	1	12
68	t	21	limbas trigger	1	12
69	t	22	limbas trigger	1	12
70	t	23	user privilege	1	12
71	t	24	user privilege	1	12
72	t	25	workflow	1	12
73	t	26	workflow	1	12
74	t	27	workflow	1	12
75	t	28	workflow	1	12
76	t	29	workflow	1	12
77	t	30	workflow	1	12
79	t	32	rename table AMPEL	1	12
80	t	33	rename table ATTRIBUTE_D	1	12
81	t	34	rename table ATTRIBUTE_P	1	12
82	t	35	rename table ATTRIBUTE_W	1	12
83	t	36	rename table BACKUP_HIST	1	12
84	t	37	rename table BERICHTE	1	12
86	t	39	rename table CONF_SPALTEN	1	12
87	t	40	rename table CONF_TABELLEN	1	12
88	t	41	rename table CONF_TABGRUPPEN	1	12
89	t	42	rename table CRONTAB	1	12
90	t	43	rename table CURRENCY	1	12
91	t	45	rename table DB_TRIGGER	1	12
92	t	46	rename table DIAGRAMME	1	12
93	t	47	rename table ERROR_MSG	1	12
94	t	48	rename table FARBSCHEMA	1	12
96	t	50	rename table FILES	1	12
97	t	51	rename table FILES_META	1	12
98	t	52	rename table FILESTRUCTURE	1	12
99	t	53	rename table FILES_FAVORITE	1	12
100	t	54	rename table FONTS	1	12
101	t	55	rename table FORMULAR	1	12
103	t	57	rename table GROUPDB	1	12
104	t	58	rename table GROUP_LINK	1	12
105	t	59	rename table HISTORY_ACTION	1	12
106	t	60	rename table HISTORY_UPDATE	1	12
107	t	61	rename table INDIZE_D	1	12
108	t	62	rename table INDIZE_DS	1	12
109	t	63	rename table INDIZE_F	1	12
111	t	65	rename table INDIZE_HIST	1	12
112	t	66	rename table INDIZE_W	1	12
113	t	67	rename table LANGUAGE	1	12
114	t	68	rename table LANGUAGE_LOCAL	1	12
115	t	70	rename table LINKS	1	12
116	t	71	rename table LINKS_LOCAL	1	12
117	t	72	rename table MIMETYPES	1	12
119	t	74	rename table RECHTE_FILES	1	12
120	t	75	rename table RECHTE_REPFORM	1	12
121	t	76	rename table RECHTE_SPALTEN	1	12
122	t	77	rename table RECHTE_TABELLEN	1	12
123	t	78	rename table SELECT_D	1	12
124	t	79	rename table SELECT_P	1	12
126	t	81	rename table SESSION	1	12
127	t	82	rename table SNAPSHOT	1	12
128	t	83	rename table SNAPSHOT_ARCHIVE	1	12
129	t	84	rename table SNAPSHOT_SHARED	1	12
130	t	85	rename table STAT_USER	1	12
131	t	86	rename table TABPATTERN	1	12
133	t	88	rename table UMGVAR	1	12
134	t	89	rename table USERDB	1	12
135	t	90	rename table xx	1	12
136	t	91	rename table USRGRP_SHORTLIST	1	12
137	t	92	rename table ZUSATZ_GROUP_DATEN	1	12
139	t	94	rename system table names for FILES	1	12
140	t	100	rename system table names for FILES	1	12
141	t	101	rename system table names for USERDB	1	12
142	t	102	single Element-ID for forms	1	12
144	t	104	single Element-ID for forms	1	12
145	t	105	sub groups	1	12
146	t	106	userdb	1	12
147	t	107	userdb	1	12
148	t	108	userdb	1	12
149	t	109	rename desc	1	12
150	t	110	rename desc	1	12
151	t	111	rename desc	1	12
152	t	112	rename desc	1	12
154	t	114	rename desc	1	12
155	t	115	DEFAULTVALUE fields	1	12
156	f	1	defaultvalue	2	0
157	f	2	trigger	2	0
158	f	3	trigger	2	0
159	t	4	trigger	2	0
161	t	6	quicksearch	2	0
162	t	7	table tree	2	0
163	t	8	verknextensions	2	0
165	t	10	umgvar	2	0
166	t	11	mailsystem	2	0
167	t	12	mailsystem	2	0
168	t	13	fieldtype subselect	2	0
169	t	14	lock text	2	0
170	t	15	viewrule	2	0
171	t	16	fieldtype subselect	2	0
172	t	17	fieldtype subselect	2	0
174	t	19	fieldtype subselect	2	0
175	t	20	report list	2	0
176	t	21	conf fields	2	0
177	t	22	report form hidden	2	0
179	t	24	resize field tabelle	2	0
180	t	25	resize field time_zone	2	0
181	t	26	reset field time_zone	2	0
182	t	27	relation order	2	0
183	t	28	view definition	2	0
184	t	29	specific rules	2	0
185	t	30	umgvar settings	2	0
186	t	31	help link	2	0
187	t	32	help link local	2	0
188	t	33	help link umgvar	2	0
189	t	34	drop fileview from userdb	2	0
191	t	36	drop gzip from userdb	2	0
192	t	37	update umgvar	2	0
193	t	38	formular subelements	2	0
194	t	39	formular subelements	2	0
195	t	40	formular subelements	2	0
196	t	41	ooffice reports	2	0
197	t	42	ooffice reports	2	0
198	t	43	disable use_jsgraphics	2	0
199	t	44	ooffice reports	2	0
200	f	45	user defaults	2	0
202	t	2	new indicator functionality	2	1
203	t	3	new indicator functionality	2	1
204	t	4	new indicator functionality	2	1
205	t	5	new indicator functionality	2	1
206	t	6	global editrules	2	1
207	t	7	number potency	2	1
209	t	9	update umgvar	2	1
210	t	10	extend inherit function	2	1
211	t	11	extend inherit function	2	1
212	t	12	extend inherit function	2	1
213	t	13	extend inherit function	2	1
214	t	14	new report mode	2	1
215	t	15	update umgvar	2	1
216	t	16	update umgvar	2	1
218	t	1	view	2	2
219	t	2	view	2	2
220	t	3	view	2	2
221	t	4	view	2	2
222	t	5	view	2	2
224	t	7	view	2	2
225	t	8	report	2	2
226	t	9	relation view	2	2
228	t	11	dynamic save	2	2
229	t	12	reminder	2	2
230	t	13	reminder	2	2
231	t	14	reminder	2	2
232	t	15	reminder	2	2
233	t	16	trigger	2	2
234	t	17	update umgvar	2	2
235	t	18	formular	2	2
236	t	19	formular	2	2
237	t	20	formular	2	2
239	t	22	update e_setting	2	2
240	t	23	update e_setting	2	2
241	t	24	drop trigger procedure	2	2
242	t	25	update trigger procedure	2	2
243	t	26	update umgvar	2	2
244	t	27	update umgvar	2	2
246	t	1	mssql	2	3
247	t	2	mssql	2	3
248	t	3	mssql	2	3
249	t	4	mssql	2	3
251	t	6	mssql	2	3
252	t	7	mssql	2	3
253	t	8	mssql	2	3
254	t	9	mssql	2	3
255	t	10	mssql	2	3
256	t	11	mssql	2	3
258	t	13	mssql	2	3
259	t	14	mssql	2	3
261	t	16	usable field size	2	3
262	t	17	usable field size	2	3
263	t	18	usable field size	2	3
264	t	19	usable field size	2	3
265	t	20	view extensions	2	3
266	t	21	update umgvar	2	3
267	t	22	drop deprecated snapshot table	2	3
268	t	23	extend snapshot	2	3
269	t	24	extend snapshot	2	3
270	t	25	save frame settings	2	3
272	t	27	extend form parameter	2	3
273	t	28	extend collective replace	2	3
274	t	29	numrow calculation	2	3
275	t	30	numrow calculation	2	3
276	t	31	report tables	2	3
278	t	33	new KEY-ID for report table	2	3
279	t	34	new KEY-ID for report table	2	3
280	t	35	sequenz tables	2	3
2	t	2	\N	1	10
13	t	13	\N	1	10
24	t	24	\N	1	10
35	t	35	\N	1	10
36	t	1	Bugfix in Table Files for Versioning	1	11
47	t	12	class definition for formulars	1	11
55	t	7	add new systemfiled 'CONTENT' in Table FILES	1	12
78	t	31	formular relation	1	12
85	t	38	rename table BERICHTE_LISTE	1	12
95	t	49	rename table FIELD_TYPE	1	12
102	t	56	rename table FORMULAR_LISTE	1	12
110	t	64	rename table INDIZE_FS	1	12
118	t	73	rename table RECHTE_DATENSATZ	1	12
125	t	80	rename table SELECT_W	1	12
132	t	87	rename table TABROWSIZE	1	12
138	t	93	rename table ZUSATZ_USER_DATEN	1	12
143	t	103	single Element-ID for forms	1	12
153	t	113	rename desc	1	12
160	t	5	table tree	2	0
164	t	9	session extension for userdb	2	0
173	t	18	fieldtype subselect	2	0
178	t	23	hierarchic dataset userrules	2	0
190	t	35	drop multiframe from userdb	2	0
201	t	1	currency not longer needed	2	1
208	t	8	update umgvar	2	1
282	t	1	update umgvar	2	4
284	t	3	update umgvar	2	4
285	t	4	update umgvar	2	4
286	t	5	update umgvar	2	4
287	t	6	update umgvar	2	4
289	t	8	update umgvar	2	4
290	t	9	update umgvar	2	4
291	t	10	update umgvar	2	4
292	t	11	update umgvar	2	4
294	t	13	update umgvar	2	4
295	t	14	update umgvar	2	4
296	t	15	update umgvar	2	4
297	t	16	update umgvar	2	4
299	t	18	update umgvar	2	4
300	t	19	datetime extension for seconds	2	4
301	t	20	reserve ID	2	4
302	t	21	resize graph template	2	4
303	t	22	update umgvar	2	4
305	t	24	tabletree rebuild	2	4
306	t	25	tabletree rebuild	2	4
307	t	26	tabletree rebuild	2	4
308	t	27	tabletree rebuild	2	4
309	t	28	tabletree rebuild	2	4
310	t	29	tabletree rebuild	2	4
311	t	30	tabletree rebuild	2	4
312	t	31	tabletree rebuild	2	4
313	t	32	tabletree rebuild	2	4
314	t	33	tabletree rebuild	2	4
315	t	34	tabletree rebuild	2	4
316	t	35	tabletree rebuild	2	4
317	t	36	extend usertable	2	4
319	t	38	extend usertable	2	4
320	t	39	aggregate function for fields	2	4
321	t	40	iconset for tablegroups	2	4
322	t	41	skale fielddefinition	2	4
323	t	42	skale fielddefinition	2	4
325	f	44	formular subtables	2	4
326	t	45	System	2	4
327	t	1	extended reminder	2	5
328	t	2	extended reminder	2	5
329	t	3	extended reminder	2	5
330	t	4	mysql - update ldms_rules	2	5
331	t	5	mysql - update lmb_rules_tables	2	5
332	t	6	mysql - update lmb_userdb	2	5
333	t	7	mysql - update ldms_files	2	5
334	t	8	workflow	2	5
335	t	9	workflow	2	5
336	t	10	workflow	2	5
337	t	11	extended reminder	2	5
338	t	12	workflow	2	5
339	t	13	workflow	2	5
340	t	14	update umgvar	2	5
341	t	15	extended reminder	2	5
342	t	16	extended reminder	2	5
343	t	17	System	2	5
345	t	19	mysql - update lmb_rules_tables	2	5
346	t	20	mysql - update lmb_conf_tables	2	5
347	t	21	mysql - update lmb_conf_tables	2	5
348	t	1	odt template	2	6
349	t	2	ods template	2	6
350	t	3	update umgvar	2	6
351	t	4	reminder sort	2	6
352	t	5	update umgvar	2	6
354	t	2	calendar form size	2	7
355	t	3	last modified for tables	2	7
356	t	4	modify umgvars	2	7
357	t	5	add superadmin status	2	7
358	t	6	change superadmin status	2	7
359	t	7	add snapshot extension	2	7
361	t	1	update umgvar	2	8
362	t	2	update umgvar	2	8
363	t	3	update calender tables	2	8
364	t	4	update umgvar	2	8
365	t	5	add primary key to lmb_forms if needed	2	8
366	t	6	add primary key to lmb_form_list if needed	2	8
367	t	7	update umgvar	2	8
368	t	8	update umgvar	2	8
369	t	9	add option rule	2	8
370	t	10	update umgvar	2	8
372	t	12	update umgvar	2	8
373	t	13	update umgvar	2	8
374	t	14	update umgvar	2	8
375	t	15	update umgvar	2	8
377	t	17	update dms typ	2	8
378	t	1	adding relation parameter	2	9
379	t	2	adding userdefined keyfield for tables	2	9
380	t	3	set keyfield to ID	2	9
382	t	5	adding field parameter listing_cut	2	9
383	t	6	adding field parameter listing_viewmode	2	9
384	t	7	umgvar with flexible categories	2	9
385	t	8	adding table params	2	9
386	t	9	adding table params	2	9
387	t	10	update umgvar	2	9
388	t	11	tree-relation	2	9
217	t	17	update number format	2	1
223	f	6	view	2	2
227	t	10	relation view	2	2
238	t	21	update umgvar	2	2
245	t	28	update umgvar	2	2
250	t	5	error-handling	2	3
257	t	12	mssql	2	3
260	t	15	usable field size	2	3
271	t	26	extend form parameter	2	3
277	t	32	resize trigger table	2	3
281	t	36	new COLORSCHEMES for skalar	2	3
283	t	2	update umgvar	2	4
288	t	7	update umgvar	2	4
293	t	12	update umgvar	2	4
298	t	17	update umgvar	2	4
304	t	23	tabletree rebuild	2	4
318	t	37	extend usertable	2	4
324	t	43	default layout - older layouts are deprecated	2	4
344	t	18	mysql - update lmb_rules_tables	2	5
353	t	1	calendar form size	2	7
360	t	8	BUGFIX - update lmb_rules_tables	2	7
371	t	11	update umgvar	2	8
376	t	16	update umgvar	2	8
381	t	4	rename option in lmb_rules_fields	2	9
389	t	1	update dbpatch table	2	10
390	t	2	charts noheader attribute	2	10
391	t	3	update umgvar	2	10
392	t	4	ldms_files fieldtype defaultproblem	2	10
393	t	5	ldms_files fieldtype defaultproblem	2	10
394	t	6	ldms_files fieldtype defaultproblem	2	10
395	t	7	update umgvar	2	10
396	t	8	create conf directory	2	10
397	t	9	chart system tables	2	10
398	t	10	update umgvar	2	10
399	t	11	update diagramm action	2	10
400	t	1	multilanguage support	2	11
401	t	2	multilanguage support	2	11
402	t	3	reminder language support	2	11
403	t	4	fieldtype picture	2	11
404	t	5	independent field types	2	11
405	t	0	\N	3	0
406	t	1	add storage-path for ldms_structure	3	1
407	t	2	update umgvar	3	1
408	t	3	add storage-path UPLOAD/STORAGE	3	1
409	t	4	update usertable with primary key	3	1
410	t	5	mofify default values LMB_CHART_LIST	3	1
411	t	1	update colorschema	3	2
412	t	1	adding table LMB_REVISION	3	3
413	t	2	adding table LMB_SYNC_SLAVES	3	3
414	t	3	adding table LMB_SYNC_CACHE	3	3
415	t	4	adding table LMB_SYNC_CONF	3	3
418	f	5	adding table LMB_SYNC_TEMPLATE	3	3
419	f	6	adding data sync to table definition	3	3
420	t	7	adding listedit to rule definition	3	3
421	t	8	adding speechrec to rule definition	3	3
422	t	9	adding popupdefault to rule definition	3	3
423	t	10	update umgvar	3	3
424	t	11	adding table LMB_SYNC_LOG	3	3
425	t	12	update umgvar	3	3
426	t	13	update umgvar	3	3
427	t	14	update umgvar	3	3
428	t	15	empty lmb_lang before adding primary key	3	3
429	f	16	adding primary key to lmb_lang	3	3
430	t	1	adding full table search	3	4
431	t	2	resize VERKNSEARCH	3	4
432	t	3	resize VERKNVIEW	3	4
433	t	4	resize VERKNFIND	3	4
434	t	5	update umgvar	3	4
435	t	6	adding VIEW_LFORM to rule definition	3	4
436	t	7	adding table LMB_SQL_FAVORITES	3	4
437	t	8	delete wrong formuar css entries	3	4
438	t	9	adding VIEW_ISVALID to view definition table	3	4
439	t	10	update umgvar	3	4
440	t	11	update session refresh action	3	4
441	t	12	update upload function name	3	4
442	t	7	update umgvar description for update_check	3	5
443	t	8	update umgvar default value for update_check	3	5
444	t	9	add lmb_printers table	3	5
445	t	10	update umgvar: add lpstat_params	3	5
446	t	11	update umgvar: add lpoptions_params	3	5
447	t	12	update umgvar: add lp_params	3	5
448	t	1	update umgvar: add password_hash	3	6
449	t	2	increased length of password field to contain secure hashes	3	6
450	t	3	adding default storage_id for folders	3	6
451	t	4	adding storage_id for files	3	6
452	t	5	adding public download link for files	3	6
453	t	6	resize files secname for external storage	3	6
454	t	7	adding external storage configuration	3	6
455	t	8	adding auth token access	3	6
456	t	9	resize files secname for external storage	3	6
457	t	10	formular subtables	3	6
458	t	11	report tables	3	6
459	t	12	adding table LMB_SQL_FAVORITES	3	6
460	t	1	adding VIEW_SETMANUALLY to view definition table	4	0
461	t	2	update colors	4	0
462	t	3	adding COLOR to atrribute_w table	4	0
463	t	4	adding ATTRPOOL to atrribute_w table	4	0
464	t	5	adding HIDETAG to atrribute_w table	4	0
465	t	6	adding TAGMODE to LMB_ATTRIBUTE_P table	4	0
466	t	7	adding TAGMODE to LMB_SELECT_P table	4	0
467	t	8	adding MULTIMODE to LMB_ATTRIBUTE_P table	4	0
468	t	9	adding MULTIMODE to LMB_SELECT_P table	4	0
469	t	10	adding MANDATORY to LMB_ATTRIBUTE_W table	4	0
470	t	11	adding COLOR to LMB_SELECT_W table	4	0
471	f	12	adding COLOR to LMB_SELECT_W table	4	0
472	t	13	adding JOB_USER To Table LMB_CRONTAB	4	0
473	t	14	update umgvar: add date_max_two_digit_year_addend	4	0
474	t	15	update umgvar: add restpath	4	0
475	t	1	adding TABLE lmb_custvar	4	1
476	t	2	adding TABLE lmb_custvar_depend	4	1
477	t	3	adding MULTITENANT to lmb_conf_tables table	4	1
478	t	4	adding table LMB_MULTITENANT	4	1
479	t	5	adding MULTITENANT to lmb_userdb table	4	1
480	t	6	adding TABLE LMB_CURRENCY_RATE	4	1
481	t	7	drop COLUMN LMB_CURRENCY.unit	4	1
482	t	8	update umgvar: add multitenant	4	1
483	t	9	update umgvar: add multitenant_length	4	1
484	t	10	update umgvar: add php_mailer parameter	4	1
485	t	11	update umgvar: change php_mailer parameter	4	1
486	t	12	update lmb_multitenant: add syncslave	4	1
487	t	13	update LMB_USERDB: add DLANGUAGE	4	1
488	t	14	adding table LMB_CUSTMENU_LIST	4	1
489	t	15	adding index to lmb_reminder	4	1
490	t	16	adding index to lmb_reminder	4	1
491	t	17	resize formular parameter	4	1
492	t	18	update umgvar: add soap_base64 	4	1
493	t	19	rebuild umgvar id	4	1
494	t	20	update VERKNGROUP for trigger calculation	4	1
495	t	21	update umgvar: add custerrors 	4	1
496	t	22	update umgvar: add enc_cipher 	4	1
497	t	23	rename lmb_sql_favorites to lmb_code_favorites	4	1
498	t	24	add type column to lmb_code_favorties	4	1
499	t	25	add index to LMB_HISTORY_ACTION	4	1
500	t	1	update umgvar: add postgres_use_fulltextsearch	4	2
501	t	2	update umgvar: add postgres_indize_lang	4	2
502	t	3	update umgvar: add postgres_headline	4	2
503	t	4	update umgvar: add postgres_strip_tsvector	4	2
504	t	5	update umgvar: add postgres_rank_func	4	2
505	t	6	rebuild trigger procedure	4	2
506	t	7	update lmb_report_list: add css field	4	2
\.


--
-- Data for Name: lmb_external_storage; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_external_storage (id, descr, classname, config, externalaccessurl, publiccloud) FROM stdin;
\.


--
-- Data for Name: lmb_field_types; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_field_types (id, field_type, data_type, data_type_exp, datentyp, size, lmrule, sort, format, parse_type, funcid, hassize) FROM stdin;
49	17	43	2175	SMALLINT	5	^.{0,128}$	49	2176	2	2	f
41	3	39	1383	LONG	0	^.{0,}|.$	10	1419	2	22	f
22	1	28	1369	VARCHAR(128)	128	^.{0,128}$	11	1405	2	17	t
21	1	29	1368	VARCHAR(230)	230	^.{0,230}$	13	1404	2	18	t
44	2	40	1932	DATE	10	(([0-3]{0,1}[0-9]{1}.([0-1]{0,1}[0-9]{1}|[A-Za-z]{3,9}).[12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}(.?|.[0-2]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1})|([12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}))|(#[-]{0,1}[0-9]{1,3}(DAY|MONTH|YEAR)#))	15	1933	4	4	f
16	2	11	1364	TIMESTAMP	26	(([0-3]{0,1}[0-9]{1}.([0-1]{0,1}[0-9]{1}|[A-Za-z]{3,9}).[12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}(.?|.[0-2]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1})|([12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}))|(#[-]{0,1}[0-9]{1,3}(DAY|MONTH|YEAR)#))	16	1400	4	4	f
43	7	26	1931	TIME	8	[0-2]{1}[0-9]{1}.[0-5]{1}[0-9]{1}	17	1934	5	25	f
30	4	14	1484	VARCHAR(50)	50	^.{0,50}$	19	1483	2	15	f
25	4	12	1371	VARCHAR(50)	50	^.{0,50}$	20	1407	2	9	f
31	4	18	1485	SMALLINT	5	^.{0,160}$	21	1482	1	23	f
26	4	31	1372	SMALLINT	5	^.{0,160}$	22	1408	1	10	f
27	4	32	1373	SMALLINT	5	^.{0,160}$	23	1409	1	11	f
52	19	46	2211	SMALLINT	5	^.{0,255}$	24	2212	1	11	f
33	11	27	1376	FIXED(18)	18	^.{0,60}$	26	1412	1	14	f
34	11	24	1377	FIXED(18)	18	^.{0,60}$	27	1413	1	14	f
46	9	41	2086	BOOLEAN	1	\N	28	2087	3	27	f
28	6	13	1374	VARCHAR(30)	30	^.{0,128}$	30	1410	2	12	f
2	5	16	1350	FIXED	10	^[-]?[0-9]{0,xx}$	1	1386	1	1	t
17	10	20	1365	BOOLEAN	1	^([0-1]|TRUE|FALSE|true|false)$	2	1401	3	5	f
20	5	30	1367	NUMERIC	18	^-?[0-9]{1,xx}([.,][0-9]{1,})?( ?([A-Za-z]{1,3}|[$]))?$	6	1403	6	7	t
13	1	1	1361	VARCHAR	50	^.{0,xx}$	8	1397	2	2	t
60	\N	\N	2944	\N	\N	\N	0	\N	\N	\N	f
61	\N	\N	1361	\N	\N	\N	7	\N	\N	\N	f
63	\N	\N	2945	\N	\N	\N	18	\N	\N	\N	f
64	\N	\N	2946	\N	\N	\N	25	\N	\N	\N	f
65	\N	\N	2947	\N	\N	\N	29	\N	\N	\N	f
66	\N	\N	2362	\N	\N	\N	35	\N	\N	\N	f
67	\N	\N	2948	\N	\N	\N	39	\N	\N	\N	f
54	20	48	2351	Boolean	1	^.{0,40}$	32	2352	3	32	f
51	18	45	2196	FIXED(5)	5	^.{0,30}$	33	2197	1	30	f
50	5	44	2194	FIXED(16)	16	^([0-9]{0,16})|([0-9TMKB]{0,18})$	34	2195	1	29	f
45	100	100	1993	0	0	\N	36	1994	100	0	f
55	101	101	2360	0	0	\N	37	2361	100	33	f
57	101	102	2529	0	0	\N	38	2530	100	34	f
29	8	15	1375	VARCHAR(160)	160	^.{0,160}$	41	1411	2	13	f
53	8	47	2256	BOOLEAN	1	^.{0,160}$	42	2257	3	31	f
19	5	22	1366	INTEGER	10	^[-]?[0-9]{0,xx}$	44	1402	1	6	f
36	14	34	1378	SMALLINT	5	^.{0,50}$	45	1414	1	19	f
38	15	36	1380	TIMESTAMP	26	([<>][=]{0,2}){0,1}(([0-3]{0,1}[0-9]{1}.([0-1]{0,1}[0-9]{1}|[A-Za-z]{3,9}).[12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}(.?|.[0-2]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1})|([12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}))|(#[-]{0,1}[0-9]{1,3}(DAY|MONTH|YEAR)#))	46	1416	4	20	f
37	14	35	1379	SMALLINT	5	^.{0,50}$	47	1415	1	19	f
39	15	37	1381	TIMESTAMP	26	([<>][=]{0,2}){0,1}(([0-3]{0,1}[0-9]{1}.([0-1]{0,1}[0-9]{1}|[A-Za-z]{3,9}).[12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}(.?|.[0-2]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1}.[0-5]{0,1}[0-9]{0,1})|([12]{0,1}[90]{0,1}[0-9]{0,1}[0-9]{1}))|(#[-]{0,1}[0-9]{1,3}(DAY|MONTH|YEAR)#))	48	1417	4	20	f
40	16	38	1382	SMALLINT	5	^.{0,50}$	49	1418	2	21	f
59	22	51	2916	SMALLINT	4	^[-]?[0-9]{0,xx}$	50	2917	1	35	f
56	5	49	2467	FLOAT	10	^[-]?([0-9]{0,xx}|[0-9.,]{0,xxx})([Ee](-)?(\\d){1,2})?$	3	2468	6	1	t
5	5	19	1353	NUMERIC	10	^[-]?([0-9]{0,xx}|[0-9.,]{0,xxx})([Ee](-)?(\\d){1,2})?$	4	1389	6	1	t
42	5	21	1595	NUMERIC	10	^[-]?([0-9]{0,xx}|[0-9.,]{0,xxx})([Ee](-)?(\\d){1,2})?( )?(%)?$	5	1596	6	1	t
47	1	42	2123	VARCHAR(30)	30	(?:\\(\\+?\\d+\\)|\\+?\\d+)(?:\\s*[\\-\\/]*\\s*\\d+)+	12	2124	2	28	t
15	3	10	1363	VARCHAR	1000	^(.|\\n){0,xx}$	9	1399	2	3	t
58	21	50	2641	VARCHAR(8)	8	^#?[a-zA-Z0-9]{3}([a-zA-Z0-9]{3})?$	40	2642	2	16	f
68	23	52	2969	INTEGER	4	^.{0,50}$	68	2970	1	36	f
23	1	33	2903	VARCHAR	180	^.{0,xx}$	31	2904	2	24	f
\.


--
-- Data for Name: lmb_field_types_depend; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_field_types_depend (id, field_type, data_type, data_type_exp, datentyp, size, lmrule, sort, format, parse_type, funcid, hassize) FROM stdin;
\.


--
-- Data for Name: lmb_fonts; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_fonts (id, family, name, style) FROM stdin;
\.


--
-- Data for Name: lmb_form_list; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_form_list (id, name, beschreibung, referenz_tab, erstdatum, editdatum, erstuser, edituser, form_typ, frame_size, redirect, css, extension, dimension) FROM stdin;
\.


--
-- Data for Name: lmb_forms; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_forms (keyid, erstdatum, editdatum, erstuser, edituser, form_id, typ, posx, posy, height, width, style, tab_group, tab_id, field_id, z_index, uform_typ, uform_vtyp, pic_typ, pic_style, pic_size, tab, tab_size, tab_el_col, tab_el_row, tab_el_col_size, title, event_click, event_over, event_out, event_dblclick, event_change, inhalt, class, parentrel, id, subelement, categorie, tab_el, parameters) FROM stdin;
\.


--
-- Data for Name: lmb_groups; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_groups (group_id, name, erstdatum, editdatum, level, del, redirect, multiframelist, description) FROM stdin;
1	admin	2001-01-15 11:17:07	\N	\N	f	\N	default.php	ADMINISTRATOR
\.


--
-- Data for Name: lmb_gtab_groupdat; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_gtab_groupdat (id, group_id, tab_id, dat_id, color) FROM stdin;
\.


--
-- Data for Name: lmb_gtab_pattern; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_gtab_pattern (id, erstuser, patid, tabid, posx, posy, width, height, visible, viewid) FROM stdin;
\.


--
-- Data for Name: lmb_gtab_rowsize; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_gtab_rowsize (id, erstdatum, user_id, tab_id, row_size) FROM stdin;
\.


--
-- Data for Name: lmb_gtab_status_save; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_gtab_status_save (id, erstdatum, erstuser, tab_id, formel, bezeichnung, group_id, typ, beschreibung, dssdsd) FROM stdin;
1	2006-01-25 17:19:35	1	7	if(!#*[10]*# AND #*[3]*#){\n$gvalue = "FF1232";\n$gdesc = '';\n}elseif(!#*[3]*#){\n$gvalue = "C6AA73";\n$gdesc = '';\n}	DNS	1	-1	\N	f
2	2006-05-10 13:23:40	1	25	if(#*[13]*# == 'Rechnung'){\nif(!#*[8]*# AND (local_stamp(1) - get_stamp(#*[6]*#) > 1814400) AND (local_stamp(1) - get_stamp(#*[6]*#) < 3024000)){\n$gvalue = "FFDDDD";\n$gdesc = '21 Tage überschritten';\n}elseif(!#*[8]*# AND (local_stamp(1) - get_stamp(#*[6]*#) > 3024000)){\n$gvalue = "FFAAAA";\n$gdesc = '35 Tage überschritten';\n}\n}	Mahnung	1	-1	Mahnung	f
\.


--
-- Data for Name: lmb_history_action; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_history_action (id, erstdatum, userid, tab, dataid, action, loglevel, lwf_id, lwf_inid, lwf_prid) FROM stdin;
\.


--
-- Data for Name: lmb_history_backup; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_history_backup (id, erstdatum, label, action, result, medium, size, nextlogpage, server, location, message, cron_id) FROM stdin;
\.


--
-- Data for Name: lmb_history_update; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_history_update (id, erstdatum, userid, tab, field, dataid, fieldvalue, action_id, lwf_id, lwf_inid, lwf_prid) FROM stdin;
\.


--
-- Data for Name: lmb_history_user; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_history_user (id, userid, sessionid, login_date, update_date, ip, host, login_time) FROM stdin;
39	1	hkon8nimctpsqmlh39kdgttdc8	2020-09-18 12:29:47.990531	2020-09-18 12:30:09	127.0.0.1		22
\.


--
-- Data for Name: lmb_indize_d; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_indize_d (id, sid, wid, ref, tabid, fieldid) FROM stdin;
\.


--
-- Data for Name: lmb_indize_ds; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_indize_ds (id, sid, wid, ref, tabid, fieldid) FROM stdin;
\.


--
-- Data for Name: lmb_indize_f; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_indize_f (id, sid, wid, fid, meta) FROM stdin;
\.


--
-- Data for Name: lmb_indize_fs; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_indize_fs (id, sid, wid, fid, meta) FROM stdin;
\.


--
-- Data for Name: lmb_indize_history; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_indize_history (id, erstdatum, result, used_time, message, action, inum, job, jnum) FROM stdin;
\.


--
-- Data for Name: lmb_indize_w; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_indize_w (id, val, metaphone, upperval) FROM stdin;
\.


--
-- Data for Name: lmb_lang; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_lang (id, language_id, element_id, typ, wert, language, edit, lmfile, js) FROM stdin;
2412	1	1246	1	ohne	deutsch	t	5	f
6285	4	418	2	Créer un nouveau message	francais	t	0	f
6286	4	421	2	Rechercher	francais	t	0	f
6287	4	422	2	Rechercher un message	francais	t	0	f
6288	4	425	2	Rappel	francais	t	0	f
6289	4	426	2	Rappel personnel	francais	t	0	f
6417	4	672	3	Nom	francais	t	136	f
6558	4	890	1	Novembre	francais	t	41	f
6559	4	891	1	Decembre	francais	t	41	f
6677	4	1024	3	Indiqué	francais	t	149	f
6802	4	1157	3	N° page	francais	t	169	f
6941	4	1315	3	Le nom d''utilisateur et le mot de passe doivent comporter un minimum de 5 caractères!	francais	t	127	f
6943	4	1317	1	Non autorisé!	francais	t	31	f
6945	4	1319	2	Editeur de chargement	francais	t	0	f
6946	4	1320	2	Editeur de chargement	francais	t	0	f
6948	4	1322	1	Chemin du fichier	francais	t	186	f
6949	4	1324	1	Importer liste de fichier!	francais	t	186	f
7115	4	1500	2	Apercu	francais	t	0	f
7120	4	1506	1	Oui	francais	t	15	f
7361	4	1775	3	Formulaire	francais	t	168	f
7481	4	1900	3	Paramètre de sécurité	francais	t	164	f
7630	4	2051	1	Vous n'' actuellement ni tache ni workflow!	francais	t	208	f
7633	4	2054	1	Le workflow a été annulé avec succès!	francais	t	209	f
7638	4	2059	2	Workflow	francais	t	0	f
7833	1	2125	2	verstecke gesperrte	deutsch	t	\N	f
7834	2	2125	2	hide locked data	english	t	\N	f
7835	4	2125	2	verstecke gesperrte Daten	francais	t	\N	f
7837	1	2126	2	verstecke gesperrte Datensätze	deutsch	t	\N	f
7838	2	2126	2	hide locked records	english	t	\N	f
7839	4	2126	2	verstecke gesperrte Datensätze	francais	t	\N	f
7862	1	2132	3	versionieren	deutsch	t	140	f
7863	2	2132	3	versionise	english	t	140	f
7869	1	2134	2	versionieren	deutsch	t	\N	f
7870	2	2134	2	versionise	english	t	\N	f
7871	4	2134	2	versionieren	francais	t	\N	f
7873	1	2135	2	Datensatz versionieren	deutsch	t	\N	f
7874	2	2135	2	versionise record	english	t	\N	f
7875	4	2135	2	neue Datensatzversion	francais	t	\N	f
7878	2	2136	2	select all	english	t	\N	f
6271	4	392	2	sortie imprimée	francais	t	0	f
7879	4	2136	2	alle auswählen	francais	t	\N	f
8030	1	2174	2	\N	deutsch	t	0	f
8031	2	2174	2	\N	english	t	0	f
8002	1	2167	1	zeige Symbolleiste	deutsch	t	46	f
8005	1	2168	2	suchen	deutsch	t	\N	f
8006	2	2168	2	search	english	t	\N	f
8009	1	2169	2	Suchmenü	deutsch	t	\N	f
8010	2	2169	2	Search menu	english	t	\N	f
8013	1	2170	2	Versionsstand	deutsch	t	\N	f
8014	2	2170	2	show Version status	english	t	\N	f
8015	4	2170	2	zeige Versionsstand	francais	t	\N	f
8017	1	2171	2	zeige Versionsstand eines Datums	deutsch	t	\N	f
7922	1	2147	1	Es kann nur die aktuelle Version des Datensatzes versioniert bzw. editiert werden!	deutsch	t	13	t
8019	4	2171	2	zeige Versionsstand eines Datums	francais	t	\N	f
8022	1	2172	1	Status vom:	deutsch	t	5	f
8023	2	2172	1	Status of:	english	t	5	f
8026	1	2173	2	-------Extension-Feldtypen-------	deutsch	t	0	f
8027	2	2173	2	-------Extension-Fieldtypes-------	english	t	0	f
8042	1	2177	1	Datensatz ist identisch!	deutsch	t	13	f
8043	2	2177	1	Identical record!	english	t	13	f
8046	1	2178	3	colspan	deutsch	t	168	f
8047	2	2178	3	colspan	english	t	168	f
8050	1	2179	3	rowspan	deutsch	t	168	f
8051	2	2179	3	rowspan	english	t	168	f
8053	1	2180	2	zeige verknüpfte	deutsch	t	\N	f
8054	2	2180	2	show linked	english	t	\N	f
8055	4	2180	2	zeige verknüpfte	francais	t	\N	f
8057	1	2181	2	zeige verknüpfte Datensätze	deutsch	t	\N	f
8058	2	2181	2	show linked records	english	t	\N	f
8201	1	2217	2	zu Favoriten	deutsch	t	\N	f
8203	4	2217	2	zu Favoriten	francais	t	\N	f
8205	1	2218	2	zu Favoriten hinzufügen	deutsch	t	\N	f
8206	2	2218	2	add to favorites	english	t	\N	f
8207	4	2218	2	zu Favoriten hinzufügen	francais	t	\N	f
8210	1	2219	1	Wollen Sie die Datei/en zu den Favoriten hinzufügen?	deutsch	t	66	f
8122	1	2197	2	Mimetype	deutsch	t	0	f
8211	2	2219	1	Add file/s to favorites?	english	t	66	f
8219	4	2221	2	System Arrays	francais	t	\N	f
8222	2	2222	2	System Arrays	english	t	\N	f
8223	4	2222	2	System Arrays	francais	t	\N	f
8225	1	2223	2	Datei suchen	deutsch	t	\N	f
8227	4	2223	2	Datei suchen	francais	t	\N	f
8091	2	2189	1	You have no permission for this file. 	english	t	66	f
8111	2	2194	2	filesize	english	t	0	f
8202	2	2217	2	to favorites	english	t	\N	f
8238	1	2226	1	auswählen	deutsch	t	215	f
8371	4	2259	2	Bildvorschau	francais	t	\N	f
8373	1	2260	2	Bildershow	deutsch	t	\N	f
8374	2	2260	2	Picture show	english	t	\N	f
8375	4	2260	2	Bildershow	francais	t	\N	f
8377	1	2261	2	Bildershow	deutsch	t	\N	f
8378	2	2261	2	Picture show	english	t	\N	f
8379	4	2261	2	Bildershow	francais	t	\N	f
8382	1	2262	3	Session Lebensdauer	deutsch	t	127	f
8383	2	2262	3	Session durability	english	t	127	f
8386	2	2263	2	Language	english	t	\N	f
8387	4	2263	2	Sprache	francais	t	\N	f
8390	2	2264	2	Local language table	english	t	\N	f
6144	4	164	1	tableau 	francais	t	49	f
6247	4	356	2	Remarques sur la relation 	francais	t	0	f
8362	1	2257	2	Formelkonstrukt (SQL)	deutsch	t	0	f
8391	4	2264	2	Lokale Sprachtabelle	francais	t	\N	f
10145	2	2265	2	Trigger	english	t	\N	f
10332	1	2309	1	Ordner	deutsch	t	97	f
10146	4	2265	2	Trigger	francais	t	\N	f
10150	2	2266	2	Database Trigger	english	t	\N	f
10151	4	2266	2	Datenbank Trigger	francais	t	\N	f
8267	2	2233	1	simple view	english	t	215	f
8271	2	2234	1	advanced view	english	t	215	f
10166	2	2269	3	Definition	english	t	218	f
10170	1	2270	3	Editiert am	deutsch	t	218	f
10171	2	2270	3	Edited on	english	t	218	f
10175	1	2271	3	Editiert von	deutsch	t	218	f
10176	2	2271	3	Edited by	english	t	218	f
10496	1	2350	2	\N	deutsch	t	unknown	f
10312	1	2304	2	OCR	deutsch	t	0	f
10313	2	2304	2	OCR	english	t	0	f
10316	1	2305	2	OCR Erkennung	deutsch	t	0	f
10317	2	2305	2	OCR Identification	english	t	0	f
10324	1	2307	2	Symbolleiste	deutsch	t	0	f
10328	1	2308	2	zeige Symbolleiste	deutsch	t	0	f
10308	1	2303	3	lesen	deutsch	t	122	f
10204	1	2277	2	Berichtrechte	deutsch	t	0	f
10309	2	2303	3	read	english	t	122	f
10265	2	2292	2	show selve linked records 	english	t	0	f
10208	1	2278	2	Berichtrechte festlegen	deutsch	t	0	f
10333	2	2309	1	Folder	english	t	97	f
10336	1	2310	1	Sie haben keine Ordnerrechte!	deutsch	t	97	f
10337	2	2310	1	No folder rights!	english	t	97	f
10340	1	2311	1	keine Löschrechte!	deutsch	t	97	f
10348	1	2313	1	Die Quelldatei existiert schon. Bitte versuchen Sie es erneut.	deutsch	t	97	f
10349	2	2313	1	Sourcefile already exists. Please try again.	english	t	97	f
10352	1	2314	1	OCR Erkennung starten	deutsch	t	66	f
10353	2	2314	1	Start OCR identification	english	t	66	f
10356	1	2315	2	Verknüpfungs-Modus	deutsch	t	0	f
10360	1	2316	2	zeige nur verknüpfte Datensätze	deutsch	t	0	f
10361	2	2316	2	show only linked records	english	t	0	f
10364	1	2317	1	Die Quelldatei existiert nicht mehr!	deutsch	t	66	f
10365	2	2317	1	Source file does not exist anymore!	english	t	66	f
10368	1	2318	1	Datei löschen	deutsch	t	215	f
10372	1	2319	2	Unterordner durchsuchen	deutsch	t	0	f
10373	2	2319	2	search subfolder	english	t	0	f
10376	1	2320	2	rekursive Suche	deutsch	t	0	f
10497	2	2350	2	\N	english	t	unknown	f
10500	1	1993	2	Sparte	deutsch	t	unknown	f
10501	2	1993	2	Division	english	t	unknown	f
10341	2	2311	1	No rights to delete!	english	t	97	f
10369	2	2318	1	delete file	english	t	215	f
2620	1	1350	2	Zahl	deutsch	t	0	f
10504	1	1994	2	Kategorie-Beschriftung	deutsch	t	unknown	f
10505	2	1994	2	Category inscription	english	t	unknown	f
10516	1	2353	3	Static-IP	deutsch	t	127	f
10517	2	2353	3	Static-IP	english	t	127	f
10520	1	2354	1	Unterschied zwischen den Versionen	deutsch	t	204	f
10521	2	2354	1	Difference between the versions	english	t	204	f
10524	1	2355	1	zeige als pdf	deutsch	t	204	f
10525	2	2355	1	show as pdf	english	t	204	f
10532	1	2357	3	Seperator	deutsch	t	168	f
10533	2	2357	3	Seperator	english	t	168	f
10536	1	2358	1	Verknüpfung lösen	deutsch	t	13	f
10540	1	2359	1	Wollen Sie die Verknüpfung dieses Datensatzes entfernen?	deutsch	t	13	t
10512	1	2352	2	Referenz zu Dokument	deutsch	t	0	f
10552	1	2362	2	Gruppierung	deutsch	t	0	f
10553	2	2362	2	Grouping	english	t	0	f
10556	1	2363	2	Feld Gruppierung	deutsch	t	0	f
10557	2	2363	2	Field grouping	english	t	0	f
10576	1	2368	3	Infotext bei Sperrung	deutsch	t	154	f
10577	2	2368	3	Infotext if blockage	english	t	154	f
10604	1	2375	1	Die hochgeladene Datei existiert schon mit gleichem oder unter anderem Namen in folgenden Ordnern	deutsch	t	41	f
10605	2	2375	1	The uploaded file already exists with same or under another name in the following folders.	english	t	41	f
6331	4	474	2	taille de l'élément de rapport	francais	t	0	f
10780	1	2419	3	Nachricht	deutsch	t	52	f
10781	2	2419	3	News	english	t	52	f
10816	1	2428	3	unbegrenzt sperren	deutsch	t	221	f
10817	2	2428	3	Unlimited locked	english	t	221	f
10821	2	2429	2	lock	english	t	0	f
10828	1	2431	2	entsperren	deutsch	t	0	f
10829	2	2431	2	unlock	english	t	0	f
10832	1	2432	2	Datensatz entsperren	deutsch	t	0	f
10836	1	2433	1	soll der Datensatz wieder freigegeben werden?	deutsch	t	13	t
10837	2	2433	1	Shall the record be released again?	english	t	13	f
10844	1	2435	1	Datensatz wurde erfolgreich gesperrt!	deutsch	t	25	f
10845	2	2435	1	Record has been successfully locked!	english	t	25	f
10848	1	2436	1	Datensätze wurden erfolgreich gesperrt!	deutsch	t	25	f
10849	2	2436	1	Records have been successfully locked!	english	t	25	f
10852	1	2437	1	Datensatz wurde erfolgreich entsperrt!	deutsch	t	25	f
10853	2	2437	1	Record has been successfully unlocked!	english	t	25	f
10856	1	2438	1	Datensätze wurden erfolgreich entsperrt!	deutsch	t	25	f
10825	2	2430	2	lock record	english	t	0	f
10857	2	2438	1	Records have been successfully unlocked!	english	t	25	f
10860	1	2439	2	gesperrte Daten	deutsch	t	0	f
10861	2	2439	2	locked data	english	t	0	f
10864	1	2440	2	meine gesperrten Datensätze	deutsch	t	0	f
10865	2	2440	2	my locked data	english	t	0	f
10868	1	2441	2	zeige gesperrte	deutsch	t	0	f
10869	2	2441	2	show locked	english	t	0	f
10872	1	2442	2	zeige gesperrte Datensätze	deutsch	t	0	f
10877	2	2443	2	save	english	t	0	f
10985	2	2470	2	delete incl. ref. integrity	english	t	0	f
10820	1	2429	2	sperren	deutsch	t	0	f
10996	1	2473	1	folgende Abhängigkeiten bestehen:	deutsch	t	25	f
10997	2	2473	1	the following dependence exists:	english	t	25	f
11000	1	2474	1	folgende Abhängigkeiten wurden gelöst!:	deutsch	t	25	f
7779	2	2111	3	Folder	english	t	170	f
11001	2	2474	1	the following dependence were deleted:	english	t	25	f
11028	1	2481	3	Temporäre Inhalte	deutsch	t	154	f
11032	1	2482	3	Datenbankfunktionen	deutsch	t	154	f
11033	2	2482	3	Database functions	english	t	154	f
11040	1	2484	3	Rechteverwaltung	deutsch	t	154	f
11041	2	2484	3	Rights management	english	t	154	f
11044	1	2485	3	Usereinstellungen	deutsch	t	154	f
11045	2	2485	3	User settings	english	t	154	f
11008	1	2476	3	Foreign Keys prüfen	deutsch	t	154	f
10989	2	2471	2	special features	english	t	0	f
10993	2	2472	2	special features	english	t	0	f
11029	2	2481	3	temporary contents	english	t	154	f
11036	1	2483	3	System	deutsch	t	154	f
11064	1	2490	2	Beziehungsbäume	deutsch	t	0	f
731	1	731	2	Formulare	deutsch	t	\N	f
732	1	732	2	Formulare	deutsch	t	\N	f
8137	1	2201	2	Berichte	deutsch	t	\N	f
8141	1	2202	2	Berichte	deutsch	t	\N	f
750	1	750	2	Diagramme	deutsch	t	\N	f
751	1	751	2	Auswertungs-Diagramme	deutsch	t	\N	f
11065	2	2490	2	Relationtrees	english	t	0	f
2681	2	1380	2	Post-date 	english	t	0	f
2683	2	1381	2	Edit-date 	english	t	0	f
11076	1	2493	2	Tabellenbaum	deutsch	t	0	f
11080	1	2494	2	Tabellenbaum	deutsch	t	0	f
11077	2	2493	2	tabletree	english	t	0	f
11081	2	2494	2	tabletree	english	t	0	f
2695	2	1387	2	10-digit number 	english	t	0	f
7009	4	1386	2	Nombre à 5 chiffres	francais	t	0	f
11196	1	2523	1	Imap Port	deutsch	t	46	f
11200	1	2524	1	Imap Passwort	deutsch	t	46	f
10445	2	2337	3	maintain Userrights 	english	t	221	f
10565	2	2365	2	Overview dublicates 	english	t	0	f
11056	1	2488	3	Trigger prüfen	deutsch	t	154	f
2421	2	1250	3	history	english	t	132	f
11061	2	2489	2	Tabletree 	english	t	0	f
11113	2	2502	1	format	english	t	13	f
11117	2	2503	1	default fomular	english	t	13	f
11125	2	2505	3	view rule	english	t	110	f
11133	2	2507	3	fast search	english	t	110	f
11137	2	2508	3	html	english	t	168	f
11141	2	2509	3	report extension	english	t	170	f
11153	2	2512	3	system reports	english	t	222	f
11181	2	2519	1	mailaddress	english	t	46	f
11185	2	2520	1	reply address	english	t	46	f
11189	2	2521	1	imap hostname	english	t	46	f
11193	2	2522	1	imap username	english	t	46	f
11197	2	2523	1	imap port	english	t	46	f
11201	2	2524	1	imap password	english	t	46	f
11204	1	2525	2	Einstellungen	deutsch	t	0	f
11312	1	2552	3	Datensatzrechte neu berechnen	deutsch	t	154	f
11320	1	2554	3	Verknüpfungsreiter	deutsch	t	173	f
11324	1	2555	3	Menuleiste	deutsch	t	173	f
11332	1	2557	3	Fußleiste	deutsch	t	173	f
550	1	550	3	leeren	deutsch	t	108	f
6374	4	550	3	Supprimer tout	francais	t	108	f
7778	1	2111	3	Ablageordner	deutsch	t	170	f
11348	1	2561	3	Tabulator-Rahmen	deutsch	t	175	f
431	1	431	2	UmgVar	deutsch	t	\N	f
432	1	432	2	Umgebungsvariablen	deutsch	t	\N	f
11376	1	2568	3	Standardwert bei anlegen eines neuen Datensatzes	deutsch	t	221	f
11400	1	2574	3	Standardformular	deutsch	t	221	f
11420	1	2579	2	OCR	deutsch	t	0	f
11424	1	2580	2	OCR Erkennung	deutsch	t	0	f
10876	1	2443	2	speichern	deutsch	t	0	f
10880	1	2444	2	übernehmen	deutsch	t	0	f
11360	1	2564	2	Erweiterte Einstellungen	deutsch	t	0	f
502	1	502	2	SQL-Editor	deutsch	t	\N	f
11428	1	2581	3	css Datei	deutsch	t	175	f
11432	1	2582	1	verknüpfen	deutsch	t	15	f
11169	2	2516	3	transmit userrights hierarchic	english	t	221	f
10529	2	2356	3	show all versioned 	english	t	221	f
11353	2	2562	3	User could not be created!	english	t	126	f
11357	2	2563	2	Settings	english	t	0	f
11361	2	2564	2	Advanced settings	english	t	0	f
11484	1	2595	3	Trennzeichen	deutsch	t	110	f
2428	1	1254	3	Wollen Sie die Gruppe und alle Untergruppen löschen?\nUser dieser Gruppen können mit [zeige gelöschte User] anderen Gruppen zugeordnet werden!	deutsch	t	115	t
10320	1	2306	3	Formular/Berichtrechte	deutsch	t	119	f
7858	1	2131	3	Menürechte	deutsch	t	119	f
11444	1	2585	3	übernehme Rechte von Obergruppe:	deutsch	t	119	f
923	1	923	3	Titel	deutsch	t	110	f
6586	4	923	3	Description	francais	t	110	f
11536	1	2608	3	Filter	deutsch	t	110	f
11540	1	2609	3	Suchfeld	deutsch	t	110	f
11544	1	2610	3	Evaluierung	deutsch	t	110	f
11548	1	2611	3	Vererbung	deutsch	t	110	f
11172	1	2517	1	hirarchisch vererben	deutsch	t	13	f
11549	2	2611	3	inheritance	english	t	110	f
1700	2	550	3	empty	english	t	108	f
4968	1	1718	3	Soll der gesamte Index dieses Feldes gelöscht werden?	deutsch	t	110	f
7304	4	1718	3	Est-ce-que l''index entier doit être supprimé pour ce champs?	francais	t	110	f
5556	1	1914	1	Suchtipps:\n-korrekte Schreibweise beachten\n-verallgemeinern Sie die Suche\n-suchen Sie in Unterordnern (sub)	deutsch	t	66	t
7494	4	1914	1	Conseil de recherche:\n - porter attention à l''orthographe\n - rechercher dans les sous-dossiers	francais	t	66	t
5868	1	2018	3	neueste Version	deutsch	t	52	f
7598	4	2018	3	Dernière version	francais	t	52	f
5970	1	2052	1	Workflow wurdet nicht abgebrochen! Möglicherweise ein Rechteproblem.	deutsch	t	209	f
7631	4	2052	1	Le workflow ne peut être interrompu! Probablement un	francais	t	209	f
5973	1	2053	1	Workflow konnte nicht angehalten werden! Möglicherweise ein Rechteproblem.	deutsch	t	209	f
7632	4	2053	1	Le workflow ne peut être suspendu! Surement un problème de droit.	francais	t	209	f
7660	4	2081	3	Inc. sous-dos.	francais	t	212	f
7694	1	2090	3	Hintergr.	deutsch	t	168	f
7696	4	2090	3	Arrière-plan	francais	t	168	f
2040	2	918	3	where ?ID stands for article-no. 	english	t	107	f
5554	2	1913	1	- limit the result with more search parameters.\n- If entitled, expand the result limit.\n- If entitled, cancel the result limit.	english	t	5	t
6333	4	476	2	contenu  de l'élément de rapport	francais	t	0	f
6334	4	477	2	représentation	francais	t	0	f
11613	2	2627	3	sum	english	t	226	f
11617	2	2628	3	min	english	t	226	f
11621	2	2629	3	max	english	t	226	f
11637	2	2633	3	ascendant	english	t	226	f
11641	2	2634	3	descending	english	t	226	f
11645	2	2635	3	show systemtables	english	t	225	f
11657	2	2638	3	view	english	t	168	f
11677	2	2643	1	to User	english	t	13	f
11681	2	2644	1	set	english	t	13	f
11633	2	2632	3	criteria	english	t	226	f
11692	1	2647	1	Ziel	deutsch	t	66	f
7692	4	2089	3	Champs affiché	francais	t	121	f
5610	1	1932	2	Datum	deutsch	t	0	f
5770	2	1985	1	Years	english	t	13	f
5772	1	1986	3	Erweiterung	deutsch	t	162	f
5773	2	1986	3	Extension	english	t	162	f
5775	1	1987	3	Trigger onCh	deutsch	t	122	f
5776	2	1987	3	Trigger onCh	english	t	122	f
5778	2	1988	2	Trigger	english	t	\N	f
5781	2	1989	2	Trigger	english	t	\N	f
5790	1	1992	3	Dateisystem-Tabellen erneuern	deutsch	t	154	f
5791	2	1992	3	rebuild filesystem tables	english	t	154	f
5799	1	1995	3	Debug	deutsch	t	164	f
5800	2	1995	3	debug	english	t	164	f
5808	1	1998	1	speichern als	deutsch	t	5	f
5814	1	2000	1	administrieren	deutsch	t	5	f
5815	2	2000	1	administrate	english	t	5	f
5832	1	2006	1	erfolgreich gespeichert!	deutsch	t	0	f
5833	2	2006	1	Successfully saved!	english	t	0	f
6042	1	2076	3	Monatstag	deutsch	t	212	f
5835	1	2007	1	erfolgreich gelöscht!	deutsch	t	0	f
5836	2	2007	1	Successfully deleted!	english	t	0	f
5838	1	2008	1	erfolgreich gesendet!	deutsch	t	0	f
5839	2	2008	1	Successfully sent!	english	t	0	f
5619	2	1935	2	File mode	english	t	\N	f
6636	4	979	3	gzip	francais	t	145	f
3523	3	854	1	y	Espagñol	t	19	f
6442	4	730	2	Modifier la réimpression	francais	t	0	f
6448	4	736	2	requêtes de table	francais	t	0	f
6510	4	835	2	paramètres généraux du groupe	francais	t	0	f
7098	4	1483	2	Champ de sélection (liste)	francais	t	0	f
7099	4	1484	2	Sélection (radio)	francais	t	0	f
7111	4	1496	3	frontière supérieure	francais	t	168	f
7112	4	1497	3	marge inférieure	francais	t	168	f
7792	4	2114	1	limite	francais	t	5	f
7904	4	2142	3	récursive	francais	t	140	f
7908	4	2143	3	fixé	francais	t	140	f
7912	4	2144	3	manuellement	francais	t	122	f
7916	4	2145	3	automatiquement	francais	t	122	f
8044	4	2177	1	L'enregistrement de données est identique!	francais	t	13	f
8048	4	2178	3	colspan	francais	t	168	f
8052	4	2179	3	rowspan	francais	t	168	f
8064	4	2182	1	Le record était lié!	francais	t	25	f
8068	4	2183	1	Les enregistrements ont été liés!	francais	t	25	f
8072	4	2184	1	Le lien a été résolu!	francais	t	25	f
8076	4	2185	1	Les liens ont été résolus!	francais	t	25	f
8128	4	2198	3	dépendant\r\n	francais	t	168	f
8164	4	2207	3	modèle	francais	t	177	f
8032	4	2174	2	 	francais	t	0	f
10206	4	2277	2	droits de rapport	francais	t	0	f
10210	4	2278	2	Définir les droits de rapport	francais	t	0	f
10214	4	2279	3	Le formulaire devrait-il être supprimé?	francais	t	176	f
10222	4	2281	3	formes	francais	t	222	f
10234	4	2284	3	Le rapport devrait-il être supprimé?	francais	t	170	f
10238	4	2285	3	Le diagramme devrait-il être supprimé?	francais	t	177	f
5625	2	1937	2	Key word 	english	t	\N	f
5634	2	1940	2	Time frame	english	t	\N	f
5637	2	1941	2	Change timeframe	english	t	\N	f
5685	1	1957	3	Zellengitter	deutsch	t	168	f
5780	1	1989	2	Gruppen Trigger	deutsch	t	\N	f
5686	2	1957	3	Margin 	english	t	168	f
5777	1	1988	2	Trigger	deutsch	t	\N	f
5862	1	2016	1	Excel	deutsch	t	5	f
5863	2	2016	1	Excel	english	t	5	f
5865	1	2017	1	XML	deutsch	t	5	f
5866	2	2017	1	XML	english	t	5	f
5874	1	2020	3	Konvertierung des Feldes:	deutsch	t	110	f
140	1	140	1	Userdaten	deutsch	t	46	f
5877	1	2021	3	Inhalte mit Überlängen oder falschen Typs werden gekürzt bzw. gelöscht!	deutsch	t	110	f
5883	1	2023	3	Abfrage	deutsch	t	140	f
5884	2	2023	3	Query	english	t	140	f
5886	2	2024	2	Querys	english	t	\N	f
5889	2	2025	2	Query-Generator	english	t	\N	f
5892	1	2026	3	SQL	deutsch	t	205	f
5893	2	2026	3	SQL	english	t	205	f
5895	1	2027	3	Editor	deutsch	t	205	f
5896	2	2027	3	Editor	english	t	205	f
5904	1	2030	3	Temporäre Feldinhalte aktualisieren	deutsch	t	154	f
5919	1	2035	3	Workflow	deutsch	t	140	f
5920	2	2035	3	Workflow	english	t	140	f
5928	2	2038	2	My tasks	english	t	\N	f
5931	2	2039	2	Workflow elements	english	t	\N	f
11673	2	2642	2	Colojoice 	english	t	0	f
5940	1	2042	1	letzte Nutzer	deutsch	t	208	f
5941	2	2042	1	Last user	english	t	208	f
5943	1	2043	1	aktuelle Nutzer	deutsch	t	208	f
5944	2	2043	1	Current user	english	t	208	f
5946	1	2044	1	nächste Nutzer	deutsch	t	208	f
5947	2	2044	1	Next user	english	t	208	f
5952	1	2046	1	Möchten Sie diesen Workflow anhalten?	deutsch	t	208	f
5953	2	2046	1	Do you want to stop this workflow	english	t	208	f
5955	1	2047	1	Möchten Sie diesen Workflow abbrechen?	deutsch	t	208	f
5956	2	2047	1	Do you want to cancel this workflow?	english	t	208	f
5958	1	2048	1	Augfabe	deutsch	t	208	f
5959	2	2048	1	Task	english	t	208	f
5961	1	2049	1	von	deutsch	t	208	f
5962	2	2049	1	from	english	t	208	f
5964	1	2050	1	an	deutsch	t	208	f
5965	2	2050	1	to	english	t	208	f
5967	1	2051	1	Sie haben momentan weder eine Aufgabe noch ein Workflow gestartet!	deutsch	t	208	f
5968	2	2051	1	no workflow or task was started	english	t	208	f
5976	1	2054	1	Workflow wurde erfolgreich abgebrochen!	deutsch	t	209	f
5977	2	2054	1	Workflow successfully cancelled	english	t	209	f
5985	1	2057	1	Meine Workflows	deutsch	t	204	f
5986	2	2057	1	My workflow	english	t	204	f
5988	1	2058	1	Keine Aufgabe	deutsch	t	204	f
5989	2	2058	1	No task	english	t	204	f
5991	2	2059	2	Workflow	english	t	\N	f
5994	2	2060	2	Workflow	english	t	\N	f
5997	1	2061	1	Erster Datensatz!	deutsch	t	23	f
5998	2	2061	1	First record!	english	t	23	f
6000	1	2062	1	Letzter Datensatz!	deutsch	t	23	f
6001	2	2062	1	Last record!	english	t	23	f
6003	1	2063	3	Z-Index berücksichtigen	deutsch	t	175	f
6004	2	2063	3	consider Z-Index	english	t	175	f
6006	1	2064	3	in den Vordergrund	deutsch	t	168	f
6007	2	2064	3	In foreground	english	t	168	f
6009	1	2065	3	in den Hintergrund	deutsch	t	168	f
6010	2	2065	3	In backgroud	english	t	168	f
6015	1	2067	3	Z-Index erneuern	deutsch	t	168	f
6016	2	2067	3	renew Z-Index	english	t	168	f
6018	1	2068	3	Nr	deutsch	t	212	f
6019	2	2068	3	Nr	english	t	212	f
6024	1	2070	3	Zeit	deutsch	t	212	f
6025	2	2070	3	Time	english	t	212	f
6030	1	2072	3	aktiv	deutsch	t	212	f
6031	2	2072	3	active	english	t	212	f
5990	1	2059	2	Workflow	deutsch	t	\N	f
5993	1	2060	2	Workflow	deutsch	t	\N	f
1	1	1	1	Zugriff verweigert!	deutsch	t	2	f
4	1	4	1	Name	deutsch	t	4	f
7	1	7	1	Host	deutsch	t	4	f
8	1	8	1	IP	deutsch	t	4	f
9	1	9	1	Agent	deutsch	t	4	f
10	1	10	1	Authentifizierung	deutsch	t	4	f
11	1	11	1	Firma	deutsch	t	4	f
24	1	24	1	Wollen Sie einen neuen Datensatz anlegen?	deutsch	t	5	f
25	1	25	1	Ein unbestimmter Fehler ist aufgetreten!	deutsch	t	5	f
27	1	27	1	Zusatz	deutsch	t	12	f
29	1	29	1	Wert	deutsch	t	12	f
30	1	30	1	suchen	deutsch	t	12	f
33	1	33	1	übernehmen	deutsch	t	12	f
34	1	34	1	neuer Wert	deutsch	t	12	f
49	1	49	1	Wollen Sie diesen Datensatz archivieren?	deutsch	t	13	t
50	1	50	1	Wollen Sie diese Datei wirklich löschen?	deutsch	t	13	t
56	1	56	1	Ein Fehler ist aufgetreten!	deutsch	t	13	f
58	1	58	1	Syntaxfehler! Die Eingaben entsprechen nicht dem Datentyp.	deutsch	t	14	f
59	1	59	1	ersetze mit Wert	deutsch	t	14	f
60	1	60	1	bei Bedingung	deutsch	t	14	f
84	1	84	1	Wollen Sie diesen Datensatz wirklich löschen?	deutsch	t	17	f
86	1	86	1	Einträge	deutsch	t	17	f
88	1	88	1	Zeilen	deutsch	t	17	f
89	1	89	1	Seite	deutsch	t	17	f
93	1	93	1	Treffer	deutsch	t	17	f
96	1	96	1	zeige	deutsch	t	17	f
98	1	98	1	keine Datensätze vorhanden!	deutsch	t	17	f
101	1	101	1	Detailsuche	deutsch	t	19	f
102	1	102	1	nach	deutsch	t	19	f
103	1	103	1	suche in	deutsch	t	19	f
112	1	112	1	Dieser Eintrag kann nicht gelöscht werden, da bereits Werte ausgewählt sind!	deutsch	t	22	f
941	1	941	3	Referentielle Integrität	deutsch	t	139	f
115	1	115	1	Änderungen wurden zurückgesetzt!	deutsch	t	25	f
116	1	116	1	Datensatz wurde erfolgreich gelöscht!	deutsch	t	25	f
118	1	118	1	Sie haben keine Feldrechte!	deutsch	t	27	f
122	1	122	1	Keine Verknüpfung vorhanden	deutsch	t	34	f
126	1	126	1	Beschreibung	deutsch	t	34	f
133	1	133	1	Die upgeloadete Datei besitzt ein unbekanntes Format	deutsch	t	41	f
134	1	134	1	Eingabefehler! Folgende Felder wurden falsch ausgefüllt:	deutsch	t	37	f
138	1	138	1	Bitte überprüfen Sie die Richtigkeit Ihrer Eingaben.	deutsch	t	41	f
141	1	141	1	Passwort	deutsch	t	46	f
142	1	142	1	Vorname	deutsch	t	46	f
144	1	144	1	email	deutsch	t	46	f
106	1	106	1	enthält	deutsch	t	19	f
108	1	108	1	beginnt	deutsch	t	19	f
146	1	146	1	Allg. Einstellungen	deutsch	t	46	f
154	1	154	1	Eigene Farbliste	deutsch	t	47	f
155	1	155	1	Farbauswahl	deutsch	t	47	f
156	1	156	1	Farbwert	deutsch	t	47	f
160	1	160	1	löschen	deutsch	t	49	f
164	1	164	1	Tabelle	deutsch	t	49	f
168	1	168	1	Feld	deutsch	t	50	f
455	1	455	2	Gruppen	deutsch	t	\N	f
195	1	195	1	Es ist ein Fehler aufgetreten!	deutsch	t	54	f
197	1	197	1	Datum	deutsch	t	55	f
200	1	200	1	neue Vorlage	deutsch	t	55	f
209	1	209	1	Dateiname	deutsch	t	66	f
210	1	210	1	Größe	deutsch	t	66	f
242	1	242	2	Unterordner einbinden	deutsch	t	44	f
293	1	293	1	KW	deutsch	t	86	f
294	1	294	1	Farbe	deutsch	t	86	f
295	1	295	1	Bemerkung	deutsch	t	86	f
296	1	296	1	Monate	deutsch	t	86	f
297	1	297	1	starte	deutsch	t	86	f
300	1	300	1	Kalenderansicht	deutsch	t	86	f
301	1	301	1	Tabellenansicht	deutsch	t	86	f
302	1	302	1	eintragen	deutsch	t	86	f
303	1	303	1	Kein Eintrag!	deutsch	t	87	f
304	1	304	1	Kalenderübersicht	deutsch	t	88	f
311	1	311	1	Mo	deutsch	t	88	f
312	1	312	1	Di	deutsch	t	88	f
313	1	313	1	Mi	deutsch	t	88	f
314	1	314	1	Do	deutsch	t	88	f
315	1	315	1	Fr	deutsch	t	88	f
316	1	316	1	Sa	deutsch	t	88	f
317	1	317	1	So	deutsch	t	88	f
353	1	353	2	bearbeiten	deutsch	t	\N	f
354	1	354	2	Liste bearbeiten	deutsch	t	\N	f
355	1	355	2	Bemerkung	deutsch	t	\N	f
356	1	356	2	Verknüpfungs-Bemerkungen	deutsch	t	\N	f
357	1	357	2	Details	deutsch	t	\N	f
358	1	358	2	Datensatz Detailansicht	deutsch	t	\N	f
359	1	359	2	Export	deutsch	t	\N	f
360	1	360	2	Liste exportieren	deutsch	t	\N	f
361	1	361	2	anpassen	deutsch	t	\N	f
362	1	362	2	Mehrfachauswahlfeld bearbeiten	deutsch	t	\N	f
367	1	367	2	löschen	deutsch	t	\N	f
368	1	368	2	Datensatz löschen	deutsch	t	\N	f
391	1	391	2	drucken	deutsch	t	\N	f
392	1	392	2	Druckausgabe	deutsch	t	\N	f
393	1	393	2	maximieren	deutsch	t	\N	f
394	1	394	2	Anzeige maximieren	deutsch	t	\N	f
395	1	395	2	minimieren	deutsch	t	\N	f
396	1	396	2	Anzeige minimieren	deutsch	t	\N	f
401	1	401	2	Auswahl zurücksetzen	deutsch	t	\N	f
402	1	402	2	löschen von Such und Filterkriterien	deutsch	t	\N	f
403	1	403	2	Einstellungen	deutsch	t	\N	f
404	1	404	2	Allg. User Einstellungen	deutsch	t	\N	f
409	1	409	2	Farben	deutsch	t	\N	f
410	1	410	2	User Farbauswahl	deutsch	t	\N	f
415	1	415	2	Nachrichten	deutsch	t	\N	f
416	1	416	2	Nachrichtensystem	deutsch	t	\N	f
417	1	417	2	neue Nachricht	deutsch	t	\N	f
418	1	418	2	neue Nachricht erstellen	deutsch	t	\N	f
421	1	421	2	suche	deutsch	t	\N	f
422	1	422	2	Nachrichten suchen	deutsch	t	\N	f
427	1	427	2	Vorlagen	deutsch	t	\N	f
429	1	429	2	User anlegen	deutsch	t	\N	f
430	1	430	2	User anlegen	deutsch	t	\N	f
443	1	443	2	Import	deutsch	t	\N	f
444	1	444	2	Import	deutsch	t	\N	f
456	1	456	2	Gruppenverwaltung	deutsch	t	\N	f
461	1	461	2	Setup	deutsch	t	\N	f
462	1	462	2	Allgemeine Einstellungen	deutsch	t	\N	f
463	1	463	2	Tools	deutsch	t	\N	f
464	1	464	2	Tools	deutsch	t	\N	f
465	1	465	2	Berichte	deutsch	t	\N	f
466	1	466	2	Berichte bearbeiten	deutsch	t	\N	f
473	1	473	2	Größe	deutsch	t	\N	f
474	1	474	2	Bericht Element-Größe	deutsch	t	\N	f
475	1	475	2	Inhalt	deutsch	t	\N	f
476	1	476	2	Bericht Element-Inhalt	deutsch	t	\N	f
477	1	477	2	Darstellung	deutsch	t	\N	f
478	1	478	2	Bericht Element-Style	deutsch	t	\N	f
517	1	517	3	Argument	deutsch	t	101	f
518	1	518	3	Umg.-Variablen	deutsch	t	101	f
519	1	519	3	Username	deutsch	t	101	f
520	1	520	3	Vollständiger Name	deutsch	t	101	f
521	1	521	3	E-Mail	deutsch	t	101	f
522	1	522	3	ändern	deutsch	t	101	f
529	1	529	3	RGB-Farbwerte	deutsch	t	106	f
530	1	530	3	HEX-Farbwerte	deutsch	t	106	f
540	1	540	3	hinzufügen	deutsch	t	106	f
543	1	543	3	Zeitpunkt	deutsch	t	108	f
544	1	544	3	Aktion	deutsch	t	108	f
545	1	545	3	Datei	deutsch	t	108	f
546	1	546	3	Zeile	deutsch	t	108	f
547	1	547	3	Fehlermeldung	deutsch	t	108	f
548	1	548	3	SQL_Query	deutsch	t	108	f
561	1	561	3	Gruppe	deutsch	t	115	f
563	1	563	3	angelegt	deutsch	t	115	f
569	1	569	3	Name der Gruppe	deutsch	t	119	f
571	1	571	3	anlegen	deutsch	t	119	f
573	1	573	3	Menü	deutsch	t	120	f
575	1	575	3	Rechte	deutsch	t	120	f
577	1	577	3	Tabellen	deutsch	t	120	f
600	1	600	3	schon vorhanden!	deutsch	t	111	f
612	1	612	3	Email	deutsch	t	127	f
616	1	616	3	max. Anzahl Treffer	deutsch	t	127	f
623	1	623	3	Farbschema	deutsch	t	127	f
624	1	624	3	Sprache	deutsch	t	127	f
632	1	632	3	Aktiv	deutsch	t	46	f
633	1	633	3	Inaktiv	deutsch	t	46	f
11906	4	2700	3	Paramètres du calendrier	francais	t	164	f
11958	4	2713	3	onglet Tableau	francais	t	173	f
7309	4	1723	3	Date et heure	francais	t	110	f
656	1	656	3	Log-Level	deutsch	t	132	f
657	1	657	3	sperren	deutsch	t	132	f
672	1	672	3	Nachname	deutsch	t	136	f
698	1	698	1	Layout	deutsch	t	46	f
700	1	700	1	öffne Quick-Kalender	deutsch	t	34	f
927	1	927	3	unique	deutsch	t	110	f
363	1	363	2	Info	deutsch	t	\N	f
364	1	364	2	Datensatz Informationen	deutsch	t	\N	f
704	1	704	1	Ergebnisfenster teilen	deutsch	t	46	f
711	1	711	1	größer	deutsch	t	19	f
441	1	441	2	Export	deutsch	t	\N	f
442	1	442	2	Export	deutsch	t	\N	f
457	1	457	2	Tabellen	deutsch	t	\N	f
458	1	458	2	Tabellen bearbeiten	deutsch	t	\N	f
495	1	495	2	allgemein	deutsch	t	\N	f
496	1	496	2	allg. Usereinstellungen	deutsch	t	\N	f
497	1	497	2	Tabellenrechte	deutsch	t	\N	f
453	1	453	2	User/Gruppen	deutsch	t	\N	f
454	1	454	2	User/Grupen-Verwaltung	deutsch	t	\N	f
451	1	451	2	Statistik	deutsch	t	\N	f
452	1	452	2	User Diagramm Statistik	deutsch	t	\N	f
712	1	712	1	kleiner	deutsch	t	19	f
713	1	713	1	gleich	deutsch	t	19	f
715	1	715	1	öffne Auswahldetails	deutsch	t	34	f
716	1	716	3	max. Uploadgröße	deutsch	t	127	f
722	1	722	1	Datensatz:	deutsch	t	13	f
605	1	605	3	Es müssen mindestens Username, Passwort und Hauptgruppe angegeben werden!	deutsch	t	126	f
745	1	745	1	geänderte Werte übernehmen!	deutsch	t	37	f
749	1	749	1	letzter Login	deutsch	t	4	f
752	1	752	2	Diagramme	deutsch	t	\N	f
753	1	753	2	Diagrammeditor	deutsch	t	\N	f
763	1	763	1	Dieser Datensatz ist gesperrt und kann momentan nicht  bearbeitet werden!	deutsch	t	23	f
764	1	764	1	Die Rechte dieses Datensatzes wurden entzogen oder er wurde entfernt!	deutsch	t	23	f
767	1	767	1	Nachrichten	deutsch	t	145	f
768	1	768	1	empfangen	deutsch	t	145	f
769	1	769	1	gesendet	deutsch	t	154	f
770	1	770	1	gelöscht	deutsch	t	154	f
771	1	771	2	umbenennen	deutsch	t	\N	f
772	1	772	2	Ordner/Datei umbenennen	deutsch	t	\N	f
777	1	777	2	neuer Ordner	deutsch	t	\N	f
778	1	778	2	neuen Ordner erstellen	deutsch	t	\N	f
483	1	483	2	Nutzungsrechte	deutsch	t	\N	f
784	1	784	2	verschieben	deutsch	t	\N	f
785	1	785	2	Nachricht verschieben	deutsch	t	\N	f
786	1	786	2	antworten	deutsch	t	\N	f
787	1	787	2	Nachricht antworten	deutsch	t	\N	f
788	1	788	2	weiterleiten	deutsch	t	\N	f
789	1	789	2	Nachricht weiterleiten	deutsch	t	\N	f
790	1	790	2	ungelesen	deutsch	t	\N	f
791	1	791	2	Nachricht als ungelesen markieren	deutsch	t	\N	f
812	1	812	1	Eigene Dateien	deutsch	t	3	f
813	1	813	1	öffentlicher Ordner	deutsch	t	3	f
817	1	817	2	kopieren	deutsch	t	\N	f
818	1	818	2	Dateien/Ordner kopieren	deutsch	t	\N	f
819	1	819	2	ausschneiden	deutsch	t	\N	f
820	1	820	2	Dateien/Ordner verschieben	deutsch	t	\N	f
821	1	821	1	Wollen Sie diesen Ordner und seinen Inhalt löschen?	deutsch	t	68	f
822	1	822	1	Wollen Sie die Dateien/Ordner löschen?	deutsch	t	66	f
828	1	828	2	Formular	deutsch	t	\N	f
829	1	829	2	Formular	deutsch	t	\N	f
830	1	830	2	Herkunft	deutsch	t	\N	f
831	1	831	2	Verknüpfung rückverfolgen	deutsch	t	\N	f
842	1	842	1	speichern	deutsch	t	54	f
843	1	843	1	bearbeiten	deutsch	t	54	f
844	1	844	1	schließen	deutsch	t	54	f
851	1	851	1	Spalte	deutsch	t	5	f
854	1	854	1	und	deutsch	t	19	f
855	1	855	1	oder	deutsch	t	19	f
856	1	856	1	Wollen Sie die Session wirklich löschen?	deutsch	t	46	f
857	1	857	1	zum Anfang	deutsch	t	13	f
858	1	858	1	zum Ende	deutsch	t	13	f
859	1	859	1	nächster	deutsch	t	13	f
860	1	860	1	vorheriger	deutsch	t	13	f
866	1	866	1	NEIN	deutsch	t	5	f
867	1	867	1	JA	deutsch	t	5	f
869	1	869	1	benachrichtigen	deutsch	t	15	f
870	1	870	1	Website öffnen	deutsch	t	15	f
873	1	873	1	Sonntag	deutsch	t	41	f
874	1	874	1	Montag	deutsch	t	41	f
875	1	875	1	Dienstag	deutsch	t	41	f
876	1	876	1	Mittwoch	deutsch	t	41	f
877	1	877	1	Donnerstag	deutsch	t	41	f
878	1	878	1	Freitag	deutsch	t	41	f
879	1	879	1	Samstag	deutsch	t	41	f
880	1	880	1	Januar	deutsch	t	41	f
881	1	881	1	Februar	deutsch	t	41	f
882	1	882	1	März	deutsch	t	41	f
883	1	883	1	April	deutsch	t	41	f
884	1	884	1	Mai	deutsch	t	41	f
885	1	885	1	Juni	deutsch	t	41	f
886	1	886	1	Juli	deutsch	t	41	f
887	1	887	1	August	deutsch	t	41	f
888	1	888	1	September	deutsch	t	41	f
889	1	889	1	Oktober	deutsch	t	41	f
890	1	890	1	November	deutsch	t	41	f
1548	2	382	2	help	english	t	0	f
838	1	838	2	Administrieren	deutsch	t	\N	f
839	1	839	2	User administrieren	deutsch	t	\N	f
891	1	891	1	Dezember	deutsch	t	41	f
897	1	897	3	Untergruppe von	deutsch	t	119	f
899	1	899	3	Wollen Sie die Session dieses Users löschen?	deutsch	t	127	f
900	1	900	3	Hauptgruppe	deutsch	t	127	f
901	1	901	3	Untergruppen	deutsch	t	127	f
903	1	903	3	IP-range	deutsch	t	127	f
904	1	904	3	Sessionrefresh	deutsch	t	127	f
905	1	905	3	Tabellenrechte zurücksetzten	deutsch	t	127	f
907	1	907	3	Menürechte zurücksetzten	deutsch	t	127	f
908	1	908	3	Wollen Sie den User	deutsch	t	132	f
911	1	911	3	Debug	deutsch	t	132	f
916	1	916	3	Linkgenerator	deutsch	t	107	f
917	1	917	3	Eingabe des absoluten Links!	deutsch	t	107	f
925	1	925	3	Typ	deutsch	t	110	f
926	1	926	3	Schlüssel	deutsch	t	110	f
928	1	928	3	Defaultwert	deutsch	t	110	f
930	1	930	3	konvertieren	deutsch	t	110	f
931	1	931	3	ajax	deutsch	t	110	f
939	1	939	3	Verknüpfungen in	deutsch	t	139	f
940	1	940	3	eingetragen	deutsch	t	139	f
942	1	942	3	hinzugefügt	deutsch	t	139	f
834	1	834	2	allgemein	deutsch	t	\N	f
835	1	835	2	allgemeine Gruppeneinstellungen	deutsch	t	\N	f
949	1	949	3	ID	deutsch	t	140	f
951	1	951	3	Tabellenname	deutsch	t	140	f
952	1	952	3	Pos	deutsch	t	140	f
953	1	953	3	Felder	deutsch	t	140	f
961	1	961	3	Archivierung Tabelle	deutsch	t	145	f
962	1	962	3	Excel Export	deutsch	t	145	f
963	1	963	3	Text Export	deutsch	t	145	f
964	1	964	3	System Export	deutsch	t	145	f
965	1	965	3	Teil-Export	deutsch	t	145	f
966	1	966	3	Komplett-System	deutsch	t	145	f
967	1	967	3	Komplett-Export	deutsch	t	145	f
968	1	968	3	Projekt-Export	deutsch	t	145	f
970	1	970	3	Der Export war erfolgreich	deutsch	t	145	f
12737	2	2907	2	Revision manager	english	t	0	f
12741	2	2908	2	Revision manager	english	t	0	f
971	1	971	3	Insgesamt wurden	deutsch	t	145	f
972	1	972	3	Datensätze	deutsch	t	145	f
973	1	973	3	exportiert	deutsch	t	145	f
974	1	974	3	Export-Verzeichnis	deutsch	t	145	f
977	1	977	3	Dateien zusammenfassen	deutsch	t	145	f
979	1	979	3	starten	deutsch	t	145	f
987	1	987	3	fertig	deutsch	t	147	f
988	1	988	3	Folgende Felder haben ein ungültiges Format	deutsch	t	148	f
12745	2	2909	1	assigned to	english	t	0	f
12753	2	2911	3	activates automatic deletion and re-insertion of dependent queries	english	t	110	f
12757	2	2912	3	Dependencies	english	t	110	f
12761	2	2913	3	last	english	t	139	f
12765	2	2914	2	Synchronisation	english	t	0	f
12766	4	2914	2	synchronisation	francais	t	0	f
990	1	990	3	Teil-Import	deutsch	t	148	f
991	1	991	3	Text-Import	deutsch	t	148	f
992	1	992	3	aus Textdatei	deutsch	t	148	f
993	1	993	3	keine	deutsch	t	148	f
994	1	994	3	alle	deutsch	t	148	f
995	1	995	3	System-Import	deutsch	t	148	f
12769	2	2915	2	Data synchronisation	english	t	0	f
12781	2	2918	3	open	english	t	110	f
12785	2	2919	3	will be marked as open in the table view	english	t	110	f
12767	3	2915	2	sincronización de datos	Espagñol	t	0	f
12779	3	2918	3	desplegar	Espagñol	t	110	f
12783	3	2919	3	está marcado como abierto en la vista de tabla	Espagñol	t	110	f
12770	4	2915	2	synchronisation des données	francais	t	0	f
12782	4	2918	3	ouvrir	francais	t	110	f
12786	4	2919	3	est marqué comme ouvert dans la vue de la table	francais	t	110	f
997	1	997	3	Zeilenvorschau	deutsch	t	148	f
998	1	998	3	aus Systemdatei	deutsch	t	148	f
1002	1	1002	3	überschreiben	deutsch	t	148	f
1003	1	1003	3	anhängen	deutsch	t	148	f
1004	1	1004	3	ID beibehalten	deutsch	t	148	f
1006	1	1006	3	Komplett-Import	deutsch	t	148	f
1007	1	1007	3	Config-Datei	deutsch	t	148	f
1009	1	1009	3	reinstallieren	deutsch	t	148	f
1010	1	1010	3	falscher Feldtyp	deutsch	t	149	f
1011	1	1011	3	Datensätze eingefügt	deutsch	t	149	f
1012	1	1012	3	Fehler	deutsch	t	149	f
1014	1	1014	3	Instanz testen	deutsch	t	149	f
1015	1	1015	3	Daten in Tabelle einfügen	deutsch	t	149	f
1016	1	1016	3	Reihen fehlgeschlagen	deutsch	t	149	f
1017	1	1017	3	Reihen eingefügt	deutsch	t	149	f
1018	1	1018	3	erstellt	deutsch	t	149	f
1019	1	1019	3	fehlgeschlagen	deutsch	t	149	f
1020	1	1020	3	erstelle Tabelle	deutsch	t	149	f
1021	1	1021	3	lösche Tabelle	deutsch	t	149	f
1022	1	1022	3	Import Report	deutsch	t	149	f
1024	1	1024	3	indiziert	deutsch	t	149	f
1025	1	1025	3	Indizierung Tabelle	deutsch	t	149	f
1026	1	1026	3	foreign key hinzufügen	deutsch	t	149	f
1029	1	1029	3	Tabellengruppe	deutsch	t	150	f
1036	1	1036	3	Struktur	deutsch	t	150	f
1037	1	1037	3	Struktur und Daten	deutsch	t	150	f
1038	1	1038	3	erstellen	deutsch	t	150	f
1039	1	1039	3	vorhanden	deutsch	t	151	f
1040	1	1040	3	importieren	deutsch	t	151	f
12778	4	2917	2	Synchronisation ID esclave 	francais	t	0	f
12775	3	2917	2	Sincronización ID esclavo 	Espagñol	t	0	f
12777	2	2917	2	Sync slave ID 	english	t	0	f
922	1	922	3	Feldname	deutsch	t	110	f
924	1	924	3	Bezeichnung	deutsch	t	110	f
932	1	932	3	Auswahlsuche	deutsch	t	110	f
1054	1	1054	3	Tabellen und Feldrechte abgleichen	deutsch	t	154	f
1056	1	1056	3	Menürechte abgleichen	deutsch	t	154	f
1551	2	385	2	Tables	english	t	0	f
1057	1	1057	3	Alle Sessions löschen	deutsch	t	154	f
1060	1	1060	3	System-Info	deutsch	t	155	f
1061	1	1061	3	zeigen	deutsch	t	155	f
1065	1	1065	3	ausführen	deutsch	t	155	f
1067	1	1067	3	Priviligien	deutsch	t	155	f
1068	1	1068	3	Erstellungsdatum	deutsch	t	155	f
1069	1	1069	3	Tabelle erfolgreich geleert	deutsch	t	156	f
1070	1	1070	3	Fehler! Die Tabelle wurde nicht geleert.	deutsch	t	156	f
1071	1	1071	3	Tabelle erfolgreich gelöscht	deutsch	t	156	f
1072	1	1072	3	Fehler! Die Tabelle wurde nicht gelöscht.	deutsch	t	156	f
2456	1	1268	2	Tabellenrechte	deutsch	t	\N	f
2458	1	1269	2	Tabellenrechte-Aktualisierung	deutsch	t	\N	f
2460	1	1270	2	Nutzungsrechte	deutsch	t	\N	f
2462	1	1271	2	Nutzungsrechte Aktualisierung	deutsch	t	\N	f
12764	1	2914	2	Synchronisation	deutsch	t	0	f
12768	1	2915	2	Datensynchronisation	deutsch	t	0	f
1073	1	1073	3	SQL-Query erfolgreich ausgeführt	deutsch	t	156	f
1078	1	1078	3	Regel	deutsch	t	160	f
1083	1	1083	3	URL	deutsch	t	162	f
1087	1	1087	3	Bild	deutsch	t	162	f
1099	1	1099	3	Element	deutsch	t	168	f
1100	1	1100	3	Bild-Infos	deutsch	t	168	f
1102	1	1102	3	Darstellung	deutsch	t	168	f
1104	1	1104	3	Fontfarbe	deutsch	t	168	f
1105	1	1105	3	Dicke	deutsch	t	168	f
1107	1	1107	3	Hintergrundfarbe	deutsch	t	168	f
1108	1	1108	3	spiegeln	deutsch	t	168	f
1109	1	1109	3	Spalten	deutsch	t	168	f
1111	1	1111	3	Abstand	deutsch	t	168	f
1112	1	1112	3	Kopf	deutsch	t	168	f
1113	1	1113	3	Fuß	deutsch	t	168	f
1114	1	1114	3	Liste	deutsch	t	168	f
1115	1	1115	3	Schriftstil	deutsch	t	168	f
1116	1	1116	3	Schriftgewicht	deutsch	t	168	f
1117	1	1117	3	Textdekoration	deutsch	t	168	f
1118	1	1118	3	Texttransform	deutsch	t	168	f
1119	1	1119	3	Textausrichtung	deutsch	t	168	f
1120	1	1120	3	Zeilenabstand	deutsch	t	168	f
1084	1	1084	3	Icon	deutsch	t	162	f
1121	1	1121	3	Zeichenabstand	deutsch	t	168	f
1122	1	1122	3	Wortabstand	deutsch	t	168	f
1123	1	1123	3	normal	deutsch	t	168	f
1124	1	1124	3	kursiv	deutsch	t	168	f
1125	1	1125	3	fett	deutsch	t	168	f
1126	1	1126	3	unterstrichen	deutsch	t	168	f
1127	1	1127	3	Großbuchstaben	deutsch	t	168	f
1128	1	1128	3	Kleinbuchstaben	deutsch	t	168	f
1129	1	1129	3	Blocksatz	deutsch	t	168	f
1130	1	1130	3	linksbündig	deutsch	t	168	f
1131	1	1131	3	zentriert	deutsch	t	168	f
1132	1	1132	3	rechtsbündig	deutsch	t	168	f
1134	1	1134	3	Historie	deutsch	t	168	f
1136	1	1136	3	neuberechnen	deutsch	t	168	f
1138	1	1138	3	Z-Satz	deutsch	t	169	f
1140	1	1140	3	Seitengröße (mm)	deutsch	t	169	f
1141	1	1141	3	Breite	deutsch	t	169	f
1142	1	1142	3	Höhe	deutsch	t	169	f
1143	1	1143	3	Seitenränder (mm)	deutsch	t	169	f
1144	1	1144	3	oben	deutsch	t	169	f
1145	1	1145	3	unten	deutsch	t	169	f
1146	1	1146	3	links	deutsch	t	169	f
1147	1	1147	3	rechts	deutsch	t	169	f
1148	1	1148	3	Proportionen erhalten	deutsch	t	169	f
1149	1	1149	3	Textblock	deutsch	t	169	f
1150	1	1150	3	Dateninhalte	deutsch	t	169	f
1151	1	1151	3	Graphik	deutsch	t	169	f
1152	1	1152	3	Linie	deutsch	t	169	f
1153	1	1153	3	Rechteck	deutsch	t	169	f
1154	1	1154	3	Ellipse	deutsch	t	169	f
1157	1	1157	3	Seiten-Nr	deutsch	t	169	f
1162	1	1162	3	für Tabelle	deutsch	t	170	f
1165	1	1165	3	neuer Bericht	deutsch	t	170	f
1167	1	1167	3	Die Graphik konnte nicht erfolgreich gespeichert werden	deutsch	t	172	f
1170	1	1170	3	Zeichensatz	deutsch	t	175	f
1490	2	312	1	Tue	english	t	88	f
1171	1	1171	3	Unterformular	deutsch	t	175	f
1174	1	1174	3	Submit-Button	deutsch	t	175	f
1176	1	1176	3	Qualität	deutsch	t	175	f
1179	1	1179	3	Formular	deutsch	t	176	f
1183	1	1183	3	Entwurf Einspaltig	deutsch	t	176	f
1184	1	1184	3	Entwurf Liste	deutsch	t	176	f
1186	1	1186	3	neues Formular	deutsch	t	176	f
1191	1	1191	3	neues Diagramm	deutsch	t	177	f
1200	1	1200	2	Datei-Manager	deutsch	t	\N	f
1201	1	1201	2	Datei-Manager	deutsch	t	\N	f
1163	1	1163	3	Standardformat	deutsch	t	170	f
1173	1	1173	3	Scroll-Leiste einzeln	deutsch	t	175	f
1421	2	242	2	integrate subfolder	english	t	44	f
1473	2	295	1	remark	english	t	86	f
1474	2	296	1	months	english	t	86	f
1475	2	297	1	start	english	t	86	f
1478	2	300	1	calendar-view	english	t	86	f
1479	2	301	1	table-view	english	t	86	f
1480	2	302	1	register	english	t	86	f
1481	2	303	1	no entry!	english	t	87	f
1482	2	304	1	calendar overview	english	t	88	f
1521	2	353	2	edit	english	t	0	f
1523	2	355	2	remark	english	t	0	f
1525	2	357	2	details	english	t	0	f
1526	2	358	2	record detail	english	t	0	f
1527	2	359	2	export	english	t	0	f
1528	2	360	2	csv export	english	t	0	f
1529	2	361	2	adjust	english	t	0	f
1530	2	362	2	edit multi-select	english	t	0	f
1531	2	363	2	info	english	t	0	f
1532	2	364	2	record information	english	t	0	f
1535	2	367	2	delete	english	t	0	f
1536	2	368	2	delete record	english	t	0	f
1541	2	373	2	search	english	t	0	f
1542	2	374	2	search record	english	t	0	f
1545	2	379	2	admin	english	t	0	f
1547	2	381	2	help	english	t	0	f
1552	2	386	2	Tables	english	t	0	f
1553	2	387	2	My profile	english	t	0	f
1557	2	391	2	print	english	t	0	f
1558	2	392	2	printout	english	t	0	f
1559	2	393	2	maximize	english	t	0	f
1560	2	394	2	maximize display	english	t	0	f
1561	2	395	2	minimize	english	t	0	f
1562	2	396	2	minimize display	english	t	0	f
1569	2	403	2	settings	english	t	0	f
1577	2	415	2	messages	english	t	0	f
1578	2	416	2	messaging-system	english	t	0	f
1579	2	417	2	new message	english	t	0	f
1580	2	418	2	create new message	english	t	0	f
1583	2	421	2	search	english	t	0	f
1593	2	431	2	env-var	english	t	0	f
1594	2	432	2	environment variables	english	t	0	f
1599	2	437	2	scheme	english	t	0	f
1600	2	438	2	colour-table	english	t	0	f
1601	2	439	2	colours	english	t	0	f
1602	2	440	2	colour-table	english	t	0	f
1603	2	441	2	export	english	t	0	f
1604	2	442	2	export	english	t	0	f
1605	2	443	2	import	english	t	0	f
1606	2	444	2	import	english	t	0	f
1609	2	451	2	statistics	english	t	0	f
1610	2	452	2	user diagram statistics	english	t	0	f
1611	2	453	2	user/groups	english	t	0	f
1612	2	454	2	user/groups administration	english	t	0	f
1613	2	455	2	groups	english	t	0	f
1614	2	456	2	group administration	english	t	0	f
1615	2	457	2	tables	english	t	0	f
1617	2	459	2	error-report	english	t	0	f
1618	2	460	2	error-report	english	t	0	f
1619	2	461	2	setup	english	t	0	f
1620	2	462	2	general settings	english	t	0	f
1524	2	356	2	relation-remark	english	t	0	f
1597	2	435	2	menu functions	english	t	0	f
2264	2	1142	3	height	english	t	169	f
1598	2	436	2	menu functions	english	t	0	f
1489	2	311	1	Mon	english	t	88	f
1491	2	313	1	Wed	english	t	88	f
1492	2	314	1	Thu	english	t	88	f
1493	2	315	1	Fri	english	t	88	f
1494	2	316	1	Sat	english	t	88	f
1495	2	317	1	Sun	english	t	88	f
1621	2	463	2	tools	english	t	0	f
1622	2	464	2	tools	english	t	0	f
1623	2	465	2	reports	english	t	0	f
1624	2	466	2	edit reports	english	t	0	f
1631	2	473	2	size	english	t	0	f
1632	2	474	2	element-size report	english	t	0	f
1633	2	475	2	content	english	t	0	f
1634	2	476	2	element-content report	english	t	0	f
1635	2	477	2	representation	english	t	0	f
1636	2	478	2	element-style report	english	t	0	f
1647	2	495	2	general	english	t	0	f
1648	2	496	2	general user-settings	english	t	0	f
1653	2	501	2	SQL Editor	english	t	0	f
1667	2	517	3	argument	english	t	101	f
1668	2	518	3	environment variable	english	t	101	f
1669	2	519	3	username	english	t	101	f
1670	2	520	3	whole name	english	t	101	f
1671	2	521	3	email	english	t	101	f
1672	2	522	3	change	english	t	101	f
1679	2	529	3	RGB-colours	english	t	106	f
1680	2	530	3	HEX-colours	english	t	106	f
1690	2	540	3	add	english	t	106	f
1693	2	543	3	date	english	t	108	f
1694	2	544	3	action	english	t	108	f
1695	2	545	3	file	english	t	108	f
1696	2	546	3	row	english	t	108	f
1697	2	547	3	error message	english	t	108	f
1698	2	548	3	SQL-query	english	t	108	f
1711	2	561	3	group	english	t	115	f
1719	2	569	3	group name	english	t	119	f
1721	2	571	3	create	english	t	119	f
1723	2	573	3	menu	english	t	120	f
1725	2	575	3	rights	english	t	120	f
1727	2	577	3	tables	english	t	120	f
1739	2	600	3	already exists!	english	t	111	f
1751	2	612	3	email	english	t	127	f
1763	2	624	3	language	english	t	127	f
1771	2	632	3	active	english	t	46	f
1772	2	633	3	inactive	english	t	46	f
1795	2	656	3	Log-Level	english	t	132	f
1796	2	657	3	lock	english	t	132	f
1811	2	672	3	surname	english	t	136	f
1827	2	698	1	layout	english	t	46	f
1829	2	700	1	open quick-calendar	english	t	34	f
1833	2	704	1	splitt result-window	english	t	46	f
1841	2	713	1	equal	english	t	19	f
1842	2	715	1	open selection details	english	t	34	f
1843	2	716	3	max. uploadsize	english	t	127	f
1849	2	722	1	record:	english	t	13	f
1851	2	724	2	forms	english	t	0	f
1852	2	725	2	form-editor	english	t	0	f
1853	2	726	2	language	english	t	0	f
1854	2	727	2	language-table	english	t	0	f
1858	2	731	2	Forms	english	t	0	f
1859	2	732	2	forms	english	t	0	f
1862	2	735	2	query	english	t	0	f
1863	2	736	2	table query	english	t	0	f
1874	2	749	1	last login	english	t	4	f
1875	2	750	2	Diagrams	english	t	0	f
1876	2	751	2	score-diagrams	english	t	0	f
1877	2	752	2	diagrams	english	t	0	f
1878	2	753	2	diagram-editor	english	t	0	f
1892	2	767	1	messages	english	t	145	f
1893	2	768	1	received	english	t	145	f
1894	2	769	1	sent	english	t	154	f
1895	2	770	1	deleted	english	t	154	f
1896	2	771	2	rename	english	t	0	f
1897	2	772	2	rename folder	english	t	0	f
1649	2	497	2	table rights	english	t	0	f
1839	2	711	1	higher	english	t	19	f
1870	2	745	1	save changes	english	t	37	f
1888	2	763	1	This record is locked and can currently not be  edited!	english	t	23	f
1639	2	483	2	menu rights	english	t	0	f
1640	2	484	2	define menu rights	english	t	0	f
1840	2	712	1	lower	english	t	19	f
1900	2	777	2	new folder	english	t	0	f
1901	2	778	2	create new folder	english	t	0	f
1907	2	784	2	move	english	t	0	f
1908	2	785	2	move message	english	t	0	f
1909	2	786	2	answer	english	t	0	f
1910	2	787	2	answer message	english	t	0	f
1913	2	790	2	unread	english	t	0	f
1914	2	791	2	set message as unread	english	t	0	f
1936	2	813	1	public folder	english	t	3	f
1939	2	816	2	create new file	english	t	0	f
1940	2	817	2	copy	english	t	0	f
1951	2	828	2	form	english	t	0	f
1952	2	829	2	form	english	t	0	f
1957	2	834	2	general	english	t	0	f
1958	2	835	2	general group-settings	english	t	0	f
1965	2	842	1	save	english	t	54	f
1966	2	843	1	edit	english	t	54	f
1967	2	844	1	close	english	t	54	f
1970	2	847	2	background	english	t	0	f
1974	2	851	1	column	english	t	5	f
1977	2	854	1	and	english	t	19	f
1978	2	855	1	or	english	t	19	f
1980	2	857	1	to begin	english	t	13	f
1981	2	858	1	to end	english	t	13	f
1982	2	859	1	next	english	t	13	f
1983	2	860	1	previous	english	t	13	f
1989	2	866	1	no	english	t	5	f
1990	2	867	1	yes	english	t	5	f
1992	2	869	1	inform	english	t	15	f
2019	2	897	3	subgroup of	english	t	119	f
2022	2	900	3	main group	english	t	127	f
2023	2	901	3	subgroups	english	t	127	f
2025	2	903	3	IP-range	english	t	127	f
2026	2	904	3	session-refresh	english	t	127	f
2033	2	911	3	debug	english	t	132	f
2038	2	916	3	link generator	english	t	107	f
2266	2	1144	3	top	english	t	169	f
2039	2	917	3	entry absolute link!	english	t	107	f
2047	2	925	3	type	english	t	110	f
2048	2	926	3	key	english	t	110	f
2049	2	927	3	unique	english	t	110	f
2052	2	930	3	convert	english	t	110	f
2053	2	931	3	ajax	english	t	110	f
2062	2	940	3	registered	english	t	139	f
1898	2	773	2	advanced search	english	t	0	f
1899	2	774	2	advanced search	english	t	0	f
1911	2	788	2	forward	english	t	0	f
1953	2	830	2	origin	english	t	0	f
1961	2	838	2	administrate	english	t	0	f
1962	2	839	2	administrate user	english	t	0	f
1963	2	840	2	create group	english	t	0	f
1964	2	841	2	create group	english	t	0	f
1971	2	848	2	background-colour	english	t	0	f
1979	2	856	1	Do you want to delete the session?	english	t	46	f
1984	2	861	1	ascending	english	t	5	f
1985	2	862	1	desending	english	t	5	f
1993	2	870	1	open webpage	english	t	15	f
2064	2	942	3	added	english	t	139	f
2071	2	949	3	ID	english	t	140	f
2073	2	951	3	tablename	english	t	140	f
2074	2	952	3	pos	english	t	140	f
2075	2	953	3	fields	english	t	140	f
2083	2	961	3	table archive	english	t	145	f
2084	2	962	3	excel export	english	t	145	f
2085	2	963	3	text export	english	t	145	f
2086	2	964	3	system export	english	t	145	f
2087	2	965	3	Partial export	english	t	145	f
2088	2	966	3	complete system	english	t	145	f
2089	2	967	3	Complete export	english	t	145	f
2090	2	968	3	Project export	english	t	145	f
2093	2	971	3	altogether	english	t	145	f
2094	2	972	3	records	english	t	145	f
2095	2	973	3	export	english	t	145	f
2096	2	974	3	export directory	english	t	145	f
2101	2	979	3	start	english	t	145	f
2109	2	987	3	done	english	t	147	f
2110	2	988	3	the following fields have the wrong format	english	t	148	f
2112	2	990	3	partial-import	english	t	148	f
2113	2	991	3	text-import	english	t	148	f
2115	2	993	3	none	english	t	148	f
2116	2	994	3	all	english	t	148	f
2117	2	995	3	system-import	english	t	148	f
2119	2	997	3	row-preview	english	t	148	f
2120	2	998	3	from system-file	english	t	148	f
2124	2	1002	3	overwrite	english	t	148	f
2126	2	1004	3	keep ID	english	t	148	f
2128	2	1006	3	complete-import	english	t	148	f
2129	2	1007	3	config-file	english	t	148	f
2131	2	1009	3	reinstall	english	t	148	f
2132	2	1010	3	wrong fieldtype	english	t	149	f
2133	2	1011	3	records inserted	english	t	149	f
2134	2	1012	3	error	english	t	149	f
2136	2	1014	3	test instance	english	t	149	f
2137	2	1015	3	insert data in table	english	t	149	f
2138	2	1016	3	rows failed	english	t	149	f
2139	2	1017	3	rows inserted	english	t	149	f
2140	2	1018	3	created	english	t	149	f
2141	2	1019	3	failed	english	t	149	f
2142	2	1020	3	create table	english	t	149	f
2143	2	1021	3	delete table	english	t	149	f
2144	2	1022	3	import report	english	t	149	f
2146	2	1024	3	indicated	english	t	149	f
2147	2	1025	3	table indication	english	t	149	f
2148	2	1026	3	add foreign key	english	t	149	f
2151	2	1029	3	table-group	english	t	150	f
2160	2	1038	3	create	english	t	150	f
2162	2	1040	3	import	english	t	151	f
2182	2	1060	3	system-information	english	t	155	f
2183	2	1061	3	show	english	t	155	f
2187	2	1065	3	execute	english	t	155	f
2189	2	1067	3	priviliges	english	t	155	f
2190	2	1068	3	create date	english	t	155	f
2191	2	1069	3	table successfully emptied	english	t	156	f
4338	1	1508	3	Plichtfeld	deutsch	t	122	f
5242	2	1809	3	Main menu	english	t	163	f
2192	2	1070	3	error! Table not successfully emptied.	english	t	156	f
2200	2	1078	3	rule	english	t	160	f
2099	2	977	3	summarize files 	english	t	145	f
2114	2	992	3	from text file	english	t	148	f
2178	2	1056	3	refresh menu rights	english	t	154	f
2205	2	1083	3	URL	english	t	162	f
2209	2	1087	3	picture	english	t	162	f
2221	2	1099	3	element	english	t	168	f
2222	2	1100	3	picture information	english	t	168	f
2224	2	1102	3	representation	english	t	168	f
2230	2	1108	3	reflect	english	t	168	f
2231	2	1109	3	columns	english	t	168	f
2233	2	1111	3	spacing	english	t	168	f
2236	2	1114	3	list	english	t	168	f
2237	2	1115	3	font style	english	t	168	f
2238	2	1116	3	font weight	english	t	168	f
2239	2	1117	3	text-decoration	english	t	168	f
2240	2	1118	3	text-transform	english	t	168	f
2241	2	1119	3	text-alignment	english	t	168	f
2242	2	1120	3	row-spacing	english	t	168	f
2243	2	1121	3	letter-spacing	english	t	168	f
2244	2	1122	3	word-spacing	english	t	168	f
2246	2	1124	3	italic	english	t	168	f
2247	2	1125	3	bold	english	t	168	f
2248	2	1126	3	underlined	english	t	168	f
2249	2	1127	3	capital-letters	english	t	168	f
2250	2	1128	3	small-letters	english	t	168	f
2251	2	1129	3	blockquote	english	t	168	f
2252	2	1130	3	left	english	t	168	f
2253	2	1131	3	center	english	t	168	f
2254	2	1132	3	right	english	t	168	f
2256	2	1134	3	history	english	t	168	f
2258	2	1136	3	reset	english	t	168	f
2260	2	1138	3	font	english	t	169	f
2262	2	1140	3	pagesize (mm)	english	t	169	f
2263	2	1141	3	width	english	t	169	f
2267	2	1145	3	bottom	english	t	169	f
2268	2	1146	3	left	english	t	169	f
2269	2	1147	3	right	english	t	169	f
2270	2	1148	3	maintain proportions	english	t	169	f
2271	2	1149	3	textblock	english	t	169	f
2272	2	1150	3	contents	english	t	169	f
2273	2	1151	3	graphic	english	t	169	f
2274	2	1152	3	line	english	t	169	f
2275	2	1153	3	rectangle	english	t	169	f
2276	2	1154	3	ellipse	english	t	169	f
2279	2	1157	3	page-no.	english	t	169	f
2284	2	1162	3	for table	english	t	170	f
2287	2	1165	3	new report	english	t	170	f
2292	2	1170	3	font	english	t	175	f
2293	2	1171	3	subform	english	t	175	f
2296	2	1174	3	submit button	english	t	175	f
2298	2	1176	3	quality	english	t	175	f
2301	2	1179	3	form	english	t	176	f
2305	2	1183	3	Design with unique record	english	t	176	f
2306	2	1184	3	Design with record list	english	t	176	f
2308	2	1186	3	new form	english	t	176	f
2313	2	1191	3	new diagram	english	t	177	f
2322	2	1200	2	file-manager	english	t	0	f
2323	2	1201	2	file-manager	english	t	0	f
2326	1	1203	3	Textimport	deutsch	t	180	f
2327	2	1203	3	textimport	english	t	180	f
2330	1	1205	3	Status	deutsch	t	180	f
2331	2	1205	3	status	english	t	180	f
2229	2	1107	3	background colour	english	t	168	f
2226	2	1104	3	Font colour	english	t	168	f
2227	2	1105	3	width	english	t	168	f
2354	1	1217	3	offen	deutsch	t	180	f
2356	1	1218	3	OK	deutsch	t	180	f
2357	2	1218	3	ok	english	t	180	f
2358	1	1219	3	allgemein	deutsch	t	180	f
2360	1	1220	3	admin	deutsch	t	180	f
2361	2	1220	3	admin	english	t	180	f
2362	1	1221	3	system	deutsch	t	180	f
2363	2	1221	3	system	english	t	180	f
2364	1	1222	3	Sprachauswahl	deutsch	t	180	f
2365	2	1222	3	language selection	english	t	180	f
2384	1	1232	2	Verlauf	deutsch	t	\N	f
2386	1	1233	2	History Verlauf	deutsch	t	\N	f
2400	1	1240	1	Unterordner einbinden	deutsch	t	20	f
2401	2	1240	1	include subfolder	english	t	20	f
2408	1	1244	1	horizontal	deutsch	t	5	f
2409	2	1244	1	horizontal	english	t	5	f
2410	1	1245	1	vertikal	deutsch	t	5	f
2411	2	1245	1	vertical	english	t	5	f
2413	2	1246	1	without	english	t	5	f
2418	1	1249	3	abmelden	deutsch	t	132	f
2419	2	1249	3	logout	english	t	132	f
2422	1	1251	1	Wollen Sie sich abmelden?	deutsch	t	11	f
2434	1	1257	1	archivieren	deutsch	t	122	f
2435	2	1257	1	archive	english	t	122	f
2438	1	1259	1	editieren	deutsch	t	122	f
2439	2	1259	1	edit	english	t	122	f
2448	1	1264	3	Diese Funktion prüft alle Tabellenrechte auf Vorhandensein! \nVorhandene Rechte werden nicht überschrieben	deutsch	t	154	t
2430	1	1255	3	Indikatorregel	deutsch	t	122	f
2450	1	1265	3	Diese Funktion prüft alle Menürechte auf Vorhandensein! \nVorhandene Rechte werden nicht überschrieben	deutsch	t	154	t
2452	1	1266	2	Überwachung	deutsch	t	\N	f
2454	1	1267	2	User-Überwachung	deutsch	t	\N	f
2472	1	1276	2	Tabellendetail	deutsch	t	\N	f
2474	1	1277	2	Tabelleneinstellungen	deutsch	t	\N	f
2482	1	1281	2	verknüpfen	deutsch	t	\N	f
2484	1	1282	2	Datensatz verknüpfen	deutsch	t	\N	f
2488	1	1284	2	Verknüpfung entfernen	deutsch	t	\N	f
2490	1	1285	1	Datensatz schon verknüpft!	deutsch	t	27	f
2491	2	1285	1	Record allready linked	english	t	27	f
2492	1	1286	2	Fensteraufteilung	deutsch	t	\N	f
2494	1	1287	2	Rahmengröße und Art anpassen	deutsch	t	\N	f
4689	1	1625	1	Ansicht	deutsch	t	66	f
2496	1	1288	2	automatische Breite	deutsch	t	\N	f
2498	1	1289	2	Tabellengröße automatisch anpassen	deutsch	t	\N	f
2500	1	1290	2	Liste bearbeiten	deutsch	t	\N	f
2502	1	1291	2	Liste bearbeiten	deutsch	t	\N	f
2508	1	1294	1	zur ersten Seite	deutsch	t	5	f
2510	1	1295	1	zur letzten Seite	deutsch	t	5	f
4825	2	1670	3	disabled	english	t	52	f
2512	1	1296	1	eine Seite zurück	deutsch	t	5	f
2514	1	1297	1	eine Seite weiter	deutsch	t	5	f
2516	1	1298	1	öffne Verknüpfung	deutsch	t	15	f
2387	2	1233	2	history	english	t	\N	f
2385	2	1232	2	history	english	t	\N	f
2404	1	1242	1	Benutzer	deutsch	t	20	f
4819	2	1668	3	minimum	english	t	52	f
4296	1	1494	3	tiefstellen	deutsch	t	168	f
2518	1	1299	1	erzeuge Verknüpfung	deutsch	t	15	f
2520	1	1300	3	erlaube Passwortänderung	deutsch	t	127	f
2526	1	1303	3	Verknüpfungen neu eintragen!	deutsch	t	121	f
2528	1	1304	3	neu berechnen!	deutsch	t	101	f
2529	2	1304	3	Recalculate!	english	t	101	f
2530	1	1305	2	archivieren	deutsch	t	\N	f
2531	2	1305	2	archive	english	t	\N	f
2532	1	1306	2	Datensatz archivieren	deutsch	t	\N	f
2534	1	1307	2	zeige archivierte	deutsch	t	\N	f
2536	1	1308	2	zeige archivierte Datensätze	deutsch	t	\N	f
2540	1	1310	2	Datensatz wiederherstellen	deutsch	t	\N	f
2542	1	1311	1	Soll der Datensatz wiederhergestellt werden?	deutsch	t	13	t
2544	1	1312	1	Datensatz wurde archiviert!	deutsch	t	25	f
2545	2	1312	1	Record has been archived!	english	t	25	f
2546	1	1313	1	Datensatz wurde wiederhergestellt!	deutsch	t	25	f
2547	2	1313	1	The record has been recreated!	english	t	25	f
5927	1	2038	2	Meine Aufgaben	deutsch	t	\N	f
2550	1	1315	3	Username und Passwort müssen aus mindestens 5 Zeichen bestehen!	deutsch	t	127	f
2554	1	1317	1	Keine Berechtigung!	deutsch	t	31	f
2555	2	1317	1	No permission!	english	t	31	f
2558	1	1319	2	Uploadeditor	deutsch	t	\N	f
2560	1	1320	2	Uploadeditor	deutsch	t	\N	f
2486	1	1283	2	Verknüpfungen entfernen	deutsch	t	\N	f
2522	1	1301	2	Verknüpfungseditor	deutsch	t	\N	f
2564	1	1322	1	Dateipfad	deutsch	t	186	f
2568	1	1324	1	Dateiliste importieren!	deutsch	t	186	f
2570	1	1325	1	Datensätze wurden erfolgreich gelöscht!	deutsch	t	25	f
2572	1	1326	1	Datensätze wurden achiviert!	deutsch	t	25	f
2573	2	1326	1	Records have been archived!	english	t	25	f
2574	1	1327	1	Datensätze wurden wiederhergestellt!	deutsch	t	25	f
2575	2	1327	1	The record has been recreated!	english	t	25	f
2580	1	1330	1	alle umkehren	deutsch	t	14	f
2582	1	1331	1	alle markieren	deutsch	t	14	f
2586	1	1333	1	addiere mit Wert	deutsch	t	14	f
2588	1	1334	1	subtrahiere mit Wert	deutsch	t	14	f
2596	1	1338	1	ersetze mit Datum	deutsch	t	14	f
2598	1	1339	1	addiere Tage	deutsch	t	14	f
2600	1	1340	1	subtrahiere Tage	deutsch	t	14	f
2602	1	1341	1	ändern!	deutsch	t	14	f
2603	2	1341	1	modify!	english	t	14	f
2604	1	1342	1	angezeigte	deutsch	t	5	f
2605	2	1342	1	shown	english	t	5	f
2610	1	1345	2	Kalender	deutsch	t	\N	f
2611	2	1345	2	Calendar	english	t	\N	f
2612	1	1346	2	Terminkalender	deutsch	t	\N	f
2613	2	1346	2	Appointment calendar	english	t	\N	f
2628	1	1354	2	Text 8	deutsch	t	0	f
2629	2	1354	2	Text 8	english	t	0	f
2630	1	1355	2	Text 10	deutsch	t	0	f
2631	2	1355	2	Text 10	english	t	0	f
2632	1	1356	2	Text 20	deutsch	t	0	f
2633	2	1356	2	Text 20	english	t	0	f
2634	1	1357	2	Text 30	deutsch	t	0	f
2635	2	1357	2	Text 30	english	t	0	f
2636	1	1358	2	Text 50	deutsch	t	0	f
2637	2	1358	2	Text 50	english	t	0	f
2638	1	1359	2	Text 128	deutsch	t	0	f
2639	2	1359	2	Text 128	english	t	0	f
2640	1	1360	2	Text 160	deutsch	t	0	f
2641	2	1360	2	Text 160	english	t	0	f
2656	1	1368	2	URL	deutsch	t	0	f
2657	2	1368	2	URL	english	t	0	f
2662	1	1371	2	Auswahl (Select)	deutsch	t	0	f
2663	2	1371	2	Choice (Select)	english	t	0	f
2670	1	1375	2	PHP-Argument	deutsch	t	0	f
2541	2	1310	2	recover data record	english	t	\N	f
2551	2	1315	3	Username and password must contain minimum 5 characters	english	t	127	f
2569	2	1324	1	import file list!	english	t	186	f
2571	2	1325	1	Records successfully deleted!	english	t	25	f
2581	2	1330	1	reverse all	english	t	14	f
2543	2	1311	1	Should the record be restored?	english	t	13	f
2688	1	1384	2	-------Standard-Feldtypen-------	deutsch	t	0	f
2689	2	1384	2	-------Standard Field type--------	english	t	0	f
2690	1	1385	2	-------Sonder-Feldtypen-------	deutsch	t	0	f
2691	2	1385	2	-------Other field type---------	english	t	0	f
2700	1	1390	2	Text mit max. 8 Zeichen	deutsch	t	0	f
2701	2	1390	2	Text with max 8 chars	english	t	0	f
2702	1	1391	2	Text mit max. 10 Zeichen	deutsch	t	0	f
2703	2	1391	2	Text with max 10 chars	english	t	0	f
2704	1	1392	2	Text mit max. 20 Zeichen	deutsch	t	0	f
2644	1	1362	2	Textblock 399	deutsch	t	0	f
2645	2	1362	2	Textarea 399 	english	t	0	f
2680	1	1380	2	Post-Date	deutsch	t	0	f
2682	1	1381	2	Edit-Date	deutsch	t	0	f
2705	2	1392	2	Text with max 20 chars	english	t	0	f
2706	1	1393	2	Text mit max. 30 Zeichen	deutsch	t	0	f
2707	2	1393	2	Text with max 30 chars	english	t	0	f
2708	1	1394	2	Text mit max. 50 Zeichen	deutsch	t	0	f
2709	2	1394	2	Text with max 50 chars	english	t	0	f
2710	1	1395	2	Text mit max. 128 Zeichen	deutsch	t	0	f
2711	2	1395	2	Text with max 128 chars	english	t	0	f
2712	1	1396	2	Text mit max. 160 Zeichen	deutsch	t	0	f
2713	2	1396	2	Text with max 160 chars	english	t	0	f
2728	1	1404	2	URL mit max. 230 Zeichen	deutsch	t	0	f
2729	2	1404	2	URL with max 230 chars	english	t	0	f
2730	1	1405	2	Email mit max. 128 Zeichen	deutsch	t	0	f
2734	1	1407	2	Auswahlfeld (Select)	deutsch	t	0	f
2742	1	1411	2	Formelkonstrukt (eval)	deutsch	t	0	f
2622	1	1351	2	Zahl (10)	deutsch	t	0	f
2694	1	1387	2	10 stellige Ganzzahl	deutsch	t	0	f
2696	1	1388	2	18 stellige Ganzzahl	deutsch	t	0	f
2760	1	1420	1	alle User sperren!	deutsch	t	154	f
2761	2	1420	1	Deactivate all users!	english	t	154	f
2764	1	1422	2	abrufen	deutsch	t	\N	f
2766	1	1423	2	auf neue Nachrichten prüfen	deutsch	t	\N	f
6603	4	941	3	Intégrité référentielle	francais	t	139	f
3609	3	941	3	integridad referencial	Espagñol	t	139	f
2672	1	1376	2	Verknüpfung 1:n	deutsch	t	0	f
2744	1	1412	2	z.B. Kunde (1) -> Ansprechpartner (n)	deutsch	t	0	f
2674	1	1377	2	Verknüpfung n:m	deutsch	t	0	f
2746	1	1413	2	z.B. Auftrag (n) -> Artikel (m)	deutsch	t	0	f
2676	1	1378	2	Post-User	deutsch	t	0	f
2678	1	1379	2	Edit-User	deutsch	t	0	f
2750	1	1415	2	Welcher User den Datensatz zuletzt verändert hat	deutsch	t	0	f
2736	1	1408	2	Auswahlfeld (mehrfachauswahl) als MULTISELECT	deutsch	t	0	f
2758	1	1419	2	Textblock Memo	deutsch	t	0	f
2714	1	1397	2	Text	deutsch	t	0	f
2642	1	1361	2	Text	deutsch	t	0	f
2716	1	1398	2	Textblock mit max. 399 Zeichen	deutsch	t	0	f
2752	1	1416	2	Erstellungsdatum	deutsch	t	0	f
2754	1	1417	2	Bearbeitungsdatum	deutsch	t	0	f
2717	2	1398	2	Textarea with max. 399 chars 	english	t	0	f
2777	3	8	1	IP	Espagñol	t	4	f
2841	3	96	1	mostrar tope	Espagñol	t	17	f
4107	1	1431	3	Anmeldung	deutsch	t	182	f
4108	2	1431	3	Login	english	t	182	f
4113	1	1433	3	beobachten	deutsch	t	182	f
4119	1	1435	1	Tag	deutsch	t	188	f
4120	2	1435	1	Day	english	t	188	f
4122	1	1436	1	Woche	deutsch	t	188	f
4123	2	1436	1	Week	english	t	188	f
4125	1	1437	1	Monat	deutsch	t	188	f
4126	2	1437	1	Month	english	t	188	f
4128	1	1438	1	Jahr	deutsch	t	188	f
4129	2	1438	1	Year	english	t	188	f
4137	1	1441	1	Termin	deutsch	t	192	f
4140	1	1442	1	Urlaub	deutsch	t	192	f
4143	1	1443	1	Farbe:	deutsch	t	192	f
4146	1	1444	1	Erinnerung:	deutsch	t	192	f
4149	1	1445	1	von:	deutsch	t	192	f
4150	2	1445	1	from:	english	t	192	f
4152	1	1446	1	bis:	deutsch	t	192	f
4153	2	1446	1	till:	english	t	192	f
4155	1	1447	1	Betreff:	deutsch	t	192	f
4158	1	1448	1	Inhalt:	deutsch	t	192	f
4161	1	1449	1	Art:	deutsch	t	192	f
2063	2	941	3	referential integrity	english	t	139	f
2743	2	1411	2	construct formula	english	t	0	f
2731	2	1405	2	email with max 128 chars	english	t	0	f
5032	2	1739	3	Preview	english	t	52	f
5653	2	1946	3	Main menu frame	english	t	175	f
4167	1	1451	1	löschen!	deutsch	t	192	f
4168	2	1451	1	Delete!	english	t	192	f
4191	1	1459	3	gruppierbar	deutsch	t	110	f
4192	2	1459	3	groupable	english	t	110	f
4194	1	1460	3	Verknüpfung	deutsch	t	140	f
4203	1	1463	3	proportional	deutsch	t	168	f
4204	2	1463	3	proportional	english	t	168	f
4206	1	1464	3	kopieren	deutsch	t	176	f
4223	1	1470	2	löschen	deutsch	t	\N	f
4224	2	1470	2	delete	english	t	\N	f
4226	1	1471	2	Dateien/Ordner löschen	deutsch	t	\N	f
4230	1	1472	1	Keine Dateien gefunden!	deutsch	t	66	f
4241	1	1476	2	löschen	deutsch	t	\N	f
4242	2	1476	2	delete	english	t	\N	f
4244	1	1477	2	Nachricht löschen	deutsch	t	\N	f
4257	1	1481	3	incl. Userverzeichnis	deutsch	t	127	f
4263	1	1483	2	Auswahlfeld (Liste)	deutsch	t	0	f
4266	1	1484	2	Auswahl (Radio)	deutsch	t	0	f
4272	2	1486	2	History	english	t	\N	f
4275	2	1487	2	Record history	english	t	\N	f
4284	1	1490	3	obenbündig	deutsch	t	168	f
4285	2	1490	3	align top	english	t	168	f
4287	1	1491	3	mittig	deutsch	t	168	f
5101	2	1762	1	Method	english	t	66	f
2738	1	1409	2	Auswahlfeld (mehrfachauswahl) mit neuem Fenster	deutsch	t	0	f
4260	1	1482	2	Auswahlfeld (mehrfachauswahl) als Checkbox-Liste	deutsch	t	0	f
2722	1	1401	2	TRUE | FALSE oder 0 | 1	deutsch	t	0	f
4290	1	1492	3	untenbündig	deutsch	t	168	f
4291	2	1492	3	align bottom	english	t	168	f
4293	1	1493	3	Basislinie	deutsch	t	168	f
4294	2	1493	3	baseline	english	t	168	f
4299	1	1495	3	höherstellen	deutsch	t	168	f
4302	1	1496	3	oberer Schriftrand	deutsch	t	168	f
4305	1	1497	3	unterer Schriftrand	deutsch	t	168	f
4306	2	1497	3	bottom of the font line	english	t	168	f
4307	1	1498	2	Berichtsarchiv	deutsch	t	\N	f
4310	1	1499	2	Berichtsarchiv	deutsch	t	\N	f
4313	1	1500	2	Vorschau	deutsch	t	\N	f
4316	1	1501	2	Berichts-Vorschau	deutsch	t	\N	f
4319	1	1502	2	Bericht drucken	deutsch	t	\N	f
2664	1	1372	2	Auswahl (Multiselect)	deutsch	t	0	f
4322	1	1503	2	Bericht drucken	deutsch	t	\N	f
4329	1	1505	3	Java-Script	deutsch	t	175	f
4330	2	1505	3	Javascript	english	t	175	f
4332	1	1506	1	Ja	deutsch	t	15	f
4335	1	1507	1	Nein	deutsch	t	15	f
4339	2	1508	3	Requiered field	english	t	122	f
4341	1	1509	1	Folgende Felder wurden nicht ausgefüllt!	deutsch	t	13	f
4353	1	1513	3	Gruppe gelöscht	deutsch	t	116	f
4362	1	1516	3	field_type	deutsch	t	160	f
4363	2	1516	3	field_type	english	t	160	f
4365	1	1517	3	data_type	deutsch	t	160	f
4366	2	1517	3	data_type	english	t	160	f
4368	1	1518	3	funcid	deutsch	t	160	f
4369	2	1518	3	funcid	english	t	160	f
4371	1	1519	3	Datentyp	deutsch	t	160	f
4207	2	1464	3	copy	english	t	176	f
4221	1	1469	1	Gruppen	deutsch	t	20	f
4386	1	1524	1	übernehmen+anlegen	deutsch	t	13	f
4387	2	1524	1	save and create new	english	t	13	f
4392	1	1526	1	zeige Liste	deutsch	t	13	f
4395	1	1527	1	übernehmen/anwenden	deutsch	t	5	f
4396	2	1527	1	save	english	t	5	f
4404	1	1530	1	übernehmen+nächster	deutsch	t	13	f
4405	2	1530	1	save and go to next	english	t	13	f
4407	1	1531	1	übernehmen+vorheriger	deutsch	t	13	f
5055	1	1747	3	Hinweise	deutsch	t	52	f
4408	2	1531	1	save and go to previous	english	t	13	f
4410	1	1532	3	Umleitung	deutsch	t	127	f
4411	2	1532	3	redirection	english	t	127	f
4416	1	1534	3	durchgezogen	deutsch	t	168	f
4417	2	1534	3	solid	english	t	168	f
4419	1	1535	3	gepunktet	deutsch	t	168	f
4420	2	1535	3	dashed	english	t	168	f
4422	1	1536	3	gestrichelt	deutsch	t	168	f
4423	2	1536	3	dashed	english	t	168	f
4425	1	1537	3	doppelt	deutsch	t	168	f
4426	2	1537	3	doubled	english	t	168	f
4428	1	1538	3	3D-innen	deutsch	t	168	f
4429	2	1538	3	3D in	english	t	168	f
4431	1	1539	3	3D-außen	deutsch	t	168	f
4432	2	1539	3	3D out	english	t	168	f
4434	1	1540	3	Art	deutsch	t	168	f
4435	2	1540	3	type	english	t	168	f
4437	1	1541	3	Rahmenfarbe	deutsch	t	168	f
4446	1	1544	1	Metadaten zeigen	deutsch	t	15	f
4449	1	1545	1	Metadaten ändern	deutsch	t	15	f
4470	1	1552	1	Phys.name	deutsch	t	15	f
4471	2	1552	1	Phys.name	english	t	15	f
4494	1	1560	1	entpacken	deutsch	t	15	f
4495	2	1560	1	unpack	english	t	15	f
4907	1	1698	2	kopieren	deutsch	t	\N	f
4503	1	1563	1	Format	deutsch	t	15	f
4504	2	1563	1	Format	english	t	15	f
4506	1	1564	1	Geometrie	deutsch	t	15	f
4507	2	1564	1	Geometry	english	t	15	f
4509	1	1565	1	Auflösung	deutsch	t	15	f
4510	2	1565	1	Resolution	english	t	15	f
4512	1	1566	1	Farbtiefe	deutsch	t	15	f
4515	1	1567	1	Farben	deutsch	t	15	f
4527	1	1571	1	zurück setzen	deutsch	t	20	f
4528	2	1571	1	rollback	english	t	20	f
4529	1	1572	2	Backup	deutsch	t	\N	f
4530	2	1572	2	Backup	english	t	\N	f
4532	1	1573	2	System-Backup	deutsch	t	\N	f
4533	2	1573	2	System-Backup	english	t	\N	f
4536	1	1574	1	Die Referentielle Integrität wurde verletzt!	deutsch	t	25	f
4537	2	1574	1	referentially integrity was broken	english	t	25	f
4538	1	1575	2	History	deutsch	t	\N	f
4539	2	1575	2	History	english	t	\N	f
4541	1	1576	2	Backup - History	deutsch	t	\N	f
4542	2	1576	2	Backup-History	english	t	\N	f
4544	1	1577	2	Periodisch	deutsch	t	\N	f
4545	2	1577	2	Periodical	english	t	\N	f
4547	1	1578	2	Periodisches Backup	deutsch	t	\N	f
4548	2	1578	2	Periodical Backup	english	t	\N	f
4550	1	1579	2	Interaktiv	deutsch	t	\N	f
4551	2	1579	2	Interactive	english	t	\N	f
4553	1	1580	2	Interaktives Backup	deutsch	t	\N	f
4554	2	1580	2	Interactive Backup	english	t	\N	f
4557	1	1581	3	Verschlagwortung	deutsch	t	110	f
4558	2	1581	3	keyword extraction	english	t	110	f
4559	1	1582	2	System-Jobs	deutsch	t	\N	f
4562	1	1583	2	Systemverbundene Jobs (Indizierung / OCR)	deutsch	t	\N	f
4565	1	1584	2	Periodisch	deutsch	t	\N	f
4568	1	1585	2	Periodische Ausführung	deutsch	t	\N	f
4577	1	1588	2	History	deutsch	t	\N	f
4578	2	1588	2	History	english	t	\N	f
4580	1	1589	2	Jobs - History	deutsch	t	\N	f
4584	1	1590	1	Indiziert	deutsch	t	15	f
4585	2	1590	1	Indexed	english	t	15	f
4605	1	1597	1	gesprochen	deutsch	t	19	f
4606	2	1597	1	spoken	english	t	19	f
4614	1	1600	1	Passwort wiederholen	deutsch	t	46	f
4521	1	1569	1	Style	deutsch	t	175	f
4615	2	1600	1	reenter password	english	t	46	f
4638	1	1608	1	Sie müssen einen Namen vergeben!	deutsch	t	5	f
4639	2	1608	1	You must set a name!	english	t	5	f
4649	1	1612	2	Datei runterladen	deutsch	t	\N	f
4652	1	1613	2	Datei/Archiv runterladen	deutsch	t	\N	f
4656	1	1614	3	Default	deutsch	t	122	f
4659	2	1615	2	insert	english	t	\N	f
4665	2	1617	2	file rights	english	t	\N	f
4676	1	1621	2	Dateien	deutsch	t	\N	f
4690	2	1625	1	View	english	t	66	f
4692	1	1626	1	Suchen	deutsch	t	66	f
4693	2	1626	1	Search	english	t	66	f
4695	1	1627	1	falsche Notation!	deutsch	t	66	f
4696	2	1627	1	Wrong name!	english	t	66	f
5239	2	1808	2	Type	english	t	182	f
4697	1	1628	2	Datei laden	deutsch	t	\N	f
4700	1	1629	2	Datei laden	deutsch	t	\N	f
4709	1	1632	2	Details	deutsch	t	\N	f
4710	2	1632	2	Info	english	t	\N	f
4712	1	1633	2	Datei Info/Metadaten	deutsch	t	\N	f
4713	2	1633	2	File metadata/info	english	t	\N	f
4716	1	1634	3	Allgemein	deutsch	t	52	f
4717	2	1634	3	general	english	t	52	f
4719	1	1635	3	Metadaten	deutsch	t	52	f
4720	2	1635	3	META	english	t	52	f
4725	1	1637	3	Mimetype	deutsch	t	52	f
4726	2	1637	3	Mimetype	english	t	52	f
4728	1	1638	3	Erstellt von	deutsch	t	52	f
4729	2	1638	3	Created by	english	t	52	f
4731	1	1639	3	Erstellt am	deutsch	t	52	f
4732	2	1639	3	Creation date	english	t	52	f
4734	1	1640	3	Überschrift	deutsch	t	52	f
4735	2	1640	3	header	english	t	52	f
4737	1	1641	3	Zusatz zum Namen	deutsch	t	52	f
4738	2	1641	3	other name	english	t	52	f
4740	1	1642	3	Verfasser	deutsch	t	52	f
4743	1	1643	3	Name des Verfassers (Familienname, Vorname)	deutsch	t	52	f
4744	2	1643	3	creater name (last name, first name)	english	t	52	f
4746	1	1644	3	Schlagwörter	deutsch	t	52	f
4747	2	1644	3	keywords	english	t	52	f
4749	1	1645	3	Stichworte zum Thema des Dokuments, mehrere getrennt durch Komma	deutsch	t	52	f
4755	1	1647	3	Abstrakt, Beschreibung des Inhalts	deutsch	t	52	f
4756	2	1647	3	Abstract, content description	english	t	52	f
4758	1	1648	3	Herausgeber	deutsch	t	52	f
4759	2	1648	3	Distributor	english	t	52	f
4761	1	1649	3	Verleger, Herausgeber, Universität etc.	deutsch	t	52	f
4762	2	1649	3	Distributor, university, etc...	english	t	52	f
4764	1	1650	3	Mitwirkende	deutsch	t	52	f
4765	2	1650	3	co author	english	t	52	f
4767	1	1651	3	Name einer weiteren beteiligten Person	deutsch	t	52	f
4768	2	1651	3	Name of co author	english	t	52	f
4773	1	1653	3	Art des Dokuments	deutsch	t	52	f
4774	2	1653	3	documents type	english	t	52	f
4782	1	1656	3	Identifikation	deutsch	t	52	f
4783	2	1656	3	identification	english	t	52	f
4785	1	1657	3	(ISBN, ISSN, URL o.ä. des vorliegenden Dokuments betr. eindeutiger Identifikation	deutsch	t	52	f
4786	2	1657	3	(ISBN, ISSN)	english	t	52	f
4791	1	1659	3	Werk, gedruckt oder elektronisch, aus dem das vorliegende Dokument stammt	deutsch	t	52	f
4797	1	1661	3	Sprache des Inhalts des Dokuments	deutsch	t	52	f
4798	2	1661	3	content language	english	t	52	f
4803	1	1663	3	Quelle	deutsch	t	52	f
4804	2	1663	3	source	english	t	52	f
4806	1	1664	3	Attribute	deutsch	t	52	f
4807	2	1664	3	attribute	english	t	52	f
4809	1	1665	3	geprüft	deutsch	t	52	f
4810	2	1665	3	checked	english	t	52	f
4812	1	1666	3	freigegeben	deutsch	t	52	f
4813	2	1666	3	authorized	english	t	52	f
4815	1	1667	3	Grafik-Format	deutsch	t	52	f
4816	2	1667	3	Graphic format	english	t	52	f
4818	1	1668	3	min.	deutsch	t	52	f
4824	1	1670	3	gesperrt	deutsch	t	52	f
4845	1	1677	3	Klassifikation	deutsch	t	52	f
4846	2	1677	3	classification	english	t	52	f
5107	2	1764	3	OnClick	english	t	168	f
4848	1	1678	3	Notationen zum Thema des Dokuments, mehrere getrennt durch Komma	deutsch	t	52	f
4849	2	1678	3	Notations for the document seperatet by comma	english	t	52	f
4851	1	1679	1	Kopie von	deutsch	t	66	f
4852	2	1679	1	Copy from	english	t	66	f
4863	1	1683	1	Datei schon vorhanden!	deutsch	t	66	f
4866	1	1684	1	Ordner schon vorhanden!	deutsch	t	66	f
4867	2	1684	1	Folder already exists!	english	t	66	f
4869	1	1685	3	Duplikate	deutsch	t	52	f
4870	2	1685	3	duplicate	english	t	52	f
4872	1	1686	3	Das Userverzeichniss konnte nicht gelöscht werden!	deutsch	t	29	f
4875	1	1687	3	zeige gelöschte User	deutsch	t	132	f
4878	1	1688	1	Datei ist gesperrt!	deutsch	t	66	f
4890	1	1692	1	Der Bericht wurde erzeugt.	deutsch	t	93	f
4891	2	1692	1	Report  was created.	english	t	93	f
4893	1	1693	1	Bearbeiten	deutsch	t	66	f
4902	1	1696	1	Nachrichten und Dateien können nicht gemischt werden!	deutsch	t	97	f
4903	2	1696	1	Messages and files can not be mixed	english	t	97	f
4905	1	1697	1	Dieser Ordner ist ein Systemordner. Er ist nur in Verbindung mit Tabellen, Berichten oder Nachrichten beschreibbar!	deutsch	t	66	f
4908	2	1698	2	copy	english	t	\N	f
4910	1	1699	2	Nachricht kopieren	deutsch	t	\N	f
4913	1	1700	2	speichern	deutsch	t	\N	f
4914	2	1700	2	save	english	t	\N	f
4929	1	1705	1	Dokumente	deutsch	t	3	f
4930	2	1705	1	document	english	t	3	f
4932	1	1706	1	Bilder	deutsch	t	3	f
4933	2	1706	1	picture	english	t	3	f
4941	1	1709	1	Wollen Sie den gesamten Inhalt des Ordners löschen?	deutsch	t	66	f
4944	1	1710	1	Keine Upload Berechtigung!	deutsch	t	66	f
4946	1	1711	2	kennzeichnen	deutsch	t	\N	f
4947	2	1711	2	mark	english	t	\N	f
4949	1	1712	2	Nachricht kennzeichnen	deutsch	t	\N	f
4965	1	1717	1	keine Datei ausgewählt!	deutsch	t	66	f
4966	2	1717	1	No file selected!	english	t	66	f
4971	1	1719	3	Indiziert am:	deutsch	t	52	f
4972	2	1719	3	Indexed on:	english	t	52	f
4974	1	1720	3	Index	deutsch	t	52	f
4975	2	1720	3	index	english	t	52	f
4977	1	1721	1	Benutzer:	deutsch	t	23	f
4978	2	1721	1	User:	english	t	23	f
4980	1	1722	1	vorraussichtliche Restzeit:	deutsch	t	23	f
4981	2	1722	1	Time left (min.):	english	t	23	f
4985	1	1724	2	Thumbnails erneuern	deutsch	t	\N	f
4988	1	1725	2	Vorschaubilder neu generieren	deutsch	t	\N	f
4995	1	1727	3	komplett löschen	deutsch	t	127	f
4998	1	1728	3	User aktivieren	deutsch	t	132	f
5000	1	1729	2	kopieren	deutsch	t	\N	f
5001	2	1729	2	copy	english	t	\N	f
5003	1	1730	2	Datensatz kopieren	deutsch	t	\N	f
5004	2	1730	2	copy record	english	t	\N	f
5013	1	1733	1	kein Datensatz ausgewählt!	deutsch	t	5	f
5018	1	1735	2	neues Fenster	deutsch	t	\N	f
5021	1	1736	2	neuer LIMBAS-Explorer	deutsch	t	\N	f
5022	2	1736	2	new LIMBAS-Explorer	english	t	\N	f
5025	1	1737	3	EXIF	deutsch	t	52	f
5026	2	1737	3	EXIF	english	t	52	f
5028	1	1738	3	IPTC	deutsch	t	52	f
5029	2	1738	3	IPTC	english	t	52	f
5031	1	1739	3	Vorschau	deutsch	t	52	f
5034	1	1740	3	XMP	deutsch	t	52	f
5035	2	1740	3	XMP	english	t	52	f
5037	1	1741	3	Objektbeschreibung	deutsch	t	52	f
5038	2	1741	3	Object description	english	t	52	f
5040	1	1742	3	Stichwörter	deutsch	t	52	f
5041	2	1742	3	Keyword	english	t	52	f
5043	1	1743	3	Kategorien	deutsch	t	52	f
5044	2	1743	3	Category	english	t	52	f
5046	1	1744	3	Bildrechte	deutsch	t	52	f
5047	2	1744	3	Image rights	english	t	52	f
5049	1	1745	3	Herkunft	deutsch	t	52	f
5050	2	1745	3	Origin	english	t	52	f
5052	1	1746	3	Copyright	deutsch	t	52	f
5053	2	1746	3	Cpyright	english	t	52	f
5056	2	1747	3	Hints	english	t	52	f
5058	1	1748	3	Dringlichkeit	deutsch	t	52	f
5061	1	1749	3	Kategorie	deutsch	t	52	f
5062	2	1749	3	Category	english	t	52	f
5064	1	1750	3	Autor	deutsch	t	52	f
5065	2	1750	3	Author	english	t	52	f
5070	1	1752	3	Ort	deutsch	t	52	f
5073	1	1753	3	Staat/Provinz	deutsch	t	52	f
5074	2	1753	3	State	english	t	52	f
5076	1	1754	3	Land	deutsch	t	52	f
5077	2	1754	3	Country	english	t	52	f
5079	1	1755	3	Aufgeber-Code	deutsch	t	52	f
5080	2	1755	3	Code	english	t	52	f
5082	1	1756	3	Vermerk	deutsch	t	52	f
5083	2	1756	3	Note	english	t	52	f
5085	1	1757	3	Objektname	deutsch	t	52	f
5086	2	1757	3	Object name	english	t	52	f
5088	1	1758	3	Unterkategorien	deutsch	t	52	f
5089	2	1758	3	Sub category	english	t	52	f
5090	1	1759	2	konvertieren	deutsch	t	\N	f
5329	2	1838	3	enter	english	t	104	f
5093	1	1760	2	Datei konvertieren	deutsch	t	\N	f
5100	1	1762	1	Methode	deutsch	t	66	f
5103	1	1763	3	Ereignisse	deutsch	t	168	f
5104	2	1763	3	Events	english	t	168	f
5106	1	1764	3	OnClick	deutsch	t	168	f
5109	1	1765	3	OnDblClick	deutsch	t	168	f
5110	2	1765	3	OnDblClick	english	t	168	f
5112	1	1766	3	OnMouseOver	deutsch	t	168	f
5113	2	1766	3	OnMouseOver	english	t	168	f
5115	1	1767	3	OnMouseOut	deutsch	t	168	f
5116	2	1767	3	OnMouseOut	english	t	168	f
5118	1	1768	3	OnChange	deutsch	t	168	f
5119	2	1768	3	OnChange	english	t	168	f
5120	1	1769	2	Editmodus	deutsch	t	\N	f
5123	1	1770	2	Bearbeite Long-Feld	deutsch	t	\N	f
5130	1	1772	3	PHP-Script	deutsch	t	175	f
5131	2	1772	3	PHP-Script	english	t	175	f
5133	1	1773	3	Datenbezeichnung	deutsch	t	169	f
5134	2	1773	3	Data display	english	t	169	f
5136	1	1774	3	Datensuchfeld	deutsch	t	169	f
5137	2	1774	3	Data search field	english	t	169	f
5139	1	1775	3	Form	deutsch	t	168	f
5140	2	1775	3	Form	english	t	168	f
5142	1	1776	3	sichtbar	deutsch	t	168	f
5143	2	1776	3	viewable	english	t	168	f
5145	1	1777	3	abgeschnitten	deutsch	t	168	f
5146	2	1777	3	cut	english	t	168	f
5148	1	1778	3	scrollbar	deutsch	t	168	f
5149	2	1778	3	scrollbar	english	t	168	f
5151	1	1779	3	loggen	deutsch	t	140	f
5152	2	1779	3	log	english	t	140	f
5154	1	1780	3	Aktionen	deutsch	t	127	f
5159	1	1782	2	Vergleich	deutsch	t	\N	f
5162	1	1783	2	Dateien vergleichen	deutsch	t	\N	f
5175	1	1787	1	Archivieren	deutsch	t	13	f
5178	1	1788	1	Berichte	deutsch	t	5	f
5181	1	1789	3	zeige aktive User	deutsch	t	132	f
5184	1	1790	3	zeige alle User	deutsch	t	132	f
5187	1	1791	3	Statistik	deutsch	t	132	f
5190	1	1792	3	geändert	deutsch	t	132	f
5193	1	1793	3	zeige gesperrte User	deutsch	t	132	f
5205	1	1797	1	0 (kein Logging)	deutsch	t	127	f
5206	2	1797	1	0 (no logging)	english	t	127	f
5059	2	1748	3	Priotity	english	t	52	f
5208	1	1798	1	1 (nur DB Actionen)	deutsch	t	127	f
5209	2	1798	1	1 (DB action only)	english	t	127	f
5211	1	1799	1	2 (komplettes Logging)	deutsch	t	127	f
5212	2	1799	1	2 (complete logging)	english	t	127	f
5214	1	1800	2	Login	deutsch	t	182	f
5215	2	1800	2	Login	english	t	182	f
5217	1	1801	2	Logout	deutsch	t	182	f
5218	2	1801	2	Logout	english	t	182	f
5220	1	1802	2	IP	deutsch	t	182	f
5221	2	1802	2	IP	english	t	182	f
5223	1	1803	2	Dauer	deutsch	t	182	f
5224	2	1803	2	Duration	english	t	182	f
5226	1	1804	2	Datum	deutsch	t	182	f
5227	2	1804	2	Date	english	t	182	f
5229	1	1805	2	Aktion	deutsch	t	182	f
5230	2	1805	2	Action	english	t	182	f
5232	1	1806	2	Tabelle	deutsch	t	182	f
5233	2	1806	2	Table	english	t	182	f
5235	1	1807	2	ID	deutsch	t	182	f
5236	2	1807	2	ID	english	t	182	f
5238	1	1808	2	Art	deutsch	t	182	f
5241	1	1809	3	Hauptmenü	deutsch	t	163	f
5244	1	1810	3	Admin	deutsch	t	163	f
5245	2	1810	3	Admin	english	t	163	f
5250	1	1812	3	Usermenü	deutsch	t	163	f
5251	2	1812	3	User menu	english	t	163	f
5253	1	1813	3	Erweiterungen	deutsch	t	163	f
5254	2	1813	3	Extensions	english	t	163	f
5256	1	1814	3	Untergruppe	deutsch	t	162	f
5257	2	1814	3	sub group	english	t	162	f
5259	1	1815	3	Sort	deutsch	t	162	f
5260	2	1815	3	sort	english	t	162	f
5265	1	1817	3	Passwort gültig bis	deutsch	t	127	f
5266	2	1817	3	Password valid till	english	t	127	f
5283	1	1823	3	Generator	deutsch	t	121	f
5284	2	1823	3	Generator	english	t	121	f
5286	1	1824	3	zu verknüpfende Tabelle	deutsch	t	121	f
5295	1	1827	1	mit global	deutsch	t	19	f
5296	2	1827	1	with global	english	t	19	f
5298	2	1828	2	Info	english	t	\N	f
5301	2	1829	2	Info about LIMBAS	english	t	\N	f
5304	1	1830	3	Auswahl-Pool	deutsch	t	104	f
5305	2	1830	3	Choice pool	english	t	104	f
5310	1	1832	3	neuer Pool	deutsch	t	104	f
5311	2	1832	3	New pool	english	t	104	f
5325	1	1837	3	Sortierung	deutsch	t	104	f
5326	2	1837	3	sort	english	t	104	f
5328	1	1838	3	Eingabe	deutsch	t	104	f
5331	1	1839	3	absteigend	deutsch	t	104	f
5332	2	1839	3	downward	english	t	104	f
5334	1	1840	3	aufsteigend	deutsch	t	104	f
5335	2	1840	3	upward	english	t	104	f
5340	1	1842	3	FORMAT: WERT[STRING] | ZUSATZ[STRING]	deutsch	t	104	f
5341	2	1842	3	FORMAT: WERT[STRING] | ZUSATZ[STRING]	english	t	104	f
5343	1	1843	1	Werte	deutsch	t	12	f
5346	1	1844	1	davon	deutsch	t	12	f
5347	2	1844	1	of	english	t	12	f
5349	1	1845	1	ausgewählt	deutsch	t	12	f
5350	2	1845	1	selected	english	t	12	f
5352	1	1846	1	angezeigt	deutsch	t	12	f
5353	2	1846	1	shown	english	t	12	f
5355	1	1847	3	Systemupdate	deutsch	t	154	f
5356	2	1847	3	System update	english	t	154	f
5361	1	1849	3	Ordnerstruktur abgleichen	deutsch	t	154	f
5362	2	1849	3	Synchronize folderstructure	english	t	154	f
5364	2	1850	2	Index	english	t	\N	f
5367	2	1851	2	Table-Index	english	t	\N	f
5382	1	1856	3	benutzt	deutsch	t	195	f
5383	2	1856	3	used	english	t	195	f
5388	1	1858	3	erneuern	deutsch	t	195	f
5389	2	1858	3	renew	english	t	195	f
5399	1	1862	2	Einzel-Jobs	deutsch	t	\N	f
5402	1	1863	2	Job - Templates	deutsch	t	\N	f
5403	2	1863	2	Job - Templates	english	t	\N	f
5287	2	1824	3	To be linked table	english	t	121	f
5344	2	1843	1	values	english	t	12	f
5400	2	1862	2	single jbs	english	t	\N	f
5411	1	1866	2	History	deutsch	t	\N	f
5412	2	1866	2	History	english	t	\N	f
5697	1	1961	3	Auswahl	deutsch	t	168	f
5414	1	1867	2	Jobs - History	deutsch	t	\N	f
5415	2	1867	2	Jobs - History	english	t	\N	f
5420	1	1869	2	! Limit aufheben	deutsch	t	\N	f
5421	2	1869	2	Disable limitation	english	t	\N	f
5423	1	1870	2	hebt das Datensatzlimit auf (langsam)	deutsch	t	\N	f
5430	1	1872	3	Infomenü	deutsch	t	163	f
5431	2	1872	3	Info menu	english	t	163	f
5433	2	1873	2	Logout	english	t	\N	f
5436	2	1874	2	Logout	english	t	\N	f
5439	2	1875	2	reset	english	t	\N	f
5442	2	1876	2	reset application	english	t	\N	f
5445	2	1877	2	Table schema	english	t	\N	f
5448	2	1878	2	Table schema	english	t	\N	f
5451	1	1879	3	editierbar	deutsch	t	110	f
5452	2	1879	3	editable	english	t	110	f
5454	1	1880	3	Zahlenformat	deutsch	t	110	f
5455	2	1880	3	Number format	english	t	110	f
5457	1	1881	3	RegExp	deutsch	t	110	f
5458	2	1881	3	RegExp	english	t	110	f
5463	1	1883	3	Währung	deutsch	t	110	f
5469	1	1885	3	WYSIWYG	deutsch	t	110	f
5470	2	1885	3	WYSIWYG	english	t	110	f
5472	1	1886	3	Wert-Trennung	deutsch	t	110	f
5473	2	1886	3	value seperation	english	t	110	f
5475	1	1887	3	anz. Verknüpfungen	deutsch	t	110	f
5478	2	1888	2	Fonts	english	t	\N	f
5481	2	1889	2	Font manager	english	t	\N	f
5486	1	1891	2	Suche zurücksetzen	deutsch	t	\N	f
5489	1	1892	2	Suche zurücksetzen	deutsch	t	\N	f
5493	1	1893	3	Allgemein	deutsch	t	164	f
5494	2	1893	3	General	english	t	164	f
5496	1	1894	3	Installations-Pfade	deutsch	t	164	f
5497	2	1894	3	Installation path	english	t	164	f
5499	1	1895	3	Layout	deutsch	t	164	f
5500	2	1895	3	Layout	english	t	164	f
5502	1	1896	3	Tabellen-Einstellungen	deutsch	t	164	f
5503	2	1896	3	Table parameters	english	t	164	f
5508	1	1898	3	Index-Einstellungen	deutsch	t	164	f
5509	2	1898	3	Index parameters	english	t	164	f
5511	1	1899	3	Datei-Einstellungen	deutsch	t	164	f
5512	2	1899	3	File parameters	english	t	164	f
5514	1	1900	3	Sicherheits-Einstellungen	deutsch	t	164	f
5515	2	1900	3	Security parameters	english	t	164	f
5517	1	1901	1	Die Medatdaten konnten nicht erfolgreich ausgelesen werden.	deutsch	t	41	f
5520	1	1902	1	groß/klein-Schreibung beachten	deutsch	t	66	f
5523	1	1903	1	ganzer Satz	deutsch	t	66	f
5526	1	1904	1	Teil des Wortes	deutsch	t	66	f
5538	1	1908	3	suche nur in Metadaten	deutsch	t	52	f
5541	1	1909	1	für diesen Dateityp kann keine Vorschau erstellt werden.	deutsch	t	66	f
5546	1	1911	2	Suche wird für alle Ordner gemerkt	deutsch	t	\N	f
5547	2	1911	2	Search in all marked folder	english	t	\N	f
5559	1	1915	1	Keine Dokumente gefunden!	deutsch	t	66	f
5560	2	1915	1	No document found!	english	t	66	f
5561	1	1916	2	zeige Felder	deutsch	t	\N	f
5564	1	1917	2	Auswahl anzuzeigender Felder	deutsch	t	\N	f
5573	1	1920	2	Ordneransicht speichern	deutsch	t	\N	f
5576	1	1921	2	aktuelle Ordner-Einstellung speichern	deutsch	t	\N	f
12763	3	2914	2	sincronización	Espagñol	t	0	f
5579	1	1922	2	Ansicht übernehmen	deutsch	t	\N	f
5582	1	1923	2	Ansichtseinstellungen für alle Ordner speichern	deutsch	t	\N	f
5755	2	1980	1	Minutes	english	t	13	f
5586	1	1924	3	Sonstiges	deutsch	t	52	f
5587	2	1924	3	Others	english	t	52	f
5601	1	1929	3	Kalender	deutsch	t	140	f
5602	2	1929	3	Calendar	english	t	140	f
5406	2	1864	2	periodically	english	t	\N	f
5543	1	1910	2	Suchkriterien merken	deutsch	t	\N	f
5544	2	1910	2	remember search criteria 	english	t	\N	f
5424	2	1870	2	Disable dataset limitation (is slow!)	english	t	\N	f
5607	1	1931	2	Zeit	deutsch	t	0	f
5608	2	1931	2	Time	english	t	0	f
5616	1	1934	2	00:00:00	deutsch	t	0	f
6104	4	102	1	après 	francais	t	19	f
5617	2	1934	2	00:00:00	english	t	0	f
5631	1	1939	1	Extras	deutsch	t	66	f
5632	2	1939	1	Extras	english	t	66	f
5655	1	1947	3	Text-Eingabefeld	deutsch	t	175	f
5658	1	1948	3	Textarea-Eingabefeld	deutsch	t	175	f
5661	1	1949	3	Select-Auswahlfeld	deutsch	t	175	f
5662	2	1949	3	Select input	english	t	175	f
5664	1	1950	3	Checkbox-Element	deutsch	t	175	f
5665	2	1950	3	Checkbox input	english	t	175	f
5667	1	1951	3	Radio-Element	deutsch	t	175	f
5668	2	1951	3	Radio input	english	t	175	f
5676	1	1954	3	Mehrzweck-Fenster	deutsch	t	115	f
5677	2	1954	3	Multipurpose window	english	t	115	f
5679	1	1955	3	zusammen	deutsch	t	168	f
5680	2	1955	3	together	english	t	168	f
5682	1	1956	3	getrennt	deutsch	t	168	f
5683	2	1956	3	split	english	t	168	f
5698	2	1961	3	Choice	english	t	168	f
5700	1	1962	3	ja	deutsch	t	168	f
5701	2	1962	3	yes	english	t	168	f
5703	1	1963	3	nein	deutsch	t	168	f
5704	2	1963	3	no	english	t	168	f
5708	1	1965	2	veröffentlichen	deutsch	t	\N	f
5709	2	1965	2	publish	english	t	\N	f
5715	1	1967	3	snap	deutsch	t	168	f
5718	1	1968	3	hidden	deutsch	t	168	f
5719	2	1968	3	hidden	english	t	168	f
5739	1	1975	1	in	deutsch	t	13	f
5740	2	1975	1	in	english	t	13	f
5742	1	1976	1	am	deutsch	t	13	f
5743	2	1976	1	at	english	t	13	f
5754	1	1980	1	Minuten	deutsch	t	13	f
5757	1	1981	1	Stunden	deutsch	t	13	f
5758	2	1981	1	Hours	english	t	13	f
5760	1	1982	1	Tage	deutsch	t	13	f
5763	1	1983	1	Wochen	deutsch	t	13	f
5764	2	1983	1	Weeks	english	t	13	f
5769	1	1985	1	Jahre	deutsch	t	13	f
5930	1	2039	2	Aufgaben Übersicht	deutsch	t	\N	f
6036	1	2074	3	Minute	deutsch	t	212	f
6037	2	2074	3	Minute	english	t	212	f
6039	1	2075	3	Stunde	deutsch	t	212	f
6043	2	2076	3	Day of the month	english	t	212	f
6048	1	2078	3	Wochentag	deutsch	t	212	f
6049	2	2078	3	Week day	english	t	212	f
6051	1	2079	3	Job hinzufügen	deutsch	t	212	f
6052	2	2079	3	Add job	english	t	212	f
6054	1	2080	3	Dateistruktur	deutsch	t	212	f
5716	2	1967	3	filter	english	t	168	f
6266	4	385	2	tables	francais	t	0	f
6057	1	2081	3	inkl. sub	deutsch	t	212	f
6312	4	455	2	Groupes	francais	t	0	f
6062	4	4	1	nom 	francais	t	4	f
6114	4	115	1	Une erreur est survenue! Les modifications sont annulées! 	francais	t	25	f
6121	4	126	1	description 	francais	t	34	f
6148	4	168	1	champ 	francais	t	50	f
6154	4	195	1	Une erreur est survenue! 	francais	t	54	f
6156	4	197	1	date 	francais	t	55	f
6180	4	242	2	Inclure sous-dossier 	francais	t	44	f
6229	4	317	1	dim 	francais	t	88	f
6260	4	373	2	rechercher	francais	t	0	f
6261	4	374	2	recherche d''enregistrement	francais	t	0	f
6262	4	379	2	admin	francais	t	0	f
6263	4	380	2	Paramètres admin	francais	t	0	f
6264	4	381	2	aide	francais	t	0	f
6265	4	382	2	aide	francais	t	0	f
6267	4	386	2	tables	francais	t	0	f
6268	4	387	2	profile	francais	t	0	f
6269	4	388	2	profil utilisateur	francais	t	0	f
6270	4	391	2	imprimer	francais	t	0	f
6272	4	393	2	maximiser	francais	t	0	f
6273	4	394	2	Maximiser l''affichage	francais	t	0	f
6274	4	395	2	minimiser	francais	t	0	f
6275	4	396	2	Minimiser l''affichage	francais	t	0	f
6276	4	401	2	rétablir les parametres	francais	t	0	f
6277	4	402	2	rétablir les parametres	francais	t	0	f
6278	4	403	2	Paramètres	francais	t	0	f
6279	4	404	2	Paramètres globaux des utilisateurs	francais	t	0	f
6280	4	409	2	couleurs	francais	t	0	f
6281	4	410	2	Choix des couleurs utilisateur	francais	t	0	f
6282	4	415	2	Messages	francais	t	0	f
6283	4	416	2	Messagerie	francais	t	0	f
6284	4	417	2	Nouveau message	francais	t	0	f
6290	4	427	2	Gabarit	francais	t	0	f
6292	4	429	2	Ajouter un utilisateur	francais	t	0	f
6293	4	430	2	Ajouter un utilisateur	francais	t	0	f
6294	4	431	2	Variable système	francais	t	0	f
6295	4	432	2	Variables d''environement	francais	t	0	f
6296	4	435	2	Gestionnaire de menu	francais	t	0	f
6297	4	436	2	Table en relation	francais	t	0	f
6298	4	437	2	Schema	francais	t	0	f
6299	4	438	2	Schema de couleur	francais	t	0	f
6300	4	439	2	Couleurs	francais	t	0	f
6301	4	440	2	Table des couleurs	francais	t	0	f
6302	4	441	2	Export	francais	t	0	f
6303	4	442	2	Export	francais	t	0	f
6304	4	443	2	Import	francais	t	0	f
6305	4	444	2	Import	francais	t	0	f
6306	4	445	2	Système	francais	t	0	f
6307	4	446	2	Outils système	francais	t	0	f
6308	4	451	2	statistiques	francais	t	0	f
6309	4	452	2	Statistique des diagrammes utilisateur	francais	t	0	f
6310	4	453	2	Utilisateurs/groupes	francais	t	0	f
6311	4	454	2	Administration utilisateurs/groupes	francais	t	0	f
7391	4	1805	2	Action	francais	t	182	f
6313	4	456	2	Administration des groupes	francais	t	0	f
6314	4	457	2	Tables	francais	t	0	f
6315	4	458	2	Editer les tables	francais	t	0	f
6316	4	459	2	Rapport d''erreurs	francais	t	0	f
6317	4	460	2	Rapport d''erreurs	francais	t	0	f
6318	4	461	2	Configuration	francais	t	0	f
6319	4	462	2	Paramètres généraux	francais	t	0	f
6320	4	463	2	Outils	francais	t	0	f
6321	4	464	2	Outils	francais	t	0	f
6322	4	465	2	Rapports	francais	t	0	f
6323	4	466	2	Editer les rapports	francais	t	0	f
6330	4	473	2	Taille	francais	t	0	f
6332	4	475	2	Contenu	francais	t	0	f
6336	4	483	2	Droits	francais	t	0	f
6340	4	495	2	Général	francais	t	0	f
6341	4	496	2	Paramètres généraux des utilisateurs	francais	t	0	f
6342	4	497	2	Droits des tables	francais	t	0	f
6343	4	498	2	Figer les droits des tables	francais	t	0	f
6344	4	501	2	Tables	francais	t	0	f
6345	4	502	2	Outils des tables	francais	t	0	f
6354	4	517	3	Argument	francais	t	101	f
6355	4	518	3	Variables d''environement	francais	t	101	f
6356	4	519	3	Nom d''utilisateur	francais	t	101	f
6357	4	520	3	Nom complet	francais	t	101	f
6358	4	521	3	Email	francais	t	101	f
6359	4	522	3	Modifier	francais	t	101	f
6361	4	529	3	Valeur RGB de la couleur	francais	t	106	f
6362	4	530	3	valeur HEX de la couleur	francais	t	106	f
6364	4	540	3	Ajouter	francais	t	106	f
6367	4	543	3	Date	francais	t	108	f
6368	4	544	3	Action	francais	t	108	f
6369	4	545	3	Fichier	francais	t	108	f
6370	4	546	3	Ligne	francais	t	108	f
6371	4	547	3	Message d''erreur	francais	t	108	f
6372	4	548	3	Requête SQL	francais	t	108	f
6223	4	311	1	lun 	francais	t	88	f
6224	4	312	1	mar 	francais	t	88	f
6225	4	313	1	mer 	francais	t	88	f
6226	4	314	1	jeu 	francais	t	88	f
6227	4	315	1	ven 	francais	t	88	f
6228	4	316	1	sam 	francais	t	88	f
6246	4	355	2	remarque 	francais	t	0	f
6250	4	359	2	export 	francais	t	0	f
6254	4	363	2	info 	francais	t	0	f
6258	4	367	2	supprimer 	francais	t	0	f
6291	4	428	2	modèle	francais	t	0	f
6375	4	561	3	Groupe	francais	t	115	f
6377	4	563	3	Ajouté	francais	t	115	f
6380	4	569	3	Nom du groupe	francais	t	119	f
6382	4	571	3	Ajouter	francais	t	119	f
6383	4	573	3	Menu	francais	t	120	f
6385	4	575	3	Droits	francais	t	120	f
6387	4	577	3	Tables	francais	t	120	f
6390	4	600	3	Existe déjà!	francais	t	111	f
6398	4	612	3	Email	francais	t	127	f
6546	4	878	1	Vendredi	francais	t	41	f
6401	4	616	3	Résultats affichés max.	francais	t	127	f
6402	4	623	3	Schema de couleur	francais	t	127	f
6403	4	624	3	Langue	francais	t	127	f
6405	4	632	3	Actif	francais	t	46	f
6406	4	633	3	Inactif	francais	t	46	f
6411	4	656	3	Loglevel	francais	t	132	f
6412	4	657	3	Désactivé	francais	t	132	f
6423	4	698	1	Mise en page	francais	t	46	f
6424	4	700	1	Ouvrir le calendrier express	francais	t	34	f
6426	4	704	1	Partager la fenêtre de résultat	francais	t	46	f
6429	4	711	1	Plus grand	francais	t	19	f
6430	4	712	1	Plus petit	francais	t	19	f
6431	4	713	1	Identique	francais	t	19	f
6433	4	716	3	Taille max. upload	francais	t	127	f
6437	4	724	2	Formulaire	francais	t	0	f
6438	4	725	2	Editeur de formulaire	francais	t	0	f
6439	4	726	2	Langue	francais	t	0	f
6440	4	727	2	Table des langues	francais	t	0	f
6443	4	731	2	Formulaire	francais	t	0	f
6444	4	732	2	Formulaire	francais	t	0	f
6391	4	605	3	Utilisateur	francais	t	126	f
6447	4	735	2	Requête	francais	t	0	f
6452	4	745	1	Les modifications ont été enregistrée!	francais	t	37	f
6453	4	749	1	Dernière connexion	francais	t	4	f
6454	4	750	2	Diagramme	francais	t	0	f
6456	4	752	2	Diagramme	francais	t	0	f
6457	4	753	2	Editeur de diagramme	francais	t	0	f
6458	4	763	1	Cet enregistrement est en cours d''édition par un autre utilisateur, et est donc désactivé pour une courte durée!	francais	t	23	f
6459	4	764	1	Les droits ou bien l''enregistrement ont été supprimés!	francais	t	23	f
6462	4	767	1	Message	francais	t	145	f
6463	4	768	1	Recevoir	francais	t	145	f
6464	4	769	1	Envoyé	francais	t	154	f
6465	4	770	1	Supprimé	francais	t	154	f
6466	4	771	2	Renomer	francais	t	0	f
6467	4	772	2	Renomer Dossier/Fichier	francais	t	0	f
6468	4	773	2	Avancé	francais	t	0	f
6469	4	774	2	Recherche avancé	francais	t	0	f
6470	4	777	2	Nouveau dossier	francais	t	0	f
6471	4	778	2	Ajouter un nouveau dossier	francais	t	0	f
6474	4	784	2	Deplacer	francais	t	0	f
6475	4	785	2	Deplacer message	francais	t	0	f
6476	4	786	2	Répondre	francais	t	0	f
6477	4	787	2	Repondre messsage	francais	t	0	f
6478	4	788	2	Faire suivre	francais	t	0	f
6479	4	789	2	Faire suivre le message	francais	t	0	f
6480	4	790	2	Non lu	francais	t	0	f
6481	4	791	2	Marquer le message comme non lu	francais	t	0	f
6494	4	813	1	Dossier public	francais	t	3	f
6495	4	815	2	Nouveau fichier	francais	t	0	f
6496	4	816	2	Ajouter un nouveau fichier	francais	t	0	f
6497	4	817	2	Copier	francais	t	0	f
6498	4	818	2	Copier Fichier/Dossier	francais	t	0	f
6499	4	819	2	Deplacer	francais	t	0	f
6500	4	820	2	Deplacer fichier	francais	t	0	f
6501	4	821	1	Voulez vous supprimer ce dossier ainsi que son contenu?	francais	t	68	f
7237	4	1644	3	Mot clés	francais	t	52	f
6502	4	822	1	Voulez vous supprimer ce(s) fichier(s)?	francais	t	66	f
6505	4	828	2	Formulaire	francais	t	0	f
6506	4	829	2	Formulaire	francais	t	0	f
6507	4	830	2	Suivre	francais	t	0	f
6508	4	831	2	Suivre lien	francais	t	0	f
6509	4	834	2	Général	francais	t	0	f
6511	4	838	2	Vue d''ensemble	francais	t	0	f
6512	4	839	2	Vue d''ensemble utilisateur	francais	t	0	f
6513	4	840	2	Ajouter un groupe	francais	t	0	f
6514	4	841	2	Ajouter un groupe	francais	t	0	f
6515	4	842	1	Sauvegarder	francais	t	54	f
6516	4	843	1	Editer	francais	t	54	f
6517	4	844	1	Fermer	francais	t	54	f
6520	4	847	2	Arrière plan	francais	t	0	f
6521	4	848	2	Modifier la couleur de l''arrière plan	francais	t	0	f
6523	4	851	1	Colonne	francais	t	5	f
6524	4	854	1	et	francais	t	19	f
6525	4	855	1	ou	francais	t	19	f
6526	4	856	1	Voulez vous réellement réinitialiser la session?	francais	t	46	f
6527	4	857	1	Au début	francais	t	13	f
6528	4	858	1	A la fin	francais	t	13	f
6529	4	859	1	Suivant	francais	t	13	f
6530	4	860	1	Précedent	francais	t	13	f
6534	4	866	1	Non	francais	t	5	f
6535	4	867	1	Oui	francais	t	5	f
6538	4	870	1	Ouvrir le site web	francais	t	15	f
6541	4	873	1	Dimanche	francais	t	41	f
6532	4	862	1	En arrière	francais	t	5	f
6542	4	874	1	Lundi	francais	t	41	f
6543	4	875	1	Mardi	francais	t	41	f
6544	4	876	1	Mercredi	francais	t	41	f
6545	4	877	1	Jeudi	francais	t	41	f
6547	4	879	1	Samedi	francais	t	41	f
6548	4	880	1	Janvier	francais	t	41	f
6549	4	881	1	Fevrier	francais	t	41	f
6550	4	882	1	Mars	francais	t	41	f
6551	4	883	1	Avril	francais	t	41	f
6552	4	884	1	Mai	francais	t	41	f
6553	4	885	1	Juin	francais	t	41	f
6554	4	886	1	Juillet	francais	t	41	f
6555	4	887	1	Août	francais	t	41	f
6556	4	888	1	Septembre	francais	t	41	f
6557	4	889	1	Octobre	francais	t	41	f
6564	4	897	3	Sous-groupe de	francais	t	119	f
6566	4	899	3	Supprimer la session de cet utilisateur ?	francais	t	127	f
6567	4	900	3	Groupe principal	francais	t	127	f
6568	4	901	3	Sous groupe	francais	t	127	f
6570	4	903	3	Plage IP	francais	t	127	f
6571	4	904	3	Rafrîchir la session	francais	t	127	f
6572	4	905	3	Renouveller les droits sur tables	francais	t	127	f
6573	4	907	3	Renouveller les menus	francais	t	127	f
6574	4	908	3	Supprimer l''utilisateur	francais	t	132	f
6576	4	911	3	Debug	francais	t	132	f
6580	4	916	3	Générateur de lien	francais	t	107	f
6581	4	917	3	Saisir un lien absolu!	francais	t	107	f
6588	4	925	3	Type	francais	t	110	f
6589	4	926	3	Clé	francais	t	110	f
6590	4	927	3	Unique	francais	t	110	f
6591	4	928	3	Valeur par défaut	francais	t	110	f
6593	4	930	3	Convertir	francais	t	110	f
6594	4	931	3	Recherch.dyn	francais	t	110	f
6602	4	940	3	Enregistrer	francais	t	139	f
6604	4	942	3	Ajouté	francais	t	139	f
6608	4	949	3	ID	francais	t	140	f
6610	4	951	3	Nom de table	francais	t	140	f
6611	4	952	3	Pos	francais	t	140	f
6612	4	953	3	Champs	francais	t	140	f
6619	4	961	3	Archive de table	francais	t	145	f
6620	4	962	3	Export Excel	francais	t	145	f
6621	4	963	3	Export texte	francais	t	145	f
6622	4	964	3	Export système	francais	t	145	f
6569	4	902	3	Photo	francais	t	127	f
6623	4	965	3	Groupe d''archivage	francais	t	145	f
6624	4	966	3	Système complet	francais	t	145	f
6625	4	967	3	Table projet	francais	t	145	f
6626	4	968	3	Tables systèmes dependantes	francais	t	145	f
6627	4	970	3	Export Ok	francais	t	145	f
6628	4	971	3	Ensemble	francais	t	145	f
6629	4	972	3	Enregistrement	francais	t	145	f
6630	4	973	3	Export	francais	t	145	f
6631	4	974	3	Dossier d''export	francais	t	145	f
6643	4	987	3	Terminé	francais	t	147	f
6644	4	988	3	Les champs suivant ne sont pas au bon format	francais	t	148	f
6645	4	990	3	Import partiel	francais	t	148	f
6646	4	991	3	Import texte	francais	t	148	f
6647	4	992	3	D''un fichier texte	francais	t	148	f
6648	4	993	3	Aucun	francais	t	148	f
6649	4	994	3	Tout	francais	t	148	f
6650	4	995	3	Import système	francais	t	148	f
6652	4	997	3	Apercu ligne	francais	t	148	f
6653	4	998	3	Depuis le système de fichier	francais	t	148	f
6655	4	1002	3	Ecraser	francais	t	148	f
6656	4	1003	3	Depend	francais	t	148	f
6657	4	1004	3	Conserver ID	francais	t	148	f
6659	4	1006	3	Import complet	francais	t	148	f
6787	4	1142	3	Hauteur	francais	t	169	f
6660	4	1007	3	Fichier configuration	francais	t	148	f
6662	4	1009	3	Reinstaller	francais	t	148	f
6663	4	1010	3	Type de champs incorrect	francais	t	149	f
6664	4	1011	3	Enregistrements insérer	francais	t	149	f
6665	4	1012	3	Erreur	francais	t	149	f
6667	4	1014	3	Teste de l''instance	francais	t	149	f
6668	4	1015	3	Inserer les données dans la table	francais	t	149	f
6669	4	1016	3	Ligne en erreur	francais	t	149	f
6670	4	1017	3	Lignes insérées	francais	t	149	f
6671	4	1018	3	Créé	francais	t	149	f
6672	4	1019	3	Echoué	francais	t	149	f
6673	4	1020	3	Créer table	francais	t	149	f
6674	4	1021	3	Supprimer table	francais	t	149	f
6675	4	1022	3	Importer rapport	francais	t	149	f
6678	4	1025	3	Indication table	francais	t	149	f
6679	4	1026	3	Ajouter clé externe	francais	t	149	f
6682	4	1029	3	Groupe de table	francais	t	150	f
6689	4	1036	3	Structure	francais	t	150	f
7535	4	1955	3	Assembler	francais	t	168	f
6585	4	922	3	Champs	francais	t	110	f
6595	4	932	3	Select	francais	t	110	f
6690	4	1037	3	Structure et données	francais	t	150	f
6691	4	1038	3	Créer	francais	t	150	f
6692	4	1039	3	Present	francais	t	151	f
6693	4	1040	3	Importer	francais	t	151	f
6703	4	1054	3	Raffraîchir tables et champs	francais	t	154	f
6704	4	1056	3	Raffraîchir menus	francais	t	154	f
6705	4	1057	3	Supprimer sessions	francais	t	154	f
6707	4	1060	3	Information système	francais	t	155	f
6708	4	1061	3	Afficher	francais	t	155	f
6712	4	1065	3	Executer	francais	t	155	f
6714	4	1067	3	Privilèges	francais	t	155	f
6715	4	1068	3	Date de création	francais	t	155	f
6716	4	1069	3	Table vidée avec succès	francais	t	156	f
7604	4	2024	2	Requêtes	francais	t	0	f
6717	4	1070	3	Erreur! La table n''a pas été vidée	francais	t	156	f
6718	4	1071	3	Table vidée avec succès	francais	t	156	f
6719	4	1072	3	Erreur! La table n''a pas été supprimée.	francais	t	156	f
6720	4	1073	3	Requête SQL executée avec succès	francais	t	156	f
6724	4	1078	3	Règle	francais	t	160	f
6728	4	1083	3	URL	francais	t	162	f
6732	4	1087	3	Image	francais	t	162	f
6744	4	1099	3	Element	francais	t	168	f
6745	4	1100	3	Infos image	francais	t	168	f
6747	4	1102	3	Representation	francais	t	168	f
6749	4	1104	3	Couleur de caractère	francais	t	168	f
6750	4	1105	3	Epaisseur	francais	t	168	f
6752	4	1107	3	Couleur de fond	francais	t	168	f
6753	4	1108	3	Symetrie	francais	t	168	f
6754	4	1109	3	Colonnes	francais	t	168	f
6756	4	1111	3	Marge	francais	t	168	f
6757	4	1112	3	Entête	francais	t	168	f
6758	4	1113	3	Pied de page	francais	t	168	f
6759	4	1114	3	Liste	francais	t	168	f
6760	4	1115	3	Style de police	francais	t	168	f
6762	4	1117	3	Decoration du texte	francais	t	168	f
6763	4	1118	3	Transformation du texte	francais	t	168	f
6764	4	1119	3	Alignement du texte	francais	t	168	f
6765	4	1120	3	Espacement des lignes	francais	t	168	f
6766	4	1121	3	Espacement des lettres	francais	t	168	f
6767	4	1122	3	Espacement des mots	francais	t	168	f
6768	4	1123	3	Normal	francais	t	168	f
6769	4	1124	3	Oblique	francais	t	168	f
6770	4	1125	3	Gras	francais	t	168	f
6771	4	1126	3	Souligné	francais	t	168	f
6772	4	1127	3	Majuscule	francais	t	168	f
6773	4	1128	3	Minuscule	francais	t	168	f
6774	4	1129	3	Citation	francais	t	168	f
6775	4	1130	3	Droite	francais	t	168	f
6776	4	1131	3	Centré	francais	t	168	f
6777	4	1132	3	A droite	francais	t	168	f
6779	4	1134	3	Histoirque	francais	t	168	f
6781	4	1136	3	Recalculer	francais	t	168	f
6783	4	1138	3	Police	francais	t	169	f
6785	4	1140	3	Taille de la page (mm)	francais	t	169	f
6786	4	1141	3	Largeur	francais	t	169	f
6788	4	1143	3	Marge (mm)	francais	t	169	f
6789	4	1144	3	Haut	francais	t	169	f
6790	4	1145	3	Bas	francais	t	169	f
6791	4	1146	3	Gauche	francais	t	169	f
6792	4	1147	3	Droite	francais	t	169	f
6793	4	1148	3	Proportionnel	francais	t	169	f
6794	4	1149	3	Bloc de text	francais	t	169	f
6795	4	1150	3	Contenu	francais	t	169	f
6796	4	1151	3	Graphique	francais	t	169	f
6797	4	1152	3	Ligne	francais	t	169	f
6798	4	1153	3	Rectangle	francais	t	169	f
6799	4	1154	3	Ellipse	francais	t	169	f
6807	4	1162	3	pour la table	francais	t	170	f
6810	4	1165	3	Nouveau rapport	francais	t	170	f
6811	4	1167	3	Le graphique n''a pu être sauvegarder correctement	francais	t	172	f
6814	4	1170	3	Police	francais	t	175	f
6815	4	1171	3	Sous-formulaire	francais	t	175	f
6818	4	1174	3	Button submit	francais	t	175	f
6820	4	1176	3	Qualité	francais	t	175	f
6823	4	1179	3	Formulaire	francais	t	176	f
6827	4	1183	3	Créer avec un enregistrement unique	francais	t	176	f
6828	4	1184	3	Créer avec une liste d''enregistrement	francais	t	176	f
6829	4	1186	3	Nouveau formulaire	francais	t	176	f
6834	4	1191	3	Nouveau diagramme	francais	t	177	f
6841	4	1200	2	Gestionnaire de fichier	francais	t	0	f
6842	4	1201	2	Gestionnaire de fichier	francais	t	0	f
6843	4	1203	3	Import texte	francais	t	180	f
6845	4	1205	3	Status	francais	t	180	f
6857	4	1217	3	Ouvrir	francais	t	180	f
6858	4	1218	3	Ok	francais	t	180	f
6859	4	1219	3	Général	francais	t	180	f
6860	4	1220	3	Admin	francais	t	180	f
6861	4	1221	3	Système	francais	t	180	f
6862	4	1222	3	Choix de la langue	francais	t	180	f
6867	4	1232	2	Progression	francais	t	0	f
6868	4	1233	2	Progression	francais	t	0	f
6871	4	1240	1	Inclure sous-répertoire	francais	t	20	f
6873	4	1244	1	Horizontal	francais	t	5	f
6874	4	1245	1	Vertical	francais	t	5	f
6875	4	1246	1	Sans	francais	t	5	f
6876	4	1249	3	Déconnecter	francais	t	132	f
6878	4	1251	1	Voulez vous vous déconnecter?	francais	t	11	f
6883	4	1257	1	Cacher	francais	t	122	f
6885	4	1259	1	Editer	francais	t	122	f
7138	4	1527	1	Enregistrer	francais	t	5	f
6808	4	1163	3	Action	francais	t	170	f
6817	4	1173	3	Barre défilement	francais	t	175	f
6894	4	1268	2	Droits des tables	francais	t	0	f
6895	4	1269	2	Actualiser les droits des tables	francais	t	0	f
6896	4	1270	2	Droit des menus	francais	t	0	f
6897	4	1271	2	Actualiser les droits des menus	francais	t	0	f
6877	4	1250	3	Infos	francais	t	132	f
6907	4	1281	2	Définir relation	francais	t	0	f
6908	4	1282	2	Définir relation	francais	t	0	f
6910	4	1284	2	Supprimer la relatioj	francais	t	0	f
6911	4	1285	1	Enregegistrement déjà lié.	francais	t	27	f
6912	4	1286	2	Taille de bordure	francais	t	0	f
6914	4	1288	2	Taille du tableau	francais	t	0	f
6915	4	1289	2	Taille de tableau automatique	francais	t	0	f
6916	4	1290	2	Editer la liste	francais	t	0	f
6917	4	1291	2	Vue edition	francais	t	0	f
6920	4	1294	1	A la première page	francais	t	5	f
6921	4	1295	1	A a dernière page	francais	t	5	f
6872	4	1242	1	Rechercher	francais	t	20	f
6922	4	1296	1	Une page en arrière	francais	t	5	f
6923	4	1297	1	Une page en avant	francais	t	5	f
6924	4	1298	1	Ouvrir les relations	francais	t	15	f
6925	4	1299	1	Créer relation	francais	t	15	f
6926	4	1300	3	Autoriser les changements de mot de passe	francais	t	127	f
6927	4	1301	2	Editeur de relation	francais	t	0	f
6928	4	1302	2	Editeur de relation	francais	t	0	f
6929	4	1303	3	Créer nouvelle liaison!	francais	t	121	f
6930	4	1304	3	Recalculer!	francais	t	101	f
6931	4	1305	2	Corbeille	francais	t	0	f
6932	4	1306	2	Cacher l''enregistrement	francais	t	0	f
6909	4	1283	2	Supprimer la relation	francais	t	0	f
6933	4	1307	2	Ouvrir la corbeille	francais	t	0	f
7068	4	1451	1	Supprimer!	francais	t	192	f
6934	4	1308	2	Ouvrir la corbeille	francais	t	0	f
6936	4	1310	2	Recréer l''enregistrement	francais	t	0	f
6937	4	1311	1	L#enregistrement, doit-il être recréé?	francais	t	13	f
6938	4	1312	1	L''enregistrement va être envoyé à la corbeille.	francais	t	25	f
6939	4	1313	1	L''enregistrement a été recréé!	francais	t	25	f
6881	4	1255	3	Règles des symboles	francais	t	122	f
7509	4	1929	3	Calendrier	francais	t	140	f
6950	4	1325	1	L''enregistrement a été supprimer avec succès!	francais	t	25	f
7145	4	1534	3	Encadré	francais	t	168	f
6951	4	1326	1	L''enregistrement a été deplacé vers la corbeille!	francais	t	25	f
6952	4	1327	1	L''enregistrement a été recréé!	francais	t	25	f
6955	4	1330	1	Tout déselectionner	francais	t	14	f
6956	4	1331	1	Tout selectionner	francais	t	14	f
6957	4	1333	1	Ajouter à la valeur	francais	t	14	f
6958	4	1334	1	Soustraire de la valeur	francais	t	14	f
6962	4	1338	1	Remplacer avec la date	francais	t	14	f
6963	4	1339	1	Ajouter un jour	francais	t	14	f
6964	4	1340	1	Soustrraire un jour	francais	t	14	f
6965	4	1341	1	Modifier!	francais	t	14	f
6966	4	1342	1	affichés	francais	t	5	f
6969	4	1345	2	Calendrier	francais	t	0	f
6970	4	1346	2	Agenda	francais	t	0	f
6977	4	1354	2	Texte 8	francais	t	0	f
6978	4	1355	2	Texte 10	francais	t	0	f
6979	4	1356	2	Texte 20	francais	t	0	f
6980	4	1357	2	Texte 30	francais	t	0	f
6981	4	1358	2	Texte 50	francais	t	0	f
6982	4	1359	2	Texte 128	francais	t	0	f
6983	4	1360	2	Texte 160	francais	t	0	f
6991	4	1368	2	URL	francais	t	0	f
6994	4	1371	2	Choix (Select)	francais	t	0	f
6998	4	1375	2	Argument	francais	t	0	f
7007	4	1384	2	-------Type de champs standard -------	francais	t	0	f
7008	4	1385	2	-------Autre type  de champs -------	francais	t	0	f
7013	4	1390	2	Texte max 8 caractères	francais	t	0	f
7014	4	1391	2	Texte max 10 caractères	francais	t	0	f
7015	4	1392	2	Texte max 20 caractères	francais	t	0	f
7016	4	1393	2	Texte max 30 caractères	francais	t	0	f
7017	4	1394	2	Texte max 50 caractères	francais	t	0	f
7018	4	1395	2	Texte max 128 caractères	francais	t	0	f
7019	4	1396	2	Texte max 160 caractères	francais	t	0	f
7027	4	1404	2	URL avec maximum 255 caractères	francais	t	0	f
7028	4	1405	2	Email avec maximum 128 caractères	francais	t	0	f
7030	4	1407	2	Champs de choix (select)	francais	t	0	f
7034	4	1411	2	Formule (eval)	francais	t	0	f
7043	4	1420	1	Désactiver tous les utilisateurs	francais	t	154	f
7046	4	1423	2	Vérirfier les nouveaux messages	francais	t	0	f
7048	4	1431	3	Connexion	francais	t	182	f
7050	4	1433	3	Surveiller	francais	t	182	f
7052	4	1435	1	Jour	francais	t	188	f
7053	4	1436	1	Semaine	francais	t	188	f
7054	4	1437	1	Mois	francais	t	188	f
7055	4	1438	1	Année	francais	t	188	f
7058	4	1441	1	Rendez-vous	francais	t	192	f
7059	4	1442	1	Vacances	francais	t	192	f
7060	4	1443	1	Couleur.	francais	t	192	f
7061	4	1444	1	Rappel:	francais	t	192	f
7062	4	1445	1	De:	francais	t	192	f
7063	4	1446	1	A:	francais	t	192	f
7064	4	1447	1	Sujet:	francais	t	192	f
7065	4	1448	1	Contenu:	francais	t	192	f
7066	4	1449	1	Type:	francais	t	192	f
6985	4	1362	2	Bloc texte 399	francais	t	0	f
7003	4	1380	2	Date création	francais	t	0	f
7039	4	1416	2	Date de création	francais	t	0	f
7004	4	1381	2	Date edition	francais	t	0	f
7040	4	1417	2	Date de dernière édition	francais	t	0	f
7021	4	1398	2	Bloc de texte max 399 caractères	francais	t	0	f
7076	4	1459	3	Regroupable	francais	t	110	f
7077	4	1460	3	Relation	francais	t	140	f
7080	4	1463	3	Proportionnel	francais	t	168	f
7081	4	1464	3	Copier	francais	t	176	f
7085	4	1470	2	Supprimer	francais	t	0	f
7086	4	1471	2	Supprimer Fichier/Dossier	francais	t	0	f
7087	4	1472	1	Aucun fichier trouvé!	francais	t	66	f
7091	4	1476	2	Supprimer	francais	t	0	f
7092	4	1477	2	Supprimer le message	francais	t	0	f
7096	4	1481	3	Inclure dossier utilisateur	francais	t	127	f
7101	4	1486	2	Historique	francais	t	0	f
7102	4	1487	2	Historique de l''enregistrement	francais	t	0	f
7110	4	1495	3	Configurer	francais	t	168	f
7113	4	1498	2	Archive des rapports	francais	t	0	f
7114	4	1499	2	Archive des rapports	francais	t	0	f
7116	4	1501	2	Apecu de rapport	francais	t	0	f
7117	4	1502	2	Impression de rapport	francais	t	0	f
7000	4	1377	2	Relation n:m	francais	t	0	f
7036	4	1413	2	Ex: Commande (n) -> Article (m)	francais	t	0	f
7001	4	1378	2	Créateur	francais	t	0	f
7037	4	1414	2	Utilisateur ayant crée l''enregistrement	francais	t	0	f
7002	4	1379	2	Editeru	francais	t	0	f
7038	4	1415	2	Utilisateur ayant modifié l''enregistrement en dernier	francais	t	0	f
7031	4	1408	2	Champs de choix multiple sous forme de MULTISELECT	francais	t	0	f
10629	2	2381	3	Reference	english	t	52	f
7118	4	1503	2	Impression de rapport	francais	t	0	f
7119	4	1505	3	Javascript	francais	t	175	f
7121	4	1507	1	Non	francais	t	15	f
7032	4	1409	2	Champs de choix multiple sous forme de nouvelle popup	francais	t	0	f
7122	4	1508	3	Champs requis	francais	t	122	f
7123	4	1509	1	Le champs suivant ne sera pas rempli!	francais	t	13	f
6997	4	1374	2	Upload	francais	t	0	f
7125	4	1513	3	Groupe supprimer	francais	t	116	f
7126	4	1514	2	Type de champs	francais	t	0	f
7127	4	1515	2	Table - Type de champs	francais	t	0	f
7128	4	1516	3	type_champs	francais	t	160	f
7129	4	1517	3	type_donnee	francais	t	160	f
7130	4	1518	3	funcid	francais	t	160	f
7131	4	1519	3	Type de donnée	francais	t	160	f
7135	4	1524	1	Enregistrer et ajouter un nouveau	francais	t	13	f
7137	4	1526	1	Afficher liste	francais	t	13	f
7141	4	1530	1	Enregistrer et suivant	francais	t	13	f
7142	4	1531	1	Enregistrer et précedant	francais	t	13	f
7143	4	1532	3	Deviation	francais	t	127	f
6974	4	1351	2	Nombre (10)	francais	t	0	f
7010	4	1387	2	Nombre à 10 chiffres	francais	t	0	f
7011	4	1388	2	Nombre à 18 chiffres	francais	t	0	f
7146	4	1535	3	Pointillé	francais	t	168	f
7147	4	1536	3	Tiret	francais	t	168	f
7148	4	1537	3	Double	francais	t	168	f
7149	4	1538	3	3D interieur	francais	t	168	f
7150	4	1539	3	3D externe	francais	t	168	f
7151	4	1540	3	Type	francais	t	168	f
7152	4	1541	3	Couleur de bordure	francais	t	168	f
7153	4	1544	1	Afficher les meta données	francais	t	15	f
7154	4	1545	1	Modifier les meta données	francais	t	15	f
7157	4	1552	1	Nom physique	francais	t	15	f
7158	4	1560	1	Archive	francais	t	15	f
7161	4	1563	1	Format	francais	t	15	f
7162	4	1564	1	Geometrie	francais	t	15	f
7163	4	1565	1	Résolution	francais	t	15	f
7164	4	1566	1	Nombre de couleur	francais	t	15	f
7165	4	1567	1	Couleurs	francais	t	15	f
7168	4	1571	1	Rétablir	francais	t	20	f
7169	4	1572	2	Sauvegarde	francais	t	0	f
7170	4	1573	2	Sauvegarde système	francais	t	0	f
7171	4	1574	1	La contrainte d''intégré a été violée	francais	t	25	f
7172	4	1575	2	Historique	francais	t	0	f
7173	4	1576	2	Sauvegarde - Historique	francais	t	0	f
7174	4	1577	2	Périiodique	francais	t	0	f
7084	4	1469	1	Vue arbre	francais	t	20	f
7175	4	1578	2	Sauvegarde périodique	francais	t	0	f
7176	4	1579	2	interactive	francais	t	0	f
7177	4	1580	2	Sauvegarde interactive	francais	t	0	f
7536	4	1956	3	Séparé	francais	t	168	f
7178	4	1581	3	Extraction des mots clés	francais	t	110	f
7179	4	1582	2	Indexation	francais	t	0	f
7180	4	1583	2	Extraction des mots clés	francais	t	0	f
7181	4	1584	2	Périodique	francais	t	0	f
7182	4	1585	2	Indexation périodique	francais	t	0	f
7183	4	1588	2	Historique	francais	t	0	f
7184	4	1589	2	Indexation - Historique	francais	t	0	f
7185	4	1590	1	Indexé	francais	t	15	f
7191	4	1597	1	Phonétique	francais	t	19	f
7194	4	1600	1	Mot de passe (vérification)	francais	t	46	f
7202	4	1608	1	Vous devez donnez un nom!	francais	t	5	f
7205	4	1612	2	Download	francais	t	0	f
7206	4	1613	2	Download fichier archive	francais	t	0	f
7207	4	1614	3	Defaut	francais	t	122	f
7208	4	1615	2	Ajouter	francais	t	0	f
7209	4	1616	2	Ajouter fichier/dossier	francais	t	0	f
7210	4	1617	2	Droit sur les fichiers	francais	t	0	f
7211	4	1618	2	Fixer les droits sur les fichiers	francais	t	0	f
7214	4	1621	2	Fichiers	francais	t	0	f
7218	4	1625	1	Vue	francais	t	66	f
7219	4	1626	1	Rechercher	francais	t	66	f
7220	4	1627	1	Nom incorrect!	francais	t	66	f
7221	4	1628	2	Sauvegarder	francais	t	0	f
7222	4	1629	2	Downloader fichier	francais	t	0	f
7225	4	1632	2	Info	francais	t	0	f
7226	4	1633	2	Meta données/info du fichier	francais	t	0	f
7227	4	1634	3	Général	francais	t	52	f
7228	4	1635	3	META	francais	t	52	f
7230	4	1637	3	Mimetype	francais	t	52	f
7231	4	1638	3	crée par	francais	t	52	f
7232	4	1639	3	Crée le	francais	t	52	f
7233	4	1640	3	Entête	francais	t	52	f
7234	4	1641	3	Autre nom	francais	t	52	f
7235	4	1642	3	Créateur	francais	t	52	f
7236	4	1643	3	Nom du créateur (nom, prénom)	francais	t	52	f
7238	4	1645	3	Mot clés séparés par une virgule	francais	t	52	f
7240	4	1647	3	Résumé, description du contenu	francais	t	52	f
7241	4	1648	3	Distributeur	francais	t	52	f
7242	4	1649	3	Distributeur, université,etc ...	francais	t	52	f
7243	4	1650	3	Co-auteur	francais	t	52	f
7244	4	1651	3	Nom du co-auteur	francais	t	52	f
7246	4	1653	3	Type de document	francais	t	52	f
7247	4	1656	3	Identification	francais	t	52	f
7392	4	1806	2	Table	francais	t	182	f
7248	4	1657	3	(ISBN, ISSN, URL ou tout autre identifiant unique du document)	francais	t	52	f
7250	4	1659	3	Travail, imprimé ou électronique	francais	t	52	f
7252	4	1661	3	Langue du document	francais	t	52	f
7254	4	1663	3	Source	francais	t	52	f
7255	4	1664	3	Attribut	francais	t	52	f
7256	4	1665	3	Vérifié	francais	t	52	f
7257	4	1666	3	Libre	francais	t	52	f
7258	4	1667	3	Format graphique	francais	t	52	f
7259	4	1668	3	min.	francais	t	52	f
7261	4	1670	3	Désactivé	francais	t	52	f
7263	4	1677	3	Classification	francais	t	52	f
7264	4	1678	3	Remarques sur le document séparés par virgule	francais	t	52	f
7265	4	1679	1	Copie de	francais	t	66	f
7269	4	1683	1	Fichier déjà existante!	francais	t	66	f
7270	4	1684	1	Dossier déjà existant!	francais	t	66	f
7271	4	1685	3	Copie	francais	t	52	f
7272	4	1686	3	Le dossier utilisateur ne peut être supprimé!	francais	t	29	f
7273	4	1687	3	Afficher les utilisateurs supprimés	francais	t	132	f
7274	4	1688	1	Le fichier est désactivé !	francais	t	66	f
7278	4	1692	1	Rapport créé.	francais	t	93	f
7279	4	1693	1	Editer	francais	t	66	f
7282	4	1696	1	Messages et Fichiers ne peuvent être mélangés!	francais	t	97	f
7283	4	1697	1	The dossier n''est modifiable qu''au travers du mode table, message ou rapport.	francais	t	66	f
7284	4	1698	2	Copier	francais	t	0	f
7285	4	1699	2	Copier message	francais	t	0	f
7286	4	1700	2	Enregistrer	francais	t	0	f
7291	4	1705	1	Document	francais	t	3	f
7292	4	1706	1	Image	francais	t	3	f
7295	4	1709	1	Voulez vous supprimer le contenu du dossier ?	francais	t	66	f
7296	4	1710	1	Upload refusé	francais	t	66	f
7297	4	1711	2	Marquer	francais	t	0	f
7298	4	1712	2	Marquer message	francais	t	0	f
7303	4	1717	1	Aucun fichier sélectionné!	francais	t	66	f
7305	4	1719	3	Indexé le:	francais	t	52	f
7306	4	1720	3	Index	francais	t	52	f
7307	4	1721	1	Utilisateur:	francais	t	23	f
7308	4	1722	1	Temps restant (min.):	francais	t	23	f
7310	4	1724	2	Rafraichir l''apercu	francais	t	0	f
7311	4	1725	2	Régénérer l''apercu	francais	t	0	f
7313	4	1727	3	Supprimer completement	francais	t	127	f
7314	4	1728	3	Activer l''utilisateur	francais	t	132	f
7315	4	1729	2	Copier	francais	t	0	f
7316	4	1730	2	Copier l''enregistrement	francais	t	0	f
7319	4	1733	1	Aucun enregistrement sélectionné!	francais	t	5	f
7321	4	1735	2	Nouvelle fenêtre	francais	t	0	f
7322	4	1736	2	Nouveau explorer LIMBAS	francais	t	0	f
7323	4	1737	3	EXIF	francais	t	52	f
7324	4	1738	3	IPTC	francais	t	52	f
7325	4	1739	3	Apercu	francais	t	52	f
7326	4	1740	3	XMP	francais	t	52	f
7327	4	1741	3	Description de l''objet	francais	t	52	f
7328	4	1742	3	Mot clé	francais	t	52	f
7329	4	1743	3	Categorie	francais	t	52	f
7330	4	1744	3	Droit d''image	francais	t	52	f
7331	4	1745	3	Origine	francais	t	52	f
7332	4	1746	3	Copyright	francais	t	52	f
7333	4	1747	3	Résultat	francais	t	52	f
7334	4	1748	3	Urgence	francais	t	52	f
7335	4	1749	3	Categorie	francais	t	52	f
7336	4	1750	3	Auteur	francais	t	52	f
7338	4	1752	3	Lieu	francais	t	52	f
7339	4	1753	3	Ville / region	francais	t	52	f
7340	4	1754	3	Pays	francais	t	52	f
7341	4	1755	3	Code	francais	t	52	f
7342	4	1756	3	Remarque	francais	t	52	f
7343	4	1757	3	Nom de l''objet	francais	t	52	f
7344	4	1758	3	Sous-categorie	francais	t	52	f
7345	4	1759	2	Convertir	francais	t	0	f
7346	4	1760	2	Convertir fichier	francais	t	0	f
7348	4	1762	1	Methode	francais	t	66	f
7349	4	1763	3	Résultat	francais	t	168	f
7350	4	1764	3	OnClick	francais	t	168	f
7351	4	1765	3	OnDblClick	francais	t	168	f
7607	4	2027	3	Editeur	francais	t	205	f
7352	4	1766	3	OnMouseOver	francais	t	168	f
7353	4	1767	3	OnMouseOut	francais	t	168	f
7354	4	1768	3	OnChange	francais	t	168	f
7355	4	1769	2	Mode edition	francais	t	0	f
7356	4	1770	2	Editer champs long	francais	t	0	f
7358	4	1772	3	Script PHP	francais	t	175	f
7359	4	1773	3	Description des données	francais	t	169	f
7360	4	1774	3	Champs de recherche	francais	t	169	f
7362	4	1776	3	Visible	francais	t	168	f
7363	4	1777	3	Couper	francais	t	168	f
7364	4	1778	3	Scrollable	francais	t	168	f
7365	4	1779	3	Loguer	francais	t	140	f
7366	4	1780	3	Actions	francais	t	127	f
7368	4	1782	2	Comparaison	francais	t	0	f
7369	4	1783	2	Comparaison des enregistrements	francais	t	0	f
7312	4	1726	1	Fichier supprimé ou deplacé!	francais	t	66	f
7373	4	1787	1	Archiver	francais	t	13	f
7374	4	1788	1	Rapport	francais	t	5	f
7375	4	1789	3	Afficher utilisateur actif	francais	t	132	f
7496	4	1916	2	Affiché	francais	t	0	f
7376	4	1790	3	Afficher tous les utilisateurs	francais	t	132	f
7377	4	1791	3	Statistiques	francais	t	132	f
7378	4	1792	3	Modifié	francais	t	132	f
7504	4	1924	3	Autres	francais	t	52	f
7379	4	1793	3	Afficher utilisateurs desactivés	francais	t	132	f
7383	4	1797	1	0 (pas de log)	francais	t	127	f
7384	4	1798	1	1 (seulement les actions sur BDD)	francais	t	127	f
7385	4	1799	1	2 (log complet)	francais	t	127	f
7386	4	1800	2	Connecter	francais	t	182	f
7387	4	1801	2	Deconnecter	francais	t	182	f
7388	4	1802	2	IP	francais	t	182	f
7389	4	1803	2	Durée	francais	t	182	f
7390	4	1804	2	Date	francais	t	182	f
7393	4	1807	2	ID	francais	t	182	f
7394	4	1808	2	Type	francais	t	182	f
7395	4	1809	3	Menu principal	francais	t	163	f
7396	4	1810	3	Admin	francais	t	163	f
7398	4	1812	3	Menu utilisateur	francais	t	163	f
7399	4	1813	3	Autre menu	francais	t	163	f
7400	4	1814	3	Sous-groupe	francais	t	162	f
7401	4	1815	3	Tri	francais	t	162	f
7403	4	1817	3	Mot de passe valable jusqu''à	francais	t	127	f
7407	4	1823	3	Génrateur	francais	t	121	f
7408	4	1824	3	Vers table en relation	francais	t	121	f
7411	4	1827	1	Opérateur conditionnel	francais	t	19	f
7412	4	1828	2	Info	francais	t	0	f
7413	4	1829	2	Info sur LIMBAS	francais	t	0	f
7414	4	1830	3	Choix echantillon	francais	t	104	f
7416	4	1832	3	Nouvel echantillon	francais	t	104	f
7537	4	1957	3	Marge	francais	t	168	f
7421	4	1837	3	Trier	francais	t	104	f
7422	4	1838	3	Entrer	francais	t	104	f
7423	4	1839	3	En arrière	francais	t	104	f
7424	4	1840	3	En avant	francais	t	104	f
7427	4	1843	1	Valeur	francais	t	12	f
7428	4	1844	1	De	francais	t	12	f
7429	4	1845	1	Sélectionné	francais	t	12	f
7430	4	1846	1	Affiché	francais	t	12	f
7431	4	1847	3	Mise à jour du système	francais	t	154	f
7433	4	1849	3	Synchroniser la structure des dossiers	francais	t	154	f
7434	4	1850	2	Index	francais	t	0	f
7435	4	1851	2	Index de table	francais	t	0	f
7440	4	1856	3	Utilisé	francais	t	195	f
7442	4	1858	3	Renouveller	francais	t	195	f
7446	4	1862	2	Jobs	francais	t	0	f
7447	4	1863	2	Jobs - Gabarits	francais	t	0	f
7448	4	1864	2	Périodique	francais	t	0	f
7449	4	1865	2	Jobs périodique	francais	t	0	f
7450	4	1866	2	Historique	francais	t	0	f
7451	4	1867	2	Jobs - historique	francais	t	0	f
7453	4	1869	2	Augmenter la limite	francais	t	0	f
7454	4	1870	2	Augmenter la limite de résultat	francais	t	0	f
7455	4	1872	3	Menu Info	francais	t	163	f
7456	4	1873	2	Deconnecter	francais	t	0	f
7457	4	1874	2	Deconnecter	francais	t	0	f
7458	4	1875	2	Reset	francais	t	0	f
7459	4	1876	2	Reset application	francais	t	0	f
7460	4	1877	2	Schema des tables	francais	t	0	f
7461	4	1878	2	Schema des tables	francais	t	0	f
7462	4	1879	3	Editable	francais	t	110	f
7463	4	1880	3	Format de nombre	francais	t	110	f
7464	4	1881	3	Reg Exp	francais	t	110	f
7466	4	1883	3	Devise	francais	t	110	f
7468	4	1885	3	WYSIWYG	francais	t	110	f
7469	4	1886	3	Séparateur de valeur	francais	t	110	f
7470	4	1887	3	Affichage des relations	francais	t	110	f
7471	4	1888	2	Police	francais	t	0	f
7472	4	1889	2	Gestionnaire de polices	francais	t	0	f
7473	4	1891	2	Rétablir	francais	t	0	f
7474	4	1892	2	Rétablir la recherche	francais	t	0	f
7475	4	1893	3	Général	francais	t	164	f
7476	4	1894	3	Chemin d''installation	francais	t	164	f
7477	4	1895	3	Mise en page	francais	t	164	f
7478	4	1896	3	Paramètres des tables	francais	t	164	f
7479	4	1898	3	Paramètres des index	francais	t	164	f
7480	4	1899	3	Paramètres des fichiers	francais	t	164	f
7639	4	2060	2	Worfklow	francais	t	0	f
7482	4	1901	1	Les meta données ne peuvent être correctement lues.	francais	t	41	f
7483	4	1902	1	Partie de mot	francais	t	66	f
7484	4	1903	1	Phrase complète	francais	t	66	f
7485	4	1904	1	Sensible à la casse	francais	t	66	f
7489	4	1908	3	Rechercher dans les meta données	francais	t	52	f
7490	4	1909	1	Aucun apercu pour ce type de fichier.	francais	t	66	f
7492	4	1911	2	Rechercher dans tous les répertoires marqués	francais	t	0	f
7495	4	1915	1	Aucun document trouvé!	francais	t	66	f
7497	4	1917	2	Calcul des champs visible	francais	t	0	f
7500	4	1920	2	Sauvegarder les paramètres	francais	t	0	f
7501	4	1921	2	Sauvegarder les paramêtres courrant du dossier	francais	t	0	f
7502	4	1922	2	Sauvegarder l''affichage	francais	t	0	f
7503	4	1923	2	Enregistrer cette apparence pour tous les dossiers.	francais	t	0	f
7511	4	1931	2	Heure	francais	t	0	f
7514	4	1934	2	00:00:00	francais	t	0	f
7515	4	1935	2	Fichier	francais	t	0	f
7519	4	1939	1	Extra	francais	t	66	f
7527	4	1947	3	Champs de saisie - text	francais	t	175	f
7528	4	1948	3	Champs de saisie - textarea	francais	t	175	f
7529	4	1949	3	Champs de choix - select	francais	t	175	f
7530	4	1950	3	Element case à cocher	francais	t	175	f
7531	4	1951	3	Element bouton radio	francais	t	175	f
7534	4	1954	3	Fenêtre multi-usage	francais	t	115	f
7541	4	1961	3	Choix	francais	t	168	f
7542	4	1962	3	Oui	francais	t	168	f
7543	4	1963	3	Non	francais	t	168	f
7545	4	1965	2	Public	francais	t	0	f
7491	4	1910	2	Enregistrer recherche	francais	t	0	f
7547	4	1967	3	Capture	francais	t	168	f
7548	4	1968	3	Caché	francais	t	168	f
7555	4	1975	1	Dans	francais	t	13	f
7556	4	1976	1	Le	francais	t	13	f
7560	4	1980	1	Minutes	francais	t	13	f
7561	4	1981	1	Heures	francais	t	13	f
7562	4	1982	1	Jours	francais	t	13	f
7563	4	1983	1	Semaines	francais	t	13	f
7565	4	1985	1	Années	francais	t	13	f
7566	4	1986	3	Extension	francais	t	162	f
7567	4	1987	3	TriggerOnCh	francais	t	122	f
7568	4	1988	2	Trigger	francais	t	0	f
7569	4	1989	2	Trigger	francais	t	0	f
7806	2	2118	2	Diagram	english	t	\N	f
7807	4	2118	2	Diagramm	francais	t	\N	f
7572	4	1992	3	Reconstruire les tables du gestionnaire de fichier	francais	t	154	f
7575	4	1995	3	Debug	francais	t	164	f
7578	4	1998	1	Enregistrer sous	francais	t	5	f
7516	4	1936	2	Vue fichier	francais	t	0	f
7580	4	2000	1	Administrer	francais	t	5	f
7586	4	2006	1	Enregistré avec succès!	francais	t	0	f
7587	4	2007	1	Supprimé avec succès!	francais	t	0	f
7588	4	2008	1	Envoyé avec succès!	francais	t	0	f
7596	4	2016	1	Excel	francais	t	5	f
7597	4	2017	1	XML	francais	t	5	f
7600	4	2020	3	Conversion du champs:	francais	t	110	f
7601	4	2021	3	Les données trop longue vont être coupées ou supprimées!	francais	t	110	f
7603	4	2023	3	Requête	francais	t	140	f
7605	4	2025	2	Génrateur de requêtes	francais	t	0	f
7606	4	2026	3	SQL	francais	t	205	f
7610	4	2030	3	Raffraîchir les champs multiselect	francais	t	154	f
7544	4	1964	3	Select menu	francais	t	168	f
7615	4	2035	3	Workflow	francais	t	140	f
7617	4	2038	2	Mes taches	francais	t	0	f
7618	4	2039	2	Editer le workflow	francais	t	0	f
7621	4	2042	1	Dernier utilisateur	francais	t	208	f
7622	4	2043	1	Utilisateur actuel	francais	t	208	f
7623	4	2044	1	Prochain utilisateur	francais	t	208	f
7739	2	2101	3	set position	english	t	168	f
7625	4	2046	1	Voulez-vous mettre se workflow en attente?	francais	t	208	f
7626	4	2047	1	Voulez-vous supprimer ce workflow?	francais	t	208	f
7627	4	2048	1	Tache	francais	t	208	f
7628	4	2049	1	De	francais	t	208	f
7629	4	2050	1	A	francais	t	208	f
7636	4	2057	1	Mes workflows	francais	t	204	f
7637	4	2058	1	Aucune tache	francais	t	204	f
7640	4	2061	1	Premier enregistrement!	francais	t	23	f
7641	4	2062	1	Dernier enregistrement!	francais	t	23	f
7642	4	2063	3	Z-index	francais	t	175	f
7643	4	2064	3	A l''avant plan	francais	t	168	f
3054	3	311	1	lunes	Espagñol	t	88	f
7644	4	2065	3	A l''arrière plan	francais	t	168	f
7646	4	2067	3	Reconstruire:	francais	t	168	f
7647	4	2068	3	N°	francais	t	212	f
7649	4	2070	3	Durée	francais	t	212	f
7651	4	2072	3	Actif	francais	t	212	f
7653	4	2074	3	Minute	francais	t	212	f
7654	4	2075	3	Heure	francais	t	212	f
7655	4	2076	3	Jour du mois	francais	t	212	f
7657	4	2078	3	Jour de la semaine	francais	t	212	f
7658	4	2079	3	Ajouter un job	francais	t	212	f
7659	4	2080	3	Structure des fichier	francais	t	212	f
7662	1	2082	1	Workflow wurde erfolgreich gestartet!	deutsch	t	5	f
7663	2	2082	1	Workflow successfully started!	english	t	5	f
7664	4	2082	1	Le workflow a été démarré avec succès!	francais	t	5	f
7666	1	2083	1	keine Datensätze ausgewählt!	deutsch	t	5	f
10932	1	2457	3	Modus	deutsch	t	168	f
7668	4	2083	1	Aucun enregistrement sélectionné!	francais	t	5	f
7670	2	2084	2	my workflows	english	t	\N	f
7671	4	2084	2	Mes Workflows	francais	t	\N	f
7674	2	2085	2	create workflow	english	t	\N	f
7675	4	2085	2	Workflows créés	francais	t	\N	f
7669	1	2084	2	Meine Workflows	deutsch	t	\N	f
7673	1	2085	2	erstelle Workflow	deutsch	t	\N	f
7686	1	2088	3	versteckt	deutsch	t	168	f
7687	2	2088	3	hidden	english	t	168	f
7688	4	2088	3	Caché	francais	t	168	f
7698	1	2091	3	erste Seite	deutsch	t	168	f
7700	4	2091	3	Page 1	francais	t	168	f
7702	1	2092	3	Folgeseiten	deutsch	t	168	f
7703	2	2092	3	following pages	english	t	168	f
7704	4	2092	3	Pages suivantes	francais	t	168	f
7706	1	2093	3	Transp.	deutsch	t	168	f
7707	2	2093	3	Transp.	english	t	168	f
7708	4	2093	3	Transparent	francais	t	168	f
7726	1	2098	3	davor	deutsch	t	168	f
7727	2	2098	3	before	english	t	168	f
7728	4	2098	3	Avant	francais	t	168	f
7730	1	2099	3	danach	deutsch	t	168	f
7731	2	2099	3	after	english	t	168	f
7732	4	2099	3	Après	francais	t	168	f
7682	1	2087	2	Vererbtes Feld	deutsch	t	0	f
7684	4	2087	2	Champs hérité	francais	t	0	f
7734	1	2100	3	Umbruch	deutsch	t	168	f
7738	1	2101	3	Fixiere Position	deutsch	t	168	f
7740	4	2101	3	Position fixe	francais	t	168	f
7742	1	2102	3	Relativ	deutsch	t	168	f
7743	2	2102	3	Relative	english	t	168	f
7744	4	2102	3	Relatif	francais	t	168	f
7782	1	2112	3	Farbtabelle	deutsch	t	52	f
7783	2	2112	3	Colour table	english	t	52	f
7762	1	2107	3	vererben	deutsch	t	213	f
7764	4	2107	3	Heriter les droits	francais	t	213	f
7784	4	2112	3	Table des couleurs	francais	t	52	f
7786	1	2113	1	Datei konnte nicht konvertiert werden!	deutsch	t	66	f
7787	2	2113	1	File could not be converted!	english	t	66	f
7788	4	2113	1	Le fichier ne peut être converti!	francais	t	66	f
7790	1	2114	1	Limit	deutsch	t	5	f
7791	2	2114	1	Limit	english	t	5	f
7793	1	2115	2	Diagramme	deutsch	t	\N	f
10424	1	2332	1	überspringen	deutsch	t	66	f
7794	2	2115	2	Diagrams	english	t	\N	f
7795	4	2115	2	Diagramme	francais	t	\N	f
7797	1	2116	2	Diagramme	deutsch	t	\N	f
7798	2	2116	2	Diagrams	english	t	\N	f
7799	4	2116	2	Diagramme	francais	t	\N	f
7801	1	2117	2	Diagramm	deutsch	t	\N	f
7802	2	2117	2	Diagram	english	t	\N	f
7803	4	2117	2	Diagramm	francais	t	\N	f
7805	1	2118	2	Diagramm	deutsch	t	\N	f
7810	1	2119	3	Diagramme	deutsch	t	177	f
7811	2	2119	3	Diagrams	english	t	177	f
7882	2	2137	2	select all records	english	t	\N	f
7883	4	2137	2	alle Datensätze auswählen	francais	t	\N	f
10165	1	2269	3	Definition	deutsch	t	218	f
7886	1	2138	1	keine verknüpfte Tabelle ausgewählt!	deutsch	t	5	f
7887	2	2138	1	no linked table selected!	english	t	5	f
7890	1	2139	1	keine verknüpften Daten vorhanden!	deutsch	t	5	f
7891	2	2139	1	no linked data!	english	t	5	f
7699	2	2091	3	first page	english	t	168	f
7735	2	2100	3	page break	english	t	168	f
7893	1	2140	2	zeige versionierte	deutsch	t	\N	f
7894	2	2140	2	show versionised	english	t	\N	f
7895	4	2140	2	zeige Versionen	francais	t	\N	f
7897	1	2141	2	zeige versionierte Datensätze	deutsch	t	\N	f
7898	2	2141	2	show versionised records	english	t	\N	f
7899	4	2141	2	zeige versionierte Datensätze	francais	t	\N	f
7902	1	2142	3	rekursiv	deutsch	t	140	f
7903	2	2142	3	recursive	english	t	140	f
7906	1	2143	3	fix	deutsch	t	140	f
7854	1	2130	3	Dateirechte	deutsch	t	119	f
7850	1	2129	3	Tabellenrechte	deutsch	t	119	f
7907	2	2143	3	set	english	t	140	f
7910	1	2144	3	manuell	deutsch	t	122	f
7911	2	2144	3	manual	english	t	122	f
7914	1	2145	3	automatisch	deutsch	t	122	f
7915	2	2145	3	automatic	english	t	122	f
7918	1	2146	1	soll der Datensatz versioniert werden?	deutsch	t	13	t
7926	1	2148	1	Datensatz wurde erfolgreich versioniert!	deutsch	t	25	f
7927	2	2148	1	Record successfully versioned!	english	t	25	f
7930	1	2149	1	Datensätze wurden erfolgreich versioniert!	deutsch	t	25	f
7931	2	2149	1	Records successfully versioned!	english	t	25	f
7934	1	2150	1	Datensatz wurde erfolgreich kopiert!	deutsch	t	25	f
7935	2	2150	1	Record successfully copied!	english	t	25	f
7938	1	2151	1	Datensätze wurden erfolgreich kopiert!	deutsch	t	25	f
7939	2	2151	1	Records successfully copied!	english	t	25	f
7946	1	2153	1	Sollen die ausgewählten Datensätze gelöscht werden?	deutsch	t	5	f
7950	1	2154	1	Sollen die ausgewählten Datensätze archiviert werden?	deutsch	t	5	f
7954	1	2155	1	Sollen die ausgewählten Datensätze versioniert werden?	deutsch	t	5	f
7958	1	2156	1	Sollen die ausgewählten Datensätze kopiert werden?	deutsch	t	5	f
7962	1	2157	1	Sollen die ausgewählten Datensätze wieder hergestellt werden?	deutsch	t	5	f
7966	1	2158	1	Das Aufheben des Limits kann bei großen Datensatzmengen zu langen Wartezeiten führen!	deutsch	t	5	f
7967	2	2158	1	Canceling the limit with big amounts of records can lead to long latency.	english	t	5	f
7973	1	2160	2	workflow	deutsch	t	\N	f
7974	2	2160	2	workflow	english	t	\N	f
7975	4	2160	2	workflow	francais	t	\N	f
7977	1	2161	2	workflow	deutsch	t	\N	f
7978	2	2161	2	workflow	english	t	\N	f
7979	4	2161	2	workflow	francais	t	\N	f
7982	2	2162	2	compare with	english	t	\N	f
7986	2	2163	2	compare Version	english	t	\N	f
8059	4	2181	2	zeige verknüpfte Datensätze	francais	t	\N	f
8062	1	2182	1	Datensatz wurde verknüpft!	deutsch	t	25	f
8063	2	2182	1	Record linked!	english	t	25	f
8066	1	2183	1	Datensätze wurden verknüpft!	deutsch	t	25	f
8067	2	2183	1	Records linked!	english	t	25	f
8070	1	2184	1	Verknüpfung wurde gelöst!	deutsch	t	25	f
8074	1	2185	1	Verknüpfungen wurden gelöst!	deutsch	t	25	f
8078	1	2186	1	Sollen die ausgewählten Datensätze verknüpft werden?	deutsch	t	5	f
8079	2	2186	1	Link selected records?	english	t	5	f
8082	1	2187	1	Sollen die Verknüpfung der ausgewählten Datensätze gelöst werden?	deutsch	t	5	f
8090	1	2189	1	Sie haben keine Rechte für diese Datei!	deutsch	t	66	f
8126	1	2198	3	abhängig	deutsch	t	168	f
8127	2	2198	3	dependent	english	t	168	f
8130	2	2199	2	Workplace	english	t	\N	f
8134	2	2200	2	Summary	english	t	\N	f
8138	2	2201	2	Reports	english	t	\N	f
8142	2	2202	2	Reports	english	t	\N	f
8146	2	2203	2	myLimbas	english	t	\N	f
8147	4	2203	2	myLimbas	francais	t	\N	f
8150	2	2204	2	personal Data	english	t	\N	f
8162	1	2207	3	Template	deutsch	t	177	f
8163	2	2207	3	Template	english	t	177	f
8174	1	2210	3	umbenennen	deutsch	t	148	f
8175	2	2210	3	rename	english	t	148	f
8114	1	2195	2	Größenangabe in Byte	deutsch	t	0	f
8110	1	2194	2	Dateigröße	deutsch	t	0	f
8194	1	2215	3	View	deutsch	t	149	f
8195	2	2215	3	View	english	t	149	f
8198	1	2216	3	Trigger	deutsch	t	149	f
8199	2	2216	3	Trigger	english	t	149	f
8229	1	2224	2	mini Datei-Manager	deutsch	t	\N	f
8230	2	2224	2	mini File manager	english	t	\N	f
8231	4	2224	2	Datei suchen	francais	t	\N	f
8234	1	2225	1	eine Ebene höher	deutsch	t	215	f
8235	2	2225	1	one level higher	english	t	215	f
8239	2	2226	1	select	english	t	215	f
8242	1	2227	1	abbrechen	deutsch	t	215	f
8243	2	2227	1	cancel	english	t	215	f
8250	1	2229	1	suchen in	deutsch	t	215	f
8251	2	2229	1	search in	english	t	215	f
8254	1	2230	1	Home Verzeichnis	deutsch	t	215	f
8255	2	2230	1	Home index	english	t	215	f
7512	4	1932	2	Date	francais	t	0	f
8258	1	2231	1	neuer Ordner	deutsch	t	215	f
8182	1	2212	2	Attribute	deutsch	t	0	f
8259	2	2231	1	new folder	english	t	215	f
8262	1	2232	1	neue Datei	deutsch	t	215	f
8263	2	2232	1	new file	english	t	215	f
8266	1	2233	1	einfache Darstellung	deutsch	t	215	f
8270	1	2234	1	erweiterte Darstellung	deutsch	t	215	f
8274	1	2235	3	Bezeichner	deutsch	t	110	f
8275	2	2235	3	Identifier	english	t	110	f
8278	1	2236	3	Abhängigkeit	deutsch	t	52	f
8279	2	2236	3	Dependence	english	t	52	f
8290	1	2239	3	nur Backend sperren	deutsch	t	127	f
8291	2	2239	3	lock only backend	english	t	127	f
8294	1	2240	3	Konvertieren	deutsch	t	148	f
8295	2	2240	3	convert	english	t	148	f
8306	1	2243	3	abfragen	deutsch	t	148	f
8307	2	2243	3	request	english	t	148	f
8310	2	2244	2	summary	english	t	\N	f
8311	4	2244	2	Übersicht	francais	t	\N	f
8314	2	2245	2	User summary	english	t	\N	f
8315	4	2245	2	Userübersicht	francais	t	\N	f
8317	1	2246	2	Menü links	deutsch	t	\N	f
8319	4	2246	2	Menü links	francais	t	\N	f
8321	1	2247	2	Menü links	deutsch	t	\N	f
8323	4	2247	2	Menü links	francais	t	\N	f
8325	1	2248	2	Menü oben	deutsch	t	\N	f
8326	2	2248	2	Menu top	english	t	\N	f
8327	4	2248	2	Menü oben	francais	t	\N	f
8329	1	2249	2	Menü oben	deutsch	t	\N	f
8330	2	2249	2	Menu top	english	t	\N	f
8331	4	2249	2	Menü oben	francais	t	\N	f
8333	1	2250	2	Menü rechts	deutsch	t	\N	f
8334	2	2250	2	Menu right	english	t	\N	f
8335	4	2250	2	Menü rechts	francais	t	\N	f
8337	1	2251	2	Menü rechts	deutsch	t	\N	f
8338	2	2251	2	Menu right	english	t	\N	f
8339	4	2251	2	Menü rechts	francais	t	\N	f
8341	1	2252	2	Introseite	deutsch	t	\N	f
8342	2	2252	2	Intro page	english	t	\N	f
8343	4	2252	2	Introseite	francais	t	\N	f
8345	1	2253	2	Introseite	deutsch	t	\N	f
8346	2	2253	2	Intro page	english	t	\N	f
8347	4	2253	2	Introseite	francais	t	\N	f
8350	2	2254	2	Selection	english	t	\N	f
8351	4	2254	2	Auswahl	francais	t	\N	f
8354	2	2255	2	Calendar Selection	english	t	\N	f
8355	4	2255	2	Kalender Auswahl	francais	t	\N	f
8365	1	2258	2	Bildergalerie	deutsch	t	\N	f
8366	2	2258	2	Picture gallery	english	t	\N	f
8367	4	2258	2	Bildvorschau	francais	t	\N	f
8369	1	2259	2	Bildergalerie	deutsch	t	\N	f
8370	2	2259	2	Picture gallery	english	t	\N	f
10205	2	2277	2	Report/Form rights	english	t	0	f
10209	2	2278	2	set Report and Form rights	english	t	0	f
10212	1	2279	3	soll das Formular gelöscht werden?	deutsch	t	176	f
10213	2	2279	3	Delete Form?	english	t	176	f
10220	1	2281	3	Formulare	deutsch	t	222	f
10221	2	2281	3	Forms	english	t	222	f
10232	1	2284	3	soll der Bericht gelöscht werden?	deutsch	t	170	f
10236	1	2285	3	soll das Diagramm gelöscht werden?	deutsch	t	177	f
10240	1	2286	3	Soll die Tabellengruppe inklusive Tabellen gelöscht werden?	deutsch	t	140	f
10244	1	2287	3	soll die Tabelle gelöscht werden?	deutsch	t	140	f
10248	1	2288	3	alle öffnen	deutsch	t	213	f
10249	2	2288	3	open all	english	t	213	f
10256	1	2290	3	alle berechtigten öffnen	deutsch	t	213	f
10257	2	2290	3	open all entitled	english	t	213	f
10261	2	2291	2	show selve linked	english	t	0	f
10268	1	2293	1	Die Metadaten konnten nicht aktualisiert werden!	deutsch	t	66	f
10269	2	2293	1	Update Metadata not sucessfull!	english	t	66	f
10272	1	2294	1	Sie haben keine Berechtigung oder der Order wurde entfernt!	deutsch	t	66	f
10273	2	2294	1	No permission or folder has been removed!	english	t	66	f
10276	1	2295	3	Dateien sehen	deutsch	t	213	f
10280	1	2296	3	Dateien hinzufügen	deutsch	t	213	f
10284	1	2297	3	Ordner anlegen	deutsch	t	213	f
10288	1	2298	3	Dateien / Ordner löschen	deutsch	t	213	f
10292	1	2299	3	Metadaten editieren	deutsch	t	213	f
10296	1	2300	3	Dateien sperren	deutsch	t	213	f
10300	1	2301	3	berechtigte Gruppen	deutsch	t	213	f
10301	2	2301	3	entitled Groups	english	t	213	f
10304	1	2302	3	Tabelle im Menü nicht zeigen	deutsch	t	122	f
10305	2	2302	3	Don´t show table in menue.	english	t	122	f
10377	2	2320	2	recursive search	english	t	0	f
10380	1	2321	1	öffnen	deutsch	t	66	f
10381	2	2321	1	open	english	t	66	f
10384	1	2322	1	speichern unter	deutsch	t	66	f
10385	2	2322	1	save as	english	t	66	f
10388	1	2323	1	Info Metadaten	deutsch	t	66	f
10389	2	2323	1	Info Metadata	english	t	66	f
10392	1	2324	1	Info Indizierung	deutsch	t	66	f
10393	2	2324	1	Info Indexing	english	t	66	f
10396	1	2325	1	Info Versionierung	deutsch	t	66	f
10397	2	2325	1	Info Versioning	english	t	66	f
10416	1	2330	1	zeige alle Dateien	deutsch	t	66	f
10417	2	2330	1	show all files	english	t	66	f
10425	2	2332	1	skip	english	t	66	f
10428	1	2333	1	Für alle Dateien übernehmen	deutsch	t	66	f
10429	2	2333	1	Adopt for all files	english	t	66	f
10432	1	2334	1	Herkunft anzeigen	deutsch	t	15	f
10433	2	2334	1	Show origin	english	t	15	f
10448	1	2338	2	Benutzer-Rechte	deutsch	t	0	f
10449	2	2338	2	Userrights	english	t	0	f
10452	1	2339	2	Benutzer berechtigen	deutsch	t	0	f
10453	2	2339	2	entitle Userrights	english	t	0	f
10608	1	2376	3	Erweiterte Filter	deutsch	t	121	f
2623	2	1351	2	Number (10) 	english	t	0	f
2257	2	1135	3	reset	english	t	168	f
10456	1	2340	3	Bei Änderung der Berechtigung werden alle alten Einzel-Rechte dieser Tabelle gelöscht!	deutsch	t	140	f
10457	2	2340	3	If you change the permissions, all the old individual rights in this table will be deleted!	english	t	140	f
10460	1	2341	2	zeige Benutzerrechte	deutsch	t	0	f
10461	2	2341	2	show Userrights	english	t	0	f
10464	1	2342	2	Übersicht von Benutzerrechte	deutsch	t	0	f
6984	4	1361	2	Texte 254	francais	t	0	f
10465	2	2342	2	Overview Userrights	english	t	0	f
10484	1	2347	3	Z-Index	deutsch	t	169	f
10485	2	2347	3	Z-Index	english	t	169	f
10488	1	2348	3	Y-Pos	deutsch	t	169	f
10489	2	2348	3	Y-Pos	english	t	169	f
10492	1	2349	2	test	deutsch	t	unknown	f
10493	2	2349	2	test	english	t	unknown	f
10609	2	2376	3	Advanced filters	english	t	121	f
10612	1	2377	3	Beziehungen	deutsch	t	121	f
10613	2	2377	3	Relations	english	t	121	f
10616	1	2378	3	Gruppenmitglied	deutsch	t	186	f
10617	2	2378	3	Group member	english	t	186	f
10620	1	2379	3	sortierung	deutsch	t	186	f
10621	2	2379	3	sorting	english	t	186	f
10628	1	2381	3	Betreff	deutsch	t	52	f
10644	1	2385	3	Ende	deutsch	t	52	f
10544	1	2360	2	Gruppierung Reiter	deutsch	t	0	f
10548	1	2361	2	Feld Gruppierung als Reiter	deutsch	t	0	f
10656	1	2388	3	erstellt am	deutsch	t	52	f
10657	2	2388	3	created on	english	t	52	f
10660	1	2389	3	erstellt von	deutsch	t	52	f
10661	2	2389	3	created from	english	t	52	f
10664	1	2390	3	erstellt von Gruppe	deutsch	t	52	f
10665	2	2390	3	created from group	english	t	52	f
10668	1	2391	3	editiert am	deutsch	t	52	f
10669	2	2391	3	edited on	english	t	52	f
10672	1	2392	3	editiert von	deutsch	t	52	f
10673	2	2392	3	edited from	english	t	52	f
10589	2	2371	3	Back-valued relation 	english	t	121	f
10572	1	2367	3	Usereinstellungen löschen	deutsch	t	154	f
10588	1	2371	3	rückwärtige Verknüpfung	deutsch	t	121	f
10573	2	2367	3	Delete user settings	english	t	154	f
10752	1	2412	3	Nachricht Nr	deutsch	t	52	f
10753	2	2412	3	Message No.	english	t	52	f
10760	1	2414	3	Von	deutsch	t	52	f
10761	2	2414	3	From	english	t	52	f
10764	1	2415	3	An	deutsch	t	52	f
10765	2	2415	3	To	english	t	52	f
10873	2	2442	2	show locked records	english	t	0	f
10881	2	2444	2	adopt	english	t	0	f
10884	1	2445	3	immer	deutsch	t	168	f
10885	2	2445	3	always	english	t	168	f
10888	1	2446	3	gerade Seiten	deutsch	t	168	f
10889	2	2446	3	straight-digit sides	english	t	168	f
10892	1	2447	3	ungerade Seiten	deutsch	t	168	f
10893	2	2447	3	odd sides	english	t	168	f
10896	1	2448	1	gesprochen wie	deutsch	t	66	f
10897	2	2448	1	spoken like	english	t	66	f
10904	1	2450	3	Datenbank Trigger	deutsch	t	218	f
10905	2	2450	3	Database trigger	english	t	218	f
10908	1	2451	3	Limbas Trigger	deutsch	t	218	f
10909	2	2451	3	Limbas trigger	english	t	218	f
10916	1	2453	3	Benutzerrechte verwalten für selbst erstellte Datensätze	deutsch	t	221	f
10917	2	2453	3	Adminstrate User rights for self-created records	english	t	221	f
6503	4	826	2	Rapports	francais	t	0	f
10924	1	2455	1	Sie sind angemeldet als	deutsch	t	11	f
10925	2	2455	1	logged in as	english	t	11	f
10928	1	2456	3	Formularumleitung	deutsch	t	175	f
10929	2	2456	3	Form redirection	english	t	175	f
10936	1	2458	3	maxlen	deutsch	t	168	f
10937	2	2458	3	max.length	english	t	168	f
10944	1	2460	3	ersetzen	deutsch	t	168	f
10945	2	2460	3	replace	english	t	168	f
10952	1	2462	3	Projekt-Auswahl	deutsch	t	145	f
10953	2	2462	3	Project selection	english	t	145	f
10956	1	2463	3	sende Anmelde-Informationen	deutsch	t	132	f
10957	2	2463	3	send Registration Information	english	t	132	f
10965	2	2465	2	show sum	english	t	0	f
10969	2	2466	2	show sum of records	english	t	0	f
10981	2	2469	2	force delete	english	t	0	f
11085	2	2495	2	grouping headers	english	t	0	f
11089	2	2496	2	grouping headers with tabs 	english	t	0	f
11096	1	2498	1	Gruppiert	deutsch	t	84	f
11060	1	2489	2	Tabellenbaum	deutsch	t	0	f
11112	1	2502	1	Format:	deutsch	t	13	f
11116	1	2503	1	Standard-Formular	deutsch	t	13	f
11124	1	2505	3	Anzeige-Regel	deutsch	t	110	f
11132	1	2507	3	Schnellsuche	deutsch	t	110	f
11097	2	2498	1	group by	english	t	84	f
2420	1	1250	3	History	deutsch	t	132	f
11136	1	2508	3	HTML	deutsch	t	168	f
11140	1	2509	3	Bericht-Erweiterung	deutsch	t	170	f
11152	1	2512	3	system reports	deutsch	t	222	f
10444	1	2337	3	Benutzerrechte verwalten für alle Datensätze	deutsch	t	221	f
10560	1	2364	2	Duplikate	deutsch	t	0	f
10564	1	2365	2	Duplikate Übersicht	deutsch	t	0	f
11016	1	2478	2	Duplikate	deutsch	t	0	f
11020	1	2479	2	zeige Duplikate	deutsch	t	0	f
2624	1	1352	2	Zahl (18)	deutsch	t	0	f
6975	4	1352	2	Nombre (18)	francais	t	0	f
6441	4	729	2	Rappel	francais	t	0	f
11180	1	2519	1	Email Adresse	deutsch	t	46	f
11184	1	2520	1	Antwort Adresse	deutsch	t	46	f
11188	1	2521	1	Imap Hostname	deutsch	t	46	f
11192	1	2522	1	Imap Username	deutsch	t	46	f
11057	2	2488	3	Check Limbas -Trigger	english	t	154	f
2753	2	1416	2	creation date	english	t	0	f
2755	2	1417	2	edit date	english	t	0	f
10561	2	2364	2	Dublicate	english	t	0	f
11017	2	2478	2	dublicates	english	t	0	f
11148	1	2511	3	Ablagename	deutsch	t	170	f
744	1	744	1	Der eingegebene Wert hat nicht das erforderliche Format!\nBitte korrigieren Sie Ihre Eingabe.	deutsch	t	37	t
6451	4	744	1	Mauvais format.	francais	t	37	t
896	1	896	3	Diese Funktion stellt die Standard-Rechte der Gruppe und deren Untergruppen wieder her!\nDabei werden vorhandene Rechte überschrieben!	deutsch	t	115	t
1869	2	744	1	The entered value does not have the required format!\nPlease correct your entry. 	english	t	37	t
1048	1	1048	3	Sie wollen alle Sessions löschen!\nAlle Sessions werden neu gestartet.	deutsch	t	154	t
6699	4	1048	3	Supprimer toutes les sessions?\n Toutes les sessions vont être réinitialisées.	francais	t	154	t
1168	1	1168	3	Datei nicht gefunden!\nBitte geben sie den korrekten Pfad an.	deutsch	t	172	t
6812	4	1168	3	Fichier non trouvé!\nMerci de spécier le chemin correct.	francais	t	172	t
2768	1	1424	1	Der Datensatz wurde geändert ohne zu speichern.\nSoll versucht werden die Änderungen zu übernehmen?	deutsch	t	13	t
7047	4	1424	1	L''enregistrement a été modifé sans être suvegardé. Les modifications doivent elles être soumises à enregistrement?	francais	t	13	t
4596	1	1594	3	Wollen Sie die Datenbank zurücksetzten?\nDabei werden alle Daten gelöscht!	deutsch	t	154	t
7188	4	1594	3	Voulez vous réinitialiser la base de donnée?\nToutes les données seront perdues!	francais	t	154	t
2170	2	1048	3	Delete all sessions?\nAll sessions will be restarted. 	english	t	154	t
2769	2	1424	1	The record was changed without saving.\nShould the changed been tryed to being submited? 	english	t	13	t
1517	2	349	2	create new	english	t	0	f
11149	2	2511	3	Storage name	english	t	170	f
11325	2	2555	3	menuebar	english	t	173	f
5418	1	1868	1	Die Anfrage übersteigt das Maximum der gleichzeitig zu behandelnden Datensätze!\nEine Sortierung wird nur über die zugelassene Ergebnismenge erfolgen. Folgende Schritte stehen Ihnen zur Verfügung:\n\n	deutsch	t	5	t
1534	2	366	2	record list	english	t	0	f
6880	4	1254	3	Voulez-vous supprimer le groupe et ses sous-groupes	francais	t	115	t
7452	4	1868	1	Votre requête dépasse l''espace de résultat.	francais	t	5	t
2625	2	1352	2	Number (18) 	english	t	0	f
5611	2	1932	2	Date	english	t	0	f
735	1	735	2	Abfragen	deutsch	t	\N	f
5553	1	1913	1	- Schränken Sie das Ergebnis durch Suchparameter weiter ein.\n- Erhöhen Sie, falls berechtigt, das Limit.\n- Heben Sie, falls berechtigt, das Limit auf.	deutsch	t	5	t
7493	4	1913	1	 - limiter le résultat avec d''avantage de paramètres de recherche\n - augmenter la limite	francais	t	5	t
5787	1	1991	3	Sollen die Dateisystemtabellen FILES und FILES_META neu erstellt werden? \nVorhandene Inhalte werden gelöscht!\nDie Dateitabellen werden in der Tabellengruppe limbassys erstellt.	deutsch	t	154	t
7571	4	1991	3	Voulez-vous reconstruire les tables systèmes FILES et FILES_META?\nToutes les données vont être supprimées!	francais	t	154	t
8190	1	2214	3	Für dieses Feld besteht bereits eine positive Verknüpfung!\nDiese Aktion nutzt die vorhandene Verknüpfung negativ.\nVorhandene Verknüpfungen werden gelöscht!	deutsch	t	121	t
11745	2	2660	3	content	english	t	173	f
10412	1	2329	3	Sollen die die htaccess Dateien neu generiert werden?\nNeue Passwörter werden nur übernommen wenn die clear_password Option in den umgvars aktiviert wurde	deutsch	t	154	t
5788	2	1991	3	Do you want to rebuild the Systemtables FILES and FILES_META? Existing data will be deleted!\nThe file tables are provided in the table group limbassys. 	english	t	154	t
10413	2	2329	3	Shall the htaccess files be renewed? \t\nNew passwords will only be accepted if the clear_password option in the umgvars was activated. 	english	t	154	t
2556	1	1318	1	Es wurden noch keine Änderungen an diesem neuen Datensatz gemacht!\nErzeugen von leeren Datensätzen ist nicht ratsam.	deutsch	t	13	t
2290	2	1168	3	File not found. please check the file-path.	english	t	172	t
4597	2	1594	3	Do you want to reset the database?\nAll data will be lost!	english	t	154	t
11364	1	2565	3	Versionierungsart	deutsch	t	221	f
5419	2	1868	1	Your request exceeds the number of data records, that can be handled simultaniously. Only the number of allowed datarecords will be sorted. You have the following options:	english	t	5	t
8115	2	2195	2	size in byte	english	t	0	f
2018	2	896	3	Set user rights for groups and sub groupsalignment to default. Existing rights will reset to default. system alignment!\nThis can require time.	english	t	115	t
721	1	721	1	Dieser Datensatz ist mit einer Wiedervorlage versehen! Soll diese aufgehoben werden?	deutsch	t	13	t
2045	2	923	3	title	english	t	110	f
2799	3	30	1	creado el	Espagñol	t	12	f
11021	2	2479	2	show dublicates 	english	t	0	f
4992	1	1726	1	Der zugehörige Datensatz oder die Metainformationen der Datei sind nicht vorhanden!	deutsch	t	66	f
11208	1	2526	2	erweiterte Einstellungen	deutsch	t	0	f
349	1	349	2	neu anlegen	deutsch	t	0	f
350	1	350	2	Datensatz anlegen	deutsch	t	0	f
351	1	351	2	bearbeiten	deutsch	t	0	f
1519	2	351	2	edit	english	t	0	f
352	1	352	2	Datensatz bearbeiten	deutsch	t	0	f
1520	2	352	2	edit record	english	t	0	f
1533	2	365	2	list	english	t	0	f
826	1	826	2	Berichte	deutsch	t	0	f
11205	2	2525	2	settings	english	t	0	f
1949	2	826	2	reports	english	t	0	f
827	1	827	2	Berichte	deutsch	t	0	f
1950	2	827	2	reports	english	t	0	f
6504	4	827	2	Rapports	francais	t	0	f
5289	1	1825	3	beschreibt	deutsch	t	121	f
736	1	736	2	Tabellen-Abfragen	deutsch	t	\N	f
10632	1	2382	3	Start	deutsch	t	52	f
7513	4	1933	2	JJ.MM.AAAA \n\nex: 05.12.07 - 5 dec 02 - 05 decembre 2002	francais	t	0	t
11220	1	2529	2	Gruppierung Zeile	deutsch	t	0	f
11224	1	2530	2	Feld Gruppierung in einer Zeile	deutsch	t	0	f
11228	1	2531	1	Die Länge des Dateinamens darf 128 Zeichen nicht überschreiten!	deutsch	t	41	f
11276	1	2543	3	neuer Tabellenbaum	deutsch	t	207	f
8129	1	2199	2	Arbeitsplatz	deutsch	t	\N	f
8133	1	2200	2	Zusammenfassung	deutsch	t	\N	f
385	1	385	2	Tabellen	deutsch	t	\N	f
386	1	386	2	Tabellen	deutsch	t	\N	f
445	1	445	2	System	deutsch	t	\N	f
446	1	446	2	Systemtools	deutsch	t	\N	f
11212	1	2527	2	update	deutsch	t	0	f
11216	1	2528	2	update	deutsch	t	0	f
7518	4	1938	2	Vue moteur de recherche	francais	t	0	f
4679	1	1622	2	Zeitzone	deutsch	t	\N	f
7215	4	1622	2	Vue fichiers	francais	t	0	f
902	1	902	3	Lokale Einstellung	deutsch	t	127	f
5157	1	1781	3	Sperr-Nachricht	deutsch	t	127	f
10633	2	2382	3	Start	english	t	52	f
11213	2	2527	2	update	english	t	0	f
5628	2	1938	2	Search engine view 	english	t	\N	f
5158	2	1781	3	lock-message  	english	t	127	f
365	1	365	2	Liste	deutsch	t	0	f
366	1	366	2	Datensatz Liste	deutsch	t	0	f
11308	1	2551	3	Datensatzrechte zurücksetzen	deutsch	t	154	f
5444	1	1877	2	Tabellenschema	deutsch	t	\N	f
5447	1	1878	2	Tabellenschema	deutsch	t	\N	f
10144	1	2265	2	Trigger	deutsch	t	\N	f
10149	1	2266	2	Trigger	deutsch	t	\N	f
840	1	840	2	Gruppe anlegen	deutsch	t	\N	f
841	1	841	2	Gruppe anlegen	deutsch	t	\N	f
724	1	724	2	Formulare	deutsch	t	\N	f
725	1	725	2	Formulareditor	deutsch	t	\N	f
8309	1	2244	2	Übersicht	deutsch	t	\N	f
8313	1	2245	2	Userübersicht	deutsch	t	\N	f
4664	1	1617	2	Dateirechte	deutsch	t	\N	f
4667	1	1618	2	Dateirechte festlegen	deutsch	t	\N	f
498	1	498	2	Tabellenrechte festlegen	deutsch	t	\N	f
5706	1	1964	3	neuer Tabulator	deutsch	t	168	f
11333	2	2557	3	footer	english	t	173	f
6256	4	365	2	liste 	francais	t	0	f
6257	4	366	2	liste des enregistrements 	francais	t	0	f
11352	1	2562	3	Benutzer konnte nicht angelegt werden!	deutsch	t	126	f
11296	1	2548	3	sollen alle temporären Thumbnails gelöscht werden?	deutsch	t	154	t
606	1	606	3	Username schon vorhanden!	deutsch	t	126	f
6392	4	606	3	Existe déjà ou bien est marqué pour suppression!	francais	t	126	f
11168	1	2516	3	Benutzerrechte hierarchisch vererben	deutsch	t	221	f
10528	1	2356	3	zeige alle Versionierte	deutsch	t	221	f
11372	1	2567	3	Spalten Hintergrundfarbe	deutsch	t	221	f
11380	1	2569	3	Filterregel	deutsch	t	221	f
11384	1	2570	3	Editierregel	deutsch	t	221	f
11392	1	2572	3	Formatieungseinstellungen	deutsch	t	221	f
11396	1	2573	3	Regel für Schreibrecht	deutsch	t	221	f
11356	1	2563	2	Einstellungen	deutsch	t	0	f
10252	1	2289	3	alle schließen	deutsch	t	213	f
5618	1	1935	2	Datei-Modus	deutsch	t	\N	f
5621	1	1936	2	Exploreransicht	deutsch	t	\N	f
5624	1	1937	2	Schlagwort-Modus	deutsch	t	\N	f
5627	1	1938	2	Suchmachinenansicht	deutsch	t	\N	f
11408	1	2576	3	Datumsformat	deutsch	t	127	f
8217	1	2221	2	Variablen	deutsch	t	\N	f
8221	1	2222	2	System Variablen	deutsch	t	\N	f
5363	1	1850	2	Constraints	deutsch	t	\N	f
5366	1	1851	2	Tabellen Constraints	deutsch	t	\N	f
484	1	484	2	Nutzungsrechte festlegen	deutsch	t	\N	f
11412	1	2577	3	sende Infomail an User	deutsch	t	172	f
6587	4	924	3	Affichage	francais	t	110	f
11452	1	2587	3	Potenzschwelle	deutsch	t	110	f
11456	1	2588	3	Datenbankspezifischer Defaultwert<br>z.B. 12 | text | now()	deutsch	t	110	f
11460	1	2589	3	Ändern des Feldtyps soweit möglich	deutsch	t	110	f
11464	1	2590	3	Ersetzen des Feldtyps mit einer eigenen Funktion aus [ext_type.inc]	deutsch	t	110	f
2295	2	1173	3	single scroll bar	english	t	175	f
11468	1	2591	3	Regel zum Ausblenden des Feldes, erwartet: return true/false	deutsch	t	110	f
11472	1	2592	3	Regel für Schreibrecht des Feldes, erwartet: return true/false	deutsch	t	110	f
11476	1	2593	3	einrichten	deutsch	t	110	f
11492	1	2597	3	Ab wieviel Stellen die Zahl in Expotentialschreibweise dargestellt werden soll	deutsch	t	110	f
7005	4	1382	2	Liste utilisateur/groupe	francais	t	0	f
2756	1	1418	2	Auswahlfeld System-User/Gruppe	deutsch	t	0	f
11500	1	2599	3	Standardeinstellung für Währung	deutsch	t	110	f
11504	1	2600	3	Zeitformat	deutsch	t	110	f
11488	1	2596	3	Zahlendarstellung im numberformat() Format: z.B. 2, ''.'', ''''	deutsch	t	110	f
11520	1	2604	3	Verknüpfungstabelle	deutsch	t	110	f
11524	1	2605	1	darf nicht doppelt vergeben werden!	deutsch	t	13	f
865	1	865	1	Auswahl gruppieren	deutsch	t	5	f
11873	2	2692	3	write	english	t	168	f
10321	2	2306	3	Form/Report rights	english	t	119	f
11433	2	2582	1	link to	english	t	15	f
11437	2	2583	2	extension editor	english	t	0	f
11441	2	2584	2	extension editor	english	t	0	f
11445	2	2585	3	adopt rights of parent group	english	t	119	f
11453	2	2587	3	Power threshold	english	t	110	f
11457	2	2588	3	Database-specific default value e.g. 12 | text | now()	english	t	110	f
11477	2	2593	3	set up	english	t	110	f
11485	2	2595	3	seperator	english	t	110	f
11505	2	2600	3	time formate	english	t	110	f
11501	2	2599	3	standard setting currency	english	t	110	f
11469	2	2591	3	Rule to hide field expects: return true/false	english	t	110	f
11473	2	2592	3	Rule for field write right expects: return true/false	english	t	110	f
11525	2	2605	1	Should not be assigned twice!	english	t	13	f
11489	2	2596	3	Number representation in number formate() formate: e.g 2, ''.'', ''''	english	t	110	f
11493	2	2597	3	How the number should be shown as expotencial spelling	english	t	110	f
1745	2	606	3	Username already exists!	english	t	126	f
2024	2	902	3	Local setting	english	t	127	f
2054	2	932	3	select search	english	t	110	f
2431	2	1255	3	Indicator rules	english	t	122	f
5622	2	1936	2	Explorer view	english	t	\N	f
5707	2	1964	3	new tabulator	english	t	168	f
7851	2	2129	3	table rights	english	t	119	f
7855	2	2130	3	file rights	english	t	119	f
7859	2	2131	3	menu rights	english	t	119	f
10545	2	2360	2	Grouping tab	english	t	0	f
2692	1	1386	2	Ganzzahl	deutsch	t	0	f
6973	4	1350	2	Nomber (5)	francais	t	0	f
2720	1	1400	2	DD.MM.YYYY hh:mm.ss \nz.B. 05.12.02 \nz.B.. 5 dez 02 \nz.B.. 05 Dezember 2 15.10.00	deutsch	t	0	t
7023	4	1400	2	JJ.MM.AA hh:mm:ss \n\n5 dec 06\n 05 decembre 2002 15.10.00	francais	t	0	t
10549	2	2361	2	Field grouping as a tab	english	t	0	f
10645	2	2385	3	End	english	t	52	f
7690	1	2089	3	Suchergebnis	deutsch	t	121	f
11037	2	2483	3	System	english	t	154	f
11209	2	2526	2	advanced settings	english	t	0	f
11217	2	2528	2	update	english	t	0	f
11221	2	2529	2	Grouping row	english	t	0	f
11225	2	2530	2	field grouping in one row	english	t	0	f
11229	2	2531	1	The file name must not exceed 128 characters!	english	t	41	f
11309	2	2551	3	Reset record rights	english	t	154	f
11313	2	2552	3	Recalculate record rights	english	t	154	f
2697	2	1388	2	18-digit number 	english	t	0	f
11173	2	2517	1	transmit hierarchic  	english	t	13	f
10253	2	2289	3	close all 	english	t	213	f
11872	1	2692	3	schreiben	deutsch	t	168	f
11349	2	2561	3	tabulator border	english	t	175	f
11365	2	2565	3	type of versioning	english	t	221	f
11377	2	2568	3	Default value: create new record	english	t	221	f
11381	2	2569	3	Filter rule	english	t	221	f
11385	2	2570	3	Edit rule	english	t	221	f
11393	2	2572	3	formatting settings	english	t	221	f
11397	2	2573	3	Rule write right	english	t	221	f
11401	2	2574	3	Standard form	english	t	221	f
11413	2	2577	3	send infomail to User	english	t	172	f
11421	2	2579	2	OCR	english	t	0	f
11425	2	2580	2	OCR identification	english	t	0	f
11429	2	2581	3	css file	english	t	175	f
11465	2	2590	3	Replace fieldtype with a separate function from [ext_type.inc]	english	t	110	f
11537	2	2608	3	filter	english	t	110	f
11541	2	2609	3	searchfield	english	t	110	f
11545	2	2610	3	evaluation	english	t	110	f
128	1	128	1	Datei konnte nicht gespeichert werden!\nDie Datei ist keine reguläre Datei, der Zielort lässt kein speichern zu oder ist voll.	deutsch	t	41	t
1744	2	605	3	Username, password and main group are required.	english	t	126	f
11317	2	2553	3	All existing datarecord specific rights of the selected table will be deleted!	english	t	154	f
1988	2	865	1	group selection	english	t	5	f
2044	2	922	3	fieldname	english	t	110	f
2285	2	1163	3	standard format	english	t	170	f
4680	2	1622	2	tme zone	english	t	\N	f
4993	2	1726	1	The corresponding record or metadata of the file do not exist!	english	t	66	f
11409	2	2576	3	date format	english	t	127	f
11461	2	2589	3	Change of field type so far as possible	english	t	110	f
7763	2	2107	3	inhertit	english	t	213	f
2	1	2	1	Version	deutsch	t	4	f
918	1	918	3	wobei ? ID für die Artikelnummer steht	deutsch	t	107	f
1135	1	1135	3	zurücksetzen	deutsch	t	168	f
6780	4	1135	3	Rétablir	francais	t	168	f
2538	1	1309	2	wiederherstellen	deutsch	t	\N	f
6935	4	1309	2	Annuler	francais	t	0	f
11553	2	2612	3	View Editor	english	t	225	f
4881	1	1689	1	max. Anzahl gleichzeitiger downloads:	deutsch	t	66	f
7275	4	1689	1	Nombre maximum de download simultanés	francais	t	66	f
4916	1	1701	2	Änderungen speichern	deutsch	t	\N	f
7287	4	1701	2	Enregistrer les modifications	francais	t	0	f
5869	2	2018	3	new version 	english	t	52	f
11297	2	2548	3	Delete all temporary thumpnails?	english	t	154	f
6058	2	2081	3	inc. sub 	english	t	212	f
7695	2	2090	3	Background 	english	t	168	f
11552	1	2612	3	Abfrage Editor	deutsch	t	225	f
11733	2	2657	3	Create-Query	english	t	140	f
11572	1	2617	3	Beinhaltet nur die Datensätze bei denen die Inhalte der verknüpften Felder beider Tabellen gleich sind	deutsch	t	226	f
11576	1	2618	3	Beinhaltet alle Datensätze aus	deutsch	t	226	f
2648	1	1364	2	Datum/Zeit	deutsch	t	0	f
11580	1	2619	3	und nur die Datensätze aus	deutsch	t	226	f
11584	1	2620	3	bei denen die Inhalte der verknüpften Felder beider Tabellen gleich sind	deutsch	t	226	f
11600	1	2624	3	Alias	deutsch	t	226	f
11604	1	2625	3	Funktion	deutsch	t	226	f
11612	1	2627	3	Summe	deutsch	t	226	f
11616	1	2628	3	Min	deutsch	t	226	f
11620	1	2629	3	Max	deutsch	t	226	f
11628	1	2631	3	Anzeigen	deutsch	t	226	f
11632	1	2632	3	Kriterien	deutsch	t	226	f
11636	1	2633	3	Aufsteigend	deutsch	t	226	f
11640	1	2634	3	Absteigend	deutsch	t	226	f
11644	1	2635	3	zeige Systemtabellen	deutsch	t	225	f
2539	2	1309	2	recover	english	t	\N	f
4882	2	1689	1	Max number of simultanious downloads reachedl.	english	t	66	f
4917	2	1701	2	save modification	english	t	\N	f
5971	2	2052	1	Workflow was not cancelled! You might not have permission for this function.	english	t	209	f
5974	2	2053	1	Workflow was not cancelled! You might not have permission for this function.	english	t	209	f
129	1	129	1	Die max. Größe einer hochgeladenen Datei ist beschränkt auf	deutsch	t	41	f
11656	1	2638	3	anzeigen	deutsch	t	168	f
11664	1	2640	3	Ajaxpost	deutsch	t	110	f
2176	2	1054	3	refresh table and field rules	english	t	154	f
11676	1	2643	1	an User	deutsch	t	13	f
11680	1	2644	1	gesetzt	deutsch	t	13	f
11573	2	2617	3	get only data where the content of linked fields are the same	english	t	226	f
11585	2	2620	3	where the content of linked fields are the same	english	t	226	f
11601	2	2624	3	Alias	english	t	226	f
11605	2	2625	3	Function	english	t	226	f
11700	1	2649	3	Listenmodus	deutsch	t	169	f
4593	1	1593	3	Datenbank zurücksetzen!!!	deutsch	t	154	f
7187	4	1593	3	Réinitialisation de la base de donnée!!!	francais	t	154	f
11704	1	2650	1	versionierte Datensätze können nicht gelöscht werden!	deutsch	t	13	f
11708	1	2651	1	gesperrte Datensätze können nicht gelöscht werden!	deutsch	t	13	f
11693	2	2647	1	target	english	t	66	f
11701	2	2649	3	listmode	english	t	169	f
6989	4	1366	2	ID-BD	francais	t	0	f
2724	1	1402	2	Schlüsselwert 18 stellige Zahl	deutsch	t	0	f
7025	4	1402	2	Valeur de la clé encodée sur 18 caractères	francais	t	0	f
11724	1	2655	3	Feldgröße<br>z.B. 255 | 5,2	deutsch	t	110	f
6999	4	1376	2	Relation 1:n	francais	t	0	f
7035	4	1412	2	Ex: Client (1) -> Interlocuteur (n)	francais	t	0	f
2748	1	1414	2	Welcher User den Datensatz erstellt hat	deutsch	t	0	f
8178	1	2211	2	Attribut	deutsch	t	0	f
8358	1	2256	2	SQL-Argument	deutsch	t	0	f
10508	1	2351	2	Dokument-Inhalt	deutsch	t	0	f
2684	1	1382	2	User/Gruppen-Liste	deutsch	t	0	f
7041	4	1418	2	Choix de sélection d''utilisateur ou de groupe	francais	t	0	f
2652	1	1366	2	Auto-ID	deutsch	t	0	f
7683	2	2087	2	inherited field 	english	t	0	f
5613	1	1933	2	DD.MM.YYYY\nnz.B. 05.12.02 \nz.B. 5 dez 02 \nz.B. 05 Dezember 2	deutsch	t	0	t
11581	2	2619	3	and only data records from	english	t	226	f
11577	2	2618	3	get all data records from	english	t	226	f
11629	2	2631	3	view	english	t	226	f
8363	2	2257	2	formula construct (SQL) 	english	t	0	f
6060	4	2	1	version 	francais	t	4	f
3060	3	317	1	domingo	Espagñol	t	88	f
5913	1	2033	3	Soll die angezeigte Anzahl von Verknüpfungen und Multiselectfeldern neu berechnet werden?	deutsch	t	154	t
425	1	425	2	Wiedervorlage	deutsch	t	\N	f
426	1	426	2	persönliche Wiedervorlagen	deutsch	t	\N	f
11709	2	2651	1	you can''t delete locked datasets!	english	t	13	f
11725	2	2655	3	fieldsize<br>255 or 5,2	english	t	110	f
11728	1	2656	3	Auswahlabfrage	deutsch	t	140	f
11732	1	2657	3	Erstellungsabfrage	deutsch	t	140	f
11736	1	2658	3	Anfügeabfrage	deutsch	t	140	f
11740	1	2659	3	Löschabfrage	deutsch	t	140	f
11744	1	2660	3	Inhalt	deutsch	t	173	f
11760	1	2664	3	nutze [serial] id	deutsch	t	140	f
2446	1	1263	3	erstelle Berechtigungen	deutsch	t	110	f
6889	4	1263	3	Incl. droits	francais	t	110	f
11764	1	2665	3	nutze [sequence] Tabelle	deutsch	t	140	f
7167	4	1569	1	Liaison negative	francais	t	175	f
5652	1	1946	3	Hauptmenü-Rahmen	deutsch	t	175	f
7526	4	1946	3	Menu mode texte	francais	t	175	f
11768	1	2666	3	ausschneiden	deutsch	t	173	f
11772	1	2667	3	einfügen	deutsch	t	173	f
5802	1	1996	1	veröffentlichen	deutsch	t	5	f
7576	4	1996	1	Envoyer	francais	t	5	f
4209	1	1465	3	Verkn-Popup	deutsch	t	140	f
7082	4	1465	3	Regroupement	francais	t	140	f
4617	1	1601	1	färben	deutsch	t	140	f
7195	4	1601	1	Couleurs	francais	t	140	f
11804	1	2675	1	Soll in einer Stapeländerung der Inhalt des Feldes geändert werden?\nDie Aktion kann nicht rückgängig gemacht werden!	deutsch	t	230	t
11816	1	2678	1	kein Feld ausgewählt	deutsch	t	230	f
11792	1	2672	3	Stapeländerung	deutsch	t	110	f
11796	1	2673	1	ersetzen mit	deutsch	t	230	f
11808	1	2676	1	Anzahl betroffener Datensätze	deutsch	t	230	f
11812	1	2677	1	Betroffenes Feld	deutsch	t	230	f
8034	1	2175	2	Versionsbemerkung	deutsch	t	0	f
4210	2	1465	3	Relation-Popup	english	t	140	f
4522	2	1569	1	Style	english	t	175	f
11729	2	2656	3	Select-Query	english	t	140	f
11737	2	2658	3	Attach-Query	english	t	140	f
11741	2	2659	3	Delete-Query	english	t	140	f
373	1	373	2	suchen	deutsch	t	\N	f
374	1	374	2	Datensatz suchen	deutsch	t	\N	f
11820	1	2679	2	neues Fenster	deutsch	t	0	f
11824	1	2680	2	neues Fenster	deutsch	t	0	f
11836	1	2683	1	ungleich	deutsch	t	19	f
11776	1	2668	2	zeige Felder	deutsch	t	0	f
11780	1	2669	2	zeige Felder	deutsch	t	0	f
51	1	51	1	Soll für die ausgewählten Datensätze ein Bericht gedruckt werden?	deutsch	t	13	t
11840	1	2684	1	Datensätze geändert	deutsch	t	230	f
11844	1	2685	3	standard	deutsch	t	140	f
11848	1	2686	3	wenig Ergebnisse	deutsch	t	140	f
11852	1	2687	3	keine Berechnung	deutsch	t	140	f
11856	1	2688	3	Ergebnisanzahl	deutsch	t	140	f
5885	1	2024	2	Abfragen	deutsch	t	\N	f
5888	1	2025	2	Abfrage-Generator	deutsch	t	\N	f
11832	1	2682	1	ist nicht leer	deutsch	t	19	f
2686	1	1383	2	Long	deutsch	t	0	f
7006	4	1383	2	Long	francais	t	0	f
7042	4	1419	2	Bloc de texte avec maximum 100000 caractères	francais	t	0	f
11860	1	2689	3	bearbeite Tabellenfelder	deutsch	t	140	f
11864	1	2690	3	öffne Abfrageeditor	deutsch	t	140	f
4594	2	1593	3	Reset Database !	english	t	154	f
11705	2	2650	1	you can''t delet datasets under revision control!	english	t	13	f
7020	4	1397	2	Texte max 250 caractères	francais	t	0	f
11880	1	2694	3	Sollen alle temporären Textdateien gelöscht werden?	deutsch	t	154	f
11288	1	2546	3	Temporäre Thumbnails löschen	deutsch	t	154	f
11876	1	2693	1	Kurzschreibweise in der Schnellsuche	deutsch	t	19	f
11300	1	2549	3	solle versucht werden alle fehlgeschlagene Thumbnails neu zu berechnen?	deutsch	t	154	t
11884	1	2695	3	Temporäre Textdateien löschen	deutsch	t	154	f
11292	1	2547	3	Fehlgeschlagene Thumbnails neu berechnen	deutsch	t	154	f
10933	2	2457	3	mode	english	t	168	f
11301	2	2549	3	Recalculate failed thumpnails? 	english	t	154	f
11821	2	2679	2	new window	english	t	0	f
11825	2	2680	2	new window	english	t	0	f
11845	2	2685	3	default	english	t	140	f
11892	1	2697	3	Soll die Ordnerstruktur auf Konsistenz geprüft werden?\nFehlende Benutzer oder Berichtsordner werden neu erstellt.	deutsch	t	154	t
11896	1	2698	3	Rotation	deutsch	t	168	f
4271	1	1486	2	History	deutsch	t	\N	f
4274	1	1487	2	Datensatz-History	deutsch	t	\N	f
11900	1	2699	3	nicht veröffentlicht	deutsch	t	140	f
2621	2	1350	2	Number	english	t	0	f
2643	2	1361	2	Text	english	t	0	f
2653	2	1366	2	Auto-ID 	english	t	0	f
2673	2	1376	2	Relation 1:n 	english	t	0	f
2675	2	1377	2	Relation n:m 	english	t	0	f
2677	2	1378	2	Post-user 	english	t	0	f
2679	2	1379	2	Edit-user 	english	t	0	f
2685	2	1382	2	User/group list	english	t	0	f
2687	2	1383	2	Long 	english	t	0	f
2693	2	1386	2	Integer	english	t	0	f
2715	2	1397	2	Text	english	t	0	f
2721	2	1400	2	DD.MM.YYYY hh:mm.ss,\nneg. 05.12.02,\nneg. 5 dez 02,  \nneg. 05 Dezember 2 15.10.00	english	t	0	t
2745	2	1412	2	f.i. Customer (1) -> Contact(n) 	english	t	0	f
2747	2	1413	2	f.i. Contract (n) -> Article (m) 	english	t	0	f
5614	2	1933	2	DD.MM.YYYY \nneg. 05.12.02\nneg. 5 dez 02  \nneg. 05 Dezember 2	english	t	0	t
8179	2	2211	2	Attribute 	english	t	0	f
8183	2	2212	2	Attributes 	english	t	0	f
8359	2	2256	2	SQL-Argument 	english	t	0	f
7026	4	1403	2	devise 25 chiffres	francais	t	0	f
11672	1	2642	2	Farbauswahl	deutsch	t	0	f
10509	2	2351	2	Document content 	english	t	0	f
10513	2	2352	2	Reference to document 	english	t	0	f
3086	3	353	2	editar	Espagñol	t	0	f
11293	2	2547	3	Recalculate failed thumpnails! 	english	t	154	f
11761	2	2664	3	use [serial] id	english	t	140	f
11888	1	2696	3	Sollen die Limbasspezifischen Trigger neu erstellt werden?	deutsch	t	154	f
2447	2	1263	3	create permissions	english	t	110	f
2749	2	1414	2	The user who created the record	english	t	0	f
2751	2	1415	2	The user who modified the record	english	t	0	f
5803	2	1996	1	publish	english	t	5	f
11289	2	2546	3	delete temporary thumbnails	english	t	154	f
11837	2	2683	1	different	english	t	19	f
11841	2	2684	1	data records changed	english	t	230	f
11765	2	2665	3	use [sequencel] table	english	t	140	f
11769	2	2666	3	cut	english	t	173	f
11773	2	2667	3	paste	english	t	173	f
11777	2	2668	2	show fields	english	t	0	f
11781	2	2669	2	show fields	english	t	0	f
11785	2	2670	2	batch processing	english	t	0	f
11789	2	2671	2	batch processing	english	t	0	f
11793	2	2672	3	batch processing	english	t	110	f
11797	2	2673	1	replace with	english	t	230	f
11813	2	2677	1	used field	english	t	230	f
11817	2	2678	1	no field selected!	english	t	230	f
11849	2	2686	3	few results	english	t	140	f
11853	2	2687	3	no permission	english	t	140	f
11861	2	2689	3	edit tablefields	english	t	140	f
11865	2	2690	3	open queryeditor	english	t	140	f
11881	2	2694	3	You want to delete all temporary textfiles?	english	t	154	f
11885	2	2695	3	Delete temporary textfiles	english	t	154	f
11897	2	2698	3	rotation	english	t	168	f
11901	2	2699	3	not published	english	t	140	f
11748	1	2661	3	Gruppierungs-Rahmen	deutsch	t	175	f
114	1	114	1	Für diese Aktion besitzen Sie keine Rechte	deutsch	t	23	f
11749	2	2661	3	grouping frame	english	t	175	f
2770	3	1	1	Permiso denegado	Espagñol	t	2	f
2773	3	4	1	nombre	Espagñol	t	4	f
2776	3	7	1	sistema anfitrión	Espagñol	t	4	f
2778	3	9	1	agente	Espagñol	t	4	f
2779	3	10	1	autentificación	Espagñol	t	4	f
2780	3	11	1	empresa	Espagñol	t	4	f
2793	3	24	1	¿desea generar un nuevo registro?	Espagñol	t	5	f
2794	3	25	1	apareció un error no determinado	Espagñol	t	5	f
2796	3	27	1	editor de selección	Espagñol	t	12	f
2798	3	29	1	contenido	Espagñol	t	12	f
2802	3	33	1	tomar control	Espagñol	t	12	f
2803	3	34	1	añadir	Espagñol	t	12	f
2818	3	49	1	¿desea realmente ocultar este registro?	Espagñol	t	13	f
11833	2	2682	1	not empty field 	english	t	19	f
11829	2	2681	1	empty field 	english	t	19	f
2819	3	50	1	¿desea realmente borrar este archivo?	Espagñol	t	13	f
2825	3	56	1	ha ocurrido un error	Espagñol	t	13	f
2826	3	58	1	cambiar	Espagñol	t	14	f
2827	3	59	1	añadir	Espagñol	t	14	f
2828	3	60	1	quitar	Espagñol	t	14	f
2832	3	84	1	¿realmente desea borrar este registro?	Espagñol	t	17	f
2834	3	86	1	entradas	Espagñol	t	17	f
2836	3	88	1	registros	Espagñol	t	17	f
2837	3	89	1	en total	Espagñol	t	17	f
2838	3	93	1	saltar a la página	Espagñol	t	17	f
2843	3	98	1	sin registros	Espagñol	t	17	f
2846	3	101	1	búsqueda del contenido del cuadro	Espagñol	t	19	f
2847	3	102	1	buscar	Espagñol	t	19	f
2848	3	103	1	buscar en	Espagñol	t	19	f
2856	3	112	1	esta entrada no puede ser borrada,  ya existen conexiones	Espagñol	t	22	f
2859	3	115	1	ha ocurrdio un error	Espagñol	t	25	f
2860	3	116	1	el registro fue borrado con éxito	Espagñol	t	25	f
2862	3	118	1	sin derechos de campo	Espagñol	t	27	f
2866	3	122	1	sin conexión	Espagñol	t	34	f
8035	2	2175	2	Version remark 	english	t	0	f
2870	3	126	1	descripción	Espagñol	t	34	f
2877	3	133	1	el archivo cargado posee un formato desconocido	Espagñol	t	41	f
2878	3	134	1	error/los siguientes campos fueron llenados incorrectamente	Espagñol	t	37	f
2882	3	138	1	por favor verificar si sus entradas son correctas	Espagñol	t	41	f
2884	3	140	1	datos del usuario	Espagñol	t	46	f
2885	3	141	1	contraseña	Espagñol	t	46	f
2886	3	142	1	primer nombre	Espagñol	t	46	f
2888	3	144	1	Correo electrónico	Espagñol	t	46	f
2890	3	146	1	configuraciones generales	Espagñol	t	46	f
2898	3	154	1	nombre	Espagñol	t	47	f
2899	3	155	1	color	Espagñol	t	47	f
2900	3	156	1	valor	Espagñol	t	47	f
11809	2	2676	1	number of used data records	english	t	230	f
2904	3	160	1	borrar	Espagñol	t	49	f
2908	3	164	1	cuadro	Espagñol	t	49	f
2912	3	168	1	campo	Espagñol	t	50	f
2771	3	2	1	Versión	Espagñol	t	4	f
2939	3	195	1	ha ocurrido un error	Espagñol	t	54	f
2941	3	197	1	fecha	Espagñol	t	55	f
2944	3	200	1	nueva plantilla	Espagñol	t	55	f
2953	3	209	1	nombre de archivo	Espagñol	t	66	f
2954	3	210	1	tamaño	Espagñol	t	66	f
2986	3	242	2	integrar subcarpeta	Espagñol	t	44	f
3036	3	293	1	KW	Espagñol	t	86	f
3037	3	294	1	color	Espagñol	t	86	f
3038	3	295	1	observación	Espagñol	t	86	f
3039	3	296	1	meses	Espagñol	t	86	f
3040	3	297	1	comenzar	Espagñol	t	86	f
3043	3	300	1	vista del calendario	Espagñol	t	86	f
3044	3	301	1	vista del cuadro	Espagñol	t	86	f
3045	3	302	1	registrar	Espagñol	t	86	f
3046	3	303	1	no hay registro	Espagñol	t	87	f
3047	3	304	1	vista general del calendario	Espagñol	t	88	f
3055	3	312	1	martes	Espagñol	t	88	f
3056	3	313	1	miércoles	Espagñol	t	88	f
3057	3	314	1	jueves	Espagñol	t	88	f
3058	3	315	1	viernes	Espagñol	t	88	f
3059	3	316	1	sábado	Espagñol	t	88	f
3087	3	354	2	editar sólo columna	Espagñol	t	0	f
3088	3	355	2	observación	Espagñol	t	0	f
3089	3	356	2	observaciones de conexión	Espagñol	t	0	f
3090	3	357	2	detalles	Espagñol	t	0	f
3091	3	358	2	vista de detalles del registro	Espagñol	t	0	f
3092	3	359	2	exportar	Espagñol	t	0	f
3093	3	360	2	exportación csv	Espagñol	t	0	f
3094	3	361	2	añadir	Espagñol	t	0	f
3095	3	362	2	añadir campo de selección múltiple	Espagñol	t	0	f
3096	3	363	2	información	Espagñol	t	0	f
3097	3	364	2	informaciones de registro	Espagñol	t	0	f
3100	3	367	2	borrar	Espagñol	t	0	f
3101	3	368	2	borrar registro	Espagñol	t	0	f
3106	3	373	2	buscar	Espagñol	t	0	f
3107	3	374	2	buscar registro	Espagñol	t	0	f
3108	3	379	2	administración	Espagñol	t	0	f
3109	3	380	2	ajustes	Espagñol	t	0	f
3110	3	381	2	ayuda	Espagñol	t	0	f
3111	3	382	2	ayuda	Espagñol	t	0	f
3114	3	385	2	cuadros	Espagñol	t	0	f
3115	3	386	2	cuadros	Espagñol	t	0	f
3116	3	387	2	usuario	Espagñol	t	0	f
3117	3	388	2	usuario	Espagñol	t	0	f
3120	3	391	2	imprimir	Espagñol	t	0	f
3121	3	392	2	versión impresa	Espagñol	t	0	f
3122	3	393	2	maximizar	Espagñol	t	0	f
3123	3	394	2	maximizar muestra	Espagñol	t	0	f
3124	3	395	2	minimizar	Espagñol	t	0	f
3125	3	396	2	minimizar muestra	Espagñol	t	0	f
3128	3	401	2	reconfigurar	Espagñol	t	0	f
3129	3	402	2	reconfigurar resultados	Espagñol	t	0	f
4602	1	1596	2	Kommazahl Numeric mit Prozentdarstellung	deutsch	t	0	f
3130	3	403	2	configuraciones	Espagñol	t	0	f
3131	3	404	2	configuraciones generales	Espagñol	t	0	f
3132	3	409	2	colores	Espagñol	t	0	f
4600	2	1595	2	decimal in percent 	english	t	0	f
4603	2	1596	2	decimal numeric in percent 	english	t	0	f
2853	3	109	1	CS	Espagñol	f	19	f
2851	3	107	1	todo el campo	Espagñol	f	19	f
2850	3	106	1	parte del contenido del campo	Espagñol	f	19	f
2852	3	108	1	comienzo del contenido del campo	Espagñol	f	19	f
3133	3	410	2	selección del color	Espagñol	t	0	f
3134	3	415	2	mensajes	Espagñol	t	0	f
3135	3	416	2	sistema de mensajes	Espagñol	t	0	f
3136	3	417	2	nuevo mensaje	Espagñol	t	0	f
3137	3	418	2	crear un nuevo mensaje	Espagñol	t	0	f
3140	3	421	2	búsqueda	Espagñol	t	0	f
3141	3	422	2	buscar mensajes	Espagñol	t	0	f
3142	3	425	2	nueva presentación	Espagñol	t	0	f
3143	3	426	2	nuevas presentaciones personales	Espagñol	t	0	f
3144	3	427	2	presentaciones	Espagñol	t	0	f
3146	3	429	2	generar usuario	Espagñol	t	0	f
3147	3	430	2	generar usuario	Espagñol	t	0	f
3148	3	431	2	variable de entorno	Espagñol	t	0	f
3149	3	432	2	variables de entorno	Espagñol	t	0	f
3152	3	435	2	puntos del menú	Espagñol	t	0	f
3153	3	436	2	lista de conexión	Espagñol	t	0	f
3154	3	437	2	esquema	Espagñol	t	0	f
3155	3	438	2	cuadro de colores	Espagñol	t	0	f
3156	3	439	2	colores	Espagñol	t	0	f
3157	3	440	2	cuadro de colores	Espagñol	t	0	f
3158	3	441	2	exportación	Espagñol	t	0	f
3159	3	442	2	exportación	Espagñol	t	0	f
3160	3	443	2	importación	Espagñol	t	0	f
3161	3	444	2	importación	Espagñol	t	0	f
3823	3	1157	3	página No.	Espagñol	t	169	f
3162	3	445	2	actualización del sistema	Espagñol	t	0	f
3163	3	446	2	actualización del sistema	Espagñol	t	0	f
3164	3	451	2	estadística	Espagñol	t	0	f
3165	3	452	2	estadística del diagrama de usuario	Espagñol	t	0	f
3166	3	453	2	usuario/grupos	Espagñol	t	0	f
3167	3	454	2	usuario/administración de grupos	Espagñol	t	0	f
3168	3	455	2	grupos	Espagñol	t	0	f
3169	3	456	2	administración de grupos	Espagñol	t	0	f
3170	3	457	2	cuadros	Espagñol	t	0	f
3171	3	458	2	editar cuadros	Espagñol	t	0	f
3172	3	459	2	informe de errores	Espagñol	t	0	f
3173	3	460	2	informe de errores	Espagñol	t	0	f
3174	3	461	2	configuración	Espagñol	t	0	f
3175	3	462	2	configuraciones generales	Espagñol	t	0	f
3176	3	463	2	herramientas	Espagñol	t	0	f
3177	3	464	2	herramientas	Espagñol	t	0	f
3178	3	465	2	informes	Espagñol	t	0	f
3179	3	466	2	editar informes	Espagñol	t	0	f
3186	3	473	2	tamaño	Espagñol	t	0	f
3187	3	474	2	informe tamaño de elementos	Espagñol	t	0	f
3188	3	475	2	contenido	Espagñol	t	0	f
3189	3	476	2	informe contenido de elementos	Espagñol	t	0	f
3190	3	477	2	representación	Espagñol	t	0	f
3191	3	478	2	informe estilo de elementos	Espagñol	t	0	f
3192	3	483	2	derechos del menú	Espagñol	t	0	f
3744	3	1078	3	norma	Espagñol	t	160	f
3193	3	484	2	establecer derechos del menú	Espagñol	t	0	f
3196	3	495	2	en general	Espagñol	t	0	f
3197	3	496	2	configuraciones generales del usuario	Espagñol	t	0	f
3198	3	497	2	derechos de cuadro	Espagñol	t	0	f
3199	3	498	2	establecer derechos de cuadro	Espagñol	t	0	f
3200	3	501	2	cuadros	Espagñol	t	0	f
3201	3	502	2	herramientas de cuadros	Espagñol	t	0	f
3214	3	517	3	argumento	Espagñol	t	101	f
3215	3	518	3	variables de ambiente	Espagñol	t	101	f
3216	3	519	3	nombre de usuario	Espagñol	t	101	f
3217	3	520	3	nombre completo	Espagñol	t	101	f
3218	3	521	3	correo electrónico	Espagñol	t	101	f
3219	3	522	3	cambiar	Espagñol	t	101	f
3226	3	529	3	valores de color RGB	Espagñol	t	106	f
3227	3	530	3	valores de color HEX	Espagñol	t	106	f
3237	3	540	3	añadir	Espagñol	t	106	f
3240	3	543	3	fecha	Espagñol	t	108	f
3241	3	544	3	acción	Espagñol	t	108	f
3242	3	545	3	archivo	Espagñol	t	108	f
3243	3	546	3	fila	Espagñol	t	108	f
3244	3	547	3	aviso de error	Espagñol	t	108	f
3245	3	548	3	consulta SQL	Espagñol	t	108	f
3258	3	561	3	grupo	Espagñol	t	115	f
3260	3	563	3	generado	Espagñol	t	115	f
3266	3	569	3	nombre del grupo	Espagñol	t	119	f
3268	3	571	3	aplicar	Espagñol	t	119	f
3270	3	573	3	menú	Espagñol	t	120	f
3272	3	575	3	derechos	Espagñol	t	120	f
3274	3	577	3	cuadros	Espagñol	t	120	f
3286	3	600	3	ya existe	Espagñol	t	111	f
3298	3	612	3	correo electrónico	Espagñol	t	127	f
3549	3	880	1	enero	Espagñol	t	41	f
3302	3	616	3	máximo número de aciertos	Espagñol	t	127	f
3309	3	623	3	esquema de color	Espagñol	t	127	f
3310	3	624	3	idioma	Espagñol	t	127	f
3318	3	632	3	activo	Espagñol	t	46	f
3319	3	633	3	inactivo	Espagñol	t	46	f
3342	3	656	3	activo	Espagñol	t	132	f
3343	3	657	3	bloquear	Espagñol	t	132	f
3358	3	672	3	apellido	Espagñol	t	136	f
3374	3	698	1	layout	Espagñol	t	46	f
3376	3	700	1	abrir calendario rápido	Espagñol	t	34	f
3379	3	704	1	dividir ventana de resultados	Espagñol	t	46	f
3385	3	711	1	más grande	Espagñol	t	19	f
3386	3	712	1	más pequeño	Espagñol	t	19	f
3387	3	713	1	igual	Espagñol	t	19	f
3388	3	715	1	abrir detalles de selección	Espagñol	t	34	f
3389	3	716	3	máximo tamaño de cargado	Espagñol	t	127	f
3395	3	722	1	registro	Espagñol	t	13	f
3397	3	724	2	formularios	Espagñol	t	0	f
3398	3	725	2	editor de formularios	Espagñol	t	0	f
3399	3	726	2	idioma	Espagñol	t	0	f
3400	3	727	2	cuadro de idioma	Espagñol	t	0	f
8196	4	2215	3	vue	francais	t	149	f
3403	3	730	2	marcar como nueva presentación / fichero de reserva	Espagñol	t	0	f
3404	3	731	2	formularios	Espagñol	t	0	f
3405	3	732	2	formularios	Espagñol	t	0	f
3408	3	735	2	consultas	Espagñol	t	0	f
3409	3	736	2	consultas de cuadros	Espagñol	t	0	f
3416	3	745	1	aceptar valor cambiado	Espagñol	t	37	f
3420	3	749	1	último acceso	Espagñol	t	4	f
3421	3	750	2	diagramas	Espagñol	t	0	f
3422	3	751	2	diagramas de evaluación	Espagñol	t	0	f
3423	3	752	2	diagramas	Espagñol	t	0	f
3424	3	753	2	editor de diagramas	Espagñol	t	0	f
3435	3	764	1	no se encontró ningún registro con estas características	Espagñol	t	23	f
3438	3	767	1	mensajes	Espagñol	t	145	f
3439	3	768	1	recibir	Espagñol	t	145	f
3440	3	769	1	enviado	Espagñol	t	154	f
3441	3	770	1	borrado	Espagñol	t	154	f
3442	3	771	2	renombrar	Espagñol	t	0	f
3443	3	772	2	renombrar carpeta	Espagñol	t	0	f
3444	3	773	2	buscar	Espagñol	t	0	f
3445	3	774	2	buscar archivos	Espagñol	t	0	f
3446	3	777	2	nueva carpeta	Espagñol	t	0	f
3447	3	778	2	crear nueva carpeta	Espagñol	t	0	f
3453	3	784	2	transferir	Espagñol	t	0	f
3454	3	785	2	transferir mensaje	Espagñol	t	0	f
3455	3	786	2	responder	Espagñol	t	0	f
3456	3	787	2	reponder el mensaje	Espagñol	t	0	f
3457	3	788	2	transmitir	Espagñol	t	0	f
3458	3	789	2	transmitir mensaje	Espagñol	t	0	f
3459	3	790	2	no leído	Espagñol	t	0	f
3460	3	791	2	marcar mensaje como no leído	Espagñol	t	0	f
3291	3	605	3	usuario	Espagñol	t	126	f
3481	3	812	1	archivos propios	Espagñol	t	3	f
3482	3	813	1	imágenes	Espagñol	t	3	f
3484	3	815	2	nuevo archivo	Espagñol	t	0	f
3485	3	816	2	crear nuevo archivo	Espagñol	t	0	f
3486	3	817	2	copiar	Espagñol	t	0	f
3487	3	818	2	copiar archivo	Espagñol	t	0	f
3488	3	819	2	transferir	Espagñol	t	0	f
3489	3	820	2	transferir archivo	Espagñol	t	0	f
3490	3	821	1	¿desea borrar esta carpeta y su contenido?	Espagñol	t	68	f
3491	3	822	1	¿desea borrar el archivo?	Espagñol	t	66	f
3497	3	828	2	formulario	Espagñol	t	0	f
3498	3	829	2	formulario	Espagñol	t	0	f
3499	3	830	2	rastreo	Espagñol	t	0	f
3500	3	831	2	rastrear conexión	Espagñol	t	0	f
3503	3	834	2	en general	Espagñol	t	0	f
3504	3	835	2	configuraciones generales de grupo	Espagñol	t	0	f
3507	3	838	2	vista general	Espagñol	t	0	f
3508	3	839	2	vista general del usuario	Espagñol	t	0	f
3509	3	840	2	generar un grupo	Espagñol	t	0	f
3510	3	841	2	generar un grupo	Espagñol	t	0	f
3511	3	842	1	almacenar	Espagñol	t	54	f
3512	3	843	1	editar	Espagñol	t	54	f
3513	3	844	1	cerrar	Espagñol	t	54	f
3516	3	847	2	fondo	Espagñol	t	0	f
3517	3	848	2	color de fondo	Espagñol	t	0	f
3520	3	851	1	columna	Espagñol	t	5	f
3524	3	855	1	o	Espagñol	t	19	f
3525	3	856	1	¿desea realmente borrar la sesión?	Espagñol	t	46	f
3526	3	857	1	para comenzar	Espagñol	t	13	f
3527	3	858	1	para terminar	Espagñol	t	13	f
3528	3	859	1	siguiente	Espagñol	t	13	f
3529	3	860	1	anterior	Espagñol	t	13	f
3535	3	866	1	no	Espagñol	t	5	f
3536	3	867	1	sí	Espagñol	t	5	f
3538	3	869	1	informar	Espagñol	t	15	f
3539	3	870	1	abrir página web	Espagñol	t	15	f
3542	3	873	1	domingo	Espagñol	t	41	f
3543	3	874	1	lunes	Espagñol	t	41	f
3544	3	875	1	martes	Espagñol	t	41	f
3545	3	876	1	miércoles	Espagñol	t	41	f
3546	3	877	1	jueves	Espagñol	t	41	f
3547	3	878	1	viernes	Espagñol	t	41	f
3548	3	879	1	sábado	Espagñol	t	41	f
3550	3	881	1	febrero	Espagñol	t	41	f
3551	3	882	1	marzo	Espagñol	t	41	f
3552	3	883	1	abril	Espagñol	t	41	f
3553	3	884	1	mayo	Espagñol	t	41	f
3554	3	885	1	junio	Espagñol	t	41	f
3555	3	886	1	julio	Espagñol	t	41	f
3556	3	887	1	agosto	Espagñol	t	41	f
3557	3	888	1	setiembre	Espagñol	t	41	f
3558	3	889	1	octubre	Espagñol	t	41	f
3559	3	890	1	noviembre	Espagñol	t	41	f
3560	3	891	1	diciembre	Espagñol	t	41	f
3565	3	897	3	subgrupo de	Espagñol	t	119	f
3567	3	899	3	¿desea borrar realmente la sesión de este usuario?	Espagñol	t	127	f
3568	3	900	3	grupo principal	Espagñol	t	127	f
3569	3	901	3	subgrupos	Espagñol	t	127	f
3571	3	903	3	rango IP	Espagñol	t	127	f
5365	3	1850	2	Index	Espagñol	t	\N	f
3572	3	904	3	reinicio de sesión	Espagñol	t	127	f
3573	3	905	3	reconfigurar derechos de cuadro	Espagñol	t	127	f
3575	3	907	3	reconfigurar derechos del menú	Espagñol	t	127	f
3576	3	908	3	desea el usuario	Espagñol	t	132	f
3579	3	911	3	depurar	Espagñol	t	132	f
3584	3	916	3	generador de vínculos	Espagñol	t	107	f
3585	3	917	3	entrada del vínculo absoluto	Espagñol	t	107	f
3593	3	925	3	tipo	Espagñol	t	110	f
3594	3	926	3	clave	Espagñol	t	110	f
3595	3	927	3	clasificación	Espagñol	t	110	f
3596	3	928	3	valor default	Espagñol	t	110	f
3598	3	930	3	editar	Espagñol	t	110	f
3599	3	931	3	Int. Ref.	Espagñol	t	110	f
3607	3	939	3	conexión en	Espagñol	t	139	f
3608	3	940	3	registrado	Espagñol	t	139	f
3610	3	942	3	añadido	Espagñol	t	139	f
3617	3	949	3	ID	Espagñol	t	140	f
3590	3	922	3	campo	Espagñol	t	110	f
3592	3	924	3	denominación	Espagñol	t	110	f
3600	3	932	3	seleccionar	Espagñol	t	110	f
3534	3	865	1	agrupar conexiones	Espagñol	t	5	f
3619	3	951	3	nombre del cuadro	Espagñol	t	140	f
3620	3	952	3	positivo	Espagñol	t	140	f
3621	3	953	3	campos	Espagñol	t	140	f
3629	3	961	3	archivar cuadro	Espagñol	t	145	f
3630	3	962	3	exportación de excel	Espagñol	t	145	f
3631	3	963	3	exportación de texto	Espagñol	t	145	f
3632	3	964	3	exportación del sistema	Espagñol	t	145	f
3633	3	965	3	archivar grupo	Espagñol	t	145	f
3634	3	966	3	sistema completo	Espagñol	t	145	f
3635	3	967	3	cuadros de proyecto	Espagñol	t	145	f
3636	3	968	3	cuadros del sistema dependientes	Espagñol	t	145	f
3638	3	970	3	la exportación fue exitosa	Espagñol	t	145	f
3639	3	971	3	en total fueron	Espagñol	t	145	f
3640	3	972	3	registros	Espagñol	t	145	f
3641	3	973	3	exportado	Espagñol	t	145	f
3642	3	974	3	índice de exportación	Espagñol	t	145	f
3645	3	977	3	resumir archivos	Espagñol	t	145	f
3647	3	979	3	gzip	Espagñol	t	145	f
3655	3	987	3	terminado	Espagñol	t	147	f
3656	3	988	3	los siguientes campos tienen un formato no válido	Espagñol	t	148	f
3658	3	990	3	importación parcial	Espagñol	t	148	f
3659	3	991	3	importación de texto	Espagñol	t	148	f
6335	4	478	2	style élément de rapport	francais	t	0	f
3660	3	992	3	de archivo de texto	Espagñol	t	148	f
3661	3	993	3	ninguno	Espagñol	t	148	f
3662	3	994	3	todos	Espagñol	t	148	f
3663	3	995	3	importación de sistema	Espagñol	t	148	f
3665	3	997	3	vista previa de la fila	Espagñol	t	148	f
3666	3	998	3	del archivo del sistema	Espagñol	t	148	f
3670	3	1002	3	sobreescribir	Espagñol	t	148	f
3671	3	1003	3	añadir	Espagñol	t	148	f
3672	3	1004	3	conservar ID	Espagñol	t	148	f
3674	3	1006	3	importación completa	Espagñol	t	148	f
3675	3	1007	3	archivo de configuración	Espagñol	t	148	f
3677	3	1009	3	reinstalar	Espagñol	t	148	f
3678	3	1010	3	tipo de campo falso	Espagñol	t	149	f
3679	3	1011	3	registros insertados	Espagñol	t	149	f
3680	3	1012	3	error	Espagñol	t	149	f
3682	3	1014	3	probar instancia	Espagñol	t	149	f
3683	3	1015	3	insertar datos en  el cuadro	Espagñol	t	149	f
3684	3	1016	3	fallo de filas	Espagñol	t	149	f
3685	3	1017	3	filas insertadas	Espagñol	t	149	f
3686	3	1018	3	creado	Espagñol	t	149	f
3687	3	1019	3	fallado	Espagñol	t	149	f
3688	3	1020	3	crear cuadro	Espagñol	t	149	f
3689	3	1021	3	borrar cuadro	Espagñol	t	149	f
3690	3	1022	3	informe de importación	Espagñol	t	149	f
3692	3	1024	3	indexado	Espagñol	t	149	f
3693	3	1025	3	tabla indexada	Espagñol	t	149	f
3694	3	1026	3	añadir clave externa	Espagñol	t	149	f
3697	3	1029	3	grupo del cuadro	Espagñol	t	150	f
3704	3	1036	3	estructura	Espagñol	t	150	f
3705	3	1037	3	estructura y datos	Espagñol	t	150	f
3706	3	1038	3	crear	Espagñol	t	150	f
3707	3	1039	3	existente	Espagñol	t	151	f
3708	3	1040	3	importar	Espagñol	t	151	f
3721	3	1054	3	revisión de todos los cuadros y derechos de campo	Espagñol	t	154	f
3722	3	1056	3	revisión de todos los derechos del menú	Espagñol	t	154	f
3723	3	1057	3	borrar todas las sesiones	Espagñol	t	154	f
3726	3	1060	3	información del sistema	Espagñol	t	155	f
3727	3	1061	3	mostrar	Espagñol	t	155	f
3731	3	1065	3	ejecutar	Espagñol	t	155	f
3733	3	1067	3	privilegios	Espagñol	t	155	f
3734	3	1068	3	fecha de creación	Espagñol	t	155	f
6337	4	484	2	Définir les droits	francais	t	0	f
3735	3	1069	3	cuadro vaciado con éxito	Espagñol	t	156	f
3736	3	1070	3	error/el cuadro no fue vaciado	Espagñol	t	156	f
3737	3	1071	3	cuadro borrado con éxito	Espagñol	t	156	f
3738	3	1072	3	error/el cuadro no fue borrado	Espagñol	t	156	f
3739	3	1073	3	Consulta SQL ejecutada con éxito	Espagñol	t	156	f
3749	3	1083	3	URL	Espagñol	t	162	f
3753	3	1087	3	imagen	Espagñol	t	162	f
3765	3	1099	3	elemento	Espagñol	t	168	f
3766	3	1100	3	informaciones de imagen	Espagñol	t	168	f
3768	3	1102	3	presentación	Espagñol	t	168	f
3770	3	1104	3	color	Espagñol	t	168	f
3771	3	1105	3	grosor	Espagñol	t	168	f
3773	3	1107	3	fondo	Espagñol	t	168	f
3774	3	1108	3	reflejar	Espagñol	t	168	f
3775	3	1109	3	columnas	Espagñol	t	168	f
3777	3	1111	3	distancia	Espagñol	t	168	f
3778	3	1112	3	cabeza	Espagñol	t	168	f
3779	3	1113	3	pie	Espagñol	t	168	f
3780	3	1114	3	lista	Espagñol	t	168	f
3781	3	1115	3	estilo de fuente	Espagñol	t	168	f
3782	3	1116	3	peso de fuente	Espagñol	t	168	f
3783	3	1117	3	decoración del texto	Espagñol	t	168	f
3784	3	1118	3	transformación del texto	Espagñol	t	168	f
3785	3	1119	3	alineación del texto	Espagñol	t	168	f
3786	3	1120	3	distancia de filas	Espagñol	t	168	f
3787	3	1121	3	distancia de letra	Espagñol	t	168	f
3788	3	1122	3	distancia de palabra	Espagñol	t	168	f
3789	3	1123	3	normal	Espagñol	t	168	f
3790	3	1124	3	cursiva	Espagñol	t	168	f
3791	3	1125	3	negrita	Espagñol	t	168	f
3792	3	1126	3	subrayada	Espagñol	t	168	f
3793	3	1127	3	mayúsculas	Espagñol	t	168	f
3794	3	1128	3	minúsculas	Espagñol	t	168	f
3795	3	1129	3	en bloque	Espagñol	t	168	f
3796	3	1130	3	justificado a la izquierda	Espagñol	t	168	f
3797	3	1131	3	centrado	Espagñol	t	168	f
3798	3	1132	3	justificado a la derecha	Espagñol	t	168	f
3800	3	1134	3	historia	Espagñol	t	168	f
3802	3	1136	3	recalcular	Espagñol	t	168	f
3804	3	1138	3	fuente	Espagñol	t	169	f
3806	3	1140	3	tamaño de página (mm)	Espagñol	t	169	f
3807	3	1141	3	ancho	Espagñol	t	169	f
3808	3	1142	3	altura	Espagñol	t	169	f
3809	3	1143	3	márgenes (mm)	Espagñol	t	169	f
3810	3	1144	3	arriba	Espagñol	t	169	f
3811	3	1145	3	abajo	Espagñol	t	169	f
3812	3	1146	3	izquierda	Espagñol	t	169	f
3813	3	1147	3	derecha	Espagñol	t	169	f
3814	3	1148	3	proporciones	Espagñol	t	169	f
3815	3	1149	3	bloque de texto	Espagñol	t	169	f
3816	3	1150	3	contenidos	Espagñol	t	169	f
3817	3	1151	3	gráfico	Espagñol	t	169	f
3818	3	1152	3	línea	Espagñol	t	169	f
3819	3	1153	3	rectángulo	Espagñol	t	169	f
3820	3	1154	3	elipse	Espagñol	t	169	f
3828	3	1162	3	para cuadro	Espagñol	t	170	f
3831	3	1165	3	nuevo informe	Espagñol	t	170	f
3833	3	1167	3	el gráfico no pudo ser almacenado con éxito	Espagñol	t	172	f
3836	3	1170	3	fuente	Espagñol	t	175	f
3837	3	1171	3	subformulario	Espagñol	t	175	f
3839	3	1173	3	barra de desplazamiento	Espagñol	t	175	f
3840	3	1174	3	botón submit	Espagñol	t	175	f
3842	3	1176	3	calidad	Espagñol	t	175	f
3845	3	1179	3	formulario	Espagñol	t	176	f
3849	3	1183	3	vista previa	Espagñol	t	176	f
3850	3	1184	3	una columna	Espagñol	t	176	f
3852	3	1186	3	nuevo formulario	Espagñol	t	176	f
3857	3	1191	3	nuevo diagrama	Espagñol	t	177	f
8184	4	2212	2	attribut	francais	t	0	f
3866	3	1200	2	administrador de archivo	Espagñol	t	0	f
3867	3	1201	2	administrador de archivo	Espagñol	t	0	f
6432	4	715	1	Détails open sélection	francais	t	34	f
6436	4	722	1	enregistrement de données	francais	t	13	f
6455	4	751	2	Tableau d'évaluation	francais	t	0	f
6493	4	812	1	Mes documents	francais	t	3	f
6537	4	869	1	informer	francais	t	15	f
6601	4	939	3	liens	francais	t	139	f
6634	4	977	3	fichiers Ensemble	francais	t	145	f
6761	4	1116	3	poids police	francais	t	168	f
6890	4	1264	3	Cette fonction vérifie tous les droits de table à l'existence! Les droits existants ne sont pas remplacés	francais	t	154	t
6891	4	1265	3	Cette fonction vérifie tous les droits de menu à l'existence! Les droits existants ne sont pas remplacés	francais	t	154	t
6892	4	1266	2	surveillance	francais	t	0	f
6893	4	1267	2	Surveillance de l'utilisateur	francais	t	0	f
6902	4	1276	2	tableau détail	francais	t	0	f
6903	4	1277	2	paramètres de table	francais	t	0	f
6913	4	1287	2	Ajuster à la taille du cadre et le type	francais	t	0	f
7045	4	1422	2	récupérer	francais	t	0	f
7105	4	1490	3	haut affleurant	francais	t	168	f
7106	4	1491	3	centre	francais	t	168	f
7107	4	1492	3	vers le bas affleurant	francais	t	168	f
7108	4	1493	3	base	francais	t	168	f
7109	4	1494	3	indice	francais	t	168	f
7097	4	1482	2	Case à cocher (choix multiple) comme une liste de cases à cocher	francais	t	0	f
7426	4	1842	3	FORMAT: VALEUR [STRING] | AUTRES [STRING]	francais	t	104	f
7517	4	1937	2	Mode mot-clé	francais	t	0	f
7736	4	2100	3	maquillage	francais	t	168	f
7812	4	2119	3	diagrammes	francais	t	177	f
7864	4	2132	3	versioning	francais	t	140	f
7888	4	2138	1	non table liée sélectionnée!	francais	t	5	f
7892	4	2139	1	Aucune donnée disponible associé!	francais	t	5	f
10538	4	2358	1	lien Break	francais	t	13	f
7856	4	2130	3	droit de fichier	francais	t	119	f
7852	4	2129	3	droits de table	francais	t	119	f
7920	4	2146	1	si le dossier versionné?	francais	t	13	f
7928	4	2148	1	Record a été versionné avec succès!	francais	t	25	f
7932	4	2149	1	Les dossiers ont été versionnées avec succès!	francais	t	25	f
7936	4	2150	1	Enregistrement a été copié avec succès!	francais	t	25	f
7940	4	2151	1	Datensätze wurden erfolgreich kopiert!	francais	t	25	f
7948	4	2153	1	Si les enregistrements sélectionnés sont supprimés?	francais	t	5	f
7952	4	2154	1	Si les enregistrements sélectionnés sont archivés?	francais	t	5	f
7956	4	2155	1	Si les enregistrements sélectionnés sont versionnés?	francais	t	5	f
7960	4	2156	1	Si les enregistrements sélectionnés sont copiés?	francais	t	5	f
7964	4	2157	1	Si les enregistrements sélectionnés sont restaurés?	francais	t	5	f
7968	4	2158	1	Annulation des limites peut conduire à des longs délais d'attente pour les grands ensembles de disques!	francais	t	5	f
7983	4	2162	2	comparer avec	francais	t	\N	f
7987	4	2163	2	comparer la version	francais	t	\N	f
7995	4	2165	2	barre d'outils	francais	t	\N	f
7999	4	2166	2	barre d'outils d'exposition	francais	t	\N	f
8004	4	2167	1	barre d'outils d'exposition	francais	t	46	f
8007	4	2168	2	recherche	francais	t	\N	f
8011	4	2169	2	menu de recherche	francais	t	\N	f
3827	3	1161	3	creado por	Espagñol	t	170	f
10330	4	2308	2	barre d'outils d'exposition	francais	t	0	f
7924	4	2147	1	Il peut être versionné et édité seule la version actuelle du dossier!	francais	t	13	f
8024	4	2172	1	Situation au:	francais	t	5	f
8028	4	2173	2	-------types de champs d'extension ------- 	francais	t	0	f
8080	4	2186	1	Si les enregistrements sélectionnés sont liés?	francais	t	5	f
8084	4	2187	1	Si l'opération des enregistrements sélectionnés sera résolu?	francais	t	5	f
8092	4	2189	1	Vous n'avez pas droit à ce dossier!	francais	t	66	f
8131	4	2199	2	lieu de travail	francais	t	\N	f
8135	4	2200	2	résumé	francais	t	\N	f
8139	4	2201	2	rapports	francais	t	\N	f
8143	4	2202	2	rapports	francais	t	\N	f
8151	4	2204	2	données personnelles	francais	t	\N	f
8176	4	2210	3	rebaptiser	francais	t	148	f
8116	4	2195	2	Taille en octets	francais	t	0	f
8200	4	2216	3	gâchette	francais	t	149	f
10338	4	2310	1	Vous avez pas de dossier des droits!	francais	t	97	f
8120	4	2196	2	mimetype	francais	t	0	f
8040	4	2176	2	Versioning remarque additionnelle	francais	t	0	f
8212	4	2219	1	Voulez-vous ajouter le fichier / s à vos favoris?	francais	t	66	f
8236	4	2225	1	un niveau	francais	t	215	f
8240	4	2226	1	sélectionner	francais	t	215	f
8244	4	2227	1	abandonner	francais	t	215	f
8252	4	2229	1	regardant dans	francais	t	215	f
8256	4	2230	1	Répertoire de base	francais	t	215	f
8260	4	2231	1	nouveau dossier	francais	t	215	f
8264	4	2232	1	nouveau fichier	francais	t	215	f
8268	4	2233	1	simple présentation	francais	t	215	f
8272	4	2234	1	affichage étendu	francais	t	215	f
8276	4	2235	3	identificateurs	francais	t	110	f
8280	4	2236	3	dépendance	francais	t	52	f
8292	4	2239	3	uniquement backend verrouillage	francais	t	127	f
8296	4	2240	3	convertir	francais	t	148	f
8308	4	2243	3	question	francais	t	148	f
8384	4	2262	3	la vie de la session	francais	t	127	f
11034	4	2482	3	fonctions de base de données	francais	t	154	f
10167	4	2269	3	définition	francais	t	218	f
10172	4	2270	3	édité sur	francais	t	218	f
10177	4	2271	3	édité par	francais	t	218	f
4225	3	1470	2	löschen	Espagñol	t	\N	f
4360	3	1515	2	Feldtypen	Espagñol	t	\N	f
4228	3	1471	2	Dateien/Ordner löschen	Espagñol	t	\N	f
10242	4	2286	3	Si le groupe de table sera supprimé, y compris les tables?	francais	t	140	f
4243	3	1476	2	löschen	Espagñol	t	\N	f
4246	3	1477	2	Nachricht löschen	Espagñol	t	\N	f
10246	4	2287	3	Voulez-vous la table à supprimer?	francais	t	140	f
10250	4	2288	3	tous ouverts	francais	t	213	f
10258	4	2290	3	tous ouverts justifiés	francais	t	213	f
10262	4	2291	2	montrer elle-même liée	francais	t	0	f
10270	4	2293	1	Les métadonnées ne peut pas être mis à jour!	francais	t	66	f
10274	4	2294	1	Vous n'êtes pas autorisé ou l'ordre a été retiré!	francais	t	66	f
4273	3	1486	2	Details	Espagñol	t	\N	f
4276	3	1487	2	Datensatz-Statistik	Espagñol	t	\N	f
10278	4	2295	3	voir les fichiers	francais	t	213	f
10282	4	2296	3	Ajouter des fichiers	francais	t	213	f
10286	4	2297	3	Créer un dossier	francais	t	213	f
10290	4	2298	3	Supprimer les fichiers / dossiers	francais	t	213	f
10294	4	2299	3	modifier les métadonnées	francais	t	213	f
10298	4	2300	3	fichiers de verrouillage	francais	t	213	f
10302	4	2301	3	groupes autorisés	francais	t	213	f
10306	4	2302	3	ne pas afficher le menu de table	francais	t	122	f
10314	4	2304	2	OCR	francais	t	0	f
10318	4	2305	2	reconnaissance OCR	francais	t	0	f
10326	4	2307	2	barre d'outils	francais	t	0	f
10310	4	2303	3	lire	francais	t	122	f
10266	4	2292	2	montrer avec lui-même les dossiers liés	francais	t	0	f
4309	3	1498	2	Berichtsarchiv	Espagñol	t	\N	f
5401	3	1862	2	Jobs	Espagñol	t	\N	f
4312	3	1499	2	Berichtsarchiv	Espagñol	t	\N	f
4315	3	1500	2	Voransicht	Espagñol	t	\N	f
4318	3	1501	2	Berichts-Voransicht	Espagñol	t	\N	f
4321	3	1502	2	Bericht drucken	Espagñol	t	\N	f
4324	3	1503	2	Bericht drucken	Espagñol	t	\N	f
10334	4	2309	1	fichier	francais	t	97	f
10342	4	2311	1	Aucun droit de suppression!	francais	t	97	f
10350	4	2313	1	Le fichier source existe déjà. S'il vous plaît essayer à nouveau.	francais	t	97	f
10354	4	2314	1	Lancer la reconnaissance OCR	francais	t	66	f
10358	4	2315	2	Linked mode	francais	t	0	f
10362	4	2316	2	afficher uniquement les enregistrements liés	francais	t	0	f
4357	3	1514	2	Feldtypen	Espagñol	t	\N	f
10366	4	2317	1	Le fichier source n'existe plus!	francais	t	66	f
10370	4	2318	1	supprimer le fichier	francais	t	215	f
10374	4	2319	2	Rechercher les sous-dossiers	francais	t	0	f
10378	4	2320	2	recherche récursive	francais	t	0	f
10382	4	2321	1	ouvert	francais	t	66	f
10386	4	2322	1	Enregistrer	francais	t	66	f
10390	4	2323	1	métadonnées Info	francais	t	66	f
10394	4	2324	1	l'indexation de l'information	francais	t	66	f
10398	4	2325	1	Infos versionnage	francais	t	66	f
10418	4	2330	1	voir tous les fichiers	francais	t	66	f
10426	4	2332	1	sauter	francais	t	66	f
10430	4	2333	1	Appliquer à tous les fichiers	francais	t	66	f
10434	4	2334	1	Voir origine	francais	t	15	f
10450	4	2338	2	Droits de l'utilisateur	francais	t	0	f
10454	4	2339	2	les utilisateurs d'autorisation	francais	t	0	f
10458	4	2340	3	Si vous modifiez les autorisations tous les anciens unique des droits de cette table sera supprimé!	francais	t	140	f
10462	4	2341	2	Afficher les droits des utilisateurs	francais	t	0	f
10466	4	2342	2	Vue d'ensemble des droits des utilisateurs	francais	t	0	f
10486	4	2347	3	Z-Index	francais	t	169	f
10490	4	2348	3	Y-Pos	francais	t	169	f
10494	4	2349	2	test	francais	t	unknown	f
4531	3	1572	2	Backup	Espagñol	t	\N	f
4534	3	1573	2	System-Backup	Espagñol	t	\N	f
4540	3	1575	2	History	Espagñol	t	\N	f
4543	3	1576	2	Backup-History	Espagñol	t	\N	f
4546	3	1577	2	Periodisches Backup	Espagñol	t	\N	f
4549	3	1578	2	Periodisches Backup	Espagñol	t	\N	f
4552	3	1579	2	Manuell	Espagñol	t	\N	f
4555	3	1580	2	Manuelles Backup	Espagñol	t	\N	f
4561	3	1582	2	Schlagworte	Espagñol	t	\N	f
4564	3	1583	2	Verschlagwortung	Espagñol	t	\N	f
4567	3	1584	2	Tabellen	Espagñol	t	\N	f
4570	3	1585	2	Datensatz-Memos	Espagñol	t	\N	f
12013	2	2727	3	Ref. table	english	t	195	f
4579	3	1588	2	History	Espagñol	t	\N	f
4582	3	1589	2	Schlagwort-History	Espagñol	t	\N	f
10498	4	2350	2	 	francais	t	unknown	f
10502	4	1993	2	section	francais	t	unknown	f
10410	4	2328	3	sont tous les paramètres utilisateur seront perdus?	francais	t	154	f
10506	4	1994	2	étiquetage Catégorie	francais	t	unknown	f
10518	4	2353	3	IP statique	francais	t	127	f
10446	4	2337	3	Gérer les droits des utilisateurs pour tous les enregistrements	francais	t	221	f
10522	4	2354	1	La différence entre les versions	francais	t	204	f
10526	4	2355	1	Télécharger en pdf	francais	t	204	f
4651	3	1612	2	download	Espagñol	t	\N	f
4654	3	1613	2	download archive	Espagñol	t	\N	f
10534	4	2357	3	seperator	francais	t	168	f
4660	3	1615	2	einfügen	Espagñol	t	\N	f
11358	4	2563	2	paramètres	francais	t	0	f
10542	4	2359	1	Voulez-vous supprimer le lien de ce document?	francais	t	13	f
4666	3	1617	2	Dateirechte	Espagñol	t	\N	f
4669	3	1618	2	Dateirechte festlegen	Espagñol	t	\N	f
4678	3	1621	2	Dateien	Espagñol	t	\N	f
10514	4	2352	2	Document de référence	francais	t	0	f
10554	4	2362	2	regroupement	francais	t	0	f
10558	4	2363	2	groupement de terrain	francais	t	0	f
10578	4	2368	3	Information Texte Bien verrouillé	francais	t	154	f
4699	3	1628	2	speichern	Espagñol	t	\N	f
4702	3	1629	2	Dateien speichern	Espagñol	t	\N	f
4711	3	1632	2	Info	Espagñol	t	\N	f
4714	3	1633	2	Datei Informationen	Espagñol	t	\N	f
10606	4	2375	1	Le fichier téléchargé existe déjà avec le même ou un autre nom dans les dossiers suivants	francais	t	41	f
10610	4	2376	3	filtre avancé	francais	t	121	f
10614	4	2377	3	relations	francais	t	121	f
10618	4	2378	3	membre du groupe	francais	t	186	f
10622	4	2379	3	tri	francais	t	186	f
10630	4	2381	3	respect	francais	t	52	f
10646	4	2385	3	fin	francais	t	52	f
10546	4	2360	2	onglet regroupement	francais	t	0	f
10550	4	2361	2	Regroupement des champs en tant que coureur	francais	t	0	f
10658	4	2388	3	créé sur	francais	t	52	f
10662	4	2389	3	créé par	francais	t	52	f
10666	4	2390	3	Créé par groupe	francais	t	52	f
10670	4	2391	3	édité sur	francais	t	52	f
10674	4	2392	3	édité par	francais	t	52	f
10574	4	2367	3	Supprimer les paramètres de l'utilisateur	francais	t	154	f
10590	4	2371	3	back-link	francais	t	121	f
10754	4	2412	3	message non.	francais	t	52	f
10762	4	2414	3	de	francais	t	52	f
10766	4	2415	3	à	francais	t	52	f
10782	4	2419	3	message	francais	t	52	f
10818	4	2428	3	verrouillage illimité	francais	t	221	f
10822	4	2429	2	serrure	francais	t	0	f
10826	4	2430	2	enregistrement de verrouillage	francais	t	0	f
10830	4	2431	2	déverrouillage	francais	t	0	f
10834	4	2432	2	déverrouiller disque	francais	t	0	f
10838	4	2433	1	le document devrait être libéré?	francais	t	13	f
3098	3	365	2	lista	Espagñol	t	0	f
10846	4	2435	1	Record a été bloqué avec succès!	francais	t	25	f
10850	4	2436	1	Les dossiers ont été bloqués avec succès!	francais	t	25	f
10854	4	2437	1	Record a été débloqué avec succès!	francais	t	25	f
10858	4	2438	1	Les dossiers ont été avec succès déverrouillé!	francais	t	25	f
10862	4	2439	2	Date verrouillée	francais	t	0	f
10866	4	2440	2	mes dossiers verrouillés	francais	t	0	f
10870	4	2441	2	show bloqué	francais	t	0	f
10874	4	2442	2	Affichage des enregistrements verrouillés	francais	t	0	f
10878	4	2443	2	sauver	francais	t	0	f
10882	4	2444	2	prendre	francais	t	0	f
10886	4	2445	3	toujours	francais	t	168	f
10890	4	2446	3	même des pages	francais	t	168	f
10894	4	2447	3	pages impaires	francais	t	168	f
10898	4	2448	1	parlé comme	francais	t	66	f
10906	4	2450	3	base de données de déclenchement	francais	t	218	f
10910	4	2451	3	déclenchement Limbas	francais	t	218	f
11694	4	2647	1	cible	francais	t	66	f
10918	4	2453	3	Gérer les droits des utilisateurs pour les enregistrements générés en interne	francais	t	221	f
4909	3	1698	2	kopieren	Espagñol	t	\N	f
4912	3	1699	2	Nachricht kopieren	Espagñol	t	\N	f
4915	3	1700	2	speichern	Espagñol	t	\N	f
10926	4	2455	1	Vous êtes connecté en tant	francais	t	11	f
10930	4	2456	3	redirection de forme	francais	t	175	f
10938	4	2458	3	maxlen	francais	t	168	f
10946	4	2460	3	remplacer	francais	t	168	f
10954	4	2462	3	La sélection des projets	francais	t	145	f
4948	3	1711	2	markieren	Espagñol	t	\N	f
4951	3	1712	2	Nachricht markieren	Espagñol	t	\N	f
10958	4	2463	3	sende Anmelde-Informationen	francais	t	132	f
4987	3	1724	2	Neuberechnung	Espagñol	t	\N	f
4990	3	1725	2	Vorschau neu berechnen	Espagñol	t	\N	f
5002	3	1729	2	kopieren	Espagñol	t	\N	f
5005	3	1730	2	Datensatz kopieren	Espagñol	t	\N	f
5020	3	1735	2	neues Fenster	Espagñol	t	\N	f
5023	3	1736	2	neuer LIMBAS-Explorer	Espagñol	t	\N	f
10966	4	2465	2	somme spectacle	francais	t	0	f
10970	4	2466	2	montrer la somme des dossiers	francais	t	0	f
10982	4	2469	2	Numéro de point de flotteur	francais	t	0	f
10986	4	2470	2	récursives liens et versions de suppression	francais	t	0	f
10990	4	2471	2	fonctions spéciales	francais	t	0	f
10994	4	2472	2	fonctions spéciales	francais	t	0	f
10998	4	2473	1	Les dépendances suivantes sont réunies:	francais	t	25	f
11002	4	2474	1	Les dépendances suivantes ont été résolus:	francais	t	25	f
11030	4	2481	3	contenu temporaire	francais	t	154	f
11042	4	2484	3	gestion des droits	francais	t	154	f
11046	4	2485	3	Paramètres utilisateur	francais	t	154	f
11038	4	2483	3	système	francais	t	154	f
5092	3	1759	2	Vorschau	Espagñol	t	\N	f
5095	3	1760	2	Vorschau	Espagñol	t	\N	f
11066	4	2490	2	arbres relation	francais	t	0	f
11078	4	2493	2	arbre de table	francais	t	0	f
11082	4	2494	2	arbre de table	francais	t	0	f
11086	4	2495	2	Rechercher les divisions du Groupe	francais	t	0	f
11090	4	2496	2	Rechercher les en-têtes de groupe sur le terrain	francais	t	0	f
11098	4	2498	1	groupes	francais	t	84	f
11062	4	2489	2	arbre de table	francais	t	0	f
5122	3	1769	2	Editmodus	Espagñol	t	\N	f
5125	3	1770	2	Bearbeite Long-Feld	Espagñol	t	\N	f
11114	4	2502	1	Format:	francais	t	13	f
11118	4	2503	1	Formulaire standard	francais	t	13	f
11126	4	2505	3	Afficher l'article	francais	t	110	f
11134	4	2507	3	Recherche rapide	francais	t	110	f
11138	4	2508	3	HTML	francais	t	168	f
11142	4	2509	3	Extension rapport	francais	t	170	f
5161	3	1782	2	Vergleich	Espagñol	t	\N	f
5299	3	1828	2	Info	Espagñol	t	\N	f
5164	3	1783	2	Vergleich zweier Dateien	Espagñol	t	\N	f
11154	4	2512	3	rapports du système	francais	t	222	f
8112	4	2194	2	Taille du fichier	francais	t	0	f
10562	4	2364	2	doublons	francais	t	0	f
10566	4	2365	2	Vue d'ensemble des doublons	francais	t	0	f
11018	4	2478	2	doublons	francais	t	0	f
11022	4	2479	2	Afficher les doublons	francais	t	0	f
11182	4	2519	1	e-mail:	francais	t	46	f
11186	4	2520	1	adresse de réponse	francais	t	46	f
11190	4	2521	1	Nom d'hôte Imap	francais	t	46	f
11194	4	2522	1	Nom d'utilisateur Imap	francais	t	46	f
11198	4	2523	1	port imap	francais	t	46	f
11202	4	2524	1	Mot de passe imap	francais	t	46	f
6563	4	896	3	Cette fonction définit les droits standards du groupe et de ses sous-groupes ici encore! Ici, les droits existants sont remplacés!	francais	t	115	t
8192	4	2214	3	déjà il y a un lien positif pour ce domaine! Cette action utilise le raccourci négatif existant. Les liens existants seront perdus!	francais	t	121	t
10414	4	2329	3	Si les fichiers .htaccess à régénérer? Les nouveaux mots de passe ne sont appliqués que lorsque l'option clear_password est activée dans les umgvars	francais	t	154	t
6435	4	721	1	Cet ensemble de données est muni d'une nouvelle présentation! Faut-il être retiré?	francais	t	13	t
11206	4	2525	2	paramètres	francais	t	0	f
11210	4	2526	2	paramètres avancés	francais	t	0	f
11214	4	2527	2	mettre à jour	francais	t	0	f
11218	4	2528	2	mettre à jour	francais	t	0	f
10634	4	2382	3	début	francais	t	52	f
11222	4	2529	2	ligne de regroupement	francais	t	0	f
11226	4	2530	2	groupe sur le terrain dans une rangée	francais	t	0	f
11230	4	2531	1	La longueur du nom de fichier ne peut pas dépasser 128 caractères!	francais	t	41	f
5302	3	1829	2	Info über LIMBAS	Espagñol	t	\N	f
11278	4	2543	3	nouvel arbre de table	francais	t	207	f
5368	3	1851	2	Tabellen Index	Espagñol	t	\N	f
5404	3	1863	2	setup_jobs_cron	Espagñol	t	\N	f
5407	3	1864	2	Periodisch	Espagñol	t	\N	f
5410	3	1865	2	setup_jobs_cron	Espagñol	t	\N	f
5413	3	1866	2	History	Espagñol	t	\N	f
5416	3	1867	2	setup_jobs_hist	Espagñol	t	\N	f
5422	3	1869	2	Beschränkung aufheben	Espagñol	t	\N	f
5425	3	1870	2	Beschränkung aufheben	Espagñol	t	\N	f
5434	3	1873	2	Abmelden	Espagñol	t	\N	f
5437	3	1874	2	Abmelden	Espagñol	t	\N	f
5440	3	1875	2	nav_refresh	Espagñol	t	\N	f
5443	3	1876	2	aktualisieren	Espagñol	t	\N	f
5446	3	1877	2	Tabellenschema	Espagñol	t	\N	f
5449	3	1878	2	Tabellenschema	Espagñol	t	\N	f
7367	4	1781	3	un message de verrouillage	francais	t	127	f
6582	4	918	3	où? ID est le numéro d'article	francais	t	107	f
11310	4	2551	3	rétablir les droits d'enregistrement	francais	t	154	f
11314	4	2552	3	droits d'enregistrement recalculent ensemble de données recalcul droit	francais	t	154	f
11322	4	2554	3	onglet raccourci	francais	t	173	f
11326	4	2555	3	menubar	francais	t	173	f
5479	3	1888	2	Zeichensätze	Espagñol	t	\N	f
5482	3	1889	2	fontmanager	Espagñol	t	\N	f
5488	3	1891	2	zurücksetzen	Espagñol	t	\N	f
5491	3	1892	2	Suche zurücksetzen	Espagñol	t	\N	f
11334	4	2557	3	plinthe	francais	t	173	f
11150	4	2511	3	Nom de stockage	francais	t	170	f
7780	4	2111	3	dossier de stockage	francais	t	170	f
11350	4	2561	3	Tab Rahmenc	francais	t	175	f
11354	4	2562	3	L'utilisateur n'a pas pu être créé!	francais	t	126	f
11298	4	2548	3	sollen alle temporären Thumbnails gelöscht werden?	francais	t	154	f
11362	4	2564	2	paramètres avancés	francais	t	0	f
11170	4	2516	3	Droits de l'utilisateur hérité hiérarchiquement	francais	t	221	f
10530	4	2356	3	voir tous versionné	francais	t	221	f
11366	4	2565	3	Versionierungsart	francais	t	221	f
11374	4	2567	3	Colonnes couleur de fond	francais	t	221	f
5548	3	1911	2	Suchparameter für alle Ordner	Espagñol	t	\N	f
11382	4	2569	3	règle de filtrage	francais	t	221	f
5563	3	1916	2	Anzeige	Espagñol	t	\N	f
5566	3	1917	2	Auswahl anzuzeigender Felder	Espagñol	t	\N	f
11386	4	2570	3	règles d'édition	francais	t	221	f
5575	3	1920	2	Einstellung speichern	Espagñol	t	\N	f
5578	3	1921	2	Einstellung speichern	Espagñol	t	\N	f
5581	3	1922	2	Ansicht speichern	Espagñol	t	\N	f
4983	1	1723	3	Datum+Zeit	deutsch	t	110	f
5584	3	1923	2	Ansichtseinstellungen füell alle Ordner speichern	Espagñol	t	\N	f
11394	4	2572	3	paramètres de formatage	francais	t	221	f
11398	4	2573	3	Règle d'accès en écriture	francais	t	221	f
10254	4	2289	3	tout près	francais	t	213	f
11410	4	2576	3	format de date	francais	t	127	f
11318	4	2553	3	toutes les données existantes des droits spécifiques définis du Tablle sélectionné sont supprimés!	francais	t	154	f
5620	3	1935	2	Datei	Espagñol	t	\N	f
5626	3	1937	2	Schlagwort	Espagñol	t	\N	f
11414	4	2577	3	Infos envoyer du courrier à l'utilisateur	francais	t	172	f
11422	4	2579	2	OCR	francais	t	0	f
5623	3	1936	2	Dateiansicht	Espagñol	t	\N	f
11378	4	2568	3	Par défaut pour la création d'un nouveau record	francais	t	221	f
11426	4	2580	2	reconnaissance OCR	francais	t	0	f
11430	4	2581	3	fichier css	francais	t	175	f
11434	4	2582	1	lien	francais	t	15	f
11438	4	2583	2	extensions	francais	t	0	f
11442	4	2584	2	extensions d'édition	francais	t	0	f
11486	4	2595	3	séparateur	francais	t	110	f
10322	4	2306	3	Formulaire / Rapport des droits	francais	t	119	f
7860	4	2131	3	menu à droite	francais	t	119	f
11446	4	2585	3	accepter les droits du groupe supérieur:	francais	t	119	f
11454	4	2587	3	seuil de puissance	francais	t	110	f
11458	4	2588	3	valeur par défaut spécifique à base de données <br> 12 | texte | maintenant ()	francais	t	110	f
11462	4	2589	3	Modification du type de champ si possible	francais	t	110	f
11466	4	2590	3	Remplacement du type boîte ayant une fonction distincte de [ext_type.inc]	francais	t	110	f
11470	4	2591	3	En général, pour cacher le champ, attendu: return true / false	francais	t	110	f
11474	4	2592	3	Règle d'accès en écriture du champ, attendu: return true / false	francais	t	110	f
11478	4	2593	3	installer	francais	t	110	f
5710	3	1965	2	veröffentlichen	Espagñol	t	\N	f
11494	4	2597	3	De combien d'endroits le nombre à afficher dans Expotentialschreibweise	francais	t	110	f
11502	4	2599	3	Devise par défaut	francais	t	110	f
11506	4	2600	3	format de l'heure	francais	t	110	f
11490	4	2596	3	Représentation des nombres dans le format numérique () Format: par exemple 2, ''. '', '' ''	francais	t	110	f
11522	4	2604	3	table de liaison	francais	t	110	f
11526	4	2605	1	ne doit pas être plus affecté!	francais	t	13	f
11402	4	2574	3	forme standard	francais	t	221	f
6533	4	865	1	sélection de groupe	francais	t	5	f
5779	3	1988	2	Trigger	Espagñol	t	\N	f
5782	3	1989	2	Trigger	Espagñol	t	\N	f
11538	4	2608	3	filtre	francais	t	110	f
11542	4	2609	3	Boîte de recherche	francais	t	110	f
11546	4	2610	3	évaluation	francais	t	110	f
5887	3	2024	2	Abfragen	Espagñol	t	\N	f
5890	3	2025	2	Abfragen-Generator	Espagñol	t	\N	f
5929	3	2038	2	workflow	Espagñol	t	\N	f
5545	3	1910	2	suche global	Espagñol	t	\N	f
11550	4	2611	3	hérédité	francais	t	110	f
5932	3	2039	2	workflow	Espagñol	t	\N	f
11174	4	2517	1	hiérarchisés hériter	francais	t	13	f
11866	4	2690	3	ouvrir l'éditeur de requête	francais	t	140	f
11554	4	2612	3	l'éditeur de requête	francais	t	225	f
11574	4	2617	3	Comprend uniquement les enregistrements dans lesquels le contenu des champs joints sont égaux	francais	t	226	f
11578	4	2618	3	Comprend tous les dossiers de	francais	t	226	f
11582	4	2619	3	et que les enregistrements de	francais	t	226	f
11586	4	2620	3	où le contenu des champs joints sont égaux	francais	t	226	f
11602	4	2624	3	alias	francais	t	226	f
5992	3	2059	2	Workflow	Espagñol	t	\N	f
5995	3	2060	2	Workflow	Espagñol	t	\N	f
11606	4	2625	3	fonction	francais	t	226	f
11614	4	2627	3	somme	francais	t	226	f
11618	4	2628	3	min	francais	t	226	f
11622	4	2629	3	max	francais	t	226	f
11630	4	2631	3	spectacle	francais	t	226	f
11634	4	2632	3	critères	francais	t	226	f
11638	4	2633	3	ascendant	francais	t	226	f
11642	4	2634	3	descendant	francais	t	226	f
11646	4	2635	3	tables système d'exposition	francais	t	225	f
11658	4	2638	3	spectacle	francais	t	168	f
11666	4	2640	3	poste ajax	francais	t	110	f
11678	4	2643	1	à l'utilisateur	francais	t	13	f
11682	4	2644	1	ensemble	francais	t	13	f
7672	3	2084	2	Meine Workflows	Espagñol	t	\N	f
7676	3	2085	2	erstellte Workflows	Espagñol	t	\N	f
11702	4	2649	3	mode liste	francais	t	169	f
12073	2	2741	1	create new	english	t	7	f
11706	4	2650	1	dossiers versionnés ne peuvent pas être supprimés!	francais	t	13	f
11710	4	2651	1	dossiers verrouillés ne peuvent pas être supprimés!	francais	t	13	f
11726	4	2655	3	Taille du champ <br> par exemple 255 | 5.2	francais	t	110	f
8180	4	2211	2	attribut	francais	t	0	f
8360	4	2256	2	arguments	francais	t	0	f
8364	4	2257	2	construction de formule (SQL)	francais	t	0	f
10510	4	2351	2	Contenu du document	francais	t	0	f
7613	4	2033	3	Si le nombre indiqué de liens et des champs sélectionner plusieurs recalculé?	francais	t	154	f
11730	4	2656	3	requête de sélection	francais	t	140	f
11734	4	2657	3	la création de requête	francais	t	140	f
11738	4	2658	3	ajouter	francais	t	140	f
11742	4	2659	3	supprimer la requête	francais	t	140	f
11746	4	2660	3	content	francais	t	173	f
11762	4	2664	3	utiliser id [série]	francais	t	140	f
11766	4	2665	3	utiliser le tableau [séquence]	francais	t	140	f
11770	4	2666	3	découper	francais	t	173	f
11774	4	2667	3	insérer	francais	t	173	f
7796	3	2115	2	Diagramme	Espagñol	t	\N	f
7800	3	2116	2	Diagramme	Espagñol	t	\N	f
7804	3	2117	2	Diagramm	Espagñol	t	\N	f
7808	3	2118	2	Diagramm	Espagñol	t	\N	f
11778	4	2668	2	montrer les champs	francais	t	0	f
11782	4	2669	2	montrer les champs	francais	t	0	f
7836	3	2125	2	verstecke gesperrte Daten	Espagñol	t	\N	f
7840	3	2126	2	verstecke gesperrte Datensätze	Espagñol	t	\N	f
11786	4	2670	2	changement de lot	francais	t	0	f
11790	4	2671	2	changement de lot	francais	t	0	f
7872	3	2134	2	versionieren	Espagñol	t	\N	f
7876	3	2135	2	neue Datensatzversion	Espagñol	t	\N	f
7880	3	2136	2	alle auswählen	Espagñol	t	\N	f
7884	3	2137	2	alle Datensätze auswählen	Espagñol	t	\N	f
11818	4	2678	1	kein Feld ausgewählt	francais	t	230	f
11794	4	2672	3	changement de lot	francais	t	110	f
7896	3	2140	2	zeige Versionen	Espagñol	t	\N	f
7900	3	2141	2	zeige versionierte Datensätze	Espagñol	t	\N	f
11798	4	2673	1	remplacer par	francais	t	230	f
11810	4	2676	1	Nombre de dossiers concernés	francais	t	230	f
8036	4	2175	2	Version Commentaires 	francais	t	0	f
11806	4	2675	1	Pour modifier un lot changer le contenu du champ? L'action ne peut pas être annulée!	francais	t	230	t
11814	4	2677	1	champ affecté	francais	t	230	f
11822	4	2679	2	nouvelle fenêtre	francais	t	0	f
11826	4	2680	2	nouvelle fenêtre	francais	t	0	f
11838	4	2683	1	inégal	francais	t	19	f
7976	3	2160	2	workflow	Espagñol	t	\N	f
7980	3	2161	2	workflow	Espagñol	t	\N	f
7984	3	2162	2	Versionen	Espagñol	t	\N	f
7988	3	2163	2	Versionen vergleichen	Espagñol	t	\N	f
7996	3	2165	2	Symbolleiste	Espagñol	t	\N	f
8000	3	2166	2	zeige Symbolleiste	Espagñol	t	\N	f
8008	3	2168	2	suchen	Espagñol	t	\N	f
8012	3	2169	2	Suchmenü	Espagñol	t	\N	f
8016	3	2170	2	zeige Versionsstand	Espagñol	t	\N	f
8020	3	2171	2	zeige Versionsstand eines Datums	Espagñol	t	\N	f
11842	4	2684	1	enregistrements modifiés	francais	t	230	f
11846	4	2685	3	standard	francais	t	140	f
11850	4	2686	3	Pas assez de réponses	francais	t	140	f
11854	4	2687	3	aucun calcul	francais	t	140	f
11858	4	2688	3	numéro de résultat	francais	t	140	f
11862	4	2689	3	champs de table d'édition	francais	t	140	f
8056	3	2180	2	zeige verknüpfte	Espagñol	t	\N	f
8060	3	2181	2	zeige verknüpfte Datensätze	Espagñol	t	\N	f
10934	4	2457	3	mode	francais	t	168	f
11874	4	2692	3	écrire	francais	t	168	f
11882	4	2694	3	Si tous les fichiers temporaires, sont effacés?	francais	t	154	f
11878	4	2693	1	Sténographie dans la recherche rapide	francais	t	19	f
11290	4	2546	3	Supprimer les vignettes temporaires	francais	t	154	f
11302	4	2549	3	toutes les vignettes ont échoué devraient essayer de recalcule?	francais	t	154	f
11886	4	2695	3	Supprimer des fichiers texte temporaires	francais	t	154	f
11294	4	2547	3	Recalculer Échec miniatures	francais	t	154	f
11894	4	2697	3	Si la structure du dossier de cohérence est? utilisateur manquants ou dossiers rapports sont reconstruits.	francais	t	154	f
11898	4	2698	3	rotation	francais	t	168	f
11902	4	2699	3	non publié	francais	t	140	f
8132	3	2199	2	Zusammenfassung	Espagñol	t	\N	f
8136	3	2200	2	Zusammenfassung	Espagñol	t	\N	f
8140	3	2201	2	Berichte	Espagñol	t	\N	f
8144	3	2202	2	Berichte	Espagñol	t	\N	f
8148	3	2203	2	myLimbas	Espagñol	t	\N	f
8152	3	2204	2	Persöhnliche Daten	Espagñol	t	\N	f
11750	4	2661	3	cadre de regroupement	francais	t	175	f
11994	4	2722	1	Que manque index Limbasspezifische sont reconstruits?	francais	t	154	f
11718	4	2653	3	Si les procédures de base de données Limbasspezifischen recréés?	francais	t	154	f
3591	3	923	3	descripción	Espagñol	t	110	f
11674	4	2642	2	sélection de couleurs	francais	t	0	f
11758	4	2663	3	Sollen die Limbasspezifischen Sequenz-Tabellen neu erstellt werden?	francais	t	154	f
11714	4	2652	3	Les procédures de vérification	francais	t	154	f
11754	4	2662	3	Vérifiez séquences	francais	t	154	f
11998	4	2723	3	inceste	francais	t	195	f
8204	3	2217	2	zu Favoriten	Espagñol	t	\N	f
8208	3	2218	2	zu Favoriten hinzufügen	Espagñol	t	\N	f
12002	4	2724	3	Contraintes uniques	francais	t	195	f
12038	4	2733	1	Masquer la colonne	francais	t	5	f
8220	3	2221	2	System Arrays	Espagñol	t	\N	f
8224	3	2222	2	System Arrays	Espagñol	t	\N	f
8228	3	2223	2	Datei suchen	Espagñol	t	\N	f
8232	3	2224	2	Datei suchen	Espagñol	t	\N	f
12102	4	2748	2	Définir des droits de tableau	francais	t	0	f
12110	4	2750	2	Définir des droits de workflow	francais	t	0	f
12198	4	2772	2	Gérer la piscine de sélection	francais	t	0	f
12206	4	2774	2	Terminserie	francais	t	0	f
12294	4	2796	1	prendre en charge et à proximité	francais	t	13	f
12298	4	2797	2	Importation de fichiers	francais	t	0	f
12306	4	2799	1	début	francais	t	200	f
12430	4	2830	3	l'envoi automatique active / sauvegarde du formulaire en arrière-plan en cas de changement des dossiers	francais	t	140	f
12406	4	2824	3	En général, pour mettre en évidence ou le marquage des dossiers individuels avec des couleurs ou des symboles. appel de fonction prévue.	francais	t	140	f
12434	4	2831	3	active le déroulement des liens ou des groupes dans la liste des enregistrements	francais	t	140	f
12398	4	2822	3	Type de versioning. <br> <b> recursiv: </ b> toutes les versions 1: n des liens si versioning activement <br> <b> Correction: </ b> versionné que l'enregistrement en cours	francais	t	140	f
12482	4	2843	3	Champ peut être représenté dans la liste des tables Groupés	francais	t	110	f
11956	1	2713	3	Tabellenreiter	deutsch	t	173	f
12470	4	2840	3	l'envoi automatique active / magasin le champ de formulaire en arrière-plan lors d'un changement.	francais	t	110	f
11912	1	2702	3	Datum+Zeit+Sec	deutsch	t	110	f
12486	4	2844	3	active le changement empilement / collecte pour ce champ	francais	t	110	f
12514	4	2851	3	la définition d'une ressource source pour la représentation de Gantt. Attendu n: m relation	francais	t	140	f
11662	4	2639	3	Recherche ajax	francais	t	110	f
8312	3	2244	2	Übersicht	Espagñol	t	\N	f
8316	3	2245	2	Userübersicht	Espagñol	t	\N	f
8320	3	2246	2	Menü links	Espagñol	t	\N	f
8324	3	2247	2	Menü links	Espagñol	t	\N	f
8328	3	2248	2	Menü oben	Espagñol	t	\N	f
8332	3	2249	2	Menü oben	Espagñol	t	\N	f
8336	3	2250	2	Menü rechts	Espagñol	t	\N	f
8340	3	2251	2	Menü rechts	Espagñol	t	\N	f
8344	3	2252	2	Introseite	Espagñol	t	\N	f
8348	3	2253	2	Introseite	Espagñol	t	\N	f
8352	3	2254	2	Auswahl	Espagñol	t	\N	f
8356	3	2255	2	Kalender Auswahl	Espagñol	t	\N	f
8368	3	2258	2	Bildvorschau	Espagñol	t	\N	f
8372	3	2259	2	Bildvorschau	Espagñol	t	\N	f
8376	3	2260	2	Bildershow	Espagñol	t	\N	f
8380	3	2261	2	Bildershow	Espagñol	t	\N	f
12518	4	2852	3	paramètres spécifiques au calendrier	francais	t	140	f
8388	3	2263	2	Sprache	Espagñol	t	\N	f
12490	4	2845	3	recherche de sélection basée sur AJAX à la place du champ déroulant	francais	t	110	f
12494	4	2846	3	Représentation du lien comme un champ de sélection	francais	t	110	f
8392	3	2264	2	Lokale Sprachtabelle	Espagñol	t	\N	f
10147	3	2265	2	Trigger	Espagñol	t	\N	f
10152	3	2266	2	Datenbank Trigger	Espagñol	t	\N	f
12502	4	2848	3	<B> Kurtz forme: </ b> affichage numérique Shorter <br> <b> détaillée: </ b> affichage de toutes les valeurs séparées par des coups de séparateur	francais	t	110	f
12506	4	2849	3	Isolateur pour la présentation détaillée	francais	t	110	f
12474	4	2841	3	Afficher en champ de sélection dans le <b> Tableau barre de recherche </ b>	francais	t	110	f
12546	4	2859	3	export Sync	francais	t	145	f
12658	4	2887	3	valeur show	francais	t	177	f
12662	4	2888	3	montrer le pourcentage	francais	t	177	f
12666	4	2889	3	Pie-rayon	francais	t	177	f
12674	4	2891	3	propriété	francais	t	177	f
12682	4	2893	3	réglage	francais	t	177	f
12730	4	2905	2	Mimetypes	francais	t	0	f
12734	4	2906	2	Mimetypes	francais	t	0	f
12738	4	2907	2	Révision-Manager	francais	t	0	f
12742	4	2908	2	Révision-Manager	francais	t	0	f
3402	3	729	2	nueva presentación / fichero de reserva	Espagñol	t	0	f
3415	3	744	1	el valor introducido no tiene el formato necesario/por favor corregir su entrada	Espagñol	t	37	t
3716	3	1048	3	desea borrar todas las sesiones/todas las sesiones fueron reiniciadas	Espagñol	t	154	t
3834	3	1168	3	no se encontró el archivo/por favor indicar la ruta correcta	Espagñol	t	172	t
2872	3	128	1	no se encontró el archivo/especificar la ruta correcta del archivo	Espagñol	t	41	t
3082	3	349	2	generar	Espagñol	t	0	f
3083	3	350	2	generar registro	Espagñol	t	0	f
3084	3	351	2	editar	Espagñol	t	0	f
3099	3	366	2	lista de registro	Espagñol	t	0	f
3085	3	352	2	editar registro	Espagñol	t	0	f
3495	3	826	2	informes	Espagñol	t	0	f
3496	3	827	2	informes	Espagñol	t	0	f
5629	3	1938	2	Suchmaschienen-Ansicht	Espagñol	t	\N	f
4681	3	1622	2	Dateien	Espagñol	t	\N	f
3394	3	721	1	este registro está provisto de una función para una nueva presentación /fichero de reserva/¿debe ser cancelado?	Espagñol	t	13	t
3570	3	902	3	foto	Espagñol	t	127	f
3247	3	550	3	borrar todo	Espagñol	t	108	f
3829	3	1163	3	acciones	Espagñol	t	170	f
3292	3	606	3	ya existe	Espagñol	t	126	f
3586	3	918	3	con lo cual ID significa número de artículo	Espagñol	t	107	f
3801	3	1135	3	reconfigurar	Espagñol	t	168	f
4918	3	1701	2	änderungen Speichern	Espagñol	t	\N	f
2820	3	51	1	¿debe ser el informe impreso y por consiguiente archivado?	Espagñol	t	13	f
2858	3	114	1	no puede realizar esta acción	Espagñol	t	23	f
1857	2	730	2	mark as reminder	english	t	0	f
1856	2	729	2	Reminder	english	t	0	f
1587	2	425	2	Reminder	english	t	0	f
11521	2	2604	3	Relation-table	english	t	110	f
11321	2	2554	3	Relation-tab	english	t	173	f
10541	2	2359	1	Do you want to delete the relation of this file?	english	t	13	f
10537	2	2358	1	unlink relation	english	t	13	f
10357	2	2315	2	Relation-mode	english	t	0	f
2499	2	1289	2	automatically adjust table size 	english	t	\N	f
8191	2	2214	3	A positve relation already exists for this field.\nThis action uses the existing relation negative.\nExisting Links will be deleted. 	english	t	121	t
8083	2	2187	1	Detach relations of selected records?	english	t	5	f
8075	2	2185	1	Relations detached!	english	t	25	f
8071	2	2184	1	Relation detached!	english	t	25	f
2061	2	939	3	relations in	english	t	139	f
1954	2	831	2	trace relation	english	t	0	f
11904	1	2700	3	Kalender-Einstellungen	deutsch	t	164	f
5914	2	2033	3	Do you want to recalculate the displayed number of relations and multiple choice fields? 	english	t	154	f
11905	2	2700	3	Calender settings	english	t	164	f
1588	2	426	2	personal reminder	english	t	0	f
4195	2	1460	3	relation	english	t	140	f
5476	2	1887	3	amount of relations	english	t	110	f
11009	2	2476	3	Check  foreign keys for relations	english	t	154	f
7520	4	1940	2	Fuseau horraire	francais	t	0	f
5635	3	1940	2	Zeitzone	Espagñol	t	\N	f
7521	4	1941	2	Changer de fuseau horraire	francais	t	0	f
5638	3	1941	2	Zeitzone ändern	Espagñol	t	\N	f
11889	2	2696	3	Do you want to create new LIMBAS specific trigger?	english	t	154	f
11917	2	2703	3	Lock data record 	english	t	140	f
11914	4	2702	3	Date + heure + Sec	francais	t	110	f
11916	1	2703	3	reserviere ID	deutsch	t	140	f
11918	4	2703	3	ID de réserve	francais	t	140	f
11924	1	2705	1	Ganztags	deutsch	t	52	f
11926	4	2705	1	À plein temps	francais	t	52	f
11936	1	2708	3	Position	deutsch	t	173	f
11938	4	2708	3	Position	francais	t	173	f
11940	1	2709	3	erster	deutsch	t	173	f
11942	4	2709	3	premier	francais	t	173	f
11944	1	2710	3	merken	deutsch	t	173	f
11946	4	2710	3	ne pas oublier	francais	t	173	f
11952	1	2712	3	Click Event für Formularreiter<br>z.B. alert(''hallo'');	deutsch	t	110	f
10988	1	2471	2	Sonderfunktionen	deutsch	t	0	f
10992	1	2472	2	Sonderfunktionen	deutsch	t	0	f
11954	4	2712	3	<br> cliquez sur l'événement pour former les coureurs comme alert ( '' bonjour '');	francais	t	110	f
10408	1	2328	3	sollen alle Usereinstellungen gelöscht werden?	deutsch	t	154	f
11978	4	2718	3	icône	francais	t	204	f
11976	1	2718	3	Symbol	deutsch	t	204	f
11986	4	2720	3	disparaître	francais	t	204	f
11890	4	2696	3	Si le déclencheur Limbasspezifischen recréée?	francais	t	154	f
11984	1	2720	3	Ausblenden	deutsch	t	204	f
11925	2	2705	1	Full-time	english	t	52	f
11010	4	2476	3	Vérifiez les clés étrangères	francais	t	154	f
11316	1	2553	3	alle vorhandenen datensatz-spezifischen Rechte der ausgewählten Tablle werden gelöscht!	deutsch	t	154	t
11012	1	2477	3	Sollen die Limbasspezifischen Foreign-Keys erneuert werden?	deutsch	t	154	f
11014	4	2477	3	Si les clés étrangères Limbasspezifischen à la retraite?	francais	t	154	f
11058	4	2488	3	déclencheur Vérifier	francais	t	154	f
11013	2	2477	3	Do you wnat to renew the LIMBAS specific  foreign keys?	english	t	154	f
11937	2	2708	3	Position	english	t	173	f
11941	2	2709	3	First	english	t	173	f
11957	2	2713	3	Tab	english	t	173	f
10409	2	2328	3	Shall all user settings for the file system be deleted?	english	t	154	f
11977	2	2718	3	Icon	english	t	204	f
11985	2	2720	3	Hide	english	t	204	f
11988	1	2721	3	Indizes prüfen	deutsch	t	154	f
11990	4	2721	3	Vérifiez les index	francais	t	154	f
11992	1	2722	1	Sollen fehlende Limbasspezifische Indizes neu erstellt werden ?	deutsch	t	154	f
11716	1	2653	3	Sollen die Limbasspezifischen Datenbankprozeduren neu erstellt werden?	deutsch	t	154	f
11756	1	2663	3	Sollen die Limbasspezifischen Sequenz-Tabellen neu erstellt werden?	deutsch	t	154	t
11712	1	2652	3	Prozeduren prüfen	deutsch	t	154	f
11752	1	2662	3	Sequenzen prüfen	deutsch	t	154	f
12017	2	2728	3	Ref. field	english	t	195	f
7877	1	2136	2	alle auswählen	deutsch	t	\N	f
7881	1	2137	2	alle Datensätze auswählen	deutsch	t	\N	f
6944	4	1318	1	Les données n''ont pas encore été modifiées! Un enregistrement vide n''est pas conseillé.	francais	t	13	t
11996	1	2723	3	Indizes	deutsch	t	195	f
12000	1	2724	3	Unique Constraints	deutsch	t	195	f
12004	1	2725	3	Foreign Keys	deutsch	t	195	f
12006	4	2725	3	Clés étrangères	francais	t	195	f
12014	4	2727	3	Réf. Tabelle	francais	t	195	f
12012	1	2727	3	Ref. Tabelle	deutsch	t	195	f
12018	4	2728	3	Ref sur le terrain.	francais	t	195	f
11913	2	2702	3	Date+Time+Sec	english	t	110	f
12016	1	2728	3	Ref. Feld	deutsch	t	195	f
11436	1	2583	2	Erweiterungen	deutsch	t	0	f
11440	1	2584	2	Erweiterungen editieren	deutsch	t	0	f
12022	4	2729	3	Clés primaires	francais	t	195	f
12020	1	2729	3	Primary Keys	deutsch	t	195	f
12030	4	2731	3	Agregatfunktion	francais	t	110	f
12028	1	2731	3	Agregatfunktion	deutsch	t	110	f
12034	4	2732	3	Calculer le nombre de lignes affichées dans le format sélectionné	francais	t	110	f
12032	1	2732	3	Berechnen der angezeigten Zeilen im ausgewählten Format	deutsch	t	110	f
861	1	861	1	aufsteigend sortieren	deutsch	t	5	f
6531	4	861	1	En avant	francais	t	5	f
3530	3	861	1	hacia arriba	Espagñol	t	5	f
862	1	862	1	absteigend sortieren	deutsch	t	5	f
3531	3	862	1	hacia abajo	Espagñol	t	5	f
12036	1	2733	1	Spalte ausblenden	deutsch	t	5	f
11713	2	2652	3	Check database procedures	english	t	154	f
12289	2	2795	3	options	english	t	221	f
11717	2	2653	3	Do you want to create new LIMBAS specific data base procedures ?	english	t	154	f
11753	2	2662	3	Check database sequences	english	t	154	f
12089	2	2745	2	form rules	english	t	0	f
11757	2	2663	3	Do you want to create new LIMBAS specific  sequence tables ?	english	t	154	f
11989	2	2721	3	Check indexing	english	t	154	f
11993	2	2722	1	Do you want to create new LIMBAS specific Indices?	english	t	154	f
11997	2	2723	3	Indices	english	t	195	f
12001	2	2724	3	Unique Constraints	english	t	195	f
12005	2	2725	3	Foreign Keys	english	t	195	f
12021	2	2729	3	Primary Keys	english	t	195	f
12029	2	2731	3	Agregatfunction	english	t	110	f
12033	2	2732	3	Calculate the listed rows in the choosen format	english	t	110	f
12037	2	2733	1	Hide column	english	t	5	f
4297	2	1494	3	subscript	english	t	168	f
1472	2	294	1	colour	english	t	86	f
11945	2	2710	3	remember	english	t	173	f
11953	2	2712	3	Click event for form-tabulator<br>e.g. alert(''hello'')	english	t	110	f
1471	2	293	1	cw	english	t	86	f
1518	2	350	2	create record	english	t	0	f
1546	2	380	2	Admin settings	english	t	0	f
1554	2	388	2	user profil	english	t	0	f
1567	2	401	2	reset selection	english	t	0	f
1568	2	402	2	reset selection and filter	english	t	0	f
12237	2	2782	3	coordinates	english	t	169	f
1570	2	404	2	general user settings	english	t	0	f
1573	2	409	2	colours	english	t	0	f
1574	2	410	2	user colour-selection	english	t	0	f
1584	2	422	2	search message	english	t	0	f
1589	2	427	2	template	english	t	0	f
1591	2	429	2	create user	english	t	0	f
1592	2	430	2	create user	english	t	0	f
1607	2	445	2	system	english	t	0	f
1608	2	446	2	system tools	english	t	0	f
1616	2	458	2	edit tables 	english	t	0	f
1650	2	498	2	define table-settings	english	t	0	f
1654	2	502	2	SQL Editor	english	t	0	f
1713	2	563	3	created 	english	t	115	f
1755	2	616	3	max. number of hits	english	t	127	f
1762	2	623	3	colourscheme	english	t	127	f
2765	2	1422	2	pull	english	t	\N	f
1889	2	764	1	This record was deleted or you rights  for this datarecord are expired.	english	t	23	f
1912	2	789	2	forward message	english	t	0	f
1935	2	812	1	personal files	english	t	3	f
1938	2	815	2	upload file	english	t	0	f
501	1	501	2	SQL Editor	deutsch	t	\N	f
1941	2	818	2	copy file/folder	english	t	0	f
1942	2	819	2	cut	english	t	0	f
1943	2	820	2	move file/folder	english	t	0	f
1944	2	821	1	Do wou want to delete this folder and its content?	english	t	68	f
1945	2	822	1	Do wou want to delete this file/folder?	english	t	66	f
1996	2	873	1	Sunday	english	t	41	f
1997	2	874	1	Monday	english	t	41	f
1998	2	875	1	Tuesday	english	t	41	f
1999	2	876	1	Wednesday	english	t	41	f
2000	2	877	1	Thursday	english	t	41	f
2001	2	878	1	Friday	english	t	41	f
2002	2	879	1	Saturday	english	t	41	f
2003	2	880	1	January	english	t	41	f
2004	2	881	1	February	english	t	41	f
2005	2	882	1	March	english	t	41	f
2006	2	883	1	April	english	t	41	f
2007	2	884	1	May	english	t	41	f
2008	2	885	1	June	english	t	41	f
2009	2	886	1	July	english	t	41	f
2010	2	887	1	August	english	t	41	f
2011	2	888	1	September	english	t	41	f
2012	2	889	1	Cctober	english	t	41	f
2013	2	890	1	November	english	t	41	f
2014	2	891	1	Decemberr	english	t	41	f
2021	2	899	3	Do you want to delete the session of this user?	english	t	127	f
2027	2	905	3	Reset table rights	english	t	127	f
2029	2	907	3	Reset menu	english	t	127	f
2030	2	908	3	Do you want to  delete this user?	english	t	132	f
2050	2	928	3	default value	english	t	110	f
2046	2	924	3	subject	english	t	110	f
2092	2	970	3	export finished  successfully	english	t	145	f
2125	2	1003	3	attach	english	t	148	f
2158	2	1036	3	structure	english	t	150	f
2159	2	1037	3	structure and data	english	t	150	f
2161	2	1039	3	existing	english	t	151	f
2179	2	1057	3	delete all sessions	english	t	154	f
2193	2	1071	3	Table successfully deleted.	english	t	156	f
2194	2	1072	3	Table not successfully deleted.	english	t	156	f
2195	2	1073	3	SQL-query successfully executed	english	t	156	f
2245	2	1123	3	normal	english	t	168	f
2265	2	1143	3	margins (mm)	english	t	169	f
4513	2	1566	1	Colour depth	english	t	15	f
2289	2	1167	3	picture couldn´t be saved successfully	english	t	172	f
2355	2	1217	3	to do	english	t	180	f
2359	2	1219	3	general	english	t	180	f
2423	2	1251	1	Do you want to logout?	english	t	11	f
2429	2	1254	3	Do you want to delete the group and all subgroups? User of these groups can be assigned to other groups with [show deleted Users]	english	t	115	t
2449	2	1264	3	This function checks all table rights if they are present!\nExisting rights will not been overwritten.	english	t	154	t
4864	2	1683	1	File already exists!	english	t	66	f
2451	2	1265	3	This function checks all menu rights if they are present!\nExisting rights will not been overwritten.	english	t	154	t
2453	2	1266	2	monitoring	english	t	\N	f
2455	2	1267	2	user monitoring	english	t	\N	f
2457	2	1268	2	table rights	english	t	\N	f
2459	2	1269	2	table rigths update	english	t	\N	f
2461	2	1270	2	menu rights\n	english	t	\N	f
2463	2	1271	2	menu rights update	english	t	\N	f
2473	2	1276	2	table detail	english	t	\N	f
2475	2	1277	2	table settings	english	t	\N	f
2485	2	1282	2	link record	english	t	\N	f
2483	2	1281	2	link	english	t	\N	f
2489	2	1284	2	delete link	english	t	\N	f
2493	2	1286	2	windows view	english	t	\N	f
2495	2	1287	2	adjust border size and style	english	t	\N	f
2497	2	1288	2	default width	english	t	\N	f
12217	2	2777	3	embedding	english	t	169	f
2501	2	1290	2	edit list	english	t	\N	f
2503	2	1291	2	edit list	english	t	\N	f
2509	2	1294	1	to first page	english	t	5	f
2511	2	1295	1	to last page	english	t	5	f
2234	2	1112	3	header	english	t	168	f
1522	2	354	2	edit table	english	t	0	f
2235	2	1113	3	footer	english	t	168	f
2513	2	1296	1	one page back	english	t	5	f
2515	2	1297	1	one page forward	english	t	5	f
2517	2	1298	1	open link	english	t	15	f
2519	2	1299	1	create link	english	t	15	f
2521	2	1300	3	allow password change	english	t	127	f
2523	2	1301	2	link editor	english	t	\N	f
2525	2	1302	2	link editor	english	t	\N	f
2533	2	1306	2	archive record	english	t	\N	f
2535	2	1307	2	show archived 	english	t	\N	f
2537	2	1308	2	show archived records	english	t	\N	f
2559	2	1319	2	upload editor	english	t	\N	f
2561	2	1320	2	upload editor	english	t	\N	f
2565	2	1322	1	file path	english	t	186	f
2583	2	1331	1	select all	english	t	14	f
2587	2	1333	1	add with value	english	t	14	f
2589	2	1334	1	substract from value	english	t	14	f
2597	2	1338	1	replace with date	english	t	14	f
2599	2	1339	1	add day	english	t	14	f
2601	2	1340	1	substract day	english	t	14	f
2671	2	1375	2	PHP Argument	english	t	0	f
12382	4	2818	3	Système	francais	t	165	f
2735	2	1407	2	choice (Select)	english	t	0	f
2737	2	1408	2	choice (multiple) as multiselect	english	t	0	f
2725	2	1402	2	keyword 18 digit number	english	t	0	f
2757	2	1418	2	select field system-user/-group	english	t	0	f
2759	2	1419	2	textarea memo	english	t	0	f
2767	2	1423	2	check for new messages	english	t	\N	f
4114	2	1433	3	monitor	english	t	182	f
4138	2	1441	1	appointement	english	t	192	f
4141	2	1442	1	hollidays	english	t	192	f
4144	2	1443	1	volour:	english	t	192	f
4147	2	1444	1	reminder:	english	t	192	f
4156	2	1447	1	subject:	english	t	192	f
4159	2	1448	1	content:	english	t	192	f
4162	2	1449	1	type:	english	t	192	f
4227	2	1471	2	delete file/folder 	english	t	\N	f
4231	2	1472	1	No files found	english	t	66	f
4245	2	1477	2	delete message 	english	t	\N	f
4258	2	1481	3	incl. user directory	english	t	127	f
4261	2	1482	2	multiple choice field as checkbox list	english	t	0	f
4264	2	1483	2	multiple choice field as list	english	t	0	f
4267	2	1484	2	multiple choice field as radio button	english	t	0	f
4288	2	1491	3	align middle	english	t	168	f
4303	2	1496	3	top of the font line	english	t	168	f
4308	2	1498	2	report archive	english	t	\N	f
4311	2	1499	2	report archive	english	t	\N	f
4314	2	1500	2	preview	english	t	\N	f
4317	2	1501	2	report preview	english	t	\N	f
4320	2	1502	2	print report	english	t	\N	f
4323	2	1503	2	print report	english	t	\N	f
4333	2	1506	1	yes	english	t	15	f
4336	2	1507	1	no	english	t	15	f
4342	2	1509	1	Input missing for the following fields!	english	t	13	f
4354	2	1513	3	delete group 	english	t	116	f
4356	2	1514	2	field type	english	t	\N	f
4359	2	1515	2	table field type	english	t	\N	f
4372	2	1519	3	file type	english	t	160	f
4393	2	1526	1	show list	english	t	13	f
4438	2	1541	3	border colour	english	t	168	f
4447	2	1544	1	display metadata	english	t	15	f
4450	2	1545	1	modify metadata	english	t	15	f
4560	2	1582	2	System jobs	english	t	\N	f
4563	2	1583	2	System jobs (indexation / OCR)	english	t	\N	f
4566	2	1584	2	Periodically	english	t	\N	f
4569	2	1585	2	Periodically executuion	english	t	\N	f
4581	2	1589	2	Job-History	english	t	\N	f
4618	2	1601	1	colour	english	t	140	f
4650	2	1612	2	download file	english	t	\N	f
4653	2	1613	2	download file/archive	english	t	\N	f
4657	2	1614	3	Default	english	t	122	f
4662	2	1616	2	insert file/folder	english	t	\N	f
4668	2	1618	2	define file rights	english	t	\N	f
4677	2	1621	2	files	english	t	\N	f
4698	2	1628	2	load file	english	t	\N	f
4701	2	1629	2	load file	english	t	\N	f
4741	2	1642	3	creator	english	t	52	f
4750	2	1645	3	Document keywords, several separated by comma 	english	t	52	f
4792	2	1659	3	Source of this document 	english	t	52	f
4873	2	1686	3	User directory could not be deleted.   	english	t	29	f
4876	2	1687	3	show  deleted user	english	t	132	f
4879	2	1688	1	file locked!	english	t	66	f
4894	2	1693	1	edit	english	t	66	f
4906	2	1697	1	This folder is a system folder. You can use it only for  tables, reports or messages.	english	t	66	f
4911	2	1699	2	copy message	english	t	\N	f
12052	1	2736	3	von Tabelle	deutsch	t	168	f
4942	2	1709	1	Do you want  to delete the content of the this folder?	english	t	66	f
4945	2	1710	1	upload denied . no permission	english	t	66	f
4300	2	1495	3	superscript\n	english	t	168	f
4950	2	1712	2	mark mesasge	english	t	\N	f
4969	2	1718	3	Should the whole index be deleted for this field!	english	t	110	f
4986	2	1724	2	refresh thumbnails	english	t	\N	f
4989	2	1725	2	refresh preview	english	t	\N	f
4996	2	1727	3	delete all	english	t	127	f
4999	2	1728	3	activate user	english	t	132	f
12053	2	2736	3	from Table	english	t	168	f
5014	2	1733	1	No record selected	english	t	5	f
5019	2	1735	2	new window	english	t	\N	f
5071	2	1752	3	City	english	t	52	f
5091	2	1759	2	convert into	english	t	\N	f
5094	2	1760	2	convert file	english	t	\N	f
5124	2	1770	2	edit long field	english	t	\N	f
5121	2	1769	2	edit mode	english	t	\N	f
5155	2	1780	3	action	english	t	127	f
5160	2	1782	2	comparison	english	t	\N	f
5163	2	1783	2	compare data records	english	t	\N	f
5179	2	1788	1	report	english	t	5	f
5182	2	1789	3	show atcive users	english	t	132	f
5185	2	1790	3	show all users	english	t	132	f
5188	2	1791	3	statistics	english	t	132	f
5191	2	1792	3	modified	english	t	132	f
5194	2	1793	3	show disabled users	english	t	132	f
5409	2	1865	2	periodically excecution	english	t	\N	f
5464	2	1883	3	currency	english	t	110	f
5487	2	1891	2	reset surch criterias	english	t	\N	f
5490	2	1892	2	reset surch criterias	english	t	\N	f
12365	2	2814	3	short form	english	t	139	f
5518	2	1901	1	The metadata were not successfully read.	english	t	41	f
5524	2	1903	1	complete sentence	english	t	66	f
5521	2	1902	1	case sensitive	english	t	66	f
5527	2	1904	1	part of the word	english	t	66	f
5539	2	1908	3	search only in metadata	english	t	52	f
5542	2	1909	1	Preview not possible for this  file type 	english	t	66	f
5562	2	1916	2	display fields	english	t	\N	f
5565	2	1917	2	selection of displayed fields	english	t	\N	f
5574	2	1920	2	save folder view 	english	t	\N	f
5577	2	1921	2	save current folder settings	english	t	\N	f
5580	2	1922	2	save view	english	t	\N	f
5583	2	1923	2	save view for all folders	english	t	\N	f
5656	2	1947	3	Text input field	english	t	175	f
5659	2	1948	3	Textarea input filed	english	t	175	f
5761	2	1982	1	Days	english	t	13	f
5809	2	1998	1	save as	english	t	5	f
5875	2	2020	3	convert field	english	t	110	f
5878	2	2021	3	In case the content is  too long or the wrong type it be cut or deleted!	english	t	110	f
5905	2	2030	3	Refresh temporary content	english	t	154	f
6040	2	2075	3	Hour	english	t	212	f
6055	2	2080	3	file structure	english	t	212	f
7667	2	2083	1	 No data records selected!	english	t	5	f
7919	2	2146	1	Do you want to versionise this record?	english	t	13	f
7947	2	2153	1	Do you want to delete the selected records?	english	t	5	f
7951	2	2154	1	Do you want to archive the selected records?	english	t	5	f
7955	2	2155	1	Do you want to versionise the selcted records?	english	t	5	f
7959	2	2156	1	Do you want to copy  the selcted records?	english	t	5	f
7963	2	2157	1	Do you want to restore the selcted records?	english	t	5	f
7994	2	2165	2	toolbar	english	t	\N	f
7998	2	2166	2	show toolbar	english	t	\N	f
8003	2	2167	1	show toolbar	english	t	46	f
8018	2	2171	2	show the version for a specific date	english	t	\N	f
8218	2	2221	2	Arrays	english	t	\N	f
8226	2	2223	2	search file	english	t	\N	f
8318	2	2246	2	Menu left	english	t	\N	f
8322	2	2247	2	Menu left	english	t	\N	f
10233	2	2284	3	Do you want to delete the report?	english	t	170	f
10237	2	2285	3	Do you want to  delete the diagram?	english	t	177	f
10241	2	2286	3	Do you want to delete the tablegroup including all tables?	english	t	140	f
10245	2	2287	3	Do you want to delete the table?	english	t	140	f
10285	2	2297	3	create  folder	english	t	213	f
10281	2	2296	3	add files	english	t	213	f
10277	2	2295	3	see files	english	t	213	f
10289	2	2298	3	delete Files/Folders	english	t	213	f
10293	2	2299	3	edit Metadata	english	t	213	f
10297	2	2300	3	lock files?	english	t	213	f
10325	2	2307	2	toolbar	english	t	0	f
10329	2	2308	2	show  toolbar	english	t	0	f
10833	2	2432	2	unlock record	english	t	0	f
11277	2	2543	3	new tabletree	english	t	207	f
11857	2	2688	3	number of hits	english	t	140	f
11877	2	2693	1	Spelling in quicksearch	english	t	19	f
12648	1	2885	3	Pie-Chart	deutsch	t	177	f
11893	2	2697	3	You want to check the filesystem for missing folders?Missing folders will be created.	english	t	154	f
2557	2	1318	1	Data not yet changed!\nEmpty record creation is not recommended. 	english	t	13	t
4516	2	1567	1	Colour	english	t	15	f
2873	3	129	1	el archivo cargado tiene un tamaño de	Espagñol	t	41	f
2527	2	1303	3	create new relation!	english	t	121	f
12042	4	2370	3	devrait rester à l'arrière-lien?	francais	t	121	f
12046	4	2734	3	Auswahlpools neu sortieren	francais	t	154	f
12096	1	2747	2	Diagrammrechte	deutsch	t	0	f
12100	1	2748	2	Diagrammrechte festlegen	deutsch	t	0	f
12080	1	2743	2	Wiedervorlagen	deutsch	t	0	f
12084	1	2744	2	Wiedervorlagen-Rechte festlegen	deutsch	t	0	f
12050	4	2735	3	style cellulaire	francais	t	168	f
12040	1	2370	3	soll die rückwärtige Verknüpfung bestehen bleiben?	deutsch	t	121	f
12054	4	2736	3	table	francais	t	168	f
12044	1	2734	3	Auswahlpools neu sortieren	deutsch	t	154	f
12048	1	2735	3	Zellenstyle	deutsch	t	168	f
12062	4	2738	2	resoumission	francais	t	0	f
12066	4	2739	2	resoumission	francais	t	0	f
12106	4	2749	2	droits de flux de travail	francais	t	0	f
12070	4	2740	3	nouvelle resoumission	francais	t	187	f
12074	4	2741	1	Créer un nouveau	francais	t	7	f
12068	1	2740	3	neue Wiedervorlage	deutsch	t	187	f
12078	4	2742	3	par groupe	francais	t	187	f
12072	1	2741	1	neu anlegen	deutsch	t	7	f
12069	2	2740	3	new reminder	english	t	187	f
12065	2	2739	2	reminder	english	t	0	f
12061	2	2738	2	reminder	english	t	0	f
12049	2	2735	3	cellstyle	english	t	168	f
12045	2	2734	3	sort pools values	english	t	154	f
12041	2	2370	3	Should the backward relation remain? 	english	t	121	f
12082	4	2743	2	resoumissions	francais	t	0	f
12076	1	2742	3	Gruppenbasiert	deutsch	t	187	f
12086	4	2744	2	Définir les droits des rappels	francais	t	0	f
12090	4	2745	2	droits de formulaire	francais	t	0	f
12094	4	2746	2	Définir des droits de formulaire	francais	t	0	f
12098	4	2747	2	droit diagramme	francais	t	0	f
12104	1	2749	2	Workflowrechte	deutsch	t	0	f
12108	1	2750	2	Workflowrechte festlegen	deutsch	t	0	f
12060	1	2738	2	Wiedervorlage	deutsch	t	0	f
12064	1	2739	2	Wiedervorlage	deutsch	t	0	f
12088	1	2745	2	Formularrechte	deutsch	t	0	f
11805	2	2675	1	You want to change content with a batch process? you can''t undo the changes!	english	t	230	t
12092	1	2746	2	Formularrechte festlegen	deutsch	t	0	f
12114	4	2751	3	Créer sauvegarde	francais	t	140	f
12112	1	2751	3	starte Backup	deutsch	t	140	f
12118	4	2752	3	nouveau flux de travail	francais	t	208	f
12116	1	2752	3	neuer Workflow	deutsch	t	208	f
12126	4	2754	3	nouvelle tâche	francais	t	208	f
12124	1	2754	3	neuer Task	deutsch	t	208	f
1169	1	1169	3	Detail-Formular	deutsch	t	175	f
6813	4	1169	3	Formulaire	francais	t	175	f
3835	3	1169	3	formulario	Espagñol	t	175	f
12134	4	2756	3	Formulaire de liste	francais	t	175	f
12132	1	2756	3	Listen-Formular	deutsch	t	175	f
12136	1	2757	3	Radius	deutsch	t	168	f
12138	4	2757	3	rayon	francais	t	168	f
12142	4	2758	3	Créer un fichier	francais	t	213	f
12140	1	2758	3	Datei erstellen	deutsch	t	213	f
8124	4	2197	2	mimetype	francais	t	0	f
1161	1	1161	3	Office Template	deutsch	t	170	f
6806	4	1161	3	Créer par	francais	t	170	f
8118	1	2196	2	Mimetype	deutsch	t	0	f
12150	4	2760	3	Lorsque vous modifiez la version existante des informations versioning seront supprimés!	francais	t	140	f
12154	4	2761	3	synchroniser	francais	t	139	f
12148	1	2760	3	Bei Änderung der Versionierung werden vorhandene Versionsinformationen gelöscht!	deutsch	t	140	f
12152	1	2761	3	synchronisieren	deutsch	t	139	f
12158	4	2762	1	maintenant	francais	t	204	f
12172	1	2766	1	vor	deutsch	t	204	f
1848	2	721	1	This record has a reminder. Do you want to cancel the reminder. 	english	t	13	t
2283	2	1161	3	Office Template 	english	t	170	f
2291	2	1169	3	Detail-formular	english	t	175	f
2405	2	1242	1	User	english	t	20	f
4222	2	1469	1	Groups	english	t	20	f
12077	2	2742	3	groupbased	english	t	187	f
12081	2	2743	2	Reminder	english	t	0	f
12085	2	2744	2	set reminder rules	english	t	0	f
12093	2	2746	2	set form rules	english	t	0	f
12097	2	2747	2	diagram rules	english	t	0	f
12101	2	2748	2	set diagram rules	english	t	0	f
12105	2	2749	2	workflow rules	english	t	0	f
12109	2	2750	2	set workflow rules	english	t	0	f
12113	2	2751	3	starting backup	english	t	140	f
12117	2	2752	3	new workflow	english	t	208	f
12125	2	2754	3	new task	english	t	208	f
12133	2	2756	3	list-formular	english	t	175	f
12137	2	2757	3	radius	english	t	168	f
12141	2	2758	3	create file	english	t	213	f
12149	2	2760	3	changing versioning will delete existing version-informations!	english	t	140	f
12153	2	2761	3	synchronize	english	t	139	f
8119	2	2196	2	Mimetype 	english	t	0	f
8123	2	2197	2	Mimetype 	english	t	0	f
12156	1	2762	1	jetzt	deutsch	t	204	f
12174	4	2766	1	avant	francais	t	204	f
12157	2	2762	1	now	english	t	204	f
12173	2	2766	1	bevore	english	t	204	f
12189	2	2770	3	max. results	english	t	155	f
12190	4	2770	3	max. résultats	francais	t	155	f
12194	4	2771	2	Piscine de sélection	francais	t	0	f
12188	1	2770	3	max. Ergebnisse	deutsch	t	155	f
12193	2	2771	2	select-pools	english	t	0	f
12197	2	2772	2	administrate select-pools	english	t	0	f
12210	4	2775	2	Création d'un rendez-vous périodique	francais	t	0	f
12266	4	2789	1	par an	francais	t	200	f
12264	1	2789	1	Jährlich	deutsch	t	200	f
12270	4	2790	1	2 fois par semaine	francais	t	200	f
12268	1	2790	1	2 mal in der Woche	deutsch	t	200	f
4984	2	1723	3	Date+Time	english	t	110	f
11373	2	2567	3	background colour column	english	t	221	f
10420	1	2331	3	Parameter	deutsch	t	168	f
10422	4	2331	3	Paramètre	francais	t	168	f
8038	1	2176	2	Versionierung-Zusatzbemerkung	deutsch	t	0	f
11588	1	2621	3	Verknüpfung entfernen	deutsch	t	226	f
11590	4	2621	3	Supprimer le lien	francais	t	226	f
12566	4	2864	3	transposée	francais	t	177	f
12214	4	2776	1	Si tout lien ce jeu de données à supprimer?	francais	t	204	f
12218	4	2777	3	Embed	francais	t	169	f
12212	1	2776	1	Sollen alle Verknüpfung dieses Datensatzes entfernt werden?	deutsch	t	204	t
12222	4	2778	3	pendre	francais	t	169	f
12216	1	2777	3	einbetten	deutsch	t	169	f
12226	4	2779	3	sous rapport	francais	t	169	f
12220	1	2778	3	einhängen	deutsch	t	169	f
12230	4	2780	3	Boîte à outils	francais	t	169	f
12224	1	2779	3	Unterbericht	deutsch	t	169	f
12228	1	2780	3	Toolbox	deutsch	t	169	f
12238	4	2782	3	Les coordonnées	francais	t	169	f
12242	4	2783	3	éléments	francais	t	169	f
12236	1	2782	3	Koordinaten	deutsch	t	169	f
12240	1	2783	3	Elemente	deutsch	t	169	f
12254	4	2786	1	tous les jours	francais	t	200	f
12205	2	2774	2	ecurring appointment	english	t	0	f
12548	1	2860	3	Sync Import	deutsch	t	145	f
12209	2	2775	2	add ecurring appointments	english	t	0	f
12213	2	2776	1	do you want to drop all relations from this dataset?	english	t	204	f
12221	2	2778	3	attaching	english	t	169	f
12225	2	2779	3	subreport	english	t	169	f
12229	2	2780	3	toolbox	english	t	169	f
12241	2	2783	3	elements	english	t	169	f
10421	2	2331	3	parameters 	english	t	168	f
8039	2	2176	2	Versioning add-on remark 	english	t	0	f
11589	2	2621	3	remove relation 	english	t	226	f
2487	2	1283	2	delete link 	english	t	\N	f
12258	4	2787	1	hebdomadaire	francais	t	200	f
12252	1	2786	1	Täglich	deutsch	t	200	f
12262	4	2788	1	mensuel	francais	t	200	f
12256	1	2787	1	Wöchentlich	deutsch	t	200	f
12274	4	2791	3	répétition	francais	t	52	f
12260	1	2788	1	Monatlich	deutsch	t	200	f
12272	1	2791	3	Wiederholung	deutsch	t	52	f
12278	4	2792	3	La répétition se termine	francais	t	52	f
12276	1	2792	3	Wiederholung endet am	deutsch	t	52	f
1137	1	1137	3	Bericht	deutsch	t	169	f
6782	4	1137	3	Rapport	francais	t	169	f
3803	3	1137	3	informe	Espagñol	t	169	f
12284	1	2794	1	Achtung! Rekursives Löschen versionierter oder verknüpfter Datensätze\\\\\\\\\\\\\\\\nwurde aktiviert!	deutsch	t	17	t
10980	1	2469	2	rekursives Löschen	deutsch	t	0	f
10984	1	2470	2	rekursives Löschen von Verknüpfungen & Versionen	deutsch	t	0	f
12286	4	2794	1	Attention! Suppression récursive dossiers versionnés ou liés \\\\\\\\\\\\\\\\ Nhas activé!	francais	t	17	f
12290	4	2795	3	Options	francais	t	221	f
12288	1	2795	3	Optionen	deutsch	t	221	f
12302	4	2798	2	Importer	francais	t	0	f
12292	1	2796	1	übernehmen und schließen	deutsch	t	13	f
12253	2	2786	1	daily	english	t	200	f
12257	2	2787	1	weekly	english	t	200	f
12261	2	2788	1	monthly	english	t	200	f
12265	2	2789	1	yearly	english	t	200	f
12304	1	2799	1	Beginn	deutsch	t	200	f
12314	4	2801	1	Durée / Période	francais	t	200	f
12312	1	2801	1	Dauer/Periode	deutsch	t	200	f
12318	4	2802	1	Seriendauer	francais	t	200	f
12316	1	2802	1	Seriendauer	deutsch	t	200	f
12322	4	2803	1	série Muster	francais	t	200	f
12320	1	2803	1	Serienmuster	deutsch	t	200	f
12332	1	2806	3	angezeigte Felder in der Verknüpfungs-Schnellsuche / Verknüpungs-Auswahl	deutsch	t	121	f
12334	4	2806	3	Les champs affichés dans le lien Recherche / sélection Verknüpungs rapide	francais	t	121	f
2524	1	1302	2	Verknüpfungseditor	deutsch	t	\N	f
12346	4	2809	3	lié paramétrisation	francais	t	121	f
12344	1	2809	3	Verknüpfungs Parametrisierung	deutsch	t	121	f
12354	4	2811	3	Description de	francais	t	110	f
12352	1	2811	3	aus Beschreibung	deutsch	t	110	f
5871	1	2019	3	soll das Feld gelöscht werden?	deutsch	t	110	f
7599	4	2019	3	Supprimer le champs:	francais	t	110	f
12358	4	2812	3	Voir la liste	francais	t	139	f
12362	4	2813	3	séparateur de liste	francais	t	139	f
12356	1	2812	3	Listendarstellung	deutsch	t	139	f
12366	4	2814	3	la forme abrégée	francais	t	139	f
12360	1	2813	3	Listentrenner	deutsch	t	139	f
12370	4	2815	3	en détails	francais	t	139	f
12364	1	2814	3	Kurzform	deutsch	t	139	f
12342	4	2808	3	avec OU champs à rechercher dans la table de liens	francais	t	121	f
12368	1	2815	3	Ausführlich	deutsch	t	139	f
5292	1	1826	3	durchsucht	deutsch	t	121	f
7410	4	1826	3	Champs de recherche	francais	t	121	f
12378	4	2817	3	taille de bloc	francais	t	139	f
12340	1	2808	3	mit ODER zu durchsuchende Felder in der Verknüpfungstabelle	deutsch	t	121	f
12369	2	2815	3	in detail	english	t	139	f
12361	2	2813	3	list-delimiter	english	t	139	f
12345	2	2809	3	link parametrisation	english	t	121	f
12277	2	2792	3	repetition expires at	english	t	52	f
12317	2	2802	1	duration of series	english	t	200	f
12333	2	2806	3	displayed fields in link-fast-search / link-selection	english	t	121	f
12341	2	2808	3	fields in link table that shall be searched using OR	english	t	121	f
12269	2	2790	1	2 times a week	english	t	200	f
12273	2	2791	3	repetition	english	t	52	f
12285	2	2794	1	Attention! Recursive deletion of out-of-date or linked data sets was enabled!	english	t	17	f
12293	2	2796	1	accept and close	english	t	13	f
12297	2	2797	2	import	english	t	0	f
12301	2	2798	2	import	english	t	0	f
12305	2	2799	1	start	english	t	200	f
12376	1	2817	3	Blockgröße	deutsch	t	139	f
12386	4	2819	3	ImageMagick	francais	t	165	f
12390	4	2820	3	Ghostscript	francais	t	165	f
12394	4	2821	1	Détails suppressives	francais	t	5	f
12380	1	2818	3	System	deutsch	t	165	f
12422	4	2828	3	active la coloration d'enregistrements de données individuels gruppenzpezifische	francais	t	140	f
12384	1	2819	3	ImageMagick	deutsch	t	165	f
12388	1	2820	3	ghostscript	deutsch	t	165	f
4401	1	1529	1	Details in neuem Tab	deutsch	t	5	f
7140	4	1529	1	Editer	francais	t	5	f
12392	1	2821	1	unterdrücke Details	deutsch	t	5	f
8349	1	2254	2	Suchleiste	deutsch	t	\N	f
8353	1	2255	2	Suchleiste einblenden	deutsch	t	\N	f
12204	1	2774	2	Terminserie	deutsch	t	0	f
12208	1	2775	2	Terminserie anlegen	deutsch	t	0	f
12428	1	2830	3	aktiviert das automatische senden / speichern des Formulars im Hintergrund bei Änderung an Datensätzen	deutsch	t	140	f
12420	1	2828	3	aktiviert die gruppenzpezifische Färbung einzelner Datensätze	deutsch	t	140	f
5633	1	1940	2	Ansicht	deutsch	t	\N	f
5636	1	1941	2	Ansicht anpassen	deutsch	t	\N	f
12404	1	2824	3	Regel zur Hervorhebung oder Markierung einzelner Datensätze mit Farben oder Symbolen. Erwartet Funktionsaufruf.	deutsch	t	140	f
12440	1	2833	3	physischer Tabellenname	deutsch	t	140	f
3907	3	1244	1	horizontal	Espagñol	t	5	f
12442	4	2833	3	nom de la table physique	francais	t	140	f
12509	2	2850	3	resource	english	t	140	f
12436	1	2832	3	aktiviert das Anlegen eines Datensatzes ohne vergebene ID. Neue Datensätze werden erst nach ''Übernehmen'' angelegt.	deutsch	t	140	f
12412	1	2826	3	aktiviert das Logging aller Änderungen eines Datensatzes	deutsch	t	140	f
12438	4	2832	3	a permis la création d'un ensemble de données sans ID affecté. De nouveaux records sont « créées après » « Appliquer ».	francais	t	140	f
12416	1	2827	3	aktiviert das userspezifische Sperren einzelner Datensätze	deutsch	t	140	f
12414	4	2826	3	l'enregistrement de toutes les modifications activé un enregistrement	francais	t	140	f
12424	1	2829	3	aktiviert die gruppen/userspezifische Berechtigung einzelner Datensätze	deutsch	t	140	f
12418	4	2827	3	active le blocage spécifique à l'utilisateur des enregistrements individuels	francais	t	140	f
12426	4	2829	3	les groupes / active utilisateur autorisation spécifique des dossiers individuels	francais	t	140	f
12402	4	2823	3	Calculer le résultat alternatif défini <br> <b> par défaut :. </ B> select count (*) <br> <b> Pas assez de réponses: </ b> odbc_fetch_row	francais	t	140	f
12400	1	2823	3	Berechnung der alternativen Ergebnismenge.<br><b>standart:</b> select count(*)<br><b>wenig Ergebnisse:</b> odbc_fetch_row	deutsch	t	140	f
12446	4	2834	3	Nom de la table dépendant de la langue	francais	t	140	f
12444	1	2834	3	Sprachabhängige Tabellenbezeichnung	deutsch	t	140	f
12454	4	2836	3	Infos	francais	t	140	f
12452	1	2836	3	Infos	deutsch	t	140	f
12458	4	2837	3	champ signifiante du record de définition unique	francais	t	110	f
12456	1	2837	3	Aussagekräftiges Feld des Datensatzes zur eindeutigen Bestimmung	deutsch	t	110	f
12462	4	2838	3	Le champs a un indice de base de données	francais	t	110	f
12460	1	2838	3	Feld besitzt einen Datenbankindex	deutsch	t	110	f
12466	4	2839	3	Le champ est clairement	francais	t	110	f
12464	1	2839	3	Feld ist eindeutig	deutsch	t	110	f
12385	2	2819	3	ImageMagick	english	t	165	f
12498	4	2847	3	Représentation du lien que la recherche de sélection basée sur AJAX (uniquement en combinaison avec « » Sélectionnez Recherche « »)	francais	t	110	f
12377	2	2817	3	blocksize 	english	t	139	f
12381	2	2818	3	system	english	t	165	f
12453	2	2836	3	information	english	t	140	f
12465	2	2839	3	field is unique	english	t	110	f
12393	2	2821	1	suppressed details	english	t	5	f
12445	2	2834	3	language dependent table description	english	t	140	f
12461	2	2838	3	field has a database index	english	t	110	f
12405	2	2824	3	Rule for highlighting or marking single records using colors or symbols. Expects function-call.	english	t	140	f
12441	2	2833	3	physical tablename	english	t	140	f
12417	2	2827	3	activates user-specific locking of single records	english	t	140	f
12421	2	2828	3	activates group-specific coloring of single records	english	t	140	f
12401	2	2823	3	Calculation of alternative result set.<br><b>standard:</b> select count(*)<br><b>few results:</b> orbc_fetch_row	english	t	140	f
12468	1	2840	3	aktiviert das automatische senden / speichern des Formularfeldes im Hintergrund bei Änderung.	deutsch	t	110	f
12432	1	2831	3	aktiviert das Aufklappen von Verknüpfungen oder Gruppierungen in der Datensatzliste	deutsch	t	140	f
12408	1	2825	3	aktiviert ausgewählte Trigger	deutsch	t	140	f
12410	4	2825	3	activé déclenchement sélectionné	francais	t	140	f
12396	1	2822	3	Art der Versionierung. <br><b>recursiv:</b> versioniert alle 1:n Verknüpfungen falls ebenfalls Versionierung aktiv<br><b>Fix:</b> versioniert nur den aktuellen Datensatz	deutsch	t	140	f
12480	1	2843	3	Feld kann in der Tabellenliste Gruppiert dargestellt werden	deutsch	t	110	f
11660	1	2639	3	Ajaxsuche	deutsch	t	110	f
12484	1	2844	3	aktiviert die Stapel / Sammeländerung für dieses Feld	deutsch	t	110	f
12512	1	2851	3	definiert eine Resourcen Quelle für Gantt Darstellung. Erwartet n:m Beziehung	deutsch	t	140	f
12516	1	2852	3	Kalender spezifische Einstellungen	deutsch	t	140	f
12488	1	2845	3	AJAX basierte Auswahlsuche anstelle des dropdown Feldes	deutsch	t	110	f
12492	1	2846	3	Darstellung der Verknüpfung als Auswahlfeld	deutsch	t	110	f
12496	1	2847	3	Darstellung der Verknüpfung als AJAX basierte Auswahlsuche (nur in Kombination mit ''Auswahlsuche'')	deutsch	t	110	f
12500	1	2848	3	<b>Kurtzform: </b>Verkürzte numerische Anzeige<br><b>Ausführlich: </b>Darstellung aller Werte durch Listentrenner getrennt	deutsch	t	110	f
12504	1	2849	3	Trenner für ausführliche Darstellung	deutsch	t	110	f
12472	1	2841	3	Darstellung als Auswahlfeld in der <b>Tabellensuchleiste</b>	deutsch	t	110	f
12476	1	2842	3	aktiviert eine AJAX basierte Auswahlsuche in der <b>Tabellensuchleiste</b>	deutsch	t	110	f
12600	1	2873	3	Abstand links	deutsch	t	177	f
12478	4	2842	3	activé une recherche de sélection basée sur AJAX dans le tableau Recherche <b> bar </ b>	francais	t	110	f
12510	4	2850	3	Ressource	francais	t	140	f
12508	1	2850	3	Ressource	deutsch	t	140	f
12522	4	2853	1	ordre du jour	francais	t	200	f
12520	1	2853	1	Agenda	deutsch	t	200	f
12526	4	2854	1	gantt	francais	t	200	f
12524	1	2854	1	Gantt	deutsch	t	200	f
8166	1	2208	3	Projekt-Import	deutsch	t	148	f
8168	4	2208	3	projet d'importation	francais	t	148	f
12534	4	2856	3	Devrait être créé pour le lien existant d'une table croisée View? Les liens existants seront effacés.	francais	t	121	f
12532	1	2856	3	Soll für die vorhandene Verknüpfung ein tabellenübergreifendes View erstellt werden?\nVorhandene Verknüpfungen werden gelöscht.	deutsch	t	121	t
12528	1	2855	3	Tabellenübergreifende Verknüpfung: (nur lesend)	deutsch	t	121	f
12530	4	2855	3	Table de liaison: (lecture seule)	francais	t	121	f
12536	1	2857	3	Filter Optionen für Auswahlpool<br>z.B. $extension[''where''] = " keywords like ''%fish%'' "; return $extension;	deutsch	t	110	f
12538	4	2857	3	Les options de filtrage pour la sélection Pool | $ Extension [ '' où ''] = "mots-clés tels que '' %% de poissons « ; return $ prolongation;	francais	t	110	f
11482	4	2594	3	piscine	francais	t	110	f
11480	1	2594	3	Pool	deutsch	t	110	f
11665	2	2640	3	ajaxpost 	english	t	110	f
2259	2	1137	3	report 	english	t	169	f
12409	2	2825	3	activates selected triggers	english	t	140	f
12513	2	2851	3	defines resource for gantt-view. Expects n:m-link	english	t	140	f
12517	2	2852	3	calendar-specific settings	english	t	140	f
12469	2	2840	3	activates automated sending / saving of form field after changes	english	t	110	f
12397	2	2822	3	type of version control. <br><b>recursive:</b> version controls all 1:n-links if version control was activated<br><b>set:</b> version controls only current record	english	t	140	f
12473	2	2841	3	Display as select field in <b>table search bar</b>	english	t	110	f
12477	2	2842	3	activates AJAX-based selection search in <b>table search bar</b>	english	t	110	f
12485	2	2844	3	activates stack/collective modification for this field	english	t	110	f
12433	2	2831	3	activates opening links or groups in the record set	english	t	140	f
12501	2	2848	3	<b>Shortform: </b>Shortened numerical display<br><b>Detailed: </b>DIsplay of all values, separated by list-delimiters	english	t	110	f
2739	2	1409	2	Selection (multiple, new window)	english	t	0	f
4402	2	1529	1	details in new tab	english	t	5	f
5293	2	1826	3	searched	english	t	121	f
5872	2	2019	3	delete field?	english	t	110	f
7691	2	2089	3	search result	english	t	121	f
8167	2	2208	3	project import	english	t	148	f
11481	2	2594	3	pool	english	t	110	f
11661	2	2639	3	ajaxsearch 	english	t	110	f
12313	2	2801	1	duration/period	english	t	200	f
12357	2	2812	3	listview	english	t	139	f
12389	2	2820	3	ghostscript	english	t	165	f
12413	2	2826	3	activates logging of all changes of a record	english	t	140	f
12521	2	2853	1	agenda	english	t	200	f
12525	2	2854	1	gantt	english	t	200	f
12321	2	2803	1	series pattern	english	t	200	f
12353	2	2811	3	from description	english	t	110	f
12457	2	2837	3	Significant field of record for unambiguously identifiation	english	t	110	f
12481	2	2843	3	Field may be displayed grouped in table list	english	t	110	f
12489	2	2845	3	AJAX-based selectionsearch instead of dropdown field	english	t	110	f
12493	2	2846	3	Display of the link as selection field	english	t	110	f
12497	2	2847	3	Display of the link as AJAX-based selectionsearch (only in combination with "selectionsearch")	english	t	110	f
12505	2	2849	3	Delimiter for detailed display	english	t	110	f
12656	1	2887	3	zeige Wert	deutsch	t	177	f
12537	2	2857	3	Filter-settings for selectionpool<br>e.g. $extension["where"] = " keywords like "%fish$" "; return $extension;	english	t	110	f
12425	2	2829	3	activates group-/user-specific right of single records	english	t	140	f
12429	2	2830	3	activates automated sending / saving of the form after changes on records	english	t	140	f
12437	2	2832	3	activates creation of a record without assigned ID. New records will not be created until submitting.	english	t	140	f
12529	2	2855	3	cross-table link: (read only)	english	t	121	f
12533	2	2856	3	Shall a cross-table view be created for the existing link? Existing links will be deleted.	english	t	121	f
2668	1	1374	2	Upload	deutsch	t	0	f
12545	2	2859	3	Sync export	english	t	145	f
2740	1	1410	2	Datei Upload mit Vorschau	deutsch	t	0	f
7033	4	1410	2	Fichier - Upload	francais	t	0	f
2669	2	1374	2	Upload 	english	t	0	f
2741	2	1410	2	file upload with preview	english	t	0	f
12544	1	2859	3	Sync Export	deutsch	t	145	f
12550	4	2860	3	importation Sync	francais	t	145	f
12576	1	2867	3	Achse	deutsch	t	177	f
11784	1	2670	2	Stapeländerung	deutsch	t	0	f
11788	1	2671	2	Stapeländerung	deutsch	t	0	f
12554	4	2861	3	largeur de la cellule	francais	t	168	f
12552	1	2861	3	Zellenbreite	deutsch	t	168	f
7942	1	2152	1	Fehler bei Versionierung! Nur aktuelle Datensätze können versioniert werden!	deutsch	t	25	f
7944	4	2152	1	Erreur versioning! Seuls les enregistrements actuels peuvent être versionnées!	francais	t	25	f
12558	4	2862	3	Créer une nouvelle EXIF &#8203;&#8203;du fichier de configuration	francais	t	154	f
12556	1	2862	3	EXIF Konfigurationsdatei neu erstellen	deutsch	t	154	f
12562	4	2863	3	type de graphique	francais	t	177	f
12560	1	2863	3	Diagramm-Typ	deutsch	t	177	f
12564	1	2864	3	Transponiert	deutsch	t	177	f
12578	4	2867	3	axe	francais	t	177	f
12596	1	2872	3	Schriftgröße	deutsch	t	177	f
12598	4	2872	3	taille de la police	francais	t	177	f
12602	4	2873	3	distance par rapport à la gauche	francais	t	177	f
12604	1	2874	3	Abstand oben	deutsch	t	177	f
12606	4	2874	3	espace au-dessus	francais	t	177	f
12608	1	2875	3	Abstand rechts	deutsch	t	177	f
12610	4	2875	3	droit à distance	francais	t	177	f
12612	1	2876	3	Abstand unten	deutsch	t	177	f
12614	4	2876	3	L'espace ci-dessous	francais	t	177	f
12616	1	2877	3	Text X-Achse	deutsch	t	177	f
12618	4	2877	3	Texte axe X	francais	t	177	f
12620	1	2878	3	Text Y-Achse	deutsch	t	177	f
12622	4	2878	3	Texte axe Y	francais	t	177	f
12624	1	2879	3	Legende x	deutsch	t	177	f
12626	4	2879	3	légende x	francais	t	177	f
12628	1	2880	3	Legende y	deutsch	t	177	f
12630	4	2880	3	légende y	francais	t	177	f
12632	1	2881	3	Legende	deutsch	t	177	f
12634	4	2881	3	légende	francais	t	177	f
12636	1	2882	3	verbergen	deutsch	t	177	f
12638	4	2882	3	cacher	francais	t	177	f
12650	4	2885	3	Graphique circulaire	francais	t	177	f
12652	1	2886	3	keine Beschriftung	deutsch	t	177	f
12654	4	2886	3	pas d'étiquette	francais	t	177	f
12660	1	2888	3	zeige Prozentwert	deutsch	t	177	f
12664	1	2889	3	Pie-Radius	deutsch	t	177	f
12672	1	2891	3	Eigenschaft	deutsch	t	177	f
12680	1	2893	3	Anpassung	deutsch	t	177	f
4739	3	1642	3	autor	Espagñol	t	52	f
3908	3	1245	1	vertical	Espagñol	t	5	f
12561	2	2863	3	diagram type	english	t	177	f
12565	2	2864	3	transposed	english	t	177	f
12577	2	2867	3	axis	english	t	177	f
12597	2	2872	3	font size	english	t	177	f
12601	2	2873	3	padding left	english	t	177	f
12605	2	2874	3	padding top	english	t	177	f
12609	2	2875	3	padding right	english	t	177	f
12613	2	2876	3	padding bottom	english	t	177	f
12617	2	2877	3	text x-axis	english	t	177	f
12621	2	2878	3	text y-axis	english	t	177	f
12625	2	2879	3	legend x	english	t	177	f
12629	2	2880	3	legend y	english	t	177	f
12633	2	2881	3	legend	english	t	177	f
12637	2	2882	3	hide	english	t	177	f
12649	2	2885	3	pie-chart	english	t	177	f
12653	2	2886	3	no description	english	t	177	f
12657	2	2887	3	show value	english	t	177	f
12661	2	2888	3	show percentage value	english	t	177	f
12665	2	2889	3	pie radius	english	t	177	f
12673	2	2891	3	setting	english	t	177	f
12681	2	2893	3	customization	english	t	177	f
12686	4	2894	3	appliquer	francais	t	177	f
12684	1	2894	3	Übernehmen	deutsch	t	177	f
12690	4	2895	3	multilingue	francais	t	110	f
12688	1	2895	3	Mehrsprachig	deutsch	t	110	f
12694	4	2896	3	activé le support linguistique	francais	t	110	f
12692	1	2896	3	aktiviert die Sprachunterstützung	deutsch	t	110	f
12698	4	2897	3	traduire	francais	t	180	f
12696	1	2897	3	übersetzen	deutsch	t	180	f
7943	2	2152	1	Versioning error! Only the currents record can be versionised. 	english	t	25	f
12296	1	2797	2	Datei-Import	deutsch	t	0	f
12300	1	2798	2	Import	deutsch	t	0	f
729	1	729	2	Wiedervorlage	deutsch	t	\N	f
730	1	730	2	Wiedervorlage bearbeiten	deutsch	t	\N	f
12706	4	2899	1	filtre resoumission	francais	t	0	f
12704	1	2899	1	Wiedervorlage filtern	deutsch	t	0	f
12714	4	2901	1	Resoumission/s ajouté avec succès!	francais	t	5	f
12712	1	2901	1	Wiedervorlage/n erfolgreich hinzugefügt!	deutsch	t	5	f
12708	1	2900	1	Wiedervorlage/n erfolgreich gelöscht!	deutsch	t	5	f
12710	4	2900	1	Resoumission/s supprimé avec succès!	francais	t	5	f
12716	1	2902	1	Soll für die ausgewählten Datensätze eine Wiedervorlage erstellt/entfernt werden?	deutsch	t	5	f
12718	4	2902	1	Cible / supprimé créé pour l'enregistrements sélectionnés resoumission?	francais	t	5	f
815	1	815	2	Datei hochladen	deutsch	t	\N	f
816	1	816	2	neue Datei erstellen	deutsch	t	\N	f
12728	1	2905	2	Mimetypes	deutsch	t	0	f
12732	1	2906	2	Mimetypes	deutsch	t	0	f
12685	2	2894	3	save	english	t	177	f
12736	1	2907	2	Revisions-Manager	deutsch	t	0	f
12740	1	2908	2	Revisions Manager	deutsch	t	0	f
1317	2	138	1	please check input	english	t	41	f
1319	2	140	1	userdata 	english	t	46	f
1320	2	141	1	password 	english	t	46	f
1321	2	142	1	first name 	english	t	46	f
1323	2	144	1	email 	english	t	46	f
1325	2	146	1	general settings 	english	t	46	f
1333	2	154	1	Own colour pool 	english	t	47	f
1334	2	155	1	Colour pool 	english	t	47	f
1335	2	156	1	Value 	english	t	47	f
1339	2	160	1	delete 	english	t	49	f
1343	2	164	1	table 	english	t	49	f
1347	2	168	1	field 	english	t	50	f
1374	2	195	1	an error has occurred! 	english	t	54	f
1376	2	197	1	date 	english	t	55	f
1379	2	200	1	new template 	english	t	55	f
1388	2	209	1	filename 	english	t	66	f
1389	2	210	1	size 	english	t	66	f
7923	2	2147	1	Only the current version of the record can be versioned! 	english	t	13	f
12549	2	2860	3	Sync import	english	t	145	f
12553	2	2861	3	cell width	english	t	168	f
12557	2	2862	3	create EXIF config file	english	t	154	f
12689	2	2895	3	multilangual	english	t	110	f
12693	2	2896	3	activate multilangual	english	t	110	f
12697	2	2897	3	translate	english	t	180	f
12705	2	2899	1	filter reminder	english	t	0	f
12709	2	2900	1	reminder successfully deleted	english	t	5	f
12713	2	2901	1	reminder successfully created	english	t	5	f
12717	2	2902	1	do you want to create / delete reminders for selected rows?	english	t	5	t
12729	2	2905	2	mimetypes	english	t	0	f
12701	2	2898	3	Activate / deactivate translation.\\n Creating or deleting fields!	english	t	180	t
12733	2	2906	2	mimetypes	english	t	0	f
6729	4	1084	3	Icone - URL	francais	t	162	f
3750	3	1084	3	ícono URL	Espagñol	t	162	f
2206	2	1084	3	icon	english	t	162	f
12746	4	2909	1	attribué à	francais	t	0	f
459	1	459	2	Fehlerreport	deutsch	t	\N	f
460	1	460	2	Fehler Report	deutsch	t	\N	f
12758	4	2912	3	dépendances	francais	t	110	f
12744	1	2909	1	zugewiesen an	deutsch	t	0	f
12754	4	2911	3	active la suppression automatique et la recréation des requêtes dépendantes.	francais	t	110	f
12762	4	2913	3	dernier	francais	t	139	f
12756	1	2912	3	Abhängigkeiten	deutsch	t	110	f
12752	1	2911	3	aktiviert das automatische Löschen und Wiederanlegen von abhängigen Abfragen. 	deutsch	t	110	f
975	1	975	3	Exportdatei	deutsch	t	145	f
2097	2	975	3	export list	english	t	145	f
6632	4	975	3	Exporter liste	francais	t	145	f
3643	3	975	3	lista de exportación	Espagñol	t	145	f
12760	1	2913	3	letzter	deutsch	t	139	f
10404	1	2327	3	aktualisiere .htaccess .htpasswd	deutsch	t	154	f
5054	3	1747	3	notas	Espagñol	t	52	f
12724	1	2904	2	WEB URL zu Grafik	deutsch	t	0	f
10405	2	2327	3	update .htaccess / ./htpasswd	english	t	154	f
4658	1	1615	2	einfügen	deutsch	t	\N	f
4661	1	1616	2	Dateien/Ordner einfügen	deutsch	t	\N	f
12780	1	2918	3	aufklappen	deutsch	t	110	f
5075	3	1754	3	país	Espagñol	t	52	f
12722	4	2903	2	URL de l'image	francais	t	0	f
12784	1	2919	3	wird in der Tabellendarstellung als aufgeklappt markiert	deutsch	t	110	f
11105	2	2500	2	save settings	english	t	0	f
11101	2	2499	2	reset view-settings	english	t	0	f
10406	4	2327	3	Mise à jour .htaccess / ./htpasswd	francais	t	154	f
4022	3	1359	2	Texto 128	Espagñol	t	0	f
11106	4	2500	2	Enregistrer les paramètres en cours	francais	t	0	f
11102	4	2499	2	Voir Réinitialiser	francais	t	0	f
10403	3	2327	3	Actualizar .htaccess / ./htpasswd	Espagñol	t	154	f
11103	3	2500	2	Guardar configuración actual	Espagñol	t	0	f
4469	3	1552	1	Phys.name	Espagñol	t	15	f
11099	3	2499	2	Restablecer vista	Espagñol	t	0	f
4031	3	1368	2	URL	Espagñol	t	0	f
5996	3	2061	1	Primer registro!	Espagñol	t	23	f
6056	3	2081	3	incl. sub	Espagñol	t	212	f
7661	3	2082	1	Flujo de trabajo se ha iniciado con éxito!	Espagñol	t	5	f
10819	3	2429	2	bloquear	Espagñol	t	0	f
4592	3	1593	3	Restablecer la base de datos !!!	Espagñol	t	154	f
11703	3	2650	1	versionados registros no se pueden borrar!	Espagñol	t	13	f
4009	3	1346	2	diario	Espagñol	t	0	f
11707	3	2651	1	registros bloqueados no se pueden borrar!	Espagñol	t	13	f
11767	3	2666	3	cortar	Espagñol	t	173	f
11879	3	2694	3	Si todos los archivos temporales, se borran?	Espagñol	t	154	f
3434	3	763	1	Este registro está bloqueado y no se puede procesar en este momento!	Espagñol	t	23	f
3947	3	1284	2	Retire enlace	Espagñol	t	0	f
3870	3	1205	3	Estado	Espagñol	t	180	f
3868	3	1203	3	Importación de texto	Espagñol	t	180	f
3882	3	1217	3	abierto	Espagñol	t	180	f
3883	3	1218	3	OK	Espagñol	t	180	f
3884	3	1219	3	en general	Espagñol	t	180	f
3885	3	1220	3	administración	Espagñol	t	180	f
3886	3	1221	3	system	Espagñol	t	180	f
3887	3	1222	3	Sprachauswahl	Espagñol	t	180	f
3895	3	1232	2	curso	Espagñol	t	0	f
3896	3	1233	2	historia	Espagñol	t	0	f
10976	1	2468	2	Kommazahl Float	deutsch	t	0	f
7830	1	2124	2	+xx xx xxxx oder +xx xxxxx	deutsch	t	0	f
2646	1	1363	2	Textblock	deutsch	t	0	f
3903	3	1240	1	incluir subcarpetas	Espagñol	t	20	f
3909	3	1246	1	sin	Espagñol	t	5	f
3912	3	1249	3	finalizar la sesión	Espagñol	t	132	f
3914	3	1251	1	¿Quieres cerrar la sesión?	Espagñol	t	11	f
3920	3	1257	1	archivo	Espagñol	t	122	f
3922	3	1259	1	editar	Espagñol	t	122	f
3927	3	1264	3	Esta función comprueba todos los derechos a la existencia de mesa! los derechos existentes no se sobrescriben	Espagñol	t	154	t
3928	3	1265	3	Esta función comprueba todos los derechos a la existencia de menú! los derechos existentes no se sobrescriben	Espagñol	t	154	t
3929	3	1266	2	monitoreo	Espagñol	t	0	f
3930	3	1267	2	Monitoreo de usuario	Espagñol	t	0	f
3905	3	1242	1	usuario	Espagñol	t	20	f
3931	3	1268	2	los derechos de mesa	Espagñol	t	0	f
3932	3	1269	2	actualización de los derechos de mesa	Espagñol	t	0	f
3933	3	1270	2	derechos de uso	Espagñol	t	0	f
3934	3	1271	2	actualización de los derechos	Espagñol	t	0	f
3939	3	1276	2	detalle del vector	Espagñol	t	0	f
3940	3	1277	2	arreglos de mesa	Espagñol	t	0	f
3944	3	1281	2	enlace	Espagñol	t	0	f
3945	3	1282	2	de datos del enlace	Espagñol	t	0	f
3948	3	1285	1	Registro ya vinculado!	Espagñol	t	27	f
3949	3	1286	2	enmarcado	Espagñol	t	0	f
3950	3	1287	2	Tamaño de bastidor Fit y tipo	Espagñol	t	0	f
3951	3	1288	2	anchura automática	Espagñol	t	0	f
3952	3	1289	2	Ajustar tamaño de la tabla de forma automática	Espagñol	t	0	f
3953	3	1290	2	Editar lista	Espagñol	t	0	f
3954	3	1291	2	Editar lista	Espagñol	t	0	f
3957	3	1294	1	a la primera cara	Espagñol	t	5	f
3958	3	1295	1	la última página	Espagñol	t	5	f
3959	3	1296	1	página anterior	Espagñol	t	5	f
3960	3	1297	1	página siguiente	Espagñol	t	5	f
3961	3	1298	1	abrir el enlace	Espagñol	t	15	f
3962	3	1299	1	enlace de generación	Espagñol	t	15	f
6986	4	1363	2	bloc texte 1000 	francais	t	0	f
7012	4	1389	2	nombre à virgule	francais	t	0	f
10974	4	2467	2	nombres à virgule flottante 	francais	t	0	f
3963	3	1300	3	permitir el cambio de contraseña	Espagñol	t	127	f
3964	3	1301	2	Editor de método abreviado	Espagñol	t	0	f
3965	3	1302	2	Editor de método abreviado	Espagñol	t	0	f
3966	3	1303	3	Introducir nuevos accesos directos!	Espagñol	t	121	f
3967	3	1304	3	neu berechnen!	Espagñol	t	101	f
3968	3	1305	2	archivo	Espagñol	t	0	f
3969	3	1306	2	registro de archivo	Espagñol	t	0	f
3970	3	1307	2	Mostrar archivados	Espagñol	t	0	f
3971	3	1308	2	Mostrar registros archivados	Espagñol	t	0	f
3973	3	1310	2	restaurar los datos	Espagñol	t	0	f
3974	3	1311	1	Se deberá recuperar los datos?	Espagñol	t	13	f
3975	3	1312	1	Registro fue archivada!	Espagñol	t	25	f
3976	3	1313	1	El registro ha sido restaurado!	Espagñol	t	25	f
3978	3	1315	3	Nombre de usuario y la contraseña debe contener al menos 5 caracteres!	Espagñol	t	127	f
3980	3	1317	1	Sin permiso!	Espagñol	t	31	f
3982	3	1319	2	Editor de subida	Espagñol	t	0	f
3983	3	1320	2	Editor de subida	Espagñol	t	0	f
3946	3	1283	2	la eliminación de enlaces	Espagñol	t	0	f
3985	3	1322	1	ruta del archivo	Espagñol	t	186	f
3987	3	1324	1	Lista de archivos de importación!	Espagñol	t	186	f
3988	3	1325	1	Los registros fueron eliminados correctamente! Registros se eliminaron con éxito!	Espagñol	t	25	f
3989	3	1326	1	Los registros fueron achiviert!	Espagñol	t	25	f
3990	3	1327	1	Los registros se han restaurado!	Espagñol	t	25	f
3993	3	1330	1	todas inversa	Espagñol	t	14	f
3994	3	1331	1	Marcar todo	Espagñol	t	14	f
3996	3	1333	1	agregará valor a	Espagñol	t	14	f
5741	3	1976	1	al	Espagñol	t	13	f
3997	3	1334	1	restar valor	Espagñol	t	14	f
4001	3	1338	1	reemplazado por fecha	Espagñol	t	14	f
4002	3	1339	1	agregará días	Espagñol	t	14	f
4003	3	1340	1	restar días	Espagñol	t	14	f
4004	3	1341	1	Cambiar!	Espagñol	t	14	f
4005	3	1342	1	Viendo	Espagñol	t	5	f
4008	3	1345	2	calendario	Espagñol	t	0	f
4017	3	1354	2	Texto 8	Espagñol	t	0	f
4018	3	1355	2	Texto 10	Espagñol	t	0	f
4019	3	1356	2	Texto 20	Espagñol	t	0	f
4020	3	1357	2	Texto 30	Espagñol	t	0	f
4021	3	1358	2	Texto 50	Espagñol	t	0	f
4023	3	1360	2	Texto 160	Espagñol	t	0	f
4034	3	1371	2	Selección (Select)	Espagñol	t	0	f
4038	3	1375	2	PHP-Argumento	Espagñol	t	0	f
5117	3	1768	3	OnChange	Espagñol	t	168	f
4047	3	1384	2	------- Tipo de Campo Estándar -------	Espagñol	t	0	f
4048	3	1385	2	------- Sin-Feldtypen ------- 	Espagñol	t	0	f
4053	3	1390	2	Texto máx. 8 caracteres	Espagñol	t	0	f
4054	3	1391	2	Texto máx. 10 caracteres	Espagñol	t	0	f
4055	3	1392	2	Texto máx. 20 caracteres	Espagñol	t	0	f
4056	3	1393	2	Texto máx. 30 caracteres 	Espagñol	t	0	f
4057	3	1394	2	Texto máx. 50 caracteres	Espagñol	t	0	f
3918	3	1255	3	regla indicador	Espagñol	t	122	f
4058	3	1395	2	Texto máx. 128 caracteres	Espagñol	t	0	f
4059	3	1396	2	Texto máx. 160 caracteres	Espagñol	t	0	f
4067	3	1404	2	URL con máx. 230 caracteres	Espagñol	t	0	f
4068	3	1405	2	Un correo electrónico con máx. 128 caracteres	Espagñol	t	0	f
4070	3	1407	2	Campo de selección (Select)	Espagñol	t	0	f
4074	3	1411	2	constructo Fórmula (eval)	Espagñol	t	0	f
4083	3	1420	1	toda la lista de ignorados!	Espagñol	t	154	f
4085	3	1422	2	recuperar	Espagñol	t	0	f
4086	3	1423	2	Comprobar si hay nuevos mensajes	Espagñol	t	0	f
4106	3	1431	3	registro	Espagñol	t	182	f
4112	3	1433	3	ver	Espagñol	t	182	f
4118	3	1435	1	Etiqueta	Espagñol	t	188	f
4121	3	1436	1	semana	Espagñol	t	188	f
4025	3	1362	2	Bloque de texto 399	Espagñol	t	0	f
4043	3	1380	2	Posfechar	Espagñol	t	0	f
4079	3	1416	2	Erstellungsdatum	Espagñol	t	0	f
4044	3	1381	2	Fecha de edición	Espagñol	t	0	f
4037	3	1374	2	Upload	Espagñol	t	0	f
4080	3	1417	2	fecha de modificación	Espagñol	t	0	f
4061	3	1398	2	bloque de texto con máx. 399 caracteres	Espagñol	t	0	f
4124	3	1437	1	mes	Espagñol	t	188	f
4127	3	1438	1	año	Espagñol	t	188	f
4136	3	1441	1	plazo	Espagñol	t	192	f
4139	3	1442	1	fiesta	Espagñol	t	192	f
4142	3	1443	1	color:	Espagñol	t	192	f
4145	3	1444	1	recordatorio:	Espagñol	t	192	f
4148	3	1445	1	por:	Espagñol	t	192	f
4151	3	1446	1	a:	Espagñol	t	192	f
4154	3	1447	1	Asunto:	Espagñol	t	192	f
4157	3	1448	1	contenido:	Espagñol	t	192	f
4160	3	1449	1	tipo:	Espagñol	t	192	f
4075	3	1412	2	por ejemplo Cliente (1) -> Persona de contacto (s)	Espagñol	t	0	f
4040	3	1377	2	Enlace n:m	Espagñol	t	0	f
4076	3	1413	2	por ejemplo Orden (n) -> punto (m)	Espagñol	t	0	f
4041	3	1378	2	Postusuario	Espagñol	t	0	f
4077	3	1414	2	El usuario que creó el registro	Espagñol	t	0	f
4042	3	1379	2	Editar usuario	Espagñol	t	0	f
4078	3	1415	2	Qué usuario modificada por última vez el registro	Espagñol	t	0	f
4071	3	1408	2	Casilla de verificación (opción múltiple) como MULTISELECT	Espagñol	t	0	f
4045	3	1382	2	Lista de usuario / grupo	Espagñol	t	0	f
4166	3	1451	1	Claro!	Espagñol	t	192	f
4046	3	1383	2	Largo	Espagñol	t	0	f
4060	3	1397	2	Texto	Espagñol	t	0	f
4024	3	1361	2	Texto	Espagñol	t	0	f
4190	3	1459	3	gruppierbar	Espagñol	t	110	f
4193	3	1460	3	agruparse	Espagñol	t	140	f
4202	3	1463	3	proporcional	Espagñol	t	168	f
4205	3	1464	3	copia	Espagñol	t	176	f
4229	3	1472	1	No se han encontrado!	Espagñol	t	66	f
4014	3	1351	2	número (10)	Espagñol	t	0	f
4050	3	1387	2	número entero de 10 dígitos	Espagñol	t	0	f
4256	3	1481	3	incl. directorio de usuarios	Espagñol	t	127	f
4262	3	1483	2	Campo de selección (lista)	Espagñol	t	0	f
4265	3	1484	2	Selección (radio)	Espagñol	t	0	f
4283	3	1490	3	superior al ras	Espagñol	t	168	f
4286	3	1491	3	centro	Espagñol	t	168	f
4259	3	1482	2	Casilla de verificación (opción múltiple) como una lista casilla	Espagñol	t	0	f
4063	3	1400	2	DD.MM.YYYY hh:mm.ss z.B. 05.12.02 z.B.. 5 dez 02 z.B.. 05 Dezember 2 15.10.00	Espagñol	t	0	t
4289	3	1492	3	enrasado abajo	Espagñol	t	168	f
4292	3	1493	3	base	Espagñol	t	168	f
4295	3	1494	3	subíndice	Espagñol	t	168	f
4298	3	1495	3	aumentar	Espagñol	t	168	f
4301	3	1496	3	margen de texto superior	Espagñol	t	168	f
4304	3	1497	3	menor margen de texto	Espagñol	t	168	f
4328	3	1505	3	Java script	Espagñol	t	175	f
4331	3	1506	1	sí	Espagñol	t	15	f
4334	3	1507	1	no	Espagñol	t	15	f
4337	3	1508	3	campo obligatorio	Espagñol	t	122	f
4340	3	1509	1	Los siguientes campos no se han llenado!	Espagñol	t	13	f
4352	3	1513	3	grupo eliminado	Espagñol	t	116	f
4361	3	1516	3	Tipo de campo	Espagñol	t	160	f
4364	3	1517	3	tipo de datos	Espagñol	t	160	f
4367	3	1518	3	funcid	Espagñol	t	160	f
4370	3	1519	3	tipo de datos	Espagñol	t	160	f
4385	3	1524	1	tomar el relevo+invertir	Espagñol	t	13	f
4391	3	1526	1	Mostrar lista	Espagñol	t	13	f
4394	3	1527	1	tomar / aplicarán	Espagñol	t	5	f
4403	3	1530	1	tome + Siguiente	Espagñol	t	13	f
4406	3	1531	1	tomar el relevo+anterior	Espagñol	t	13	f
4409	3	1532	3	desvío	Espagñol	t	127	f
5753	3	1980	1	acta	Espagñol	t	13	f
4415	3	1534	3	tirado a través	Espagñol	t	168	f
4418	3	1535	3	puntos	Espagñol	t	168	f
4421	3	1536	3	discontinua	Espagñol	t	168	f
4424	3	1537	3	dos veces	Espagñol	t	168	f
4427	3	1538	3	interior 3D	Espagñol	t	168	f
4430	3	1539	3	exterior 3D	Espagñol	t	168	f
4433	3	1540	3	especie	Espagñol	t	168	f
4072	3	1409	2	Casilla de verificación (opción múltiple) con una nueva ventana	Espagñol	t	0	f
4400	3	1529	1	Los detalles en nueva pestaña	Espagñol	t	5	f
4436	3	1541	3	color del marco	Espagñol	t	168	f
4445	3	1544	1	metadatos del programa	Espagñol	t	15	f
4448	3	1545	1	cambios en los metadatos	Espagñol	t	15	f
4035	3	1372	2	Selección (selección múltiple)	Espagñol	f	0	f
4493	3	1560	1	abrir la cremallera	Espagñol	t	15	f
4772	3	1653	3	Tipo de documento	Espagñol	t	52	f
4502	3	1563	1	formato	Espagñol	t	15	f
4505	3	1564	1	geometría	Espagñol	t	15	f
4508	3	1565	1	resolución	Espagñol	t	15	f
4511	3	1566	1	profundidad de color	Espagñol	t	15	f
4514	3	1567	1	colores	Espagñol	t	15	f
4526	3	1571	1	reajustar	Espagñol	t	20	f
4535	3	1574	1	La integridad referencial ha sido violada! 	Espagñol	t	25	f
4556	3	1581	3	etiquetado	Espagñol	t	110	f
4583	3	1590	1	indicado	Espagñol	t	15	f
4604	3	1597	1	hablada	Espagñol	t	19	f
4220	3	1469	1	grupos	Espagñol	t	20	f
4613	3	1600	1	repetir contraseña	Espagñol	t	46	f
4616	3	1601	1	color	Espagñol	t	140	f
4637	3	1608	1	Debe asignar un nombre!	Espagñol	t	5	f
4655	3	1614	3	defecto	Espagñol	t	122	f
4663	3	1616	2	Insertar archivos / carpetas	Espagñol	t	\N	f
4688	3	1625	1	vista	Espagñol	t	66	f
4691	3	1626	1	búsqueda	Espagñol	t	66	f
4694	3	1627	1	Notación mal!	Espagñol	t	66	f
4715	3	1634	3	en general	Espagñol	t	52	f
4718	3	1635	3	metadatos	Espagñol	t	52	f
4724	3	1637	3	mimetype	Espagñol	t	52	f
4727	3	1638	3	creado por	Espagñol	t	52	f
4730	3	1639	3	creado en	Espagñol	t	52	f
4733	3	1640	3	titular	Espagñol	t	52	f
4736	3	1641	3	Además del nombre	Espagñol	t	52	f
4742	3	1643	3	El nombre del autor (nombre, apellidos)	Espagñol	t	52	f
4745	3	1644	3	Palabras clave	Espagñol	t	52	f
4748	3	1645	3	Etiquetas en el documento, más separados por comas	Espagñol	t	52	f
4754	3	1647	3	Abstract, descripción del contenido	Espagñol	t	52	f
4757	3	1648	3	editor	Espagñol	t	52	f
4760	3	1649	3	Editores, universidad, etc.	Espagñol	t	52	f
4763	3	1650	3	colaboradores	Espagñol	t	52	f
4766	3	1651	3	Nombrar otra persona involucrada	Espagñol	t	52	f
5048	3	1745	3	origen\r\n	Espagñol	t	52	f
4781	3	1656	3	identificación	Espagñol	t	52	f
4784	3	1657	3	(ISBN, ISSN, URL, etc. relación con este documento. La identificación única	Espagñol	t	52	f
4790	3	1659	3	Plant, impreso o electrónicamente, de la cual los presentes origina documento	Espagñol	t	52	f
4796	3	1661	3	Idioma del contenido del documento	Espagñol	t	52	f
4802	3	1663	3	fuente	Espagñol	t	52	f
4805	3	1664	3	atributos	Espagñol	t	52	f
4808	3	1665	3	probado	Espagñol	t	52	f
4811	3	1666	3	publicado	Espagñol	t	52	f
4814	3	1667	3	formato de gráficos	Espagñol	t	52	f
4817	3	1668	3	minuto	Espagñol	t	52	f
4823	3	1670	3	cerrado	Espagñol	t	52	f
4844	3	1677	3	clasificación	Espagñol	t	52	f
4847	3	1678	3	Anotaciones en el documento, más separados por comas	Espagñol	t	52	f
4850	3	1679	1	copia de	Espagñol	t	66	f
4862	3	1683	1	El archivo ya existe!	Espagñol	t	66	f
4865	3	1684	1	Carpeta ya existe!	Espagñol	t	66	f
4868	3	1685	3	duplicados	Espagñol	t	52	f
4871	3	1686	3	Das Userverzeichniss konnte nicht gelöscht werden!	Espagñol	t	29	f
4874	3	1687	3	Mostrar eliminadas usuarios	Espagñol	t	132	f
4877	3	1688	1	El archivo está bloqueado!	Espagñol	t	66	f
5138	3	1775	3	forma	Espagñol	t	168	f
4889	3	1692	1	Se generó el informe.	Espagñol	t	93	f
5024	3	1737	3	EXIF	Espagñol	t	52	f
4892	3	1693	1	editar	Espagñol	t	66	f
5498	3	1895	3	disposición	Espagñol	t	164	f
4901	3	1696	1	Los mensajes y los archivos no se pueden mezclar!	Espagñol	t	97	f
4904	3	1697	1	Dieser Ordner ist ein Systemordner. Er ist nur in Verbindung mit Tabellen, Berichten oder Nachrichten beschreibbar!	Espagñol	t	66	f
4928	3	1705	1	papeles	Espagñol	t	3	f
4931	3	1706	1	fotos	Espagñol	t	3	f
5861	3	2016	1	sobresalir	Espagñol	t	5	f
4940	3	1709	1	Para borrar todo el contenido de la carpeta?	Espagñol	t	66	f
4943	3	1710	1	Sin el permiso de carga!	Espagñol	t	66	f
4964	3	1717	1	ningún archivo seleccionado!	Espagñol	t	66	f
4970	3	1719	3	Indexada en:	Espagñol	t	52	f
4973	3	1720	3	índice	Espagñol	t	52	f
4976	3	1721	1	usuario:	Espagñol	t	23	f
4979	3	1722	1	el tiempo estimado de tiempo de descanso:	Espagñol	t	23	f
4994	3	1727	3	borrar completamente	Espagñol	t	127	f
4997	3	1728	3	habilitar al usuario	Espagñol	t	132	f
5012	3	1733	1	Ningún registro seleccionado!	Espagñol	t	5	f
5027	3	1738	3	IPTC	Espagñol	t	52	f
5030	3	1739	3	preestreno	Espagñol	t	52	f
5033	3	1740	3	XMP	Espagñol	t	52	f
5036	3	1741	3	descripción	Espagñol	t	52	f
5039	3	1742	3	Palabras clave	Espagñol	t	52	f
5042	3	1743	3	categorías	Espagñol	t	52	f
5045	3	1744	3	derechos de imagen	Espagñol	t	52	f
5051	3	1746	3	derechos de autor	Espagñol	t	52	f
5057	3	1748	3	urgencia	Espagñol	t	52	f
5060	3	1749	3	categoría	Espagñol	t	52	f
5063	3	1750	3	autor	Espagñol	t	52	f
5069	3	1752	3	lugar	Espagñol	t	52	f
5072	3	1753	3	Estado / Provincia	Espagñol	t	52	f
5078	3	1755	3	Aufgeber-Code	Espagñol	t	52	f
5081	3	1756	3	nota	Espagñol	t	52	f
5084	3	1757	3	nombre de la propiedad	Espagñol	t	52	f
5087	3	1758	3	subcategorías	Espagñol	t	52	f
5099	3	1762	1	método	Espagñol	t	66	f
5102	3	1763	3	eventos	Espagñol	t	168	f
5105	3	1764	3	OnClick	Espagñol	t	168	f
5108	3	1765	3	OnDblClick	Espagñol	t	168	f
4991	3	1726	1	Los datos o metadatos del archivo asociado no existe!	Espagñol	t	66	f
5111	3	1766	3	OnMouseOver	Espagñol	t	168	f
5114	3	1767	3	OnMouseOut	Espagñol	t	168	f
5129	3	1772	3	script PHP	Espagñol	t	175	f
5132	3	1773	3	datos Descripción	Espagñol	t	169	f
5135	3	1774	3	cuadro de búsqueda de datos	Espagñol	t	169	f
5141	3	1776	3	visible	Espagñol	t	168	f
5144	3	1777	3	aislado	Espagñol	t	168	f
5147	3	1778	3	desplazable	Espagñol	t	168	f
5150	3	1779	3	log	Espagñol	t	140	f
5153	3	1780	3	acciones	Espagñol	t	127	f
5174	3	1787	1	archivo	Espagñol	t	13	f
5177	3	1788	1	informes	Espagñol	t	5	f
5180	3	1789	3	usuarios activos mostrar	Espagñol	t	132	f
5183	3	1790	3	ver todos los usuarios	Espagñol	t	132	f
5186	3	1791	3	estadística	Espagñol	t	132	f
5189	3	1792	3	cambiado	Espagñol	t	132	f
5192	3	1793	3	Mostrar bloqueado usuarios	Espagñol	t	132	f
5204	3	1797	1	0 (sin registro)	Espagñol	t	127	f
5207	3	1798	1	1 (sólo DB, y acciones)	Espagñol	t	127	f
5210	3	1799	1	2 (registro completo)	Espagñol	t	127	f
5213	3	1800	2	Iniciar sesión	Espagñol	t	182	f
5216	3	1801	2	Cerrar sesión	Espagñol	t	182	f
5219	3	1802	2	IP	Espagñol	t	182	f
5222	3	1803	2	duración	Espagñol	t	182	f
5225	3	1804	2	fecha	Espagñol	t	182	f
5228	3	1805	2	acción	Espagñol	t	182	f
5231	3	1806	2	mesa	Espagñol	t	182	f
5234	3	1807	2	ID	Espagñol	t	182	f
5237	3	1808	2	especie	Espagñol	t	182	f
5240	3	1809	3	menú principal	Espagñol	t	163	f
5243	3	1810	3	Administración	Espagñol	t	163	f
5249	3	1812	3	menú de usuario	Espagñol	t	163	f
5252	3	1813	3	extensiones	Espagñol	t	163	f
5255	3	1814	3	subgrupo	Espagñol	t	162	f
5258	3	1815	3	Ordenar	Espagñol	t	162	f
11735	3	2658	3	anexar	Espagñol	t	140	f
5264	3	1817	3	contraseña caduca	Espagñol	t	127	f
5282	3	1823	3	Generador	Espagñol	t	121	f
5285	3	1824	3	mesa para enlazar	Espagñol	t	121	f
5294	3	1827	1	con el mundial	Espagñol	t	19	f
5303	3	1830	3	selección piscina	Espagñol	t	104	f
5309	3	1832	3	nueva piscina	Espagñol	t	104	f
5324	3	1837	3	clasificación	Espagñol	t	104	f
5327	3	1838	3	entrada	Espagñol	t	104	f
5330	3	1839	3	descendente	Espagñol	t	104	f
5333	3	1840	3	aufsteigend	Espagñol	t	104	f
5339	3	1842	3	FORMATO: VALOR [STRING] | ADICIONAL [STRING]	Espagñol	t	104	f
5342	3	1843	1	valores	Espagñol	t	12	f
5345	3	1844	1	de ella	Espagñol	t	12	f
5348	3	1845	1	seleccionado	Espagñol	t	12	f
5351	3	1846	1	apropiado	Espagñol	t	12	f
5354	3	1847	3	actualización del sistema	Espagñol	t	154	f
5360	3	1849	3	Distribuir estructura de carpetas	Espagñol	t	154	f
5381	3	1856	3	usado	Espagñol	t	195	f
5387	3	1858	3	renovar	Espagñol	t	195	f
5429	3	1872	3	menú de información	Espagñol	t	163	f
5450	3	1879	3	editable	Espagñol	t	110	f
5453	3	1880	3	formato de número	Espagñol	t	110	f
5456	3	1881	3	RegExp	Espagñol	t	110	f
5462	3	1883	3	moneda	Espagñol	t	110	f
5468	3	1885	3	WYSIWYG	Espagñol	t	110	f
5471	3	1886	3	separación valor	Espagñol	t	110	f
5474	3	1887	3	Disp. atajos	Espagñol	t	110	f
12871	3	2941	3	\N	Espagñol	f	226	f
5417	3	1868	1	La solicitud supera el máximo de los mismos registros a tratar! La ordenación se realiza sólo en el conjunto de resultados aprobado. Los pasos siguientes están disponibles:	Espagñol	t	5	t
5492	3	1893	3	en general	Espagñol	t	164	f
5495	3	1894	3	rutas de instalación	Espagñol	t	164	f
5501	3	1896	3	Los arreglos de mesa	Espagñol	t	164	f
5507	3	1898	3	Configuración del índice	Espagñol	t	164	f
5510	3	1899	3	Configuración de archivos	Espagñol	t	164	f
5513	3	1900	3	Configuración de seguridad	Espagñol	t	164	f
5516	3	1901	1	Die Medatdaten konnten nicht erfolgreich ausgelesen werden.	Espagñol	t	41	f
5519	3	1902	1	grandes / pequeños cuadernos de cartas	Espagñol	t	66	f
5522	3	1903	1	juego completo	Espagñol	t	66	f
5525	3	1904	1	Parte de la palabra	Espagñol	t	66	f
5537	3	1908	3	buscar sólo en los metadatos	Espagñol	t	52	f
5540	3	1909	1	para este tipo de archivo no se puede previsualizar creado.	Espagñol	t	66	f
5558	3	1915	1	No se encontraron documentos!	Espagñol	t	66	f
5585	3	1924	3	otro	Espagñol	t	52	f
5600	3	1929	3	calendario	Espagñol	t	140	f
5606	3	1931	2	tiempo	Espagñol	t	0	f
5615	3	1934	2	00:00:00	Espagñol	t	0	f
5630	3	1939	1	extras	Espagñol	t	66	f
5654	3	1947	3	cuadro de edición	Espagñol	t	175	f
5657	3	1948	3	cuadro de área de texto	Espagñol	t	175	f
5660	3	1949	3	Seleccione la casilla de verificación	Espagñol	t	175	f
5663	3	1950	3	elemento casilla de verificación	Espagñol	t	175	f
5666	3	1951	3	elemento de Radio	Espagñol	t	175	f
5675	3	1954	3	ventana de usos múltiples	Espagñol	t	115	f
5678	3	1955	3	junto	Espagñol	t	168	f
5681	3	1956	3	apartado	Espagñol	t	168	f
5696	3	1961	3	selección	Espagñol	t	168	f
5699	3	1962	3	Sí 	Espagñol	t	168	f
5702	3	1963	3	no	Espagñol	t	168	f
5714	3	1967	3	chasquido	Espagñol	t	168	f
5717	3	1968	3	oculto	Espagñol	t	168	f
5738	3	1975	1	en	Espagñol	t	13	f
5756	3	1981	1	Stunden	Espagñol	t	13	f
5759	3	1982	1	días	Espagñol	t	13	f
5762	3	1983	1	semana	Espagñol	t	13	f
5768	3	1985	1	años	Espagñol	t	13	f
5771	3	1986	3	extensión	Espagñol	t	162	f
5774	3	1987	3	Disparador onch	Espagñol	t	122	f
5789	3	1992	3	renovar las tablas del sistema de archivos	Espagñol	t	154	f
5798	3	1995	3	Depurar	Espagñol	t	164	f
5807	3	1998	1	guardar como	Espagñol	t	5	f
5813	3	2000	1	administrar	Espagñol	t	5	f
5831	3	2006	1	guardado correctamente!	Espagñol	t	0	f
5834	3	2007	1	eliminado correctamente!	Espagñol	t	0	f
5837	3	2008	1	enviado con éxito!	Espagñol	t	0	f
5864	3	2017	1	XML	Espagñol	t	5	f
5873	3	2020	3	La conversión de la materia:	Espagñol	t	110	f
5876	3	2021	3	Contenido con exceso de longitud o el tipo incorrecto de reducir o borrado!	Espagñol	t	110	f
5882	3	2023	3	pregunta	Espagñol	t	140	f
5891	3	2026	3	SQL	Espagñol	t	205	f
5894	3	2027	3	Editor	Espagñol	t	205	f
5903	3	2030	3	Actualizar contenidos de los campos temporales	Espagñol	t	154	f
5918	3	2035	3	Workflow	Espagñol	t	140	f
5867	3	2018	3	última versión	Espagñol	t	52	f
5684	3	1957	3	rejilla celular	Espagñol	t	168	f
5939	3	2042	1	último usuario	Espagñol	t	208	f
5942	3	2043	1	los usuarios actuales	Espagñol	t	208	f
5945	3	2044	1	próximos a los usuarios	Espagñol	t	208	f
5951	3	2046	1	¿Le detener este flujo de trabajo?	Espagñol	t	208	f
5954	3	2047	1	¿Quieres abortar este flujo de trabajo?	Espagñol	t	208	f
5957	3	2048	1	tarea	Espagñol	t	208	f
5960	3	2049	1	von\r\n	Espagñol	t	208	f
5963	3	2050	1	an	Espagñol	t	208	f
5966	3	2051	1	Sie haben momentan weder eine Aufgabe noch ein Workflow gestartet!	Espagñol	t	208	f
5975	3	2054	1	Flujo de trabajo se ha anulado correctamente!	Espagñol	t	209	f
5984	3	2057	1	mi flujo de trabajo	Espagñol	t	204	f
5987	3	2058	1	no es una tarea	Espagñol	t	204	f
5999	3	2062	1	Último registro! 	Espagñol	t	23	f
6002	3	2063	3	considerar Índice Z 	Espagñol	t	175	f
6005	3	2064	3	a un primer plano	Espagñol	t	168	f
6008	3	2065	3	en el fondo	Espagñol	t	168	f
6014	3	2067	3	renovar Índice Z	Espagñol	t	168	f
6017	3	2068	3	No.	Espagñol	t	212	f
6023	3	2070	3	tiempo	Espagñol	t	212	f
6029	3	2072	3	aktiv	Espagñol	t	212	f
6035	3	2074	3	minuto	Espagñol	t	212	f
6038	3	2075	3	hora	Espagñol	t	212	f
6041	3	2076	3	del mes	Espagñol	t	212	f
6047	3	2078	3	día laborable	Espagñol	t	212	f
6050	3	2079	3	Añadir trabajo	Espagñol	t	212	f
6053	3	2080	3	estructura de archivos	Espagñol	t	212	f
7665	3	2083	1	no hay registros seleccionados!	Espagñol	t	5	f
7685	3	2088	3	oculto	Espagñol	t	168	f
7697	3	2091	3	primera página	Espagñol	t	168	f
7701	3	2092	3	siguientes páginas	Espagñol	t	168	f
7705	3	2093	3	Transp.	Espagñol	t	168	f
7725	3	2098	3	antes	Espagñol	t	168	f
7729	3	2099	3	entonces	Espagñol	t	168	f
7681	3	2087	2	campo heredada	Espagñol	t	0	f
7733	3	2100	3	maquillaje	Espagñol	t	168	f
7737	3	2101	3	la posición del arreglo	Espagñol	t	168	f
7741	3	2102	3	relativamente	Espagñol	t	168	f
7781	3	2112	3	tabla de colores	Espagñol	t	52	f
7761	3	2107	3	legar	Espagñol	t	213	f
7785	3	2113	1	El archivo no se puede convertir!	Espagñol	t	66	f
7789	3	2114	1	límite	Espagñol	t	5	f
7809	3	2119	3	gráficos	Espagñol	t	177	f
7861	3	2132	3	de versiones	Espagñol	t	140	f
7885	3	2138	1	No tabla vinculada seleccionado!	Espagñol	t	5	f
7889	3	2139	1	No hay datos asociados disponibles!	Espagñol	t	5	f
7901	3	2142	3	de forma recursiva	Espagñol	t	140	f
7905	3	2143	3	fix	Espagñol	t	140	f
7857	3	2131	3	menú de la derecha	Espagñol	t	119	f
7853	3	2130	3	derechos de archivo	Espagñol	t	119	f
7849	3	2129	3	los derechos de mesa	Espagñol	t	119	f
7909	3	2144	3	a mano	Espagñol	t	122	f
7913	3	2145	3	automáticamente	Espagñol	t	122	f
7917	3	2146	1	debe ser versionado el registro?	Espagñol	t	13	f
7925	3	2148	1	Registro fue versionado con éxito!	Espagñol	t	25	f
7929	3	2149	1	Los registros fueron versionados correctamente!	Espagñol	t	25	f
7933	3	2150	1	El registro ha sido copiado con éxito!	Espagñol	t	25	f
7937	3	2151	1	Los registros se han copiado con éxito!	Espagñol	t	25	f
7945	3	2153	1	Si se eliminan los registros seleccionados?	Espagñol	t	5	f
7949	3	2154	1	Si se archivan los registros seleccionados?	Espagñol	t	5	f
7953	3	2155	1	Si se versionan los registros seleccionados?	Espagñol	t	5	f
7957	3	2156	1	Si se copian los registros seleccionados?	Espagñol	t	5	f
7961	3	2157	1	Si se restauran los registros seleccionados?	Espagñol	t	5	f
10335	3	2310	1	Usted no tiene ninguna carpeta derechos!	Espagñol	t	97	f
7965	3	2158	1	Cancelación de los límites puede conducir a largos tiempos de espera para grandes conjuntos de registros!	Espagñol	t	5	f
7921	3	2147	1	Puede ser versionado y editado sólo la versión actual del registro!	Espagñol	t	13	f
8001	3	2167	1	Mostrar barra de herramientas	Espagñol	t	46	f
8021	3	2172	1	Situación a:	Espagñol	t	5	f
8025	3	2173	2	------- tipos de campo Extensión -------	Espagñol	t	0	f
8029	3	2174	2	sin sentido	Espagñol	t	0	f
8041	3	2177	1	Registro es idéntico!	Espagñol	t	13	f
8045	3	2178	3	colspan	Espagñol	t	168	f
8049	3	2179	3	rowspan	Espagñol	t	168	f
10303	3	2302	3	no muestran menú de la tabla	Espagñol	t	122	f
8061	3	2182	1	Registro fue vinculado!	Espagñol	t	25	f
8065	3	2183	1	Los registros fueron ligados!	Espagñol	t	25	f
8069	3	2184	1	Link ha sido resuelto!	Espagñol	t	25	f
8073	3	2185	1	Enlaces se han resuelto!	Espagñol	t	25	f
8077	3	2186	1	Si se vinculan los registros seleccionados?	Espagñol	t	5	f
8081	3	2187	1	Si se resolverá el funcionamiento de los registros seleccionados?	Espagñol	t	5	f
8089	3	2189	1	No tiene derecho a este archivo!	Espagñol	t	66	f
8125	3	2198	3	dependiente	Espagñol	t	168	f
8161	3	2207	3	plantilla	Espagñol	t	177	f
8173	3	2210	3	rebautizar	Espagñol	t	148	f
4039	3	1376	2	Enlace 1:n	Espagñol	t	0	f
8109	3	2194	2	tamaño de archivo	Espagñol	t	0	f
8113	3	2195	2	Tamaño en bytes	Espagñol	t	0	f
8193	3	2215	3	vista	Espagñol	t	149	f
8197	3	2216	3	gatillo	Espagñol	t	149	f
8209	3	2219	1	¿Quieres añadir el archivo / s a &#8203;&#8203;sus favoritos?	Espagñol	t	66	f
8233	3	2225	1	un nivel	Espagñol	t	215	f
8237	3	2226	1	seleccionar	Espagñol	t	215	f
8241	3	2227	1	abortar	Espagñol	t	215	f
8249	3	2229	1	mirando en	Espagñol	t	215	f
8253	3	2230	1	Inicio guía	Espagñol	t	215	f
8257	3	2231	1	nueva carpeta	Espagñol	t	215	f
8177	3	2211	2	atributo	Espagñol	t	0	f
8181	3	2212	2	atributo	Espagñol	t	0	f
8261	3	2232	1	nuevo archivo	Espagñol	t	215	f
8265	3	2233	1	simple presentación	Espagñol	t	215	f
8269	3	2234	1	pantalla extendida	Espagñol	t	215	f
8273	3	2235	3	identificadores	Espagñol	t	110	f
8277	3	2236	3	dependencia	Espagñol	t	52	f
8289	3	2239	3	Sólo backend bloqueo	Espagñol	t	127	f
8293	3	2240	3	convertir	Espagñol	t	148	f
8305	3	2243	3	abfragen	Espagñol	t	148	f
8381	3	2262	3	la vida de sesión	Espagñol	t	127	f
8357	3	2256	2	argumento SQL	Espagñol	t	0	f
8361	3	2257	2	constructo Fórmula (SQL)	Espagñol	t	0	f
10164	3	2269	3	definición	Espagñol	t	218	f
10169	3	2270	3	editado en	Espagñol	t	218	f
10174	3	2271	3	editado por	Espagñol	t	218	f
10203	3	2277	2	Berichtrechte	Espagñol	t	0	f
10207	3	2278	2	Configuración de informe de Derechos	Espagñol	t	0	f
12807	3	2925	3	\N	Espagñol	f	173	f
10211	3	2279	3	debe suprimirse la forma?	Espagñol	t	176	f
10219	3	2281	3	formas	Espagñol	t	222	f
8121	3	2197	2	mimetype	Espagñol	t	0	f
8037	3	2176	2	Observación adicional de versiones	Espagñol	t	0	f
8033	3	2175	2	versión Comentarios	Espagñol	t	0	f
10231	3	2284	3	el informe debería eliminarse?	Espagñol	t	170	f
10235	3	2285	3	debe suprimirse el diagrama?	Espagñol	t	177	f
10239	3	2286	3	Si se borra el grupo de tablas, incluyendo tablas?	Espagñol	t	140	f
10363	3	2317	1	El archivo de origen ya no existe!	Espagñol	t	66	f
10243	3	2287	3	desea que la tabla que desea eliminar?	Espagñol	t	140	f
10247	3	2288	3	todos abiertos	Espagñol	t	213	f
10255	3	2290	3	todos abiertos justificada	Espagñol	t	213	f
10259	3	2291	2	muestran su vez vinculado	Espagñol	t	0	f
10267	3	2293	1	Los metadatos no se pudo actualizar!	Espagñol	t	66	f
10391	3	2324	1	Info Indizierung	Espagñol	t	66	f
10271	3	2294	1	Usted no tiene permiso o se retiró la orden!	Espagñol	t	66	f
10275	3	2295	3	ver los archivos	Espagñol	t	213	f
10279	3	2296	3	Añadir archivos	Espagñol	t	213	f
10283	3	2297	3	Ordner anlegen	Espagñol	t	213	f
10287	3	2298	3	Eliminar archivos / carpetas	Espagñol	t	213	f
10291	3	2299	3	editar metadatos	Espagñol	t	213	f
10295	3	2300	3	archivos de bloqueo	Espagñol	t	213	f
10299	3	2301	3	grupos permitidos	Espagñol	t	213	f
10311	3	2304	2	OCR	Espagñol	t	0	f
10315	3	2305	2	el reconocimiento OCR	Espagñol	t	0	f
12805	2	2924	3	tile	english	t	175	f
10323	3	2307	2	barra de herramientas	Espagñol	t	0	f
10327	3	2308	2	Mostrar barra de herramientas	Espagñol	t	0	f
10331	3	2309	1	expediente	Espagñol	t	97	f
10263	3	2292	2	mostrar consigo registros relacionados	Espagñol	t	0	f
10339	3	2311	1	No hay derechos de eliminación!	Espagñol	t	97	f
11043	3	2485	3	ajustes de usuario	Espagñol	t	154	f
10347	3	2313	1	El archivo de origen ya existe. Por favor, inténtelo de nuevo.	Espagñol	t	97	f
10351	3	2314	1	Iniciar el reconocimiento OCR	Espagñol	t	66	f
10355	3	2315	2	Modo vinculado	Espagñol	t	0	f
10359	3	2316	2	mostrar sólo los registros relacionados	Espagñol	t	0	f
10367	3	2318	1	eliminar el archivo	Espagñol	t	215	f
10371	3	2319	2	Buscar en subcarpetas	Espagñol	t	0	f
10375	3	2320	2	búsqueda recursiva	Espagñol	t	0	f
10379	3	2321	1	abierto	Espagñol	t	66	f
10383	3	2322	1	Guardar	Espagñol	t	66	f
10387	3	2323	1	información de metadatos	Espagñol	t	66	f
10395	3	2325	1	información de versiones	Espagñol	t	66	f
10415	3	2330	1	ver todos los archivos	Espagñol	t	66	f
10423	3	2332	1	omitir	Espagñol	t	66	f
10319	3	2306	3	Forma Derechos / Informe	Espagñol	t	119	f
10427	3	2333	1	Aplicar a todos los archivos	Espagñol	t	66	f
10431	3	2334	1	Ver origen	Espagñol	t	15	f
10447	3	2338	2	Derechos del usuario	Espagñol	t	0	f
10451	3	2339	2	Benutzer berechtigen	Espagñol	t	0	f
10455	3	2340	3	Si cambia los permisos de todos los viejos individuales de los derechos se borrará esta tabla!	Espagñol	t	140	f
10459	3	2341	2	Mostrar derechos de usuario	Espagñol	t	0	f
10463	3	2342	2	Descripción general de los derechos de los usuarios	Espagñol	t	0	f
10483	3	2347	3	Índice Z	Espagñol	t	169	f
10487	3	2348	3	Y-Pos	Espagñol	t	169	f
10491	3	2349	2	prueba	Espagñol	t	unknown	f
10495	3	2350	2	sin sentido	Espagñol	t	unknown	f
10499	3	1993	2	sección	Espagñol	t	unknown	f
10503	3	1994	2	Categoría etiquetado	Espagñol	t	unknown	f
10515	3	2353	3	IP estática	Espagñol	t	127	f
10519	3	2354	1	Diferencia entre versiones	Espagñol	t	204	f
10523	3	2355	1	mostrar en pdf	Espagñol	t	204	f
10531	3	2357	3	separador	Espagñol	t	168	f
10535	3	2358	1	Romper vínculo	Espagñol	t	13	f
10539	3	2359	1	¿Quieres eliminar el enlace de este disco?	Espagñol	t	13	f
10551	3	2362	2	agrupamiento	Espagñol	t	0	f
10507	3	2351	2	contenido del documento	Espagñol	t	0	f
10511	3	2352	2	Documento de referencia	Espagñol	t	0	f
12727	3	2905	2	imagen	Espagñol	t	0	f
10555	3	2363	2	campo de agrupamiento	Espagñol	t	0	f
10575	3	2368	3	Información de texto mientras está bloqueado	Espagñol	t	154	f
10603	3	2375	1	El archivo subido ya existe con el mismo o un nombre diferente en las siguientes carpetas	Espagñol	t	41	f
10607	3	2376	3	filtro avanzado	Espagñol	t	121	f
10611	3	2377	3	Beziehungen	Espagñol	t	121	f
10615	3	2378	3	miembro del grupo	Espagñol	t	186	f
10619	3	2379	3	clasificación	Espagñol	t	186	f
10627	3	2381	3	respecto	Espagñol	t	52	f
10643	3	2385	3	final	Espagñol	t	52	f
10543	3	2360	2	pestaña agrupación	Espagñol	t	0	f
10547	3	2361	2	Campo de agrupamiento como piloto	Espagñol	t	0	f
10655	3	2388	3	creado en	Espagñol	t	52	f
10659	3	2389	3	creado por	Espagñol	t	52	f
10663	3	2390	3	creado por el grupo	Espagñol	t	52	f
10667	3	2391	3	editado en	Espagñol	t	52	f
10671	3	2392	3	editado por	Espagñol	t	52	f
10751	3	2412	3	mensaje No.	Espagñol	t	52	f
10759	3	2414	3	de	Espagñol	t	52	f
10763	3	2415	3	para	Espagñol	t	52	f
10779	3	2419	3	Nachricht	Espagñol	t	52	f
10815	3	2428	3	bloquear ilimitada	Espagñol	t	221	f
10823	3	2430	2	registro de bloqueo	Espagñol	t	0	f
10827	3	2431	2	desbloqueo	Espagñol	t	0	f
10831	3	2432	2	desbloquear registro	Espagñol	t	0	f
10835	3	2433	1	debe ser liberado el disco?	Espagñol	t	13	f
10843	3	2435	1	Registro fue bloqueado correctamente!	Espagñol	t	25	f
10847	3	2436	1	Los registros fueron bloqueadas correctamente!	Espagñol	t	25	f
12796	1	2922	3	Vollsuche	deutsch	t	110	f
10851	3	2437	1	El registro ha sido desbloqueado con éxito!	Espagñol	t	25	f
10855	3	2438	1	Datensätze wurden erfolgreich entsperrt!	Espagñol	t	25	f
10859	3	2439	2	fecha bloqueado	Espagñol	t	0	f
10863	3	2440	2	mis registros bloqueados	Espagñol	t	0	f
10867	3	2441	2	Mostrar bloqueado	Espagñol	t	0	f
10871	3	2442	2	Viendo registros bloqueados	Espagñol	t	0	f
10875	3	2443	2	guardar	Espagñol	t	0	f
10879	3	2444	2	tomar el relevo	Espagñol	t	0	f
10883	3	2445	3	immer	Espagñol	t	168	f
10887	3	2446	3	incluso páginas	Espagñol	t	168	f
10891	3	2447	3	páginas impares	Espagñol	t	168	f
10895	3	2448	1	hablado como	Espagñol	t	66	f
10903	3	2450	3	trigger	Espagñol	t	218	f
10907	3	2451	3	gatillo Limbas	Espagñol	t	218	f
10915	3	2453	3	Gestionar los derechos de usuario para los registros generados internamente	Espagñol	t	221	f
10923	3	2455	1	Usted está en el sistema como	Espagñol	t	11	f
10927	3	2456	3	formulario de cambio de dirección	Espagñol	t	175	f
10587	3	2371	3	copia de enlace	Espagñol	t	121	f
10935	3	2458	3	maxlen	Espagñol	t	168	f
10943	3	2460	3	reemplazar	Espagñol	t	168	f
10951	3	2462	3	La selección de proyectos	Espagñol	t	145	f
10955	3	2463	3	enviar información de registro	Espagñol	t	132	f
11187	3	2521	1	nombre de host IMAP	Espagñol	t	46	f
10963	3	2465	2	espectáculo de suma	Espagñol	t	0	f
10967	3	2466	2	mostrar suma de los registros	Espagñol	t	0	f
10979	3	2469	2	recursiva de eliminación	Espagñol	t	0	f
12809	2	2925	3	border	english	t	173	f
10983	3	2470	2	recursivos vínculos de borrado y versiones	Espagñol	t	0	f
10987	3	2471	2	funciones especiales	Espagñol	t	0	f
10991	3	2472	2	funciones especiales	Espagñol	t	0	f
10995	3	2473	1	Existen las siguientes dependencias:	Espagñol	t	25	f
10999	3	2474	1	Las siguientes dependencias se resolvieron:	Espagñol	t	25	f
11027	3	2481	3	de contenido temporal	Espagñol	t	154	f
11031	3	2482	3	funciones de base de datos	Espagñol	t	154	f
11039	3	2484	3	gestión de derechos	Espagñol	t	154	f
11035	3	2483	3	sistema	Espagñol	t	154	f
11063	3	2490	2	árboles de relación	Espagñol	t	0	f
11075	3	2493	2	vector árbol	Espagñol	t	0	f
11079	3	2494	2	vector árbol	Espagñol	t	0	f
11083	3	2495	2	Buscar divisiones del Grupo	Espagñol	t	0	f
11087	3	2496	2	Buscar encabezados de campo del Grupo	Espagñol	t	0	f
11095	3	2498	1	grupos	Espagñol	t	84	f
11059	3	2489	2	vector árbol	Espagñol	t	0	f
11111	3	2502	1	formato:	Espagñol	t	13	f
11115	3	2503	1	Formulario estándar	Espagñol	t	13	f
11123	3	2505	3	Regla pantalla	Espagñol	t	110	f
11131	3	2507	3	Búsqueda rápida	Espagñol	t	110	f
3913	3	1250	3	Historia	Espagñol	t	132	f
11135	3	2508	3	HTML	Espagñol	t	168	f
11139	3	2509	3	Extensión informe	Espagñol	t	170	f
11151	3	2512	3	los informes del sistema	Espagñol	t	222	f
10443	3	2337	3	Gestionar los derechos de usuario para todos los registros	Espagñol	t	221	f
10559	3	2364	2	duplicados	Espagñol	t	0	f
10563	3	2365	2	Descripción general duplicados	Espagñol	t	0	f
11015	3	2478	2	duplicados	Espagñol	t	0	f
11019	3	2479	2	Mostrar duplicados	Espagñol	t	0	f
4015	3	1352	2	número (18)	Espagñol	t	0	f
11179	3	2519	1	E-mail dirección	Espagñol	t	46	f
11183	3	2520	1	dirección de respuesta	Espagñol	t	46	f
11191	3	2522	1	Nombre de usuario IMAP	Espagñol	t	46	f
4013	3	1350	2	número	Espagñol	t	0	f
4049	3	1386	2	entero	Espagñol	t	0	f
11195	3	2523	1	puerto IMAP	Espagñol	t	46	f
11199	3	2524	1	contraseña IMAP	Espagñol	t	46	f
3564	3	896	3	Esta función establece los derechos estándar del grupo y sus subgrupos aquí de nuevo! En este caso, los derechos existentes se sobreescriben!	Espagñol	t	115	t
4087	3	1424	1	El registro ha sido cambiado sin guardar. los cambios están destinados a tratar de asumir el control?	Espagñol	t	13	t
4595	3	1594	3	¿Quieres volver a poner la base de datos? Todos los datos serán borrados!	Espagñol	t	154	t
11207	3	2526	2	configuración avanzada	Espagñol	t	0	f
3917	3	1254	3	¿Quieres eliminar el grupo y todos los subgrupos? Los usuarios de estos grupos pueden utilizar [Muestra usuario eliminado] otros grupos se asignan!	Espagñol	t	115	t
12731	3	2906	2	tipos MIME	Espagñol	t	0	f
5552	3	1913	1	- Limitar el resultado por parámetros de búsqueda sucesivamente. - Aumentar si titulado hasta el límite. - Elevar, en su caso, el límite a.	Espagñol	t	5	t
11519	3	2604	3	tabla de vinculación	Espagñol	t	110	f
5786	3	1991	3	Si se vuelven a crear las tablas del sistema de archivo de los archivos y FILES_META? contenido existente será borrado! Las tablas de archivos se crean en los limbassys grupo de la tabla.	Espagñol	t	154	t
11219	3	2529	2	Gruppierung Zeile	Espagñol	t	0	f
8189	3	2214	3	Ya existe un vínculo positivo para este campo! Esta acción utiliza el acceso directo existente negativo. enlaces existentes se perderán!	Espagñol	t	121	t
10411	3	2329	3	En caso de que los archivos .htaccess a ser regenerados? Las nuevas contraseñas se aplican únicamente cuando la opción clear_password está habilitada en las umgvars	Espagñol	t	154	t
11203	3	2525	2	ajustes	Espagñol	t	0	f
11211	3	2527	2	actualización	Espagñol	t	0	f
11215	3	2528	2	actualización	Espagñol	t	0	f
10631	3	2382	3	comienzo	Espagñol	t	52	f
11223	3	2530	2	agrupación de campo en una fila	Espagñol	t	0	f
11227	3	2531	1	La longitud del nombre del archivo no puede exceder de 128 caracteres!	Espagñol	t	41	f
11275	3	2543	3	nuevo árbol mesa	Espagñol	t	207	f
3981	3	1318	1	No había hecho ningún cambio en este nuevo disco! Crear registros vacíos no es aconsejable.	Espagñol	t	13	t
5156	3	1781	3	Bloquear mensaje	Espagñol	t	127	f
12575	3	2867	3	eje	Espagñol	t	177	f
11307	3	2551	3	restablecer los derechos de registro	Espagñol	t	154	f
11311	3	2552	3	Volver a calcular el historial de derechos	Espagñol	t	154	f
11319	3	2554	3	pestaña de acceso directo	Espagñol	t	173	f
11323	3	2555	3	barra de menú	Espagñol	t	173	f
11331	3	2557	3	zócalo	Espagñol	t	173	f
11147	3	2511	3	nombre de almacenamiento	Espagñol	t	170	f
7777	3	2111	3	carpeta de almacenamiento	Espagñol	t	170	f
11347	3	2561	3	Tabulator-Rahmen	Espagñol	t	175	f
5705	3	1964	3	nueva pestaña	Espagñol	t	168	f
11351	3	2562	3	El usuario no se ha podido crear!	Espagñol	t	126	f
11459	3	2589	3	posible	Espagñol	t	110	f
11295	3	2548	3	son todos se eliminan miniaturas temporales?	Espagñol	t	154	f
11355	3	2563	2	ajustes	Espagñol	t	0	f
11359	3	2564	2	configuración avanzada	Espagñol	t	0	f
11167	3	2516	3	Los derechos de usuario heredan jerárquicamente	Espagñol	t	221	f
10527	3	2356	3	ver todas versionado	Espagñol	t	221	f
11363	3	2565	3	Arte de versiones de	Espagñol	t	221	f
11371	3	2567	3	color de fondo de las columnas	Espagñol	t	221	f
11379	3	2569	3	regla de filtrado	Espagñol	t	221	f
11383	3	2570	3	reglas de ediciónreglas 	Espagñol	t	221	f
11391	3	2572	3	configuración de formato	Espagñol	t	221	f
11395	3	2573	3	Regla para el acceso de escritura	Espagñol	t	221	f
10251	3	2289	3	todos cerca	Espagñol	t	213	f
11407	3	2576	3	formato de fecha	Espagñol	t	127	f
11411	3	2577	3	Informaciones Enviar mensaje al usuario	Espagñol	t	172	f
11419	3	2579	2	OCR	Espagñol	t	0	f
11423	3	2580	2	OCR Erkennung	Espagñol	t	0	f
11375	3	2568	3	Predeterminada para crear un nuevo registro	Espagñol	t	221	f
11399	3	2574	3	la forma estándar	Espagñol	t	221	f
11427	3	2581	3	archivo CSS	Espagñol	t	175	f
11431	3	2582	1	enlace	Espagñol	t	15	f
11435	3	2583	2	extensiones	Espagñol	t	0	f
11439	3	2584	2	extensiones de edición	Espagñol	t	0	f
11483	3	2595	3	separador	Espagñol	t	110	f
11443	3	2585	3	aceptar los derechos de grupo superior:	Espagñol	t	119	f
11451	3	2587	3	umbral de potencia	Espagñol	t	110	f
11455	3	2588	3	Datenbankspezifischer Defaultwert<br>z.B. 12 | text | now()	Espagñol	t	110	f
11463	3	2590	3	Sustitución del tipo de caja que tiene una función independiente de [ext_type.inc]	Espagñol	t	110	f
11467	3	2591	3	Por lo general, para ocultar el campo, que se espera: devolver verdadero / falso	Espagñol	t	110	f
11471	3	2592	3	Regla para el acceso de escritura del campo, que se espera: devolver verdadero / falso	Espagñol	t	110	f
11475	3	2593	3	establecer	Espagñol	t	110	f
11491	3	2597	3	De la forma en muchos lugares el número que se muestra en Expotentialschreibweise	Espagñol	t	110	f
4081	3	1418	2	Selección del sistema de carpeta de usuario / grupo	Espagñol	t	0	f
11499	3	2599	3	moneda por defecto	Espagñol	t	110	f
11503	3	2600	3	formato de hora	Espagñol	t	110	f
11487	3	2596	3	representación de números en el formato de número () Formato: por ejemplo, 2 ''. '', '' ''	Espagñol	t	110	f
11523	3	2605	1	No se le debe asignar más!	Espagñol	t	13	f
11535	3	2608	3	filtro	Espagñol	t	110	f
11539	3	2609	3	cuadro de búsqueda	Espagñol	t	110	f
11543	3	2610	3	evaluación	Espagñol	t	110	f
11547	3	2611	3	herencia	Espagñol	t	110	f
11171	3	2517	1	jerárquicamente heredar	Espagñol	t	13	f
4051	3	1388	2	número entero de 18 dígitos	Espagñol	t	0	f
5609	3	1932	2	fecha	Espagñol	t	0	f
3972	3	1309	2	restaurar	Espagñol	t	0	f
4880	3	1689	1	máx. Número de descargas simultáneas:	Espagñol	t	66	f
4967	3	1718	3	Si se borrará todo el índice de este campo?	Espagñol	t	110	f
5555	3	1914	1	Consejos para la búsqueda: prestar atención a la ortografía -korrekte que -verallgemeinern buscar: localiza en subcarpetas (sub)	Espagñol	t	66	t
11923	3	2705	1	De jornada completa	Espagñol	t	52	f
4066	3	1403	2	Moneda 25 dígitos	Espagñol	f	0	f
5969	3	2052	1	¿Se le flujo de trabajo no se cancela! Tal vez una cuestión de derechos.	Espagñol	t	209	f
5972	3	2053	1	Flujo de trabajo no pudo ser detenido! Tal vez una cuestión de derechos.	Espagñol	t	209	f
7693	3	2090	3	Backg.	Espagñol	t	168	f
4027	3	1364	2	fecha_tiempo	Espagñol	f	0	f
5612	3	1933	2	DD.MM.YYYY z.B. 05.12.02 z.B. 5 dez 02 z.B. 05 Dezember 2	Espagñol	t	0	t
11551	3	2612	3	Editor de consultas	Espagñol	t	225	f
11571	3	2617	3	Incluye sólo aquellos registros en los que el contenido de los campos combinados sean iguales	Espagñol	t	226	f
11575	3	2618	3	Incluye todos los registros de	Espagñol	t	226	f
11579	3	2619	3	y sólo aquellos registros de	Espagñol	t	226	f
11583	3	2620	3	donde el contenido de los campos combinados son iguales	Espagñol	t	226	f
11599	3	2624	3	alias	Espagñol	t	226	f
11603	3	2625	3	función	Espagñol	t	226	f
11611	3	2627	3	suma	Espagñol	t	226	f
11615	3	2628	3	min	Espagñol	t	226	f
11619	3	2629	3	Max	Espagñol	t	226	f
11627	3	2631	3	espectáculo	Espagñol	t	226	f
11631	3	2632	3	criterios	Espagñol	t	226	f
11635	3	2633	3	ascendente	Espagñol	t	226	f
11639	3	2634	3	descendente	Espagñol	t	226	f
11643	3	2635	3	tablas del sistema espectáculo	Espagñol	t	225	f
11655	3	2638	3	espectáculo	Espagñol	t	168	f
11315	3	2553	3	los derechos de todos los datos existentes establecen específicos del Tablle seleccionada se borrarán!	Espagñol	t	154	f
11675	3	2643	1	al usuario	Espagñol	t	13	f
11679	3	2644	1	conjunto	Espagñol	t	13	f
11727	3	2656	3	consulta de selección	Espagñol	t	140	f
11691	3	2647	1	objetivo	Espagñol	t	66	f
11699	3	2649	3	modo de lista	Espagñol	t	169	f
4065	3	1402	2	valor de clave número de 18 dígitos	Espagñol	t	0	f
11723	3	2655	3	El tamaño del campo como <br> 255 | 5.2	Espagñol	t	110	f
4029	3	1366	2	Autoidentificación	Espagñol	t	0	f
11731	3	2657	3	consulta la creación	Espagñol	t	140	f
7689	3	2089	3	resultados de la búsqueda	Espagñol	t	121	f
11739	3	2659	3	consulta de eliminación	Espagñol	t	140	f
11743	3	2660	3	contenido	Espagñol	t	173	f
11759	3	2664	3	utiliza [serial] Identificación	Espagñol	t	140	f
3926	3	1263	3	crear permisos	Espagñol	t	110	f
11763	3	2665	3	utiliza [secuencia] Tabla	Espagñol	t	140	f
4520	3	1569	1	estilo	Espagñol	t	175	f
5651	3	1946	3	Estructura principal	Espagñol	t	175	f
11771	3	2667	3	insertar	Espagñol	t	173	f
11775	3	2668	2	Mostrar campos	Espagñol	t	0	f
11779	3	2669	2	Mostrar campos	Espagñol	t	0	f
5801	3	1996	1	publicar	Espagñol	t	5	f
4208	3	1465	3	emergente Verkn	Espagñol	t	140	f
11803	3	2675	1	Para ser cambiado en un lote cambiar el contenido del campo? La acción no se puede deshacer!	Espagñol	t	230	f
11783	3	2670	2	el cambio de lote	Espagñol	t	0	f
11787	3	2671	2	el cambio de lote	Espagñol	t	0	f
11815	3	2678	1	no campo seleccionado	Espagñol	t	230	f
11791	3	2672	3	el cambio de lote	Espagñol	t	110	f
11795	3	2673	1	sustituir con	Espagñol	t	230	f
11807	3	2676	1	Número de registros afectados	Espagñol	t	230	f
11811	3	2677	1	campo afectado	Espagñol	t	230	f
11819	3	2679	2	nueva ventana	Espagñol	t	0	f
11823	3	2680	2	nueva ventana	Espagñol	t	0	f
11835	3	2683	1	desigual	Espagñol	t	19	f
11839	3	2684	1	registros modificados	Espagñol	t	230	f
11843	3	2685	3	estándar	Espagñol	t	140	f
11847	3	2686	3	Resultados insuficientes	Espagñol	t	140	f
11851	3	2687	3	no cálculo	Espagñol	t	140	f
11855	3	2688	3	número del resultado	Espagñol	t	140	f
4082	3	1419	2	Memo de Textblock	Espagñol	t	0	f
11859	3	2689	3	campos de la tabla de edición	Espagñol	t	140	f
11863	3	2690	3	Editor de consultas abierto	Espagñol	t	140	f
10931	3	2457	3	modo	Espagñol	t	168	f
11871	3	2692	3	escribir	Espagñol	t	168	f
11875	3	2693	1	Taquigrafía en la búsqueda rápida	Espagñol	t	19	f
11287	3	2546	3	Eliminar miniaturas temporales	Espagñol	t	154	f
12291	3	2796	1	hacerse cargo y cerca	Espagñol	t	13	f
11671	3	2642	2	selección de color	Espagñol	f	0	f
11299	3	2549	3	solle versucht werden alle fehlgeschlagene Thumbnails neu zu berechnen?	Espagñol	t	154	f
11883	3	2695	3	Eliminar archivos temporales de texto	Espagñol	t	154	f
11291	3	2547	3	Volver a calcular frustrada miniaturas	Espagñol	t	154	f
11891	3	2697	3	Si la estructura de carpetas se comprueba la consistencia? Faltan carpetas de usuario o informe se reconstruyen.	Espagñol	t	154	f
11895	3	2698	3	Rotation	Espagñol	t	168	f
11899	3	2699	3	no publicada	Espagñol	t	140	f
11747	3	2661	3	marco de agrupación	Espagñol	t	175	f
11663	3	2640	3	ajax puesto	Espagñol	t	110	f
11903	3	2700	3	ajustes del calendario	Espagñol	t	164	f
11751	3	2662	3	Compruebe secuencias	Espagñol	t	154	f
11715	3	2653	3	Si se vuelven a crear los procedimientos de base de datos específica Limbas?	Espagñol	t	154	f
11887	3	2696	3	Si Limbasspezifischen se volverá a crear el gatillo?	Espagñol	t	154	f
11755	3	2663	3	Si se las tablas de secuencia Limbasspezifischen re-creado?	Espagñol	t	154	f
11711	3	2652	3	Prozeduren prüfen	Espagñol	t	154	f
5912	3	2033	3	Si vuelve a calcular el número indicado de enlaces y campos de selección múltiple?	Espagñol	t	154	f
11955	3	2713	3	pestaña mesa	Espagñol	t	173	f
4982	3	1723	3	Fecha + Hora	Espagñol	t	110	f
11911	3	2702	3	Fecha + hora + Sec	Espagñol	t	110	f
11915	3	2703	3	Reservas Pasos ID	Espagñol	t	140	f
11935	3	2708	3	posición	Espagñol	t	173	f
11939	3	2709	3	primero	Espagñol	t	173	f
11943	3	2710	3	recordar	Espagñol	t	173	f
11951	3	2712	3	Haga clic en Evento de forma Reiter <br> ejemplo alert ( '' hola '');	Espagñol	t	110	f
12759	3	2913	3	pasado	Espagñol	t	139	f
10571	3	2367	3	Eliminar la configuración de usuario	Espagñol	t	154	f
10407	3	2328	3	todos los usuarios borrar los ajustes?	Espagñol	t	154	f
11975	3	2718	3	icono	Espagñol	t	204	f
11983	3	2720	3	desaparecer	Espagñol	t	204	f
11007	3	2476	3	Compruebe claves externas	Espagñol	t	154	f
11011	3	2477	3	Si las claves externas Limbasspezifischen a ser retirados?	Espagñol	t	154	f
11055	3	2488	3	Comprobar gatillo	Espagñol	t	154	f
11987	3	2721	3	Verificar los índices	Espagñol	t	154	f
11991	3	2722	1	Si faltan los índices se reconstruyen Limbasspezifische?	Espagñol	t	154	f
11995	3	2723	3	índices	Espagñol	t	195	f
11999	3	2724	3	restricciones únicas	Espagñol	t	195	f
12003	3	2725	3	Las claves externas	Espagñol	t	195	f
12011	3	2727	3	Ref. Tabla	Espagñol	t	195	f
12015	3	2728	3	Ref campo.	Espagñol	t	195	f
12019	3	2729	3	Las claves primarias	Espagñol	t	195	f
12027	3	2731	3	Agregatfunktion	Espagñol	t	110	f
12031	3	2732	3	Calcular el número de filas que se muestran en el formato seleccionado	Espagñol	t	110	f
12035	3	2733	1	Ocultar la columna	Espagñol	t	5	f
12047	3	2735	3	estilo de celda	Espagñol	t	168	f
10307	3	2303	3	leer	Espagñol	t	122	f
12103	3	2749	2	los derechos de flujo de trabajo	Espagñol	t	0	f
12039	3	2370	3	debe seguir siendo la copia de enlace?	Espagñol	t	121	f
12043	3	2734	3	Selección de reordenación piscina	Espagñol	t	154	f
12051	3	2736	3	mesa	Espagñol	t	168	f
12059	3	2738	2	nueva presentación	Espagñol	t	0	f
12063	3	2739	2	nueva presentación	Espagñol	t	0	f
12067	3	2740	3	nueva nueva presentación	Espagñol	t	187	f
12071	3	2741	1	crear nueva	Espagñol	t	7	f
4598	3	1595	2	Número Porcentaje de punto	Espagñol	f	0	f
12075	3	2742	3	basado en el grupo	Espagñol	t	187	f
12079	3	2743	2	reenvíos	Espagñol	t	0	f
12083	3	2744	2	los derechos establecer recordatorios	Espagñol	t	0	f
12087	3	2745	2	los derechos de formulario	Espagñol	t	0	f
12091	3	2746	2	Forma derechos establecidos	Espagñol	t	0	f
11831	3	2682	1	El campo vacío	Espagñol	f	19	f
12095	3	2747	2	tabla de derechos	Espagñol	t	0	f
12099	3	2748	2	Establecer derechos de tabla	Espagñol	t	0	f
12107	3	2750	2	Workflowrechte festlegen	Espagñol	t	0	f
12111	3	2751	3	crear copia de seguridad	Espagñol	t	140	f
12115	3	2752	3	nuevo flujo de trabajo	Espagñol	t	208	f
12123	3	2754	3	nueva tarea	Espagñol	t	208	f
12131	3	2756	3	Forma lista	Espagñol	t	175	f
12135	3	2757	3	radio	Espagñol	t	168	f
12171	3	2766	1	antes	Espagñol	t	204	f
12139	3	2758	3	crear el archivo	Espagñol	t	213	f
8117	3	2196	2	mimetype	Espagñol	t	0	f
12147	3	2760	3	Cuando se cambia la información de versiones versión existente será eliminado!	Espagñol	t	140	f
12151	3	2761	3	sincronizar	Espagñol	t	139	f
12155	3	2762	1	ahora	Espagñol	t	204	f
12191	3	2771	2	grupo de selección	Espagñol	t	0	f
12187	3	2770	3	máx. resultados	Espagñol	t	155	f
12195	3	2772	2	Manejo de grupo de selección	Espagñol	t	0	f
12203	3	2774	2	Evento recurrente	Espagñol	t	0	f
12207	3	2775	2	Creación de una cita periódica	Espagñol	t	0	f
12263	3	2789	1	Jährlich	Espagñol	t	200	f
12267	3	2790	1	2 veces a la semana	Espagñol	t	200	f
10419	3	2331	3	parámetro	Espagñol	t	168	f
12271	3	2791	3	repetición	Espagñol	t	52	f
11587	3	2621	3	Verknüpfung entfernen	Espagñol	t	226	f
12211	3	2776	1	Si todo este conjunto de datos enlazar a ser eliminado?	Espagñol	t	204	f
12215	3	2777	3	incrustar	Espagñol	t	169	f
12219	3	2778	3	caída	Espagñol	t	169	f
12223	3	2779	3	el que se informa	Espagñol	t	169	f
12227	3	2780	3	Caja de herramientas	Espagñol	t	169	f
12235	3	2782	3	coordenadas	Espagñol	t	169	f
12239	3	2783	3	elementos	Espagñol	t	169	f
12251	3	2786	1	diario	Espagñol	t	200	f
12255	3	2787	1	semanal	Espagñol	t	200	f
12259	3	2788	1	mensual	Espagñol	t	200	f
12275	3	2792	3	La repetición está terminando	Espagñol	t	52	f
12283	3	2794	1	¡Precaución! Eliminación recursiva registros versionados o vinculados \\\\\\\\\\\\\\\\ Nhas activado!	Espagñol	t	17	f
12287	3	2795	3	opciones	Espagñol	t	221	f
12295	3	2797	2	Importar archivo	Espagñol	t	0	f
12299	3	2798	2	importación	Espagñol	t	0	f
12303	3	2799	1	principio	Espagñol	t	200	f
12311	3	2801	1	Duración / Period	Espagñol	t	200	f
12315	3	2802	1	Intervalo de repetición	Espagñol	t	200	f
12319	3	2803	1	patrón de repetición	Espagñol	t	200	f
12331	3	2806	3	Los campos que se muestran en el enlace Búsqueda Rápida / selección Verknüpungs	Espagñol	t	121	f
12343	3	2809	3	parametrización implícita	Espagñol	t	121	f
12351	3	2811	3	Descripción de las	Espagñol	t	110	f
5870	3	2019	3	desea que el campo que desea eliminar?	Espagñol	t	110	f
12355	3	2812	3	vista de lista	Espagñol	t	139	f
12359	3	2813	3	separador de listas	Espagñol	t	139	f
12363	3	2814	3	forma abreviada	Espagñol	t	139	f
12367	3	2815	3	Ausführlich	Espagñol	t	139	f
5291	3	1826	3	buscado	Espagñol	t	121	f
12339	3	2808	3	con OR para ser campos de la tabla de enlace buscado	Espagñol	t	121	f
12375	3	2817	3	tamaño de bloque	Espagñol	t	139	f
12379	3	2818	3	sistema	Espagñol	t	165	f
12383	3	2819	3	ImageMagick	Espagñol	t	165	f
12387	3	2820	3	ghostscript	Espagñol	t	165	f
12391	3	2821	1	Detalles supresores	Espagñol	t	5	f
12735	3	2907	2	Revisions-Manager	Espagñol	t	0	f
12419	3	2828	3	activa la coloración de los registros de datos individuales gruppenzpezifische	Espagñol	t	140	f
12427	3	2830	3	activa el envío automático / salvamento de la forma en el fondo en caso de cambio de registros	Espagñol	t	140	f
12751	3	2911	3	activa el borrado automático y recreación de consultas dependientes.	Espagñol	t	110	f
12403	3	2824	3	Por lo general, para poner de relieve o marcas de los registros individuales con colores o símbolos. Esperada llamada de función.	Espagñol	t	140	f
12439	3	2833	3	nombre de la tabla física	Espagñol	t	140	f
12435	3	2832	3	permitido la creación de un conjunto de datos sin identificación asignado. Los nuevos registros se 'crean después' 'Aplicar'.	Espagñol	t	140	f
12411	3	2826	3	el registro de todos los cambios activa un registro	Espagñol	t	140	f
12415	3	2827	3	activa el bloqueo específico del usuario registros individuales	Espagñol	t	140	f
12423	3	2829	3	activa los grupos / autorización específica de usuario registros individuales	Espagñol	t	140	f
12443	3	2834	3	Dependiente del idioma Nombre de la tabla	Espagñol	t	140	f
12431	3	2831	3	activa el despliegue de enlaces o grupos en la lista de registros	Espagñol	t	140	f
12399	3	2823	3	El cálculo ajustado <br> el resultado alternativa <b> por defecto :. </ B> select count (*) <br> <b> Resultados insuficientes: </ b> odbc_fetch_row	Espagñol	t	140	f
12451	3	2836	3	Infos	Espagñol	t	140	f
12455	3	2837	3	campo significativo del registro de definición única	Espagñol	t	110	f
12459	3	2838	3	El campo tiene un índice de base de datos	Espagñol	t	110	f
12463	3	2839	3	El campo es claramente	Espagñol	t	110	f
12495	3	2847	3	Representación de la búsqueda enlace como la selección basada en AJAX (sólo en combinación con '' Seleccionar Buscar '')	Espagñol	t	110	f
12407	3	2825	3	gatillo seleccionado activado	Espagñol	t	140	f
12799	3	2923	3	\N	Espagñol	f	110	f
12395	3	2822	3	Tipo de control de versiones. <br> <b> recursiv: </ b> todas las versiones 1: n enlaces si la versión también activamente <br> <b> Solución: </ b> versionado sólo el registro actual	Espagñol	t	140	f
12479	3	2843	3	El campo se puede representar en la lista de tablas Agrupados	Espagñol	t	110	f
12808	1	2925	3	Rahmen	deutsch	t	173	f
12179	3	2768	2	instantáneas	Espagñol	f	0	f
12335	3	2807	3	Los campos que aparecen en Verknüpfungsaansicht	Espagñol	f	121	f
12467	3	2840	3	activa el envío / almacén automático del campo de formulario en el fondo durante un cambio.	Espagñol	t	110	f
12483	3	2844	3	activa el cambio de apilado / colección para este campo	Espagñol	t	110	f
12511	3	2851	3	la definición de un recurso de origen para la representación de Gantt. n esperado: m relación	Espagñol	t	140	f
11659	3	2639	3	ajax búsqueda	Espagñol	t	110	f
12499	3	2848	3	<B> forma Kurtz: </ b> pantalla numérica Shorter <br> <b> detallada: </ b> Visualización de todos los valores separados por separador de lista	Espagñol	t	110	f
12515	3	2852	3	-configuración específica del calendario	Espagñol	t	140	f
12487	3	2845	3	activa la pila / Búsqueda de selección basado SammeländeruAJAX lugar de la lista desplegable para este campo Feldesng	Espagñol	t	110	f
12491	3	2846	3	Representación del enlace como un campo de selección	Espagñol	t	110	f
12503	3	2849	3	Aislador para la presentación detallada	Espagñol	t	110	f
12471	3	2841	3	Ver como campo de selección en el <b> barra de búsqueda de tabla </ b>	Espagñol	t	110	f
12475	3	2842	3	una búsqueda activa de selección basado en AJAX en el <b> barra de búsqueda de tabla </ b>	Espagñol	t	110	f
12507	3	2850	3	Ressource	Espagñol	t	140	f
12519	3	2853	1	orden del día	Espagñol	t	200	f
12523	3	2854	1	Gantt	Espagñol	t	200	f
8165	3	2208	3	importación de proyectos	Espagñol	t	148	f
12531	3	2856	3	Debe ser creado para el vínculo existente una tabla cruzada View? enlaces existentes se borrarán.	Espagñol	t	121	f
12527	3	2855	3	Tabla reticulación: (sólo lectura)	Espagñol	t	121	f
12872	1	2941	3	Syntax prüfen	deutsch	t	226	f
12535	3	2857	3	Las opciones de filtrado para la selección como piscina | $ Extensión [ '', donde ''] = "palabras clave como ''%peces% '"; devolver $ extensión;	Espagñol	t	110	f
11479	3	2594	3	piscina	Espagñol	t	110	f
4073	3	1410	2	carga de archivos con vista previa	Espagñol	t	0	f
12543	3	2859	3	exportación de sincronización	Espagñol	t	145	f
12547	3	2860	3	importación de sincronización	Espagñol	t	145	f
12551	3	2861	3	ancho de la celda	Espagñol	t	168	f
7941	3	2152	1	versiones de errores! Sólo los registros actuales se pueden versionar!	Espagñol	t	25	f
12555	3	2862	3	Crear un nuevo archivo de configuración EXIF	Espagñol	t	154	f
12559	3	2863	3	Crear Un Nuevo Archivo de configuration EXIF	Espagñol	t	177	f
12563	3	2864	3	transpuesto	Espagñol	t	177	f
12595	3	2872	3	tamaño de la fuente	Espagñol	t	177	f
12599	3	2873	3	distancia a la izquierda	Espagñol	t	177	f
12603	3	2874	3	espacio por encima	Espagñol	t	177	f
12607	3	2875	3	distancia correcta	Espagñol	t	177	f
12611	3	2876	3	espacio inferior	Espagñol	t	177	f
12615	3	2877	3	Texto eje X	Espagñol	t	177	f
12619	3	2878	3	Texto del eje Y	Espagñol	t	177	f
12623	3	2879	3	Leyenda x	Espagñol	t	177	f
12627	3	2880	3	Leyenda y	Espagñol	t	177	f
12631	3	2881	3	Leyenda	Espagñol	t	177	f
12635	3	2882	3	ocultar	Espagñol	t	177	f
12647	3	2885	3	gráfico de sectores	Espagñol	t	177	f
12651	3	2886	3	sin etiqueta	Espagñol	t	177	f
12655	3	2887	3	Show	Espagñol	t	177	f
12659	3	2888	3	indican el porcentaje	Espagñol	t	177	f
12663	3	2889	3	Pie-radio	Espagñol	t	177	f
12671	3	2891	3	propiedad	Espagñol	t	177	f
12679	3	2893	3	ajuste	Espagñol	t	177	f
12683	3	2894	3	aplicar	Espagñol	t	177	f
12687	3	2895	3	plurilingüe	Espagñol	t	110	f
12691	3	2896	3	apoyo en el idioma habilitado	Espagñol	t	110	f
12695	3	2897	3	traducir	Espagñol	t	180	f
12703	3	2899	1	nueva presentación de filtro	Espagñol	t	0	f
12711	3	2901	1	Nueva presentación / s añadido correctamente!	Espagñol	t	5	f
12707	3	2900	1	Nueva presentación / s borrado correctamente!	Espagñol	t	5	f
12715	3	2902	1	Objetivo / eliminado creado para el seleccionado registra una nueva presentación?	Espagñol	t	5	f
12739	3	2908	2	Revisions-Manager	Espagñol	t	0	f
12743	3	2909	1	asignado a	Espagñol	t	0	f
12755	3	2912	3	dependencias	Espagñol	t	110	f
12723	3	2904	2	imagen	Espagñol	f	0	f
12772	1	2916	2	Sync-Slave	deutsch	t	0	f
12776	1	2917	2	Synchronisations ID Slave	deutsch	t	0	f
12773	2	2916	2	Sync slave 	english	t	0	f
12774	4	2916	2	Esclave Sync 	francais	t	0	f
12771	3	2916	2	Esclavo sync 	Espagñol	t	0	f
12788	1	2920	1	Ausführverbot aufgrund einer Triggerregel	deutsch	t	31	f
12787	3	2920	1	\N	Espagñol	f	31	f
12791	3	2921	1	\N	Espagñol	f	25	f
12789	2	2920	1	trigger denied execution 	english	t	31	f
12792	1	2921	1	nicht alle Datensätze konnten verknüpft werden!	deutsch	t	25	f
2650	1	1365	2	Boolean	deutsch	t	0	f
4028	3	1365	2	Booleano	Espagñol	f	0	f
4064	3	1401	2	TRUE | FALSE o 0 | 1	Espagñol	f	0	f
12795	3	2922	3	\N	Espagñol	f	110	f
7825	3	2123	2	telefonía	Espagñol	f	0	f
4026	3	1363	2	Bloque de texto	Espagñol	f	0	f
12800	1	2923	3	Feld wird in die globale Tabellensuche einbezogen	deutsch	t	110	f
12803	3	2924	3	\N	Espagñol	f	175	f
12804	1	2924	3	Kachel	deutsch	t	175	f
12793	2	2921	1	could not link all datasets	english	t	25	f
2654	1	1367	2	Währung	deutsch	t	0	f
4030	3	1367	2	moneda	Espagñol	f	0	f
2726	1	1403	2	Währung 25-stellig	deutsch	t	0	f
12811	3	2926	3	\N	Espagñol	f	225	f
12812	1	2926	3	prüfen	deutsch	t	225	f
12815	3	2927	1	\N	Espagñol	f	0	f
12816	1	2927	1	Version %s ist verfügbar!	deutsch	t	0	f
12819	3	2928	1	\N	Espagñol	f	0	f
12820	1	2928	1	Diese Version ist aktuell!	deutsch	t	0	f
12823	3	2929	1	\N	Espagñol	f	0	f
12824	1	2929	1	Auf Updates prüfen	deutsch	t	0	f
12827	3	2930	1	\N	Espagñol	f	0	f
12828	1	2930	1	Aktuelle Version	deutsch	t	0	f
12831	3	2931	2	\N	Espagñol	f	0	f
12835	3	2932	2	\N	Espagñol	f	0	f
12851	3	2936	2	\N	Espagñol	f	0	f
12839	3	2933	2	\N	Espagñol	f	0	f
12843	3	2934	2	\N	Espagñol	f	0	f
12847	3	2935	2	\N	Espagñol	f	0	f
12855	3	2937	2	\N	Espagñol	f	0	f
12856	1	2937	2	drucken	deutsch	t	0	f
12859	3	2938	2	\N	Espagñol	f	0	f
12860	1	2938	2	Dokument drucken	deutsch	t	0	f
12863	3	2939	1	\N	Espagñol	f	23	f
12864	1	2939	1	Auf Drucker	deutsch	t	23	f
12891	3	2946	2	\N	Espagñol	f	0	f
12892	1	2946	2	Verknüpfung	deutsch	t	0	f
12895	3	2947	2	\N	Espagñol	f	0	f
12896	1	2947	2	Datei	deutsch	t	0	f
6988	4	1365	2	booléen	francais	t	0	f
6990	4	1367	2	devise	francais	t	0	f
7024	4	1401	2	TRUE | FALSE ou 0 | 1	francais	t	0	f
12790	4	2920	1	Interdiction d'exécution à cause d'une règle de déclenchement!	francais	t	31	f
12894	4	2946	2	lien	francais	t	0	f
12899	3	2948	2	\N	Espagñol	f	0	f
12900	1	2948	2	Sonstiges	deutsch	t	0	f
12903	3	2949	2	\N	Espagñol	f	0	f
12904	1	2949	2	Limbas-System	deutsch	t	0	f
11512	1	2602	3	Datumsdarstellung im strftime() oder DateTime::format  Format: z.B. %V,%G,%Y  | Y-m-d H:i:s	deutsch	t	110	f
11511	3	2602	3	visualización de la fecha en strftime () Formato: por ejemplo, % V,% G,% Y	Espagñol	f	110	f
12867	3	2940	3	\N	Espagñol	f	226	f
12868	1	2940	3	Konfiguration speichern	deutsch	t	226	f
12876	1	2942	3	Abfrage speichern	deutsch	t	226	f
12875	3	2942	3	\N	Espagñol	f	226	f
12879	3	2943	3	\N	Espagñol	f	226	f
12880	1	2943	3	Veröffentlichung entfernen	deutsch	t	226	f
2658	1	1369	2	E-Mail-Adresse	deutsch	t	0	f
4032	3	1369	2	email	Espagñol	f	0	f
4269	1	1485	2	Auswahl (Checkbox)	deutsch	t	0	f
4268	3	1485	2	Selección (casilla de verificación)	Espagñol	f	0	f
2666	1	1373	2	Auswahl (Ajax)	deutsch	t	0	f
12813	2	2926	3	check	english	t	225	f
12821	2	2928	1	This version is up to date!	english	t	0	f
12817	2	2927	1	version %s is available!	english	t	0	f
12833	2	2931	2	favorites	english	t	0	f
4036	3	1373	2	Selección (Ajax)	Espagñol	f	0	f
7678	1	2086	2	Vererbung	deutsch	t	0	f
7677	3	2086	2	heredado	Espagñol	f	0	f
12883	3	2944	2	\N	Espagñol	f	0	f
12884	1	2944	2	Numerisch	deutsch	t	0	f
12887	3	2945	2	\N	Espagñol	f	0	f
12888	1	2945	2	Auswahl	deutsch	t	0	f
10972	1	2467	2	Fließkomma-Zahl	deutsch	t	0	f
10971	3	2467	2	Números de punto flotante	Espagñol	f	0	f
10975	3	2468	2	número de punto de flotación	Espagñol	f	0	f
2626	1	1353	2	Numerische Kommazahl	deutsch	t	0	f
4016	3	1353	2	número numérico-punto	Espagñol	f	0	f
2698	1	1389	2	Kommazahl Numeric	deutsch	t	0	f
4052	3	1389	2	Kommazahl Numeric	Espagñol	f	0	f
4599	1	1595	2	Numerische Kommazahl (Prozent)	deutsch	t	0	f
4601	3	1596	2	El punto número numérico con representación porcentaje	Espagñol	f	0	f
7826	1	2123	2	Telefonie	deutsch	t	0	f
7829	3	2124	2	+xx xx xxxx o +xx xxxxx	Espagñol	f	0	f
2718	1	1399	2	Textblock	deutsch	t	0	f
4062	3	1399	2	bloque de texto	Espagñol	f	0	f
1203	2	2	1	version 	english	t	4	f
1205	2	4	1	name 	english	t	4	f
1208	2	7	1	host 	english	t	4	f
1209	2	8	1	IP 	english	t	4	f
1210	2	9	1	agent 	english	t	4	f
1211	2	10	1	authentication 	english	t	4	f
1212	2	11	1	company 	english	t	4	f
1225	2	24	1	Do you want to create a new record? 	english	t	5	f
1226	2	25	1	an unknown error is occurred 	english	t	5	f
1228	2	27	1	other 	english	t	12	f
1230	2	29	1	value 	english	t	12	f
1231	2	30	1	search 	english	t	12	f
1234	2	33	1	save 	english	t	12	f
1235	2	34	1	new value 	english	t	12	f
1250	2	49	1	Do you want to archive this record? 	english	t	13	f
1251	2	50	1	Do you want to delete this file? 	english	t	13	f
1252	2	51	1	Do you want to print a report for the selected data records? 	english	t	13	f
1257	2	56	1	An error has occurred! 	english	t	13	f
1259	2	58	1	Syntax error! Input not according field type 	english	t	14	f
1260	2	59	1	Replace with value 	english	t	14	f
1261	2	60	1	Conditional 	english	t	14	f
1267	2	84	1	Do you want to delete this data record? 	english	t	17	f
1269	2	86	1	entries 	english	t	17	f
1271	2	88	1	rows 	english	t	17	f
1272	2	89	1	Page 	english	t	17	f
1273	2	93	1	hit 	english	t	17	f
1276	2	96	1	show 	english	t	17	f
1278	2	98	1	no records found! 	english	t	17	f
1281	2	101	1	Detail search 	english	t	19	f
1282	2	102	1	after 	english	t	19	f
1283	2	103	1	search in 	english	t	19	f
1291	2	112	1	You can not delete this entry. Value already linked.! 	english	t	22	f
1293	2	114	1	Permission denied! 	english	t	23	f
1294	2	115	1	Changes have been reset! 	english	t	25	f
1295	2	116	1	Record successfully deleted! 	english	t	25	f
1297	2	118	1	You have no persmission to change this fileds! 	english	t	27	f
1301	2	122	1	No existing links. 	english	t	34	f
1305	2	126	1	description 	english	t	34	f
5712	2	1966	2	publish filter	english	t	\N	f
6976	4	1353	2	réel (10) 	francais	t	0	f
6987	4	1364	2	date/heure	francais	t	0	f
6992	4	1369	2	adresse e-mail	francais	t	0	f
6995	4	1372	2	choix (multiselect)	francais	t	0	f
7828	4	2123	2	téléphonie 	francais	t	0	f
1307	2	128	1	File could not be saved!\r\nThe file is not a regular file, storing to this target is not allowed or no storage capacity. 	english	t	41	t
1308	2	129	1	Max file size for upload is restricted to 	english	t	41	f
1312	2	133	1	The uploaded file has an undefined format. 	english	t	41	f
1313	2	134	1	Error! The following fields are incorrect: 	english	t	37	f
1202	2	1	1	permission denied! 	english	t	2	f
2627	2	1353	2	decimal numeric 	english	t	0	f
2647	2	1363	2	Textarea 	english	t	0	f
2649	2	1364	2	Date_Time 	english	t	0	f
2651	2	1365	2	Boolean 	english	t	0	f
2655	2	1367	2	Currency 	english	t	0	f
2659	2	1369	2	email 	english	t	0	f
2665	2	1372	2	Choice (multiselect) 	english	t	0	f
2667	2	1373	2	Selection (ajax) 	english	t	0	f
2699	2	1389	2	decimal numeric 	english	t	0	f
2719	2	1399	2	Textarea 	english	t	0	f
2723	2	1401	2	TRUE | FLASE or 0 | 1 	english	t	0	f
2727	2	1403	2	currency 25 didigts 	english	t	0	f
4270	2	1485	2	multiple choice field as checkbox 	english	t	0	f
7679	2	2086	2	inherited 	english	t	0	f
7827	2	2123	2	Telephony 	english	t	0	f
7831	2	2124	2	+xx xx xxxx oder +xx xxxxx 	english	t	0	f
10973	2	2467	2	float number 	english	t	0	f
10977	2	2468	2	number with decimal point 	english	t	0	f
11513	2	2602	3	Date view as strftime() formate: e.g %V,%G,%Y 	english	t	110	f
12797	2	2922	3	fulltext search	english	t	110	f
12801	2	2923	3	using field for global search	english	t	110	f
12825	2	2929	1	check for updates	english	t	0	f
12829	2	2930	1	current version	english	t	0	f
12837	2	2932	2	favorites	english	t	0	f
12841	2	2933	2	external memory	english	t	0	f
12845	2	2934	2	external file memory	english	t	0	f
12849	2	2935	2	printer	english	t	0	f
12889	2	2945	2	joice	english	t	0	f
1288	2	109	1	case sensitive	english	t	19	f
1287	2	108	1	begin of fieldcontent 	english	t	19	f
12853	2	2936	2	manage printer	english	t	0	f
12857	2	2937	2	print	english	t	0	f
12861	2	2938	2	print dokument	english	t	0	f
12865	2	2939	1	to printer	english	t	23	f
12869	2	2940	3	save config	english	t	226	f
12873	2	2941	3	check syntax	english	t	226	f
12877	2	2942	3	save view	english	t	226	f
12885	2	2944	2	numeric	english	t	0	f
12893	2	2946	2	relation	english	t	0	f
12897	2	2947	2	file	english	t	0	f
12901	2	2948	2	miscellaneous	english	t	0	f
12905	2	2949	2	Limbas-System	english	t	0	f
12881	2	2943	3	remove publication	english	t	226	f
5176	2	1787	1	archive	english	t	13	f
5557	2	1914	1	Tipps for searching:\r\n- pay attention for correct spelling\r\n- search in subfolders too \r\n- generalize your search	english	t	66	t
109	1	109	1	groß- und kleinschreibung beachten	deutsch	t	19	f
107	1	107	1	ist	deutsch	t	19	f
11828	1	2681	1	ist leer	deutsch	t	19	f
11827	3	2681	1	campo vacío	Espagñol	f	19	f
12907	3	2950	3	\N	Espagñol	f	140	f
12908	1	2950	3	primärer Schlüssel	deutsch	t	140	f
4620	2	1602	2	filter	english	t	\N	f
4623	2	1603	2	save filter	english	t	\N	f
4626	2	1604	2	filter	english	t	\N	f
4629	2	1605	2	filter overview	english	t	\N	f
12912	1	2951	3	legt das primäre Schlüsselfeld fest sofern es nicht den Namen "ID" hat. Das Feld muß vom Typ INTEGER sein! Falls das Feld nicht existiert wird auf den Pointer zurückgegriffen.	deutsch	t	140	f
12911	3	2951	3	\N	Espagñol	f	140	f
4619	1	1602	2	Filter	deutsch	t	\N	f
4621	3	1602	2	Schnapschuß	Espagñol	f	\N	f
4622	1	1603	2	Filter speichern	deutsch	t	\N	f
4624	3	1603	2	neue Filteransicht speichern	Espagñol	f	\N	f
4625	1	1604	2	Filter	deutsch	t	\N	f
4627	3	1604	2	Schnapschuß	Espagñol	f	\N	f
4628	1	1605	2	Filter Übersicht	deutsch	t	\N	f
4630	3	1605	2	Schnapschuß Übersicht	Espagñol	f	\N	f
5711	1	1966	2	Filter veröffentlichen	deutsch	t	\N	f
5713	3	1966	2	Schnappschuß veröffentlichen	Espagñol	f	\N	f
5841	1	2009	1	Filter speichern	deutsch	t	0	f
5840	3	2009	1	Guardar instantánea	Espagñol	f	0	f
5844	1	2010	1	Filter löschen	deutsch	t	0	f
5843	3	2010	1	eliminar instantánea	Espagñol	f	0	f
10468	1	2343	3	Filter-Tabellen abgleichen	deutsch	t	154	f
10467	3	2343	3	Distribuir tablas de instantáneas	Espagñol	f	154	f
12183	3	2769	2	Trabajar con instantáneas Públicas	Espagñol	f	0	f
12244	1	2784	3	veröffentlichte Filter	deutsch	t	210	f
12243	3	2784	3	instantáneas publicadas	Espagñol	f	210	f
12248	1	2785	3	alle Filter	deutsch	t	210	f
12247	3	2785	3	todas las instantáneas	Espagñol	f	210	f
5842	2	2009	1	save filter	english	t	0	f
7196	4	1602	2	filtre	francais	t	0	f
12914	4	2951	3	Definit le champ clé sous condition qu'il n'ait pas le nom "ID". Le champ doit être du type "INTEGER". Si le champ n'existe pas, le pointeur sera employer.	francais	t	140	f
5845	2	2010	1	delete filter	english	t	0	f
10469	2	2343	3	Match filter table	english	t	154	f
12915	3	2952	2	\N	Espagñol	f	0	f
12181	2	2768	2	filter	english	t	0	f
12185	2	2769	2	manage public filter	english	t	0	f
12245	2	2784	3	public filter	english	t	210	f
12249	2	2785	3	all filter	english	t	210	f
12919	3	2953	2	\N	Espagñol	f	0	f
10476	1	2345	3	Sollen die Filter-Tabellen erneuert werden?\r\nFilter werden auf neue oder fehlende Felder geprüft.	deutsch	t	154	t
10475	3	2345	3	Si las tablas de instantáneas que se retiraron? Las instantáneas se comprueban para los campos nuevos o que faltan.	Espagñol	f	154	f
12909	2	2950	3	primary key	english	t	140	f
12917	2	2952	2	menueditor	english	t	0	f
12921	2	2953	2	editor for individual menus	english	t	0	f
12913	2	2951	3	set primary key field if not named "ID". Field must be numeric.	english	t	140	f
10477	2	2345	3	Shall the filter tables be renewed? Filter are checked for new or missing fields. 	english	t	154	f
1286	2	107	1	whole field 	english	t	19	f
1285	2	106	1	part of fieldcontent 	english	t	19	f
773	1	773	2	Erweiterte Suche	deutsch	t	\N	f
774	1	774	2	erweiterte Suche	deutsch	t	\N	f
5288	3	1825	3	vinculado	Espagñol	f	121	f
12924	1	2954	3	primäres Beschreibungsfeld. Verknüpfungsfeld ist immer 'ID'	deutsch	t	121	f
12923	3	2954	3	\N	Espagñol	f	121	f
12336	1	2807	3	angezeigte Felder in der Verknüpfungsaansicht	deutsch	t	121	f
12927	3	2955	3	\N	Espagñol	f	104	f
12928	1	2955	3	Pflicht	deutsch	t	104	f
12931	3	2956	3	\N	Espagñol	f	104	f
12932	1	2956	3	Ebene	deutsch	t	104	f
428	1	428	2	Vorlagen	deutsch	t	\N	f
3145	3	428	2	presentación del informe	Espagñol	f	0	f
5405	1	1864	2	Crontab	deutsch	t	\N	f
5408	1	1865	2	System Crontab editieren	deutsch	t	\N	f
11668	1	2641	2	Farbauswahl	deutsch	t	0	f
437	1	437	2	Schema	deutsch	t	\N	f
12926	4	2954	3	Champ de description primaire. Champ de lien est toujours "ID".	francais	t	121	f
11667	3	2641	2	selección de color	Espagñol	f	0	f
1590	2	428	2	report-template 	english	t	0	f
5290	2	1825	3	linked 	english	t	121	f
11669	2	2641	2	Colojoice 	english	t	0	f
12337	2	2807	3	displayed fields in link-view 	english	t	121	f
12925	2	2954	3	primary identifyer. Relationfield is always 'ID'	english	t	121	f
12929	2	2955	3	requirement	english	t	104	f
12933	2	2956	3	level	english	t	104	f
12936	1	2957	1	überschreibbar	deutsch	t	15	f
12935	3	2957	1	\N	Espagñol	f	15	f
7409	4	1825	3	décrit 	francais	t	121	f
12939	3	2958	2	\N	Espagñol	f	0	f
12943	3	2959	2	\N	Espagñol	f	0	f
12955	3	2962	1	\N	Espagñol	f	0	f
12956	1	2962	1	Mandant	deutsch	t	0	f
4355	1	1514	2	Feldtypen	deutsch	t	\N	f
4358	1	1515	2	Tabellen - Feldtypen	deutsch	t	\N	f
435	1	435	2	Menüpunkte	deutsch	t	\N	f
436	1	436	2	Menüpunkte	deutsch	t	\N	f
12916	1	2952	2	Menüeditor	deutsch	t	0	f
12920	1	2953	2	Editor für individuelle menüs	deutsch	t	0	f
438	1	438	2	Farb-Schema	deutsch	t	\N	f
439	1	439	2	Farben	deutsch	t	\N	f
440	1	440	2	Farb-Tabelle	deutsch	t	\N	f
726	1	726	2	Sprache	deutsch	t	\N	f
727	1	727	2	System Sprachtabelle	deutsch	t	\N	f
8385	1	2263	2	Sprache	deutsch	t	\N	f
8389	1	2264	2	Lokale Sprachtabelle	deutsch	t	\N	f
5477	1	1888	2	Schriftarten	deutsch	t	\N	f
5480	1	1889	2	Fontmanager	deutsch	t	\N	f
12180	1	2768	2	Filter	deutsch	t	0	f
12184	1	2769	2	Öffentliche Filter verwalten	deutsch	t	0	f
12192	1	2771	2	Auswahlpools	deutsch	t	0	f
12196	1	2772	2	Auswahlpools verwalten	deutsch	t	0	f
12840	1	2933	2	externer Speicher	deutsch	t	0	f
12844	1	2934	2	externer Datei Speicher	deutsch	t	0	f
12940	1	2958	2	CustVar	deutsch	t	0	f
12944	1	2959	2	Globale Variablen	deutsch	t	0	f
12947	3	2960	3	\N	Espagñol	f	0	f
12948	1	2960	3	wird überschrieben	deutsch	t	0	f
12951	3	2961	3	\N	Espagñol	f	140	f
12952	1	2961	3	Mandantenfähig	deutsch	t	140	f
10195	1	2275	3	synchronisieren	deutsch	t	218	f
10194	3	2275	3	sincronizar	Espagñol	f	218	f
12959	3	2963	3	\N	Espagñol	f	141	f
12960	1	2963	3	aktiviert die Synchronisierungsfunktionen für diese Tabelle	deutsch	t	141	f
12963	3	2964	3	\N	Espagñol	f	140	f
10196	2	2275	3	synchronize 	english	t	218	f
12937	2	2957	1	overridable	english	t	15	f
10197	4	2275	3	synchroniser	francais	t	218	f
13033	2	2981	3	main navigation	english	t	231	f
10478	4	2345	3	Souhaitez-vous actualiser les tableaux de filtres? Des champs nouveaux/manquants seront ajouté/supprimé.	francais	t	154	f
11670	4	2641	2	sélection de couleurs	francais	t	0	f
12918	4	2952	2	éditeur de menu	francais	t	0	f
12964	1	2964	3	aktiviert die Mandantenfähigkeit für diese Tabelle	deutsch	t	140	f
12967	3	2965	2	\N	Espagñol	f	0	f
12971	3	2966	2	\N	Espagñol	f	0	f
13019	3	2978	2	\N	Espagñol	f	0	f
12848	1	2935	2	Drucker	deutsch	t	0	f
12852	1	2936	2	Drucker verwalten	deutsch	t	0	f
12968	1	2965	2	Mandanten	deutsch	t	0	f
12972	1	2966	2	Mandanten	deutsch	t	0	f
12975	3	2967	2	\N	Espagñol	f	0	f
12979	3	2968	2	\N	Espagñol	f	0	f
13016	1	2977	2	Währungen	deutsch	t	0	f
13020	1	2978	2	Währungen und Wechselkurse für Feldtyp Währung	deutsch	t	0	f
13023	3	2979	1	\N	Espagñol	f	5	f
13024	1	2979	1	kein Wechselkurs vorhanden	deutsch	t	5	f
12984	1	2969	2	Mandant	deutsch	t	0	f
12983	3	2969	2	\N	Espagñol	f	0	f
12702	4	2898	3	Pour cette langue, la traduction automatique des champs de tableau sera activée ou désactivée. \\n Des champs de traduction seront supprimés ou ajoutés!	francais	t	180	f
13042	4	2983	3	contexte	francais	t	231	f
12988	1	2970	2	Mandant	deutsch	t	0	f
12987	3	2970	2	\N	Espagñol	f	0	f
12966	4	2964	3	es fonctions multi-tenant seront activé pour ce tableau	francais	t	140	f
13046	4	2984	3	additif	francais	t	231	f
12991	3	2971	2	\N	Espagñol	f	0	f
12995	3	2972	2	\N	Espagñol	f	0	f
12700	1	2898	3	Für diese Sprache wird die Sprachübersetzung für Tabellenfelder aktiviert oder deaktiviert. \\nÜbersetzungsfelder werden gelöscht oder hinzugefügt!	deutsch	t	180	t
12999	3	2973	3	\N	Espagñol	f	0	f
13000	1	2973	3	Wechselkurse	deutsch	t	0	f
13003	3	2974	3	\N	Espagñol	f	0	f
13004	1	2974	3	in	deutsch	t	0	f
13007	3	2975	3	\N	Espagñol	f	0	f
13008	1	2975	3	Wechselkurs	deutsch	t	0	f
13011	3	2976	3	\N	Espagñol	f	0	f
13012	1	2976	3	Code	deutsch	t	0	f
13015	3	2977	2	\N	Espagñol	f	0	f
13038	4	2982	3	menu contextuel	francais	t	231	f
12699	3	2898	3	Para este lenguaje, la traducción de idiomas para los campos de la tabla está activada o desactivada. \\\\\\\\\\\\\\\\ NÜbersetzungsfelder ser eliminado o añadido!	Espagñol	f	180	f
13027	3	2980	3	\N	Espagñol	f	127	f
13028	1	2980	3	Sprache abweichend für Inhalte	deutsch	t	127	f
13031	3	2981	3	\N	Espagñol	f	231	f
13032	1	2981	3	Hauptnavigation	deutsch	t	231	f
13035	3	2982	3	\N	Espagñol	f	231	f
13036	1	2982	3	Kontextmenü	deutsch	t	231	f
13039	3	2983	3	\N	Espagñol	f	231	f
13040	1	2983	3	Kontext	deutsch	t	231	f
13043	3	2984	3	\N	Espagñol	f	231	f
13044	1	2984	3	Zusatz	deutsch	t	231	f
13047	3	2985	3	\N	Espagñol	f	231	f
13048	1	2985	3	Untermenu	deutsch	t	231	f
12969	2	2965	2	tenants	english	t	0	f
12970	4	2965	2	locataires	francais	t	0	f
12974	4	2966	2	locataires	francais	t	0	f
12978	4	2967	2	locataire	francais	t	0	f
12982	4	2968	2	changement de locataire	francais	t	0	f
12986	4	2969	2	locataire	francais	t	0	f
12990	4	2970	2	locataire	francais	t	0	f
12994	4	2971	2	afficher les locataires	francais	t	0	f
12998	4	2972	2	afficher tous les locataires	francais	t	0	f
13002	4	2973	3	taux de change	francais	t	0	f
13006	4	2974	3	dans	francais	t	0	f
13010	4	2975	3	taux de change	francais	t	0	f
13014	4	2976	3	code	francais	t	0	f
13034	4	2981	3	navigation principale	francais	t	231	f
13026	4	2979	1	pas de taux de change disponible	francais	t	5	f
13030	4	2980	3	differentes langues pour ces données	francais	t	127	f
12976	1	2967	2	Mandant	deutsch	t	0	f
12980	1	2968	2	wechsle zu Mandant	deutsch	t	0	f
387	1	387	2	Profil	deutsch	t	\N	f
388	1	388	2	User-Profil	deutsch	t	\N	f
379	1	379	2	admin	deutsch	t	\N	f
380	1	380	2	Admin Einstellungen	deutsch	t	\N	f
5297	1	1828	2	Info	deutsch	t	\N	f
5300	1	1829	2	Info über LIMBAS	deutsch	t	\N	f
381	1	381	2	Hilfe	deutsch	t	\N	f
382	1	382	2	Hilfe	deutsch	t	\N	f
5432	1	1873	2	Abmelden	deutsch	t	\N	f
5435	1	1874	2	Abmelden	deutsch	t	\N	f
10824	1	2430	2	Datensatz sperren	deutsch	t	0	f
847	1	847	2	Hintergrund	deutsch	t	\N	f
848	1	848	2	Hintergrund-Farbe ändern	deutsch	t	\N	f
12941	2	2958	2	CustVar	english	t	0	f
12945	2	2959	2	Global variables	english	t	0	f
12949	2	2960	3	override	english	t	0	f
12953	2	2961	3	multitenancy	english	t	140	f
12957	2	2962	1	tenant	english	t	0	f
12961	2	2963	3	activate synchronization for this table	english	t	141	f
12965	2	2964	3	activate multitenancy for this table	english	t	140	f
12973	2	2966	2	tenants	english	t	0	f
12977	2	2967	2	tenant	english	t	0	f
12981	2	2968	2	switch tenant	english	t	0	f
12985	2	2969	2	tenant	english	t	0	f
12989	2	2970	2	tenant	english	t	0	f
12993	2	2971	2	show tenants	english	t	0	f
12997	2	2972	2	show all tenants	english	t	0	f
13005	2	2974	3	in	english	t	0	f
13013	2	2976	3	code	english	t	0	f
13017	2	2977	2	currency	english	t	0	f
13009	2	2975	3	exchange rate	english	t	0	f
13001	2	2973	3	exchange rates	english	t	0	f
13021	2	2978	2	currencies and exchange rates for currency field	english	t	0	f
13025	2	2979	1	no exchange rate available	english	t	5	f
13037	2	2982	3	context menu	english	t	231	f
13041	2	2983	3	context	english	t	231	f
13045	2	2984	3	supplement	english	t	231	f
13049	2	2985	3	submenu	english	t	231	f
13029	2	2980	3	language varying for contents	english	t	127	f
13050	4	2985	3	sous-menu	francais	t	231	f
6059	4	1	1	accès refusée! 	francais	t	2	f
6065	4	7	1	host 	francais	t	4	f
6066	4	8	1	IP 	francais	t	4	f
6067	4	9	1	agent 	francais	t	4	f
6068	4	10	1	autentification 	francais	t	4	f
6069	4	11	1	société 	francais	t	4	f
6070	4	24	1	Voulez-vous ajouter un nouvel enregistrement? 	francais	t	5	f
6071	4	25	1	Une erreur inattendue est survenue! 	francais	t	5	f
6073	4	27	1	additif 	francais	t	12	f
6074	4	29	1	valeur 	francais	t	12	f
6075	4	30	1	chercher 	francais	t	12	f
6076	4	33	1	enregistrer 	francais	t	12	f
6077	4	34	1	nouvelle valeur 	francais	t	12	f
6078	4	49	1	Voulez-vous archiver cet enregistrement? 	francais	t	13	f
6079	4	50	1	Voulez-vous vraiment supprimer cet enregistrement? 	francais	t	13	f
6080	4	51	1	Souhaitez-vous imprimer un raport pour les enregistrements choisis? 	francais	t	13	f
6083	4	56	1	Une erreur est survenue! 	francais	t	13	f
6084	4	58	1	Erreur de synthaxe! Les données saisies ne correspondent pas au type de donnée attendues. 	francais	t	14	f
6085	4	59	1	remplacer par valeur 	francais	t	14	f
6086	4	60	1	sous condition 	francais	t	14	f
6090	4	84	1	Supprimer l'enregistrement? 	francais	t	17	f
6092	4	86	1	entrées 	francais	t	17	f
6094	4	88	1	lignes 	francais	t	17	f
6095	4	89	1	pages 	francais	t	17	f
6096	4	93	1	résultat 	francais	t	17	f
6099	4	96	1	afficher 	francais	t	17	f
6101	4	98	1	Aucun enregistrement! 	francais	t	17	f
6103	4	101	1	recherche détaillée 	francais	t	19	f
6105	4	103	1	rechercher dans 	francais	t	19	f
6106	4	106	1	contient 	francais	t	19	f
6107	4	107	1	est 	francais	t	19	f
6108	4	108	1	commence 	francais	t	19	f
6109	4	109	1	tenez compte des majuscules/minuscules 	francais	t	19	f
6111	4	112	1	Cet enregistrement ne peut pas etre supprimé car des valeurs ont été saisies! 	francais	t	22	f
6113	4	114	1	Vous n'avez pas de droit suffisant pour effectuer cette action! 	francais	t	23	f
6115	4	116	1	L'enregistrement a été supprimé avec succès! 	francais	t	25	f
6116	4	118	1	Vous n'avez pas de droit de champ! 	francais	t	27	f
6117	4	122	1	aucune relation presente 	francais	t	34	f
6123	4	128	1	Le fichier ne peut pas être sauvegardé! Vérifiez le chemin spécifié. 	francais	t	41	t
6124	4	129	1	La taille maximale d'un fichier téléchargé est limité à 	francais	t	41	f
6125	4	133	1	Le fichier téléchargé a un format inconnu. 	francais	t	41	f
6126	4	134	1	Erreur! Les champs suivants sont incorrectes: 	francais	t	37	f
6128	4	138	1	Merci de vérifier vos données. 	francais	t	41	f
6129	4	140	1	Données d'utilisateur 	francais	t	46	f
6130	4	141	1	mot de passe 	francais	t	46	f
6131	4	142	1	prénom 	francais	t	46	f
6133	4	144	1	e-mail 	francais	t	46	f
6135	4	146	1	Paramètres généraux 	francais	t	46	f
6136	4	154	1	Echantillon de couleur personnel 	francais	t	47	f
6137	4	155	1	Echantillon de couleur 	francais	t	47	f
6138	4	156	1	valeur couleur 	francais	t	47	f
6140	4	160	1	supprimer 	francais	t	49	f
6159	4	200	1	nouveau modèle 	francais	t	55	f
6162	4	209	1	nom de fichier 	francais	t	66	f
6163	4	210	1	taille 	francais	t	66	f
6207	4	293	1	sem. 	francais	t	86	f
6208	4	294	1	couleur 	francais	t	86	f
6209	4	295	1	remarque 	francais	t	86	f
6210	4	296	1	mois 	francais	t	86	f
6211	4	297	1	lancer 	francais	t	86	f
6214	4	300	1	vue calendrier 	francais	t	86	f
6215	4	301	1	vue tableau 	francais	t	86	f
6216	4	302	1	enregistrer 	francais	t	86	f
6217	4	303	1	aucune entrée! 	francais	t	87	f
6218	4	304	1	vue calendrier 	francais	t	88	f
6240	4	349	2	créer 	francais	t	0	f
6241	4	350	2	créer nouvel enregistrement 	francais	t	0	f
6242	4	351	2	éditer 	francais	t	0	f
6243	4	352	2	éditer l'enregistrement 	francais	t	0	f
6244	4	353	2	éditer 	francais	t	0	f
6245	4	354	2	éditer la liste 	francais	t	0	f
6248	4	357	2	détails  	francais	t	0	f
6249	4	358	2	Affichage des détail de l'enregistrement 	francais	t	0	f
6251	4	360	2	export de liste 	francais	t	0	f
6252	4	361	2	adapter 	francais	t	0	f
6253	4	362	2	Modifier champ de multi-sélection 	francais	t	0	f
6255	4	364	2	information sur l'enregistrement 	francais	t	0	f
6259	4	368	2	supprimer l'enregistrement 	francais	t	0	f
6996	4	1373	2	choix (AJAX)	francais	t	0	f
7022	4	1399	2	bloc de texte	francais	t	0	f
7189	4	1595	2	nombre réel (pourcentage)	francais	t	0	f
7190	4	1596	2	pourcentage composé d''un nombre réel	francais	t	0	f
7100	4	1485	2	sélection (case à cocher)	francais	t	0	f
7197	4	1603	2	sauvegarder le filtre	francais	t	0	f
7198	4	1604	2	filtre	francais	t	0	f
7199	4	1605	2	vue des filtres	francais	t	0	f
7546	4	1966	2	rendre le filtre public	francais	t	0	f
7589	4	2009	1	enregistrer le filtre	francais	t	0	f
7590	4	2010	1	supprimer le filtre	francais	t	0	f
7680	4	2086	2	héritage	francais	t	0	f
7832	4	2124	2	+xx xx xxxx ou +xx xxxxx	francais	t	0	f
10470	4	2343	3	comparer les tableaux de filtres	francais	t	154	f
10978	4	2468	2	nombres à virgule "float"	francais	t	0	f
13103	3	2999	3	\N	Espagñol	f	110	f
11514	4	2602	3	affichage de la date en format strftime(): par exemple %V,%G,%Y | Y-m-d H:i:s	francais	t	110	f
11830	4	2681	1	est vide	francais	t	19	f
11834	4	2682	1	n'est pas vide	francais	t	19	f
12182	4	2768	2	filtre	francais	t	0	f
12186	4	2769	2	gérer les filtre publics	francais	t	0	f
12246	4	2784	3	filtres publics	francais	t	210	f
12250	4	2785	3	tous les filtres	francais	t	210	f
12338	4	2807	3	champs affichés dans la vue de lien	francais	t	121	f
12798	4	2922	3	recherche complète	francais	t	110	f
12802	4	2923	3	le champ sera inclu dans la recherche de tableau globale	francais	t	110	f
12806	4	2924	3	tuile	francais	t	175	f
12810	4	2925	3	cadre	francais	t	173	f
12814	4	2926	3	examiner	francais	t	225	f
12818	4	2927	1	La version %s est disponible!	francais	t	0	f
12822	4	2928	1	Cette version est actuelle!	francais	t	0	f
12826	4	2929	1	Vérifier les mises à jour.	francais	t	0	f
12830	4	2930	1	version actuelle	francais	t	0	f
12834	4	2931	2	favorits	francais	t	0	f
12838	4	2932	2	favorits	francais	t	0	f
12842	4	2933	2	mémoire externe	francais	t	0	f
12846	4	2934	2	mémoire de fichier externe	francais	t	0	f
12850	4	2935	2	imprimante	francais	t	0	f
12854	4	2936	2	gérer l'imprimante	francais	t	0	f
12858	4	2937	2	imprimer	francais	t	0	f
12862	4	2938	2	imprimer ce document	francais	t	0	f
12866	4	2939	1	Sur l'imprimante	francais	t	23	f
12870	4	2940	3	sauvegarder cette configuration	francais	t	226	f
12874	4	2941	3	vérifier la syntaxe	francais	t	226	f
12878	4	2942	3	sauvegarder la requête	francais	t	226	f
12882	4	2943	3	supprimer la publication	francais	t	226	f
12886	4	2944	2	numeric	francais	t	0	f
12890	4	2945	2	séléction	francais	t	0	f
12794	4	2921	1	Pas tous les enregistrements ont été liés!	francais	t	25	f
12898	4	2947	2	fichier	francais	t	0	f
12902	4	2948	2	autres	francais	t	0	f
12906	4	2949	2	Système Limbas	francais	t	0	f
12910	4	2950	3	clé primaire	francais	t	140	f
12922	4	2953	2	éditeur de menu individuel	francais	t	0	f
12930	4	2955	3	devoir	francais	t	104	f
12934	4	2956	3	niveau	francais	t	104	f
12938	4	2957	1	réinscriptible	francais	t	15	f
12942	4	2958	2	CustVar	francais	t	0	f
12946	4	2959	2	variables globales	francais	t	0	f
12950	4	2960	3	sera réinscrit	francais	t	0	f
12954	4	2961	3	multi-tenant	francais	t	140	f
12958	4	2962	1	locataire	francais	t	0	f
12962	4	2963	3	les fonctions de synchronisation seront activé pour ce tableau	francais	t	141	f
13018	4	2977	2	devises	francais	t	0	f
13022	4	2978	2	devises et taux de change pour le champ "taux de change"	francais	t	0	f
5438	1	1875	2	reset	deutsch	t	\N	f
5441	1	1876	2	Anwendung zurücksetzen	deutsch	t	\N	f
8145	1	2203	2	myLimbas	deutsch	t	\N	f
8149	1	2204	2	Persönliche Daten	deutsch	t	\N	f
12832	1	2931	2	Favoriten	deutsch	t	0	f
12836	1	2932	2	Favoriten	deutsch	t	0	f
13051	3	2986	2	\N	Espagñol	f	0	f
13056	1	2987	2	z.B. Kunde (1) -> Ansprechpartner (n)	deutsch	t	0	f
13055	3	2987	2	\N	Espagñol	f	0	f
13059	3	2988	3	\N	Espagñol	f	173	f
13060	1	2988	3	Verknüpfungspfad	deutsch	t	173	f
13063	3	2989	2	\N	Espagñol	f	0	f
13067	3	2990	2	\N	Espagñol	f	0	f
13075	3	2992	3	\N	Espagñol	f	110	f
13076	1	2992	3	Berechnung der Anzahl von Verknüpfungen mit oder ohne Berücksichtigung der Archivierung	deutsch	t	110	f
13064	1	2989	2	PHP Editor	deutsch	t	0	f
13068	1	2990	2	PHP Editor	deutsch	t	0	f
13071	3	2991	3	\N	Espagñol	f	110	f
13072	1	2991	3	Berechnung	deutsch	t	110	f
13084	1	2994	3	mit Archivierten	deutsch	t	110	f
13052	1	2986	2	Verknüpfung 1:n direkt	deutsch	t	0	f
13080	1	2993	3	ohne Archivierte	deutsch	t	110	f
13079	3	2993	3	\N	Espagñol	f	110	f
13083	3	2994	3	\N	Espagñol	f	110	f
13087	3	2995	3	\N	Espagñol	f	164	f
13088	1	2995	3	Index-Einstellungen Postgresql	deutsch	t	164	f
13092	1	2996	2	Verknüpfung rückwertig	deutsch	t	0	f
13091	3	2996	2	\N	Espagñol	f	0	f
13096	1	2997	2	basierend auf existierende Verknüpfung	deutsch	t	0	f
13095	3	2997	2	\N	Espagñol	f	0	f
13099	3	2998	3	\N	Espagñol	f	110	f
13100	1	2998	3	Darstellung	deutsch	t	110	f
13054	4	2986	2	Lien 1: n directement	francais	t	0	f
13058	4	2987	2	\N	francais	t	0	f
13062	4	2988	3	Chemin du lien	francais	t	173	f
13066	4	2989	2	Éditeur PHP	francais	t	0	f
13070	4	2990	2	Éditeur PHP	francais	t	0	f
13074	4	2991	3	calcul	francais	t	110	f
13078	4	2992	3	Calcul du nombre de liens	francais	t	110	f
13082	4	2993	3	sans archivé	francais	t	110	f
13086	4	2994	3	avec archivé	francais	t	110	f
13090	4	2995	3	Paramètres d'index PostgreSQL	francais	t	164	f
13094	4	2996	2	Lien vers l'arrière	francais	t	0	f
13104	1	2999	3	Dartellung als Checkbox, Radio oder Auswahlfeld	deutsch	t	110	f
12720	1	2903	2	Bild URL	deutsch	t	0	f
12719	3	2903	2	imagen	Espagñol	f	0	f
13107	3	3000	3	\N	Espagñol	f	140	f
13108	1	3000	3	Gültigkeit	deutsch	t	140	f
13111	3	3001	3	\N	Espagñol	f	140	f
13112	1	3001	3	aktiviert den Gültigkeitsfilter	deutsch	t	140	f
13115	3	3002	2	\N	Espagñol	f	0	f
13119	3	3003	2	\N	Espagñol	f	0	f
12992	1	2971	2	zeige Mandanten	deutsch	t	0	f
12996	1	2972	2	zeige alle Mandanten	deutsch	t	0	f
7981	1	2162	2	vergleiche mit	deutsch	t	\N	f
7985	1	2163	2	Version vergleichen	deutsch	t	\N	f
10260	1	2291	2	zeige selbstverknüpfte	deutsch	t	0	f
10264	1	2292	2	zeige mit sich selbst verknüpfte Datensätze	deutsch	t	0	f
10964	1	2465	2	zeige Summe	deutsch	t	0	f
10968	1	2466	2	zeige Summe von Datensätzen	deutsch	t	0	f
7993	1	2165	2	Symbolleiste	deutsch	t	\N	f
7997	1	2166	2	zeige Symbolleiste	deutsch	t	\N	f
11084	1	2495	2	gruppiere Sparten	deutsch	t	0	f
11088	1	2496	2	gruppiere Feldüberschriften	deutsch	t	0	f
11100	1	2499	2	Ansicht zurücksetzen	deutsch	t	0	f
11104	1	2500	2	aktuelle Einstellung speichern	deutsch	t	0	f
13116	1	3002	2	zeige Gültige	deutsch	t	0	f
13120	1	3003	2	zeige gültige Datensätze	deutsch	t	0	f
13123	3	3004	2	\N	Espagñol	f	0	f
13124	1	3004	2	Gültig von	deutsch	t	0	f
13127	3	3005	2	\N	Espagñol	f	0	f
13128	1	3005	2	Gültigkeits Datum - Gültig von	deutsch	t	0	f
13131	3	3006	2	\N	Espagñol	f	0	f
13132	1	3006	2	Gültig bis	deutsch	t	0	f
13135	3	3007	2	\N	Espagñol	f	0	f
13136	1	3007	2	Gültigkeits Datum - Gültig bis	deutsch	t	0	f
13139	3	3008	1	\N	Espagñol	f	0	f
13140	1	3008	1	Gültigkeitszeitraum	deutsch	t	0	f
12721	2	2903	2	image URL	english	t	0	f
12725	2	2904	2	WEB image  URL	english	t	0	f
13053	2	2986	2	relation 1:n direct	english	t	0	f
13057	2	2987	2	e.g.. Customer(1) -> Conract(n)	english	t	0	f
13061	2	2988	3	relationpath	english	t	173	f
13065	2	2989	2	PHP editor	english	t	0	f
13069	2	2990	2	PHP editor	english	t	0	f
13073	2	2991	3	calculation	english	t	110	f
13077	2	2992	3	calculation of relationcount with consideration of archived relations	english	t	110	f
13081	2	2993	3	without archived	english	t	110	f
13085	2	2994	3	with archived	english	t	110	f
13089	2	2995	3	index settings of Postgresql	english	t	164	f
13093	2	2996	2	backward relation	english	t	0	f
13097	2	2997	2	based on existing relation	english	t	0	f
13101	2	2998	3	presentation	english	t	110	f
13105	2	2999	3	presentation as Checkbox, Radio, Select	english	t	110	f
13109	2	3000	3	validity	english	t	140	f
13113	2	3001	3	activate validityfilter	english	t	140	f
13117	2	3002	2	show valid	english	t	0	f
13121	2	3003	2	show valid datasets	english	t	0	f
13125	2	3004	2	valid from	english	t	0	f
13133	2	3006	2	valid to	english	t	0	f
13129	2	3005	2	Validity date - valid from	english	t	0	f
13137	2	3007	2	Validity date - valid to	english	t	0	f
13141	2	3008	1	Validity period	english	t	0	f
12726	4	2904	2	URL de l'image	francais	t	0	f
13098	4	2997	2	basé sur le lien existant	francais	t	0	f
13102	4	2998	3	présentation	francais	t	110	f
13106	4	2999	3	Afficher sous forme de case à cocher, de radio ou de champ de sélection	francais	t	110	f
13110	4	3000	3	validité	francais	t	140	f
13114	4	3001	3	active le filtre de validité	francais	t	140	f
13118	4	3002	2	montrer valide	francais	t	0	f
13122	4	3003	2	afficher les enregistrements valides	francais	t	0	f
13126	4	3004	2	Valide à partir de	francais	t	0	f
13130	4	3005	2	Date de validité - Valable du	francais	t	0	f
13134	4	3006	2	date d'expiration	francais	t	0	f
13138	4	3007	2	Date de validité - Valable jusqu'au	francais	t	0	f
13142	4	3008	1	Période de validité	francais	t	0	f
\.


--
-- Data for Name: lmb_lang_depend; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_lang_depend (id, language_id, element_id, typ, wert, language, edit, lmfile, js) FROM stdin;
100000	3	10000	4		Espagñol	f	Tablegroup: Limbassys	f
100001	1	10000	4	Limbassys	deutsch	t	Tablegroup: Limbassys	f
100002	2	10000	4		english	f	Tablegroup: Limbassys	f
100003	4	10000	4		francais	f	Tablegroup: Limbassys	f
100004	3	10001	4		Espagñol	f	Tablegroup: Limbas Systemtabellen	f
100005	1	10001	4	Limbas Systemtabellen	deutsch	t	Tablegroup: Limbas Systemtabellen	f
100006	2	10001	4		english	f	Tablegroup: Limbas Systemtabellen	f
100007	4	10001	4		francais	f	Tablegroup: Limbas Systemtabellen	f
100008	3	10002	4		Espagñol	f	Table: ldms_files	f
100009	1	10002	4	Files	deutsch	t	Table: ldms_files	f
100010	2	10002	4		english	f	Table: ldms_files	f
100011	4	10002	4		francais	f	Table: ldms_files	f
100012	3	10003	4		Espagñol	f	ldms_files:LMSECTION	f
100013	1	10003	4	Attribute	deutsch	t	ldms_files:LMSECTION	f
100014	2	10003	4		english	f	ldms_files:LMSECTION	f
100015	4	10003	4		francais	f	ldms_files:LMSECTION	f
100016	3	10004	4		Espagñol	f	ldms_files:LMSECTION	f
100017	1	10004	4	Attribute	deutsch	t	ldms_files:LMSECTION	f
100018	2	10004	4		english	f	ldms_files:LMSECTION	f
100019	4	10004	4		francais	f	ldms_files:LMSECTION	f
100020	3	10005	4		Espagñol	f	ldms_files:ERSTGROUP	f
100021	1	10005	4	ERSTGROUP	deutsch	t	ldms_files:ERSTGROUP	f
100022	2	10005	4		english	f	ldms_files:ERSTGROUP	f
100023	4	10005	4		francais	f	ldms_files:ERSTGROUP	f
100024	3	10006	4		Espagñol	f	ldms_files:ERSTGROUP	f
100025	1	10006	4	ERSTGROUP	deutsch	t	ldms_files:ERSTGROUP	f
100026	2	10006	4		english	f	ldms_files:ERSTGROUP	f
100027	4	10006	4		francais	f	ldms_files:ERSTGROUP	f
100028	3	10007	4		Espagñol	f	ldms_files:ERSTDATUM	f
100029	1	10007	4	Erstellt am	deutsch	t	ldms_files:ERSTDATUM	f
100030	2	10007	4		english	f	ldms_files:ERSTDATUM	f
100031	4	10007	4		francais	f	ldms_files:ERSTDATUM	f
100032	3	10008	4		Espagñol	f	ldms_files:ERSTDATUM	f
100033	1	10008	4	Erstellt am	deutsch	t	ldms_files:ERSTDATUM	f
100034	2	10008	4		english	f	ldms_files:ERSTDATUM	f
100035	4	10008	4		francais	f	ldms_files:ERSTDATUM	f
100036	3	10009	4		Espagñol	f	ldms_files:ERSTUSER	f
100037	1	10009	4	Erstellt von	deutsch	t	ldms_files:ERSTUSER	f
100038	2	10009	4		english	f	ldms_files:ERSTUSER	f
100039	4	10009	4		francais	f	ldms_files:ERSTUSER	f
100040	3	10010	4		Espagñol	f	ldms_files:ERSTUSER	f
100041	1	10010	4	Erstellt von	deutsch	t	ldms_files:ERSTUSER	f
100042	2	10010	4		english	f	ldms_files:ERSTUSER	f
100043	4	10010	4		francais	f	ldms_files:ERSTUSER	f
100044	3	10011	4		Espagñol	f	ldms_files:LEVEL	f
100045	1	10011	4	LEVEL	deutsch	t	ldms_files:LEVEL	f
100046	2	10011	4		english	f	ldms_files:LEVEL	f
100047	4	10011	4		francais	f	ldms_files:LEVEL	f
100048	3	10012	4		Espagñol	f	ldms_files:LEVEL	f
100049	1	10012	4	LEVEL	deutsch	t	ldms_files:LEVEL	f
100050	2	10012	4		english	f	ldms_files:LEVEL	f
100051	4	10012	4		francais	f	ldms_files:LEVEL	f
100052	3	10013	4		Espagñol	f	ldms_files:TYP	f
100053	1	10013	4	TYP	deutsch	t	ldms_files:TYP	f
100054	2	10013	4		english	f	ldms_files:TYP	f
100055	4	10013	4		francais	f	ldms_files:TYP	f
100056	3	10014	4		Espagñol	f	ldms_files:TYP	f
100057	1	10014	4	TYP	deutsch	t	ldms_files:TYP	f
100058	2	10014	4		english	f	ldms_files:TYP	f
100059	4	10014	4		francais	f	ldms_files:TYP	f
100060	3	10015	4		Espagñol	f	ldms_files:SORT	f
100061	1	10015	4	Sortierung	deutsch	t	ldms_files:SORT	f
100062	2	10015	4		english	f	ldms_files:SORT	f
100063	4	10015	4		francais	f	ldms_files:SORT	f
100064	3	10016	4		Espagñol	f	ldms_files:SORT	f
100065	1	10016	4	Sortierung	deutsch	t	ldms_files:SORT	f
100066	2	10016	4		english	f	ldms_files:SORT	f
100067	4	10016	4		francais	f	ldms_files:SORT	f
100068	3	10017	4		Espagñol	f	ldms_files:DATID	f
100069	1	10017	4	DATID	deutsch	t	ldms_files:DATID	f
100070	2	10017	4		english	f	ldms_files:DATID	f
100071	4	10017	4		francais	f	ldms_files:DATID	f
100072	3	10018	4		Espagñol	f	ldms_files:DATID	f
100073	1	10018	4	DATID	deutsch	t	ldms_files:DATID	f
100074	2	10018	4		english	f	ldms_files:DATID	f
100075	4	10018	4		francais	f	ldms_files:DATID	f
100076	3	10019	4		Espagñol	f	ldms_files:TABID	f
100077	1	10019	4	TABID	deutsch	t	ldms_files:TABID	f
100078	2	10019	4		english	f	ldms_files:TABID	f
100079	4	10019	4		francais	f	ldms_files:TABID	f
100080	3	10020	4		Espagñol	f	ldms_files:TABID	f
100081	1	10020	4	TABID	deutsch	t	ldms_files:TABID	f
100082	2	10020	4		english	f	ldms_files:TABID	f
100083	4	10020	4		francais	f	ldms_files:TABID	f
100084	3	10021	4		Espagñol	f	ldms_files:FIELDID	f
100085	1	10021	4	FIELDID	deutsch	t	ldms_files:FIELDID	f
100086	2	10021	4		english	f	ldms_files:FIELDID	f
100087	4	10021	4		francais	f	ldms_files:FIELDID	f
100088	3	10022	4		Espagñol	f	ldms_files:FIELDID	f
100089	1	10022	4	FIELDID	deutsch	t	ldms_files:FIELDID	f
100090	2	10022	4		english	f	ldms_files:FIELDID	f
100091	4	10022	4		francais	f	ldms_files:FIELDID	f
100092	3	10023	4		Espagñol	f	ldms_files:NAME	f
100093	1	10023	4	NAME	deutsch	t	ldms_files:NAME	f
100094	2	10023	4		english	f	ldms_files:NAME	f
100095	4	10023	4		francais	f	ldms_files:NAME	f
100096	3	10024	4		Espagñol	f	ldms_files:NAME	f
100097	1	10024	4	NAME	deutsch	t	ldms_files:NAME	f
100098	2	10024	4		english	f	ldms_files:NAME	f
100099	4	10024	4		francais	f	ldms_files:NAME	f
100100	3	10025	4		Espagñol	f	ldms_files:SECNAME	f
100101	1	10025	4	Phys.name	deutsch	t	ldms_files:SECNAME	f
100102	2	10025	4		english	f	ldms_files:SECNAME	f
100103	4	10025	4		francais	f	ldms_files:SECNAME	f
100104	3	10026	4		Espagñol	f	ldms_files:SECNAME	f
100105	1	10026	4	Phys.name	deutsch	t	ldms_files:SECNAME	f
100106	2	10026	4		english	f	ldms_files:SECNAME	f
100107	4	10026	4		francais	f	ldms_files:SECNAME	f
100108	3	10027	4		Espagñol	f	ldms_files:MIMETYPE	f
100109	1	10027	4	Mimetype	deutsch	t	ldms_files:MIMETYPE	f
100110	2	10027	4		english	f	ldms_files:MIMETYPE	f
100111	4	10027	4		francais	f	ldms_files:MIMETYPE	f
100112	3	10028	4		Espagñol	f	ldms_files:MIMETYPE	f
100113	1	10028	4	Mimetype	deutsch	t	ldms_files:MIMETYPE	f
100114	2	10028	4		english	f	ldms_files:MIMETYPE	f
100115	4	10028	4		francais	f	ldms_files:MIMETYPE	f
100116	3	10029	4		Espagñol	f	ldms_files:SIZE	f
100117	1	10029	4	Größe	deutsch	t	ldms_files:SIZE	f
100118	2	10029	4		english	f	ldms_files:SIZE	f
100119	4	10029	4		francais	f	ldms_files:SIZE	f
100120	3	10030	4		Espagñol	f	ldms_files:SIZE	f
100121	1	10030	4	Größe	deutsch	t	ldms_files:SIZE	f
100122	2	10030	4		english	f	ldms_files:SIZE	f
100123	4	10030	4		francais	f	ldms_files:SIZE	f
100124	3	10031	4		Espagñol	f	ldms_files:CHECKED	f
100125	1	10031	4	geprüft	deutsch	t	ldms_files:CHECKED	f
100126	2	10031	4		english	f	ldms_files:CHECKED	f
100127	4	10031	4		francais	f	ldms_files:CHECKED	f
100128	3	10032	4		Espagñol	f	ldms_files:CHECKED	f
100129	1	10032	4	geprüft	deutsch	t	ldms_files:CHECKED	f
100130	2	10032	4		english	f	ldms_files:CHECKED	f
100131	4	10032	4		francais	f	ldms_files:CHECKED	f
100132	3	10033	4		Espagñol	f	ldms_files:PERM	f
100133	1	10033	4	freigegeben	deutsch	t	ldms_files:PERM	f
100134	2	10033	4		english	f	ldms_files:PERM	f
100135	4	10033	4		francais	f	ldms_files:PERM	f
100136	3	10034	4		Espagñol	f	ldms_files:PERM	f
100137	1	10034	4	freigegeben	deutsch	t	ldms_files:PERM	f
100138	2	10034	4		english	f	ldms_files:PERM	f
100139	4	10034	4		francais	f	ldms_files:PERM	f
100140	3	10035	4		Espagñol	f	ldms_files:LMLOCK	f
100141	1	10035	4	gesperrt	deutsch	t	ldms_files:LMLOCK	f
100142	2	10035	4		english	f	ldms_files:LMLOCK	f
100143	4	10035	4		francais	f	ldms_files:LMLOCK	f
100144	3	10036	4		Espagñol	f	ldms_files:LMLOCK	f
100145	1	10036	4	gesperrt	deutsch	t	ldms_files:LMLOCK	f
100146	2	10036	4		english	f	ldms_files:LMLOCK	f
100147	4	10036	4		francais	f	ldms_files:LMLOCK	f
100148	3	10037	4		Espagñol	f	ldms_files:LOCKUSER	f
100149	1	10037	4	LOCKUSER	deutsch	t	ldms_files:LOCKUSER	f
100150	2	10037	4		english	f	ldms_files:LOCKUSER	f
100151	4	10037	4		francais	f	ldms_files:LOCKUSER	f
100152	3	10038	4		Espagñol	f	ldms_files:LOCKUSER	f
100153	1	10038	4	LOCKUSER	deutsch	t	ldms_files:LOCKUSER	f
100154	2	10038	4		english	f	ldms_files:LOCKUSER	f
100155	4	10038	4		francais	f	ldms_files:LOCKUSER	f
100156	3	10039	4		Espagñol	f	ldms_files:CHECKUSER	f
100157	1	10039	4	CHECKUSER	deutsch	t	ldms_files:CHECKUSER	f
100158	2	10039	4		english	f	ldms_files:CHECKUSER	f
100159	4	10039	4		francais	f	ldms_files:CHECKUSER	f
100160	3	10040	4		Espagñol	f	ldms_files:CHECKUSER	f
100161	1	10040	4	CHECKUSER	deutsch	t	ldms_files:CHECKUSER	f
100162	2	10040	4		english	f	ldms_files:CHECKUSER	f
100163	4	10040	4		francais	f	ldms_files:CHECKUSER	f
100164	3	10041	4		Espagñol	f	ldms_files:PERMUSER	f
100165	1	10041	4	PERMUSER	deutsch	t	ldms_files:PERMUSER	f
100166	2	10041	4		english	f	ldms_files:PERMUSER	f
100167	4	10041	4		francais	f	ldms_files:PERMUSER	f
100168	3	10042	4		Espagñol	f	ldms_files:PERMUSER	f
100169	1	10042	4	PERMUSER	deutsch	t	ldms_files:PERMUSER	f
100170	2	10042	4		english	f	ldms_files:PERMUSER	f
100171	4	10042	4		francais	f	ldms_files:PERMUSER	f
100172	3	10043	4		Espagñol	f	ldms_files:PERMDATE	f
100173	1	10043	4	PERMDATE	deutsch	t	ldms_files:PERMDATE	f
100174	2	10043	4		english	f	ldms_files:PERMDATE	f
100175	4	10043	4		francais	f	ldms_files:PERMDATE	f
100176	3	10044	4		Espagñol	f	ldms_files:PERMDATE	f
100177	1	10044	4	PERMDATE	deutsch	t	ldms_files:PERMDATE	f
100178	2	10044	4		english	f	ldms_files:PERMDATE	f
100179	4	10044	4		francais	f	ldms_files:PERMDATE	f
100180	3	10045	4		Espagñol	f	ldms_files:CHECKDATE	f
100181	1	10045	4	CHECKDATE	deutsch	t	ldms_files:CHECKDATE	f
100182	2	10045	4		english	f	ldms_files:CHECKDATE	f
100183	4	10045	4		francais	f	ldms_files:CHECKDATE	f
100184	3	10046	4		Espagñol	f	ldms_files:CHECKDATE	f
100185	1	10046	4	CHECKDATE	deutsch	t	ldms_files:CHECKDATE	f
100186	2	10046	4		english	f	ldms_files:CHECKDATE	f
100187	4	10046	4		francais	f	ldms_files:CHECKDATE	f
100188	3	10047	4		Espagñol	f	ldms_files:LOCKDATE	f
100189	1	10047	4	LOCKDATE	deutsch	t	ldms_files:LOCKDATE	f
100190	2	10047	4		english	f	ldms_files:LOCKDATE	f
100191	4	10047	4		francais	f	ldms_files:LOCKDATE	f
100192	3	10048	4		Espagñol	f	ldms_files:LOCKDATE	f
100193	1	10048	4	LOCKDATE	deutsch	t	ldms_files:LOCKDATE	f
100194	2	10048	4		english	f	ldms_files:LOCKDATE	f
100195	4	10048	4		francais	f	ldms_files:LOCKDATE	f
100196	3	10049	4		Espagñol	f	ldms_files:VID	f
100197	1	10049	4	VID	deutsch	t	ldms_files:VID	f
100198	2	10049	4		english	f	ldms_files:VID	f
100199	4	10049	4		francais	f	ldms_files:VID	f
100200	3	10050	4		Espagñol	f	ldms_files:VID	f
100201	1	10050	4	VID	deutsch	t	ldms_files:VID	f
100202	2	10050	4		english	f	ldms_files:VID	f
100203	4	10050	4		francais	f	ldms_files:VID	f
100204	3	10051	4		Espagñol	f	ldms_files:VACT	f
100205	1	10051	4	VACT	deutsch	t	ldms_files:VACT	f
100206	2	10051	4		english	f	ldms_files:VACT	f
100207	4	10051	4		francais	f	ldms_files:VACT	f
100208	3	10052	4		Espagñol	f	ldms_files:VACT	f
100209	1	10052	4	VACT	deutsch	t	ldms_files:VACT	f
100210	2	10052	4		english	f	ldms_files:VACT	f
100211	4	10052	4		francais	f	ldms_files:VACT	f
100212	3	10053	4		Espagñol	f	ldms_files:VDESC	f
100213	1	10053	4	VDESC	deutsch	t	ldms_files:VDESC	f
100214	2	10053	4		english	f	ldms_files:VDESC	f
100215	4	10053	4		francais	f	ldms_files:VDESC	f
100216	3	10054	4		Espagñol	f	ldms_files:VDESC	f
100217	1	10054	4	VDESC	deutsch	t	ldms_files:VDESC	f
100218	2	10054	4		english	f	ldms_files:VDESC	f
100219	4	10054	4		francais	f	ldms_files:VDESC	f
100220	3	10055	4		Espagñol	f	ldms_files:VPID	f
100221	1	10055	4	VPID	deutsch	t	ldms_files:VPID	f
100222	2	10055	4		english	f	ldms_files:VPID	f
100223	4	10055	4		francais	f	ldms_files:VPID	f
100224	3	10056	4		Espagñol	f	ldms_files:VPID	f
100225	1	10056	4	VPID	deutsch	t	ldms_files:VPID	f
100226	2	10056	4		english	f	ldms_files:VPID	f
100227	4	10056	4		francais	f	ldms_files:VPID	f
100228	3	10057	4		Espagñol	f	ldms_files:THUMB_OK	f
100229	1	10057	4	Vorschau	deutsch	t	ldms_files:THUMB_OK	f
100230	2	10057	4		english	f	ldms_files:THUMB_OK	f
100231	4	10057	4		francais	f	ldms_files:THUMB_OK	f
100232	3	10058	4		Espagñol	f	ldms_files:THUMB_OK	f
100233	1	10058	4	Vorschau	deutsch	t	ldms_files:THUMB_OK	f
100234	2	10058	4		english	f	ldms_files:THUMB_OK	f
100235	4	10058	4		francais	f	ldms_files:THUMB_OK	f
100236	3	10059	4		Espagñol	f	ldms_files:META	f
100237	1	10059	4	META	deutsch	t	ldms_files:META	f
100238	2	10059	4		english	f	ldms_files:META	f
100239	4	10059	4		francais	f	ldms_files:META	f
100240	3	10060	4		Espagñol	f	ldms_files:META	f
100241	1	10060	4	META	deutsch	t	ldms_files:META	f
100242	2	10060	4		english	f	ldms_files:META	f
100243	4	10060	4		francais	f	ldms_files:META	f
100244	3	10061	4		Espagñol	f	ldms_files:INFO	f
100245	1	10061	4	Info	deutsch	t	ldms_files:INFO	f
100246	2	10061	4		english	f	ldms_files:INFO	f
100247	4	10061	4		francais	f	ldms_files:INFO	f
100248	3	10062	4		Espagñol	f	ldms_files:INFO	f
100249	1	10062	4	Info	deutsch	t	ldms_files:INFO	f
100250	2	10062	4		english	f	ldms_files:INFO	f
100251	4	10062	4		francais	f	ldms_files:INFO	f
100252	3	10063	4		Espagñol	f	ldms_files:CONTENT	f
100253	1	10063	4	Document-referenz	deutsch	t	ldms_files:CONTENT	f
100254	2	10063	4		english	f	ldms_files:CONTENT	f
100255	4	10063	4		francais	f	ldms_files:CONTENT	f
100256	3	10064	4		Espagñol	f	ldms_files:CONTENT	f
100257	1	10064	4	Content	deutsch	t	ldms_files:CONTENT	f
100258	2	10064	4		english	f	ldms_files:CONTENT	f
100259	4	10064	4		francais	f	ldms_files:CONTENT	f
100260	3	10065	4		Espagñol	f	ldms_files:MD5	f
100261	1	10065	4	MD5	deutsch	t	ldms_files:MD5	f
100262	2	10065	4		english	f	ldms_files:MD5	f
100263	4	10065	4		francais	f	ldms_files:MD5	f
100264	3	10066	4		Espagñol	f	ldms_files:MD5	f
100265	1	10066	4	MD5	deutsch	t	ldms_files:MD5	f
100266	2	10066	4		english	f	ldms_files:MD5	f
100267	4	10066	4		francais	f	ldms_files:MD5	f
100268	3	10067	4		Espagñol	f	ldms_files:STORAGE_ID	f
100269	1	10067	4	STORAGE_ID	deutsch	t	ldms_files:STORAGE_ID	f
100270	2	10067	4		english	f	ldms_files:STORAGE_ID	f
100271	4	10067	4		francais	f	ldms_files:STORAGE_ID	f
100272	3	10068	4		Espagñol	f	ldms_files:STORAGE_ID	f
100273	1	10068	4	STORAGE_ID	deutsch	t	ldms_files:STORAGE_ID	f
100274	2	10068	4		english	f	ldms_files:STORAGE_ID	f
100275	4	10068	4		francais	f	ldms_files:STORAGE_ID	f
100276	3	10069	4		Espagñol	f	ldms_files:DOWNLOAD_LINK	f
100277	1	10069	4	DOWNLOAD_LINK	deutsch	t	ldms_files:DOWNLOAD_LINK	f
100278	2	10069	4		english	f	ldms_files:DOWNLOAD_LINK	f
100279	4	10069	4		francais	f	ldms_files:DOWNLOAD_LINK	f
100280	3	10070	4		Espagñol	f	ldms_files:DOWNLOAD_LINK	f
100281	1	10070	4		deutsch	t	ldms_files:DOWNLOAD_LINK	f
100282	2	10070	4		english	f	ldms_files:DOWNLOAD_LINK	f
100283	4	10070	4		francais	f	ldms_files:DOWNLOAD_LINK	f
100284	3	10071	4		Espagñol	f	Table: ldms_meta	f
100285	1	10071	4	Files_Meta	deutsch	t	Table: ldms_meta	f
100286	2	10071	4		english	f	Table: ldms_meta	f
100287	4	10071	4		francais	f	Table: ldms_meta	f
100288	3	10072	4		Espagñol	f	ldms_meta:LMSECTION	f
100289	1	10072	4	Grafik-Format	deutsch	t	ldms_meta:LMSECTION	f
100290	2	10072	4		english	f	ldms_meta:LMSECTION	f
100291	4	10072	4		francais	f	ldms_meta:LMSECTION	f
100292	3	10073	4		Espagñol	f	ldms_meta:LMSECTION	f
100293	1	10073	4	Grafik-Format	deutsch	t	ldms_meta:LMSECTION	f
100294	2	10073	4		english	f	ldms_meta:LMSECTION	f
100295	4	10073	4		francais	f	ldms_meta:LMSECTION	f
100296	3	10074	4		Espagñol	f	ldms_meta:LMSECTION	f
100297	1	10074	4	Objektbeschreibung	deutsch	t	ldms_meta:LMSECTION	f
100298	2	10074	4		english	f	ldms_meta:LMSECTION	f
100299	4	10074	4		francais	f	ldms_meta:LMSECTION	f
100300	3	10075	4		Espagñol	f	ldms_meta:LMSECTION	f
100301	1	10075	4	Objektbeschreibung	deutsch	t	ldms_meta:LMSECTION	f
100302	2	10075	4		english	f	ldms_meta:LMSECTION	f
100303	4	10075	4		francais	f	ldms_meta:LMSECTION	f
100304	3	10076	4		Espagñol	f	ldms_meta:LMSECTION	f
100305	1	10076	4	Stichwörter	deutsch	t	ldms_meta:LMSECTION	f
100306	2	10076	4		english	f	ldms_meta:LMSECTION	f
100307	4	10076	4		francais	f	ldms_meta:LMSECTION	f
100308	3	10077	4		Espagñol	f	ldms_meta:LMSECTION	f
100309	1	10077	4	Stichwörter	deutsch	t	ldms_meta:LMSECTION	f
100310	2	10077	4		english	f	ldms_meta:LMSECTION	f
100311	4	10077	4		francais	f	ldms_meta:LMSECTION	f
100312	3	10078	4		Espagñol	f	ldms_meta:LMSECTION	f
100313	1	10078	4	Kategorien	deutsch	t	ldms_meta:LMSECTION	f
100314	2	10078	4		english	f	ldms_meta:LMSECTION	f
100315	4	10078	4		francais	f	ldms_meta:LMSECTION	f
100316	3	10079	4		Espagñol	f	ldms_meta:LMSECTION	f
100317	1	10079	4	Kategorien	deutsch	t	ldms_meta:LMSECTION	f
100318	2	10079	4		english	f	ldms_meta:LMSECTION	f
100319	4	10079	4		francais	f	ldms_meta:LMSECTION	f
100320	3	10080	4		Espagñol	f	ldms_meta:LMSECTION	f
100321	1	10080	4	Bildrechte	deutsch	t	ldms_meta:LMSECTION	f
100322	2	10080	4		english	f	ldms_meta:LMSECTION	f
100323	4	10080	4		francais	f	ldms_meta:LMSECTION	f
100324	3	10081	4		Espagñol	f	ldms_meta:LMSECTION	f
100325	1	10081	4	Bildrechte	deutsch	t	ldms_meta:LMSECTION	f
100326	2	10081	4		english	f	ldms_meta:LMSECTION	f
100327	4	10081	4		francais	f	ldms_meta:LMSECTION	f
100328	3	10082	4		Espagñol	f	ldms_meta:LMSECTION	f
100329	1	10082	4	Herkunft	deutsch	t	ldms_meta:LMSECTION	f
100330	2	10082	4		english	f	ldms_meta:LMSECTION	f
100331	4	10082	4		francais	f	ldms_meta:LMSECTION	f
100332	3	10083	4		Espagñol	f	ldms_meta:LMSECTION	f
100333	1	10083	4	Herkunft	deutsch	t	ldms_meta:LMSECTION	f
100334	2	10083	4		english	f	ldms_meta:LMSECTION	f
100335	4	10083	4		francais	f	ldms_meta:LMSECTION	f
100336	3	10084	4		Espagñol	f	ldms_meta:LMSECTION	f
100337	1	10084	4	Copyright	deutsch	t	ldms_meta:LMSECTION	f
100338	2	10084	4		english	f	ldms_meta:LMSECTION	f
100339	4	10084	4		francais	f	ldms_meta:LMSECTION	f
100340	3	10085	4		Espagñol	f	ldms_meta:LMSECTION	f
100341	1	10085	4	Copyright	deutsch	t	ldms_meta:LMSECTION	f
100342	2	10085	4		english	f	ldms_meta:LMSECTION	f
100343	4	10085	4		francais	f	ldms_meta:LMSECTION	f
100344	3	10086	4		Espagñol	f	ldms_meta:TYPE	f
100345	1	10086	4	Farbschema	deutsch	t	ldms_meta:TYPE	f
100346	2	10086	4		english	f	ldms_meta:TYPE	f
100347	4	10086	4		francais	f	ldms_meta:TYPE	f
100348	3	10087	4		Espagñol	f	ldms_meta:TYPE	f
100349	1	10087	4	Farbschema	deutsch	t	ldms_meta:TYPE	f
100350	2	10087	4		english	f	ldms_meta:TYPE	f
100351	4	10087	4		francais	f	ldms_meta:TYPE	f
100352	3	10088	4		Espagñol	f	ldms_meta:FTYPE	f
100353	1	10088	4	Art des Dokuments	deutsch	t	ldms_meta:FTYPE	f
100354	2	10088	4		english	f	ldms_meta:FTYPE	f
100355	4	10088	4		francais	f	ldms_meta:FTYPE	f
100356	3	10089	4		Espagñol	f	ldms_meta:FTYPE	f
100357	1	10089	4	Typ	deutsch	t	ldms_meta:FTYPE	f
100358	2	10089	4		english	f	ldms_meta:FTYPE	f
100359	4	10089	4		francais	f	ldms_meta:FTYPE	f
100360	3	10090	4		Espagñol	f	ldms_meta:NAME2	f
100361	1	10090	4	Zusatz zum Namen	deutsch	t	ldms_meta:NAME2	f
100362	2	10090	4		english	f	ldms_meta:NAME2	f
100363	4	10090	4		francais	f	ldms_meta:NAME2	f
100364	3	10091	4		Espagñol	f	ldms_meta:NAME2	f
100365	1	10091	4	Überschrift	deutsch	t	ldms_meta:NAME2	f
100366	2	10091	4		english	f	ldms_meta:NAME2	f
100367	4	10091	4		francais	f	ldms_meta:NAME2	f
100368	3	10092	4		Espagñol	f	ldms_meta:FORMAT	f
100369	1	10092	4	Format	deutsch	t	ldms_meta:FORMAT	f
100370	2	10092	4		english	f	ldms_meta:FORMAT	f
100371	4	10092	4		francais	f	ldms_meta:FORMAT	f
100372	3	10093	4		Espagñol	f	ldms_meta:FORMAT	f
100373	1	10093	4	Format	deutsch	t	ldms_meta:FORMAT	f
100374	2	10093	4		english	f	ldms_meta:FORMAT	f
100375	4	10093	4		francais	f	ldms_meta:FORMAT	f
100376	3	10094	4		Espagñol	f	ldms_meta:GEOMETRY	f
100377	1	10094	4	Geometrie	deutsch	t	ldms_meta:GEOMETRY	f
100378	2	10094	4		english	f	ldms_meta:GEOMETRY	f
100379	4	10094	4		francais	f	ldms_meta:GEOMETRY	f
100380	3	10095	4		Espagñol	f	ldms_meta:GEOMETRY	f
100381	1	10095	4	Geometrie	deutsch	t	ldms_meta:GEOMETRY	f
100382	2	10095	4		english	f	ldms_meta:GEOMETRY	f
100383	4	10095	4		francais	f	ldms_meta:GEOMETRY	f
100384	3	10096	4		Espagñol	f	ldms_meta:RESOLUTION	f
100385	1	10096	4	Auflösung	deutsch	t	ldms_meta:RESOLUTION	f
100386	2	10096	4		english	f	ldms_meta:RESOLUTION	f
100387	4	10096	4		francais	f	ldms_meta:RESOLUTION	f
100388	3	10097	4		Espagñol	f	ldms_meta:RESOLUTION	f
100389	1	10097	4	Auflösung	deutsch	t	ldms_meta:RESOLUTION	f
100390	2	10097	4		english	f	ldms_meta:RESOLUTION	f
100391	4	10097	4		francais	f	ldms_meta:RESOLUTION	f
100392	3	10098	4		Espagñol	f	ldms_meta:DEPTH	f
100393	1	10098	4	Farbtiefe	deutsch	t	ldms_meta:DEPTH	f
100394	2	10098	4		english	f	ldms_meta:DEPTH	f
100395	4	10098	4		francais	f	ldms_meta:DEPTH	f
100396	3	10099	4		Espagñol	f	ldms_meta:DEPTH	f
100397	1	10099	4	Farbtiefe	deutsch	t	ldms_meta:DEPTH	f
100398	2	10099	4		english	f	ldms_meta:DEPTH	f
100399	4	10099	4		francais	f	ldms_meta:DEPTH	f
100400	3	10100	4		Espagñol	f	ldms_meta:COLORS	f
100401	1	10100	4	Farben	deutsch	t	ldms_meta:COLORS	f
100402	2	10100	4		english	f	ldms_meta:COLORS	f
100403	4	10100	4		francais	f	ldms_meta:COLORS	f
100404	3	10101	4		Espagñol	f	ldms_meta:COLORS	f
100405	1	10101	4	Farben	deutsch	t	ldms_meta:COLORS	f
100406	2	10101	4		english	f	ldms_meta:COLORS	f
100407	4	10101	4		francais	f	ldms_meta:COLORS	f
100408	3	10102	4		Espagñol	f	ldms_meta:CREATOR	f
100409	1	10102	4	Name des Verfassers (Familienname, Vorname)	deutsch	t	ldms_meta:CREATOR	f
100410	2	10102	4		english	f	ldms_meta:CREATOR	f
100411	4	10102	4		francais	f	ldms_meta:CREATOR	f
100412	3	10103	4		Espagñol	f	ldms_meta:CREATOR	f
100413	1	10103	4	Verfasser	deutsch	t	ldms_meta:CREATOR	f
100414	2	10103	4		english	f	ldms_meta:CREATOR	f
100415	4	10103	4		francais	f	ldms_meta:CREATOR	f
100416	3	10104	4		Espagñol	f	ldms_meta:SUBJECT	f
100417	1	10104	4	Stichworte zum Thema des Dokuments, mehrere getrennt durch Komma	deutsch	t	ldms_meta:SUBJECT	f
100418	2	10104	4		english	f	ldms_meta:SUBJECT	f
100419	4	10104	4		francais	f	ldms_meta:SUBJECT	f
100420	3	10105	4		Espagñol	f	ldms_meta:SUBJECT	f
100421	1	10105	4	Schlagwörter	deutsch	t	ldms_meta:SUBJECT	f
100422	2	10105	4		english	f	ldms_meta:SUBJECT	f
100423	4	10105	4		francais	f	ldms_meta:SUBJECT	f
100424	3	10106	4		Espagñol	f	ldms_meta:CLASSIFICATION	f
100425	1	10106	4	Notationen zum Thema des Dokuments, mehrere getrennt durch Komma	deutsch	t	ldms_meta:CLASSIFICATION	f
100426	2	10106	4		english	f	ldms_meta:CLASSIFICATION	f
100427	4	10106	4		francais	f	ldms_meta:CLASSIFICATION	f
100428	3	10107	4		Espagñol	f	ldms_meta:CLASSIFICATION	f
100429	1	10107	4	Klassifikation	deutsch	t	ldms_meta:CLASSIFICATION	f
100430	2	10107	4		english	f	ldms_meta:CLASSIFICATION	f
100431	4	10107	4		francais	f	ldms_meta:CLASSIFICATION	f
100432	3	10108	4		Espagñol	f	ldms_meta:DESCRIPTION	f
100433	1	10108	4	Abstrakt, Beschreibung des Inhalts	deutsch	t	ldms_meta:DESCRIPTION	f
100434	2	10108	4		english	f	ldms_meta:DESCRIPTION	f
100435	4	10108	4		francais	f	ldms_meta:DESCRIPTION	f
100436	3	10109	4		Espagñol	f	ldms_meta:DESCRIPTION	f
100437	1	10109	4	Beschreibung	deutsch	t	ldms_meta:DESCRIPTION	f
100438	2	10109	4		english	f	ldms_meta:DESCRIPTION	f
100439	4	10109	4		francais	f	ldms_meta:DESCRIPTION	f
100440	3	10110	4		Espagñol	f	ldms_meta:PUBLISHER	f
100441	1	10110	4	Verleger, Herausgeber, Universität etc.	deutsch	t	ldms_meta:PUBLISHER	f
100442	2	10110	4		english	f	ldms_meta:PUBLISHER	f
100443	4	10110	4		francais	f	ldms_meta:PUBLISHER	f
100444	3	10111	4		Espagñol	f	ldms_meta:PUBLISHER	f
100445	1	10111	4	Herausgeber	deutsch	t	ldms_meta:PUBLISHER	f
100446	2	10111	4		english	f	ldms_meta:PUBLISHER	f
100447	4	10111	4		francais	f	ldms_meta:PUBLISHER	f
100448	3	10112	4		Espagñol	f	ldms_meta:CONTRIBUTORS	f
100449	1	10112	4	Name einer weiteren beteiligten Person	deutsch	t	ldms_meta:CONTRIBUTORS	f
100450	2	10112	4		english	f	ldms_meta:CONTRIBUTORS	f
100451	4	10112	4		francais	f	ldms_meta:CONTRIBUTORS	f
100452	3	10113	4		Espagñol	f	ldms_meta:CONTRIBUTORS	f
100453	1	10113	4	Mitwirkende	deutsch	t	ldms_meta:CONTRIBUTORS	f
100454	2	10113	4		english	f	ldms_meta:CONTRIBUTORS	f
100455	4	10113	4		francais	f	ldms_meta:CONTRIBUTORS	f
100456	3	10114	4		Espagñol	f	ldms_meta:IDENTIFIER	f
100457	1	10114	4	(ISBN, ISSN, URL o.ä. des vorliegenden Dokuments betr. eindeutiger Identifikation	deutsch	t	ldms_meta:IDENTIFIER	f
100458	2	10114	4		english	f	ldms_meta:IDENTIFIER	f
100459	4	10114	4		francais	f	ldms_meta:IDENTIFIER	f
100460	3	10115	4		Espagñol	f	ldms_meta:IDENTIFIER	f
100461	1	10115	4	Identifikation	deutsch	t	ldms_meta:IDENTIFIER	f
100462	2	10115	4		english	f	ldms_meta:IDENTIFIER	f
100463	4	10115	4		francais	f	ldms_meta:IDENTIFIER	f
100464	3	10116	4		Espagñol	f	ldms_meta:SOURCE	f
100465	1	10116	4	Werk, gedruckt oder elektronisch, aus dem das vorliegende Dokument stammt	deutsch	t	ldms_meta:SOURCE	f
100466	2	10116	4		english	f	ldms_meta:SOURCE	f
100467	4	10116	4		francais	f	ldms_meta:SOURCE	f
100468	3	10117	4		Espagñol	f	ldms_meta:SOURCE	f
100469	1	10117	4	Quelle	deutsch	t	ldms_meta:SOURCE	f
100470	2	10117	4		english	f	ldms_meta:SOURCE	f
100471	4	10117	4		francais	f	ldms_meta:SOURCE	f
100472	3	10118	4		Espagñol	f	ldms_meta:LANGUAGE	f
100473	1	10118	4	Sprache des Inhalts des Dokuments	deutsch	t	ldms_meta:LANGUAGE	f
100474	2	10118	4		english	f	ldms_meta:LANGUAGE	f
100475	4	10118	4		francais	f	ldms_meta:LANGUAGE	f
100476	3	10119	4		Espagñol	f	ldms_meta:LANGUAGE	f
100477	1	10119	4	Sprache	deutsch	t	ldms_meta:LANGUAGE	f
100478	2	10119	4		english	f	ldms_meta:LANGUAGE	f
100479	4	10119	4		francais	f	ldms_meta:LANGUAGE	f
100480	3	10120	4		Espagñol	f	ldms_meta:INSTRUCTIONS	f
100481	1	10120	4	Hinweise	deutsch	t	ldms_meta:INSTRUCTIONS	f
100482	2	10120	4		english	f	ldms_meta:INSTRUCTIONS	f
100483	4	10120	4		francais	f	ldms_meta:INSTRUCTIONS	f
100484	3	10121	4		Espagñol	f	ldms_meta:INSTRUCTIONS	f
100485	1	10121	4	Hinweise	deutsch	t	ldms_meta:INSTRUCTIONS	f
100486	2	10121	4		english	f	ldms_meta:INSTRUCTIONS	f
100487	4	10121	4		francais	f	ldms_meta:INSTRUCTIONS	f
100488	3	10122	4		Espagñol	f	ldms_meta:URGENCY	f
100489	1	10122	4	Dringlichkeit	deutsch	t	ldms_meta:URGENCY	f
100490	2	10122	4		english	f	ldms_meta:URGENCY	f
100491	4	10122	4		francais	f	ldms_meta:URGENCY	f
100492	3	10123	4		Espagñol	f	ldms_meta:URGENCY	f
100493	1	10123	4	Dringlichkeit	deutsch	t	ldms_meta:URGENCY	f
100494	2	10123	4		english	f	ldms_meta:URGENCY	f
100495	4	10123	4		francais	f	ldms_meta:URGENCY	f
100496	3	10124	4		Espagñol	f	ldms_meta:CATEGORY	f
100497	1	10124	4	Kategorie	deutsch	t	ldms_meta:CATEGORY	f
100498	2	10124	4		english	f	ldms_meta:CATEGORY	f
100499	4	10124	4		francais	f	ldms_meta:CATEGORY	f
100500	3	10125	4		Espagñol	f	ldms_meta:CATEGORY	f
100501	1	10125	4	Kategorie	deutsch	t	ldms_meta:CATEGORY	f
100502	2	10125	4		english	f	ldms_meta:CATEGORY	f
100503	4	10125	4		francais	f	ldms_meta:CATEGORY	f
100504	3	10126	4		Espagñol	f	ldms_meta:TITLE	f
100505	1	10126	4	Autor	deutsch	t	ldms_meta:TITLE	f
100506	2	10126	4		english	f	ldms_meta:TITLE	f
100507	4	10126	4		francais	f	ldms_meta:TITLE	f
100508	3	10127	4		Espagñol	f	ldms_meta:TITLE	f
100509	1	10127	4	Autor	deutsch	t	ldms_meta:TITLE	f
100510	2	10127	4		english	f	ldms_meta:TITLE	f
100511	4	10127	4		francais	f	ldms_meta:TITLE	f
100512	3	10128	4		Espagñol	f	ldms_meta:CREDIT	f
100513	1	10128	4	Bildrechte	deutsch	t	ldms_meta:CREDIT	f
100514	2	10128	4		english	f	ldms_meta:CREDIT	f
100515	4	10128	4		francais	f	ldms_meta:CREDIT	f
100516	3	10129	4		Espagñol	f	ldms_meta:CREDIT	f
100517	1	10129	4	Bildrechte	deutsch	t	ldms_meta:CREDIT	f
100518	2	10129	4		english	f	ldms_meta:CREDIT	f
100519	4	10129	4		francais	f	ldms_meta:CREDIT	f
100520	3	10130	4		Espagñol	f	ldms_meta:CITY	f
100521	1	10130	4	Ort	deutsch	t	ldms_meta:CITY	f
100522	2	10130	4		english	f	ldms_meta:CITY	f
100523	4	10130	4		francais	f	ldms_meta:CITY	f
100524	3	10131	4		Espagñol	f	ldms_meta:CITY	f
100525	1	10131	4	Ort	deutsch	t	ldms_meta:CITY	f
100526	2	10131	4		english	f	ldms_meta:CITY	f
100527	4	10131	4		francais	f	ldms_meta:CITY	f
100528	3	10132	4		Espagñol	f	ldms_meta:STATE	f
100529	1	10132	4	Staat/Provinz	deutsch	t	ldms_meta:STATE	f
100530	2	10132	4		english	f	ldms_meta:STATE	f
100531	4	10132	4		francais	f	ldms_meta:STATE	f
100532	3	10133	4		Espagñol	f	ldms_meta:STATE	f
100533	1	10133	4	Staat/Provinz	deutsch	t	ldms_meta:STATE	f
100534	2	10133	4		english	f	ldms_meta:STATE	f
100535	4	10133	4		francais	f	ldms_meta:STATE	f
100536	3	10134	4		Espagñol	f	ldms_meta:COUNTRY	f
100537	1	10134	4	Land	deutsch	t	ldms_meta:COUNTRY	f
100538	2	10134	4		english	f	ldms_meta:COUNTRY	f
100539	4	10134	4		francais	f	ldms_meta:COUNTRY	f
100540	3	10135	4		Espagñol	f	ldms_meta:COUNTRY	f
100541	1	10135	4	Land	deutsch	t	ldms_meta:COUNTRY	f
100542	2	10135	4		english	f	ldms_meta:COUNTRY	f
100543	4	10135	4		francais	f	ldms_meta:COUNTRY	f
100544	3	10136	4		Espagñol	f	ldms_meta:TRANSMISSION	f
100545	1	10136	4	Aufgeber-Code	deutsch	t	ldms_meta:TRANSMISSION	f
100546	2	10136	4		english	f	ldms_meta:TRANSMISSION	f
100547	4	10136	4		francais	f	ldms_meta:TRANSMISSION	f
100548	3	10137	4		Espagñol	f	ldms_meta:TRANSMISSION	f
100549	1	10137	4	Aufgeber-Code	deutsch	t	ldms_meta:TRANSMISSION	f
100550	2	10137	4		english	f	ldms_meta:TRANSMISSION	f
100551	4	10137	4		francais	f	ldms_meta:TRANSMISSION	f
100552	3	10138	4		Espagñol	f	ldms_meta:ORIGINNAME	f
100553	1	10138	4	Objektname	deutsch	t	ldms_meta:ORIGINNAME	f
100554	2	10138	4		english	f	ldms_meta:ORIGINNAME	f
100555	4	10138	4		francais	f	ldms_meta:ORIGINNAME	f
100556	3	10139	4		Espagñol	f	ldms_meta:ORIGINNAME	f
100557	1	10139	4	Objektname	deutsch	t	ldms_meta:ORIGINNAME	f
100558	2	10139	4		english	f	ldms_meta:ORIGINNAME	f
100559	4	10139	4		francais	f	ldms_meta:ORIGINNAME	f
100560	3	10140	4		Espagñol	f	ldms_meta:COPYRIGHT	f
100561	1	10140	4	Vermerk	deutsch	t	ldms_meta:COPYRIGHT	f
100562	2	10140	4		english	f	ldms_meta:COPYRIGHT	f
100563	4	10140	4		francais	f	ldms_meta:COPYRIGHT	f
100564	3	10141	4		Espagñol	f	ldms_meta:COPYRIGHT	f
100565	1	10141	4	Vermerk	deutsch	t	ldms_meta:COPYRIGHT	f
100566	2	10141	4		english	f	ldms_meta:COPYRIGHT	f
100567	4	10141	4		francais	f	ldms_meta:COPYRIGHT	f
100568	3	10142	4		Espagñol	f	ldms_meta:CREATEDATE	f
100569	1	10142	4	Erstellt am	deutsch	t	ldms_meta:CREATEDATE	f
100570	2	10142	4		english	f	ldms_meta:CREATEDATE	f
100571	4	10142	4		francais	f	ldms_meta:CREATEDATE	f
100572	3	10143	4		Espagñol	f	ldms_meta:CREATEDATE	f
100573	1	10143	4	Erstellt am	deutsch	t	ldms_meta:CREATEDATE	f
100574	2	10143	4		english	f	ldms_meta:CREATEDATE	f
100575	4	10143	4		francais	f	ldms_meta:CREATEDATE	f
100576	3	10144	4		Espagñol	f	ldms_meta:SUBCATEGORY	f
100577	1	10144	4	Unterkategorien	deutsch	t	ldms_meta:SUBCATEGORY	f
100578	2	10144	4		english	f	ldms_meta:SUBCATEGORY	f
100579	4	10144	4		francais	f	ldms_meta:SUBCATEGORY	f
100580	3	10145	4		Espagñol	f	ldms_meta:SUBCATEGORY	f
100581	1	10145	4	Unterkategorien	deutsch	t	ldms_meta:SUBCATEGORY	f
100582	2	10145	4		english	f	ldms_meta:SUBCATEGORY	f
100583	4	10145	4		francais	f	ldms_meta:SUBCATEGORY	f
100584	3	10146	4		Espagñol	f	Table: lmb_custvar_depend	f
100585	1	10146	4	Custom Vars	deutsch	t	Table: lmb_custvar_depend	f
100586	2	10146	4		english	f	Table: lmb_custvar_depend	f
100587	4	10146	4		francais	f	Table: lmb_custvar_depend	f
100588	3	10147	4		Espagñol	f	lmb_custvar_depend:ID	f
100589	1	10147	4	Nr	deutsch	t	lmb_custvar_depend:ID	f
100590	2	10147	4		english	f	lmb_custvar_depend:ID	f
100591	4	10147	4		francais	f	lmb_custvar_depend:ID	f
100592	3	10148	4		Espagñol	f	lmb_custvar_depend:ID	f
100593	1	10148	4	Nr	deutsch	t	lmb_custvar_depend:ID	f
100594	2	10148	4		english	f	lmb_custvar_depend:ID	f
100595	4	10148	4		francais	f	lmb_custvar_depend:ID	f
100596	3	10149	4		Espagñol	f	lmb_custvar_depend:ERSTDATUM	f
100597	1	10149	4	erstellt am	deutsch	t	lmb_custvar_depend:ERSTDATUM	f
100598	2	10149	4		english	f	lmb_custvar_depend:ERSTDATUM	f
100599	4	10149	4		francais	f	lmb_custvar_depend:ERSTDATUM	f
100600	3	10150	4		Espagñol	f	lmb_custvar_depend:ERSTDATUM	f
100601	1	10150	4	erstellt am	deutsch	t	lmb_custvar_depend:ERSTDATUM	f
100602	2	10150	4		english	f	lmb_custvar_depend:ERSTDATUM	f
100603	4	10150	4		francais	f	lmb_custvar_depend:ERSTDATUM	f
100604	3	10151	4		Espagñol	f	lmb_custvar_depend:ERSTUSER	f
100605	1	10151	4	erstellt von	deutsch	t	lmb_custvar_depend:ERSTUSER	f
100606	2	10151	4		english	f	lmb_custvar_depend:ERSTUSER	f
100607	4	10151	4		francais	f	lmb_custvar_depend:ERSTUSER	f
100608	3	10152	4		Espagñol	f	lmb_custvar_depend:ERSTUSER	f
100609	1	10152	4	erstellt von	deutsch	t	lmb_custvar_depend:ERSTUSER	f
100610	2	10152	4		english	f	lmb_custvar_depend:ERSTUSER	f
100611	4	10152	4		francais	f	lmb_custvar_depend:ERSTUSER	f
100612	3	10153	4		Espagñol	f	lmb_custvar_depend:ERSTGROUP	f
100613	1	10153	4	erstellt von Gruppe	deutsch	t	lmb_custvar_depend:ERSTGROUP	f
100614	2	10153	4		english	f	lmb_custvar_depend:ERSTGROUP	f
100615	4	10153	4		francais	f	lmb_custvar_depend:ERSTGROUP	f
100616	3	10154	4		Espagñol	f	lmb_custvar_depend:ERSTGROUP	f
100617	1	10154	4	erstellt von Gruppe	deutsch	t	lmb_custvar_depend:ERSTGROUP	f
100618	2	10154	4		english	f	lmb_custvar_depend:ERSTGROUP	f
100619	4	10154	4		francais	f	lmb_custvar_depend:ERSTGROUP	f
100620	3	10155	4		Espagñol	f	lmb_custvar_depend:EDITDATUM	f
100621	1	10155	4	editiert am	deutsch	t	lmb_custvar_depend:EDITDATUM	f
100622	2	10155	4		english	f	lmb_custvar_depend:EDITDATUM	f
100623	4	10155	4		francais	f	lmb_custvar_depend:EDITDATUM	f
100624	3	10156	4		Espagñol	f	lmb_custvar_depend:EDITDATUM	f
100625	1	10156	4	editiert am	deutsch	t	lmb_custvar_depend:EDITDATUM	f
100626	2	10156	4		english	f	lmb_custvar_depend:EDITDATUM	f
100627	4	10156	4		francais	f	lmb_custvar_depend:EDITDATUM	f
100628	3	10157	4		Espagñol	f	lmb_custvar_depend:EDITUSER	f
100629	1	10157	4	editiert von	deutsch	t	lmb_custvar_depend:EDITUSER	f
100630	2	10157	4		english	f	lmb_custvar_depend:EDITUSER	f
100631	4	10157	4		francais	f	lmb_custvar_depend:EDITUSER	f
100632	3	10158	4		Espagñol	f	lmb_custvar_depend:EDITUSER	f
100633	1	10158	4	editiert von	deutsch	t	lmb_custvar_depend:EDITUSER	f
100634	2	10158	4		english	f	lmb_custvar_depend:EDITUSER	f
100635	4	10158	4		francais	f	lmb_custvar_depend:EDITUSER	f
100636	3	10159	4		Espagñol	f	lmb_custvar_depend:CKEY	f
100637	1	10159	4	Schlüssel	deutsch	t	lmb_custvar_depend:CKEY	f
100638	2	10159	4		english	f	lmb_custvar_depend:CKEY	f
100639	4	10159	4		francais	f	lmb_custvar_depend:CKEY	f
100640	3	10160	4		Espagñol	f	lmb_custvar_depend:CKEY	f
100641	1	10160	4	Schlüssel	deutsch	t	lmb_custvar_depend:CKEY	f
100642	2	10160	4		english	f	lmb_custvar_depend:CKEY	f
100643	4	10160	4		francais	f	lmb_custvar_depend:CKEY	f
100644	3	10161	4		Espagñol	f	lmb_custvar_depend:CVALUE	f
100645	1	10161	4	Wert	deutsch	t	lmb_custvar_depend:CVALUE	f
100646	2	10161	4		english	f	lmb_custvar_depend:CVALUE	f
100647	4	10161	4		francais	f	lmb_custvar_depend:CVALUE	f
100648	3	10162	4		Espagñol	f	lmb_custvar_depend:CVALUE	f
100649	1	10162	4	Wert	deutsch	t	lmb_custvar_depend:CVALUE	f
100650	2	10162	4		english	f	lmb_custvar_depend:CVALUE	f
100651	4	10162	4		francais	f	lmb_custvar_depend:CVALUE	f
100652	3	10163	4		Espagñol	f	lmb_custvar_depend:DESCRIPTION	f
100653	1	10163	4	Beschreibung	deutsch	t	lmb_custvar_depend:DESCRIPTION	f
100654	2	10163	4		english	f	lmb_custvar_depend:DESCRIPTION	f
100655	4	10163	4		francais	f	lmb_custvar_depend:DESCRIPTION	f
100656	3	10164	4		Espagñol	f	lmb_custvar_depend:DESCRIPTION	f
100657	1	10164	4	Beschreibung	deutsch	t	lmb_custvar_depend:DESCRIPTION	f
100658	2	10164	4		english	f	lmb_custvar_depend:DESCRIPTION	f
100659	4	10164	4		francais	f	lmb_custvar_depend:DESCRIPTION	f
100660	3	10165	4		Espagñol	f	lmb_custvar_depend:OVERRIDABLE	f
100661	1	10165	4	überschreibbar	deutsch	t	lmb_custvar_depend:OVERRIDABLE	f
100662	2	10165	4		english	f	lmb_custvar_depend:OVERRIDABLE	f
100663	4	10165	4		francais	f	lmb_custvar_depend:OVERRIDABLE	f
100664	3	10166	4		Espagñol	f	lmb_custvar_depend:OVERRIDABLE	f
100665	1	10166	4	überschreibbar	deutsch	t	lmb_custvar_depend:OVERRIDABLE	f
100666	2	10166	4		english	f	lmb_custvar_depend:OVERRIDABLE	f
100667	4	10166	4		francais	f	lmb_custvar_depend:OVERRIDABLE	f
100668	3	10167	4		Espagñol	f	lmb_custvar_depend:ACTIVE	f
100669	1	10167	4	Aktiv	deutsch	t	lmb_custvar_depend:ACTIVE	f
100670	2	10167	4		english	f	lmb_custvar_depend:ACTIVE	f
100671	4	10167	4		francais	f	lmb_custvar_depend:ACTIVE	f
100672	3	10168	4		Espagñol	f	lmb_custvar_depend:ACTIVE	f
100673	1	10168	4	Aktiv	deutsch	t	lmb_custvar_depend:ACTIVE	f
100674	2	10168	4		english	f	lmb_custvar_depend:ACTIVE	f
100675	4	10168	4		francais	f	lmb_custvar_depend:ACTIVE	f
\.


--
-- Data for Name: lmb_mimetypes; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_mimetypes (id, mimetype, ext, pic) FROM stdin;
1	application/excel	xls	xls.gif
6	application/andrew-inset	ez	\N
17	application/mac-binhex40	hqx	\N
18	application/mac-compactpro	cpt	\N
22	application/msword	doc	doc.gif
26	application/oda	oda	\N
27	application/pdf	pdf	pdf.gif
40	application/rtf	rtf	rtf.gif
48	application/smil	mif	\N
105	application/vnd.mif	mif	\N
111	application/vnd.ms-powerpoint	ppt	ppt.gif
144	application/x-bcpio	bcpio	\N
145	application/x-cdlink	vcd	\N
146	application/x-chess-pgn	pgn	\N
148	application/x-cpio	cpio	\N
149	application/x-csh	csh	\N
151	application/x-dvi	dvi	\N
152	application/x-futuresplash	spl	\N
153	application/x-gtar	gtar	\N
155	application/x-hdf	hdf	\N
156	application/x-javascript	js	\N
158	application/x-latex	latex	\N
160	application/x-sh	sh	\N
161	application/x-shar	shar	\N
162	application/x-shockwave-flash	swf	swf.gif
163	application/x-stuffit	sit	\N
164	application/x-sv4cpio	sv4cpio	\N
165	application/x-sv4crc	sv4crc	\N
166	application/x-tar	tar	\N
167	application/x-tcl	tcl	\N
168	application/x-tex	tex	\N
171	application/x-troff-man	man	\N
172	application/x-troff-me	me	\N
173	application/x-troff-ms	ms	\N
174	application/x-ustar	ustar	\N
175	application/x-wais-source	src	\N
178	application/zip	zip	zip.gif
181	audio/midi	mid	\N
184	audio/x-aiff	aif	\N
185	audio/x-pn-realaudio	ram	\N
186	audio/x-pn-realaudio-plugin	pgm	\N
187	audio/x-realaudio	ra	\N
188	audio/x-wav	wav	wav.gif
189	chemical/x-pdb	pdb	\N
192	image/gif	gif	gif.gif
193	image/ief	ief	\N
196	image/png	png	png.gif
205	image/x-cmu-raster	ras	\N
206	image/x-portable-anymap	pnm	\N
207	image/x-portable-bitmap	pbm	\N
208	image/x-portable-graymap	pgm	\N
209	image/x-portable-pixmap	ppm	\N
210	image/x-rgb	rgb	\N
213	image/x-xwindowdump	xwd	\N
221	model/iges	igs	\N
222	model/mesh	msh	\N
224	model/vrml	wrl	\N
238	text/css	css	\N
245	text/richtext	rtf	rtf.gif
246	text/rtf	rtf	rtf.gif
256	text/x-setext	etx	\N
257	text/xml	xml	\N
263	video/x-msvideo	avi	avi.gif
264	video/x-sgi-movie	movie	\N
265	x-conference/x-cooltalk	ice	\N
269	application/octet-stream	exe	exe.gif
271	application/postscript	eps	\N
274	application/x-director	dir	\N
277	application/x-koan	skm	\N
278	application/x-netcdf	cdf	\N
279	application/x-texinfo	texi	\N
280	application/x-troff	tr	\N
283	audio/basic	snd	\N
286	audio/mpeg	mp3	mpg.gif
290	chemical/x-pdb	xyz	\N
291	image/jpeg	jpg	jpg.gif
292	image/x-photoshop	psd	psd.gif
296	video/mpeg	mpg	mpg.gif
298	text/sgml	sgm	\N
300	text/html	html	html.gif
301	text/plain	txt	txt.gif
302	video/quicktime	mov	mov.gif
303	image/bmp	bmp	bmp.gif
304	image/tiff	tif	tif.gif
305	image/pjpeg	jpeg	jpg.gif
306	unknown	?	unknown.gif
307	application/vnd.ms-excel	xls	xls.gif
308	image/x-png	png	png.gif
309	text/htm	htm	html.gif
310	application/octet-stream	msg	msg.gif
311	video/x-ms-wmv	wmv	\N
312	text/php	php	\N
313	application/vnd.oasis.opendocument.text	odt	\N
314	application/quarkxpress	qxd	qxd.gif
315	application/vnd.oasis.opendocument.spreadsheet	ods	\N
316	application/vnd.oasis.opendocument.presentation	odp	\N
317	application/vnd.oasis.opendocument.graphics	odg	\N
318	application/vnd.oasis.opendocument.chart	odc	\N
319	application/vnd.oasis.opendocument.formula	odf	\N
320	application/vnd.oasis.opendocument.image	odi	\N
321	application/vnd.oasis.opendocument.text-master	odm	\N
322	application/vnd.oasis.opendocument.text-template	ott	\N
323	application/vnd.oasis.opendocument.spreadsheet-template	ots	\N
324	application/vnd.oasis.opendocument.presentation-template	otp	\N
325	application/vnd.oasis.opendocument.graphics-template	otg	\N
326	application/x-font	pfb	\N
327	application/x-type1-font	pfm	\N
328	application/quarkxpress	qxp	qxd.gif
329	message/rfc822	eml	\N
330	message/rfc822	eml	\N
\.


--
-- Data for Name: lmb_multitenant; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_multitenant (id, name, mid, syncslave) FROM stdin;
\.


--
-- Data for Name: lmb_printers; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_printers (id, name, sysname, config, def) FROM stdin;
\.


--
-- Data for Name: lmb_reminder; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_reminder (id, user_id, tab_id, dat_id, frist, typ, description, fromuser, content, category, group_id, wfl_inst) FROM stdin;
\.


--
-- Data for Name: lmb_reminder_list; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_reminder_list (id, erstuser, erstdatum, name, tab_id, formd_id, forml_id, groupbased, sort) FROM stdin;
\.


--
-- Data for Name: lmb_report_list; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_report_list (id, name, beschreibung, page_style, sql_statement, erstdatum, editdatum, erstuser, edituser, referenz_tab, grouplist, target, savename, tagmod, extension, indexorder, odt_template, defformat, listmode, ods_template, css) FROM stdin;
\.


--
-- Data for Name: lmb_reports; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_reports (el_id, erstdatum, editdatum, erstuser, edituser, typ, posx, posy, height, width, inhalt, dbfield, verkn_baum, style, db_data_type, show_all, bericht_id, z_index, liste, tab, tab_size, tab_el_col, tab_el_row, tab_el_col_size, header, footer, pic_typ, pic_style, pic_size, pic_res, pic_name, bg, extvalue, id, tab_el) FROM stdin;
\.


--
-- Data for Name: lmb_revision; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_revision (id, erstuser, erstdatum, revision, version, corev, description) FROM stdin;
\.


--
-- Data for Name: lmb_rules_action; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_rules_action (id, group_id, link_id, perm, sort) FROM stdin;
1	1	1	2	\N
2	1	3	2	\N
3	1	4	2	\N
4	1	5	2	\N
5	1	6	2	\N
6	1	7	2	\N
7	1	8	2	\N
8	1	9	2	\N
9	1	10	2	\N
10	1	11	2	\N
13	1	14	2	\N
15	1	17	2	\N
16	1	18	2	\N
19	1	21	2	\N
21	1	23	2	\N
23	1	28	2	\N
24	1	29	2	\N
25	1	32	2	\N
26	1	35	2	\N
27	1	36	2	\N
29	1	38	2	\N
30	1	40	2	\N
31	1	41	2	\N
32	1	42	2	\N
33	1	43	2	\N
35	1	45	2	\N
36	1	46	2	\N
37	1	47	2	\N
38	1	48	2	\N
39	1	49	2	\N
40	1	50	2	\N
41	1	53	2	\N
42	1	54	2	\N
43	1	55	2	\N
44	1	56	2	\N
45	1	57	2	\N
46	1	58	2	\N
47	1	59	2	\N
48	1	65	2	\N
52	1	76	2	\N
54	1	87	2	\N
55	1	100	2	\N
56	1	102	2	\N
59	1	107	2	\N
60	1	108	2	\N
61	1	109	2	\N
68	1	116	2	\N
69	1	117	2	\N
70	1	119	2	\N
72	1	121	2	\N
73	1	122	2	\N
74	1	123	2	\N
75	1	124	2	\N
79	1	128	2	\N
80	1	129	2	\N
81	1	130	2	\N
82	1	131	2	\N
83	1	132	2	\N
84	1	133	2	\N
86	1	135	2	\N
88	1	137	2	\N
89	1	138	2	\N
91	1	140	2	\N
93	1	142	2	\N
97	1	147	2	\N
101	1	151	2	\N
102	1	152	2	\N
103	1	153	2	\N
106	1	156	2	\N
107	1	157	2	\N
108	1	158	2	\N
109	1	159	2	\N
110	1	160	2	\N
111	1	161	2	\N
113	1	163	2	\N
566	1	164	2	\N
571	1	165	2	\N
576	1	166	2	\N
809	1	167	2	\N
815	1	169	2	\N
818	1	170	2	\N
820	1	171	2	\N
821	1	172	2	\N
1064	1	173	2	\N
1067	1	174	2	\N
1070	1	175	2	\N
1073	1	176	2	\N
1078	1	177	2	\N
1973	1	180	2	\N
1976	1	181	2	\N
1979	1	182	2	\N
1982	1	183	2	\N
1985	1	184	2	\N
1988	1	185	2	\N
1994	1	187	2	\N
1997	1	188	2	\N
2000	1	189	2	\N
2003	1	190	2	\N
2138	1	191	2	\N
2141	1	192	2	\N
2278	1	193	2	\N
2282	1	194	2	\N
2286	1	195	2	\N
2692	1	196	2	\N
2695	1	197	2	\N
2701	1	199	2	\N
2704	1	200	2	\N
2707	1	201	2	\N
2710	1	202	2	\N
2713	1	203	2	\N
2716	1	204	2	\N
2719	1	205	2	\N
2731	1	207	2	\N
2733	1	208	2	\N
3139	1	209	2	\N
3143	1	210	2	\N
3147	1	211	2	\N
3151	1	212	2	\N
3155	1	213	2	\N
3159	1	214	2	\N
3163	1	215	2	\N
3167	1	216	2	\N
3171	1	217	2	\N
3175	1	218	2	\N
3179	1	219	2	\N
3183	1	220	2	\N
3187	1	221	2	\N
3195	1	222	2	\N
3199	1	223	2	\N
3200	1	224	2	\N
65	1	113	1	\N
18	1	20	1	\N
3351	1	225	2	\N
3504	1	226	2	\N
3528	1	232	2	\N
3529	1	233	2	\N
3530	1	235	2	\N
3531	1	236	2	\N
3532	1	237	2	\N
3534	1	239	2	\N
3535	1	240	2	\N
3536	1	241	2	\N
3537	1	242	2	\N
3549	1	243	2	\N
3553	1	246	2	\N
3557	1	247	2	\N
3559	1	248	2	\N
3560	1	249	2	\N
3561	1	250	2	\N
3562	1	251	2	\N
3563	1	252	2	\N
3564	1	253	2	\N
3565	1	254	2	\N
3566	1	255	2	\N
3567	1	256	2	\N
3568	1	257	2	\N
3569	1	258	2	\N
3570	1	259	2	\N
3571	1	260	2	\N
3572	1	261	2	\N
3587	1	263	2	\N
3588	1	264	2	\N
3589	1	265	2	\N
3593	1	270	2	\N
3594	1	271	2	\N
3596	1	272	2	\N
3597	1	273	2	\N
3598	1	274	2	\N
3599	1	275	2	\N
3600	1	266	2	\N
3601	1	276	2	\N
3602	1	267	2	\N
3603	1	277	2	\N
3604	1	268	2	\N
3605	1	278	2	\N
3607	1	269	2	\N
3628	1	280	2	\N
3629	1	281	2	\N
3641	1	282	2	\N
3655	1	283	2	\N
3627	1	279	2	\N
3551	1	244	2	\N
4243	1	284	2	\N
4264	1	262	2	\N
4300	1	227	2	\N
4327	1	285	2	\N
4331	1	238	2	\N
4332	1	286	2	\N
4333	1	230	2	\N
4334	1	114	2	\N
4335	1	228	2	\N
4336	1	288	2	\N
4337	1	287	2	\N
4338	1	229	2	\N
3552	1	245	1	\N
62	1	110	1	\N
4363	1	292	2	\N
4364	1	290	2	\N
4365	1	293	2	\N
4366	1	291	2	\N
4367	1	289	2	\N
4383	1	295	2	\N
4384	1	296	2	\N
4385	1	294	2	\N
4395	1	1000	2	\N
4399	1	1001	2	\N
4403	1	297	2	\N
4404	1	298	2	\N
4411	1	299	2	\N
4415	1	300	2	\N
4431	1	304	2	\N
4432	1	303	2	\N
4433	1	301	2	\N
4434	1	302	2	\N
4438	1	305	2	\N
4442	1	1002	2	\N
4461	1	309	2	\N
4462	1	311	2	\N
4463	1	307	2	\N
4464	1	306	2	\N
4465	1	310	2	\N
4466	1	308	2	\N
\.


--
-- Data for Name: lmb_rules_dataset; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_rules_dataset (keyid, edituser, datid, userid, groupid, tabid, edit, del) FROM stdin;
\.


--
-- Data for Name: lmb_rules_fields; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_rules_fields (id, tab_id, field_id, group_id, tab_group, lmview, edit, color, filter, sort, need, filtertyp, nformat, currency, deflt, copy, lmtrigger, ext_type, ver, editrule, fieldoption, listedit, speechrec) FROM stdin;
1	1	1	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
2	1	2	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
3	1	3	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
4	1	4	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
5	1	5	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
6	1	6	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
7	1	7	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
8	1	8	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
9	1	9	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
10	1	10	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
11	1	11	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
12	1	12	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
13	1	13	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
14	1	14	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
15	1	15	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
16	1	16	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
17	1	17	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
18	1	18	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
19	1	19	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
20	1	20	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
21	1	21	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
22	1	22	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
23	1	23	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
24	1	24	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
25	1	25	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
26	1	26	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
27	1	27	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
28	1	28	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
29	1	29	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
30	1	30	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
31	1	31	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
32	1	32	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
33	1	33	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
34	1	34	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
35	2	1	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
36	2	2	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
37	2	3	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
38	2	4	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
39	2	5	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
40	2	6	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
41	2	7	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
42	2	8	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
43	2	9	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
44	2	10	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
45	2	11	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
46	2	12	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
47	2	13	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
48	2	14	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
49	2	15	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
50	2	16	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
51	2	17	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
52	2	18	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
53	2	19	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
54	2	20	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
55	2	21	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
56	2	22	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
57	2	23	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
58	2	24	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
59	2	25	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
60	2	26	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
61	2	27	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
62	2	28	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
63	2	29	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
64	2	30	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
65	2	31	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
66	2	32	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
67	2	33	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
68	2	34	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
69	2	35	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
70	2	36	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
71	2	37	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
72	3	1	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
73	3	2	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
74	3	3	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
75	3	4	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
76	3	5	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
77	3	6	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
78	3	7	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
79	3	8	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
80	3	9	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
81	3	10	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
82	3	11	1	1	t	t			0	f	0	\N	\N	\N	t	\N	\N	f	\N	t	\N	\N
\.


--
-- Data for Name: lmb_rules_repform; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_rules_repform (id, typ, group_id, repform_id, lmview, hidden) FROM stdin;
\.


--
-- Data for Name: lmb_rules_tables; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_rules_tables (id, group_id, tab_id, tab_group, edit, lmview, view_period, view_form, del, hide, lmadd, need, lmtrigger, view_tform, ver, editrule, hidemenu, userrules, viewver, lmlock, userprivilege, hiraprivilege, specificprivilege, indicator, copy, view_lform) FROM stdin;
1	1	1	1	t	t	0	0	t	t	t	f	\N	\N	\N	\N	f	f	f	f	f	f	\N	\N	t	\N
2	1	2	1	t	t	0	0	t	t	t	f	\N	\N	\N	\N	f	f	f	f	f	f	\N	\N	t	\N
3	1	3	1	t	t	0	0	t	t	t	f	\N	\N	\N	\N	f	f	f	f	f	f	\N	\N	t	\N
\.


--
-- Data for Name: lmb_select_d; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_select_d (id, tab_id, dat_id, erstdatum, erstuser, field_id, w_id) FROM stdin;
\.


--
-- Data for Name: lmb_select_p; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_select_p (id, erstdatum, erstuser, name, snum, tagmode, multimode) FROM stdin;
\.


--
-- Data for Name: lmb_select_w; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_select_w (id, sort, wert, erstdatum, erstuser, def, keywords, pool, hide, level, haslevel, lang2_wert, color) FROM stdin;
\.


--
-- Data for Name: lmb_session; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_session (id, user_id, group_id, logout, erstdatum, ip, filestruct_changed, table_changed, snap_changed) FROM stdin;
hkon8nimctpsqmlh39kdgttdc8	1	1	f	2020-09-18 12:29:47.979315	127.0.0.1	f	f	f
\.


--
-- Data for Name: lmb_snap; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_snap (id, user_id, tabid, name, erstdatum, global, filter, ext) FROM stdin;
\.


--
-- Data for Name: lmb_snap_shared; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_snap_shared (id, entity_type, entity_id, snapshot_id, edit, del) FROM stdin;
\.


--
-- Data for Name: lmb_sqlreserved; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_sqlreserved (id, sql_92) FROM stdin;
1	ABSOLUTE
5	ALL
6	ALLOCATE
7	ALTER
8	AND
9	ANY
10	ARE
12	AS
13	ASC
15	ASSERTION
17	AT
19	AUTHORIZATION
20	AVG
22	BEGIN
23	BETWEEN
26	BIT
27	BIT_LENGTH
30	BOTH
32	BY
33	CALL
35	CASCADE
36	CASCADED
37	CASE
38	CAST
39	CATALOG
40	CHAR
41	CHAR_LENGTH
42	CHARACTER
43	CHARACTER_LENGTH
44	CHECK
46	CLOSE
47	COALESCE
48	COLLATE
49	COLLATION
50	COLUMN
51	COMMIT
52	CONDITION
53	CONNECT
54	CONNECTION
55	CONSTRAINT
56	CONSTRAINTS
58	CONTAINS
59	CONTINUE
60	CONVERT
61	CORRESPONDING
62	COUNT
63	CREATE
64	CROSS
66	CURRENT
67	CURRENT_DATE
69	CURRENT_PATH
71	CURRENT_TIME
72	CURRENT_TIMESTAMP
74	CURRENT_USER
75	CURSOR
78	DATE
79	DAY
80	DEALLOCATE
81	DEC
82	DECIMAL
83	DECLARE
84	DEFAULT
85	DEFERRABLE
86	DEFERRED
87	DELETE
90	DESC
91	DESCRIBE
92	DESCRIPTOR
93	DETERMINISTIC
94	DIAGNOSTICS
95	DISCONNECT
96	DISTINCT
97	DO
98	DOMAIN
99	DOUBLE
100	DROP
104	ELSE
105	ELSEIF
106	END
108	ESCAPE
109	EXCEPT
110	EXCEPTION
111	EXEC
112	EXECUTE
113	EXISTS
114	EXIT
115	EXTERNAL
116	EXTRACT
117	FALSE
118	FETCH
120	FIRST
121	FLOAT
122	FOR
123	FOREIGN
124	FOUND
126	FROM
127	FULL
128	FUNCTION
130	GET
132	GO
133	GOTO
134	GRANT
135	GROUP
137	HANDLER
138	HAVING
140	HOUR
141	IDENTITY
142	IF
143	IMMEDIATE
144	IN
145	INDICATOR
146	INITIALLY
147	INNER
148	INOUT
149	INPUT
150	INSENSITIVE
151	INSERT
152	INT
153	INTEGER
154	INTERSECT
155	INTERVAL
156	INTO
157	IS
158	ISOLATION
160	JOIN
161	KEY
164	LAST
166	LEADING
167	LEAVE
168	LEFT
170	LIKE
171	LOCAL
175	LOOP
176	LOWER
178	MATCH
179	MAX
183	MIN
184	MINUTE
186	MODULE
187	MONTH
189	NAMES
190	NATIONAL
191	NATURAL
192	NCHAR
195	NEXT
196	NO
198	NOT
199	NULL
200	NULLIF
201	NUMERIC
203	OCTET_LENGTH
204	OF
206	ON
207	ONLY
208	OPEN
209	OPTION
210	OR
211	ORDER
213	OUT
214	OUTER
215	OUTPUT
217	OVERLAPS
218	PAD
219	PARAMETER
220	PARTIAL
222	PATH
223	POSITION
224	PRECISION
225	PREPARE
226	PRESERVE
227	PRIMARY
228	PRIOR
229	PRIVILEGES
230	PROCEDURE
231	PUBLIC
233	READ
235	REAL
238	REFERENCES
240	RELATIVE
242	REPEAT
243	RESIGNAL
244	RESTRICT
246	RETURN
247	RETURNS
248	REVOKE
249	RIGHT
251	ROLLBACK
253	ROUTINE
255	ROWS
257	SCHEMA
259	SCROLL
261	SECOND
262	SECTION
263	SELECT
266	SESSION_USER
267	SET
269	SIGNAL
272	SMALLINT
273	SOME
274	SPACE
275	SPECIFIC
277	SQL
278	SQLCODE
279	SQLERROR
280	SQLEXCEPTION
281	SQLSTATE
282	SQLWARNING
287	SUBSTRING
288	SUM
291	SYSTEM_USER
292	TABLE
294	TEMPORARY
295	THEN
296	TIME
297	TIMESTAMP
298	TIMEZONE_HOUR
299	TIMEZONE_MINUTE
300	TO
301	TRAILING
302	TRANSACTION
303	TRANSLATE
304	TRANSLATION
307	TRIM
308	TRUE
310	UNDO
311	UNION
312	UNIQUE
313	UNKNOWN
315	UNTIL
316	UPDATE
317	UPPER
318	USAGE
319	USER
320	USING
321	VALUE
322	VALUES
323	VARCHAR
324	VARYING
326	WHEN
327	WHENEVER
328	WHERE
329	WHILE
331	WITH
334	WORK
335	WRITE
336	YEAR
337	ZONE
348	ARRAY
351	ASENSITIVE
353	ASYMMETRIC
355	ATOMIC
361	BIGINT
362	BINARY
365	BLOB
366	BOOLEAN
371	CALLED
382	CLOB
402	CUBE
405	CURRENT_DEFAULT_TRANSFORM_GROUP
407	CURRENT_ROLE
410	CURRENT_TRANSFORM_GROUP_FOR_TYPE
413	CYCLE
426	DEREF
438	DYNAMIC
439	EACH
440	ELEMENT
462	FREE
473	GROUPING
476	HOLD
496	ITERATE
500	LARGE
502	LATERAL
509	LOCALTIME
510	LOCALTIMESTAMP
517	MEMBER
518	MERGE
519	METHOD
522	MODIFIES
525	MULTISET
530	NCLOB
531	NEW
534	NONE
542	OLD
553	OVER
558	PARTITION
569	RANGE
571	READS
573	RECURSIVE
574	REF
576	REFERENCING
578	RELEASE
589	ROLLUP
591	ROW
593	SAVEPOINT
595	SCOPE
597	SEARCH
601	SENSITIVE
607	SIMILAR
613	SPECIFICTYPE
622	STATIC
623	SUBMULTISET
626	SYMMETRIC
627	SYSTEM
630	TABLESAMPLE
642	TREAT
651	UNNEST
667	WINDOW
669	WITHIN
670	WITHOUT
678	AFTER
695	BEFORE
705	BREADTH
731	CONSTRUCTOR
751	DATA
781	EQUALS
803	GENERAL
848	LOCATOR
851	MAP
876	OBJECT
886	ORDINALITY
924	ROLE
942	SETS
983	UNDER
\.


--
-- Data for Name: lmb_sync_cache; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_sync_cache (id, tabid, datid, slave_id, slave_datid) FROM stdin;
\.


--
-- Data for Name: lmb_sync_conf; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_sync_conf (id, template, tabid, fieldid, master, slave) FROM stdin;
\.


--
-- Data for Name: lmb_sync_log; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_sync_log (erstdatum, type, tabid, datid, fieldid, origin, errorcode, message) FROM stdin;
\.


--
-- Data for Name: lmb_sync_slaves; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_sync_slaves (id, erstuser, erstdatum, name, slave_url, slave_username, slave_pass) FROM stdin;
\.


--
-- Data for Name: lmb_sync_template; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_sync_template (id, name, conflict_mode, tabid, setting) FROM stdin;
\.


--
-- Data for Name: lmb_tabletree; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_tabletree (id, erstuser, erstdatum, tabid, target_formid, display_field, display_icon, display_title, poolname, target_snap, display, display_sort, display_rule, treeid, relationid, itemtab) FROM stdin;
\.


--
-- Data for Name: lmb_trigger; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_trigger (id, erstdatum, editdatum, edituser, erstuser, table_name, type, trigger_value, description, active, intern, sort, name, dbvendor, debvendor, "position") FROM stdin;
\.


--
-- Data for Name: lmb_uglst; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_uglst (ugid, tabid, fieldid, datid, typ) FROM stdin;
1	11	6	15	g
1	11	6	21	g
2	11	6	7	g
3	11	6	20	g
8	11	6	8	u
5	11	6	16	u
3	34	43	1	g
1	34	43	1	u
8	34	43	1	u
\.


--
-- Data for Name: lmb_umgvar; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_umgvar (id, sort, form_name, norm, beschreibung, category) FROM stdin;
12	12	checkmime	0	check mimetype for uplodas	1899
1	1	font	Verdana,Arial,Helvetica	default font	1895
4	4	memolength	30	reduced memosize for list (digits)	1896
5	5	session_length	10	session-length	1900
6	6	default_currency	EUR	default currency code defined in table lmb_currency	1893
8	8	inusetime	1	locktime of used dataset (minutes)	1896
9	9	imagemagick	/usr/bin	path of ImageMagick	2819
10	10	searchcount	3	max paralell search	1896
13	13	imagemagickpdf	1	use ImageMagick for pdf	2819
14	14	imagemagicklimit	-quiet	ImageMagick limit	2819
16	16	indize_cs	1	index case-sensitive	1898
17	17	helplink	http://www.limbas.org/wiki/	URL to Help	1893
19	19	copycache	1	count of copycaches	1899
20	20	maxdownloads	2	count of max. par. downloads	1899
22	22	thumbsize2	400x300	default thumbnail size for detail	2819
23	23	thumbsize1	40x27	default thumbnail size	2819
24	24	use_exif	2	update exif metadata (1=XMP, 2=IPTC)	1899
25	25	lock	0	system locked	1900
26	26	resultspace	1000	max. rows in intern db-result	1896
28	28	indize_level	1	Detail-Level of Index	1898
29	29	indize_badword	0	limit index across bad_word table	1898
30	30	indize_header	1	index file-headers	1898
31	31	indize_timeout	60	Limits the maximum execution time in minutes	1898
32	32	debug_lang	0	view language-ID	1995
33	33	logout_page	index.php	page after logout	1894
34	34	use_gs	1	use ghostscript for pdf	2820
35	35	lock_timeout	5	unlocktime in minutes	1899
36	36	write_systemfolders	1	permission to add files in TAB or MESSAGE Folders	1899
37	37	clear_password	0	save clear password	1995
38	38	allowed_proxys	\N	allowed proxy server	1900
40	40	report_max_level	0	Limit of relation levels	1896
41	41	ext_im_analyse	0	extended analyse for images with IM (slow)	2819
42	42	thumbsize3	300x200	default thumbnail size for detail	2819
114	114	lp_params	\N	options for command lp	2935
115	115	password_hash	1	Password hashing algorithm (see PHP function password_hash)	1900
116	116	date_max_two_digit_year_addend	20	Amount of years (e.g. 20) to add to the current year (e.g. 2019 -> 2039) to<br>determine the timespan (1940-2039) that will be used to calculate the<br>full year when entered as the last two digits (e.g. 39 -> 2039, but 40 -> 1940)	1893
117	117	restpath	main_rest.php	different url path to REST api. (e.g. mylimbas.com/api -> /api). Default is main_rest.php	1893
118	118	multitenant	0	activate multitenant mode 	2818
119	119	multitenant_length	\N	size of multitenant ID (default 5 Numeric)	2818
120	120	php_mailer	IsHTML=1;IsSMTP=1;HOST=mail.myserver.com;Port=587;Auth=true;Sec=tls;User=username;From=accountname;Pass=password	parameter of php_mailer	2818
43	43	thumbnail_type	jpg	imagetype for thumbnails	2819
44	44	use_jsgraphics	0	enable jsgraphics functions	2818
45	45	default_layout	comet	default layout for new users	1893
46	46	default_results	30	default count of datasets per page for new users	1893
47	47	default_uloadsize	5	default uloadsize for new users (MB)	1893
50	50	ps_imageresolution	120	postscript image resolution	2820
51	51	ps_imagedepth	3	postscript image depth	2820
53	53	dubl_type	rename	handle dublicate files (rename/overwrite/versioning)	1899
54	54	calendar_weekends	1	show weekends	2700
57	57	indize_length	3	ignore words less then defined characters	1898
58	58	file_quickdownload	1	download file by click on filename	1899
59	59	crontab	/var/spool/cron/tabs/webuser	path to crontab	1894
60	60	favorite_limit	50	dilsplay maximum count of favorites	1899
61	61	send_userchanges	\N	send mail of userchanges to	1900
62	62	indize_feasible	10	amount of non alphanumeric digits in %	1898
63	63	indize_clean	1	clean indexed words to alphnumeric values	1898
64	64	use_md5	1	use md5 for files and dublicates	1899
65	65	preview_maxcount	5	maximum rows of short preview in media-frame	1896
67	67	ps_output	screen	screen/ebook/printer/prepress/default	2820
68	68	ps_downsample	1	use to compress pdfs	2820
69	69	use_html2text	0	use html2text instead of strip_tags	2818
70	70	use_datetimeclass	0	using DateTime class for handling Date and Time	2818
71	71	default_fieldwidth	100	default width of fields in px if not set	1896
73	73	default_timezone	Europe/Berlin	default timezone for new users	1893
74	74	default_setlocale	de_DE	default setlocale for new users	1893
75	75	ini_defaultlrl	\N	max size of long fields	2818
76	76	ini_maxsize	\N	max size of upload/post submits (MB)	2818
77	77	multiframe	default	default multiframe	1895
78	78	default_numberformat	2,',','.'	default numberformat for currency	1893
79	79	allocate_namespace	\N	range to allocate Table IDs (50-100)	2818
80	80	allocate_freeid	1-2	search free config ID	2818
82	82	detail_viewmode	editmode	view detail as (editmode/viewmode)	1896
83	83	wysiwygeditor	TinyMCE	WYSIWYG Editor (openwysiwyg/TinyMCE)	1895
84	84	calendar_firsthour	6	determines the first hour that will be visible in the scroll pane	2700
85	85	calendar_slotminutes	30	The frequency for displaying time slots, in minutes	2700
86	86	default_loglevel	1	default loglevel for new users (0=none;1=simple;2=full) 	1893
87	87	menurefresh	5	refresh of multiframe content in (minutes)	1896
88	88	report_calc_output	xls	report output format of type calc (xls/xlsx/CSV)	2820
89	89	wsdl_cache	1	use wsdl_cache	2818
90	90	use_unoconv	0	use unoconv converter if installed	1899
91	91	calendar_repetition	0	enables calendar repetitions	2700
95	95	server_auth	intern	server authentication method (intern/LDAP)	1900
2	2	fontsize	12	default font-size	1895
96	96	header_auth	basic	client browser authentication (basic/digest)	1900
97	97	LDAP_domain	\N	a valid LDAP or domain server	1900
98	98	LDAP_baseDn	DC=mydomain,DC=local	the base dn for your domain	1900
99	99	LDAP_accountSuffix	@mydomain.local	the full account suffix for your domain	1900
100	100	LDAP_defaultGroup	\N	default LIMBAS maingroup of all LDAP users	1900
102	102	LDAP_useSSL	0	use LDAP over SSL	1900
104	104	use_phpmailer	1	use PHPMailer for sendmail	2818
15	15	indize_filetype	pdf,text,txt,html	files to index (pdf,text,html OR 1 for all)	1898
18	18	calendar_firstday	1	first day of week (0=Sunday, 1=Monday, 2=Tuesday ..)	2700
52	52	ps_compatibilitylevel	1.4	postscript Compatibility Level	2820
55	55	update_metadata	jpg,jpeg,tiff,pdf,gif	update metadata to file (jpg,jpeg,tiff,pdf,gif OR 1 for all)	1899
56	56	read_metadata	jpg,jpeg,tiff,pdf,gif	read metadata from file (jpg,jpeg,tiff,pdf,gif OR 1 for all)	1899
66	66	password_as_image	\N	send password in user notification (image/plain/none)	1900
81	81	calendar_viewmode	month	default viewmode (month/agendaWeek/agendaDay/basicWeek/basicDay)	2700
92	92	database_version	90609	database version	2818
93	93	csv_delimiter	\N	csv export delimiter (\\t / ;)	2818
94	94	csv_enclosure	\N	csv export enclosure (")	2818
101	101	debug_messages	0	store all messages in messages.log	1995
103	103	csv_escape	\N	csv escape char (\\ / ~)	2818
105	105	multi_language	2	languages to translate (1,2,3)	1896
106	106	sync_mode	0	0=master, 1=slave	2818
107	107	sync_port	9004	php socket port	2818
108	108	sync_method	socket	ynchronization method (socket / soap)	2818
109	109	sync_timeout	10	numer of connection attempts	2818
110	110	page_title	Limbas-Demo - %s	custom title %s	1893
111	111	update_check	auto	check for updates (0/1/auto)	1893
112	112	lpstat_params	\N	options for command lpstat	2935
113	113	lpoptions_params	\N	options for command lpoptions	2935
121	121	soap_base64 	0	use base46 encoding for soap requests	2818
122	162	db-custerrors	0	activate customized error parsing &lt;LMB & LMB&gt;	1995
123	162	enc_cipher	AES-256-CBC	method used for data encryption	1900
124	1	postgres_use_fulltextsearch	0	activate postgres fulltextsearch instead of limbas native (0/1)	2995
125	2	postgres_indize_lang	all	language from pg_ts_config used for indexing: Either fixed (e.g. 'german') or autodetect (e.g. 'german,english' or 'all')	2995
126	3	postgres_headline	1	DMS: use postgres headline ('1') instead of limbas headline ('0') to show document context around search results. Yields better results, but is slower	2995
127	4	postgres_strip_tsvector	0	strip word position information from postgres tsvector columns. Reduces column size but disables phrase search ('0'/'1')	2995
128	5	postgres_rank_func	TS_RANK	DMS: the postgres function to order search results by relevance ('TS_RANK'/'TS_RANK_CD'). Leave empty for no order	2995
39	39	admin_mode	0	only for LIMBAS-Crew !!!	1995
7	7	company	your company	company	1893
49	49	default_language	1	default language for new users (language_id of lmb_lang)	1893
72	72	default_dateformat	1	default dateformat for new users (1=german;2=US;3=fra)	1893
11	11	charset	UTF-8	charset	1895
48	48	default_usercolor	2	default usercolor for new users (id of lmb_colorschemes)	1893
27	27	url		Base URL of installation	1893
3	3	path	/opt/openlimbas/dependent	absolute path of installation	1893
21	21	backup_default	localhost:////opt/openlimbas/dependent/BACKUP	default path of Backup	1893
\.


--
-- Data for Name: lmb_user_colors; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_user_colors (id, userid, wert) FROM stdin;
39	1	#96B400
40	1	#C3B400
41	1	#C37800
42	1	#D2E1D2
43	1	#A5E1D2
44	1	#2D87D2
45	1	#5A6900
46	1	#876900
47	1	#D26900
48	1	#D2FFF0
49	1	#A5FFF0
50	1	#5AFFF0
52	1	#FF0000
53	1	#F01EB4
54	1	#FFFF5A
\.


--
-- Data for Name: lmb_userdb; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_userdb (user_id, group_id, username, passwort, vorname, name, email, beschreibung, erstdatum, editdatum, maxresult, farbschema, lmlock, data_hide, language, layout, uploadsize, debug, sub_group, data_display, iprange, soundlist, change_pass, del, data_color, subadmin, logging, validdate, valid, lock_txt, ufile, t_setting, symbolbar, usercolor, lockbackend, clearpass, session, gc_maxlifetime, id, static_ip, dateformat, setlocal, time_zone, ugtab, e_setting, m_setting, tel, fax, "position", superadmin, multitenant, dlanguage) FROM stdin;
1	1	admin	$2y$10$9WAMJDTSUf6DL/JII/4N9uNnNLxDAMLyuDrDAvSPoFJZS/L.mGNBe	Adminus	Administratos	test@test.org	test	2000-12-17 12:45:28	2019-03-12 14:57:21	15	2	f	1	1	comet	104857600	f	\N	1	*.*.*.*	notify.wav;ringin.wav;latetermin.wav	f	f	f	f	1	\N	f	\N		;;;	t	FFFFF	f	limbas123	\N	0	1	f	1	de_DE	Europe/Berlin	a:1:{s:6:"filter";a:5:{s:18:"ext_RelationFields";a:12:{s:8:"g_4_57_2";a:1:{i:1;s:1:"4";}s:7:"g_4_57_";a:1:{i:1;s:1:"4";}s:9:"g_25_23_9";a:2:{i:0;s:1:"1";i:1;s:1:"2";}s:8:"g_4_34_8";a:1:{i:0;s:1:"7";}s:9:"g_25_28_9";a:3:{i:0;s:1:"4";i:1;s:1:"2";i:2;s:1:"1";}s:4:"edit";a:2:{s:9:"g_25_28_9";i:1;s:9:"g_25_15_9";i:1;}s:9:"g_25_15_9";a:1:{i:0;s:1:"2";}s:6:"g_6_5_";a:2:{i:0;s:1:"2";i:1;s:4:"1001";}s:8:"g_4_13_2";a:2:{i:0;s:1:"1";i:1;s:1:"2";}s:5:"order";a:1:{s:9:"g_25_23_9";a:1:{i:0;a:3:{i:0;s:1:"1";i:1;s:1:"1";i:2;s:3:"ASC";}}}s:9:"g_34_62_5";a:0:{}s:8:"g_4_34_2";a:2:{i:0;s:1:"7";i:1;s:2:"20";}}s:12:"tabulatorKey";a:4:{i:4;a:1:{i:7;s:2:"11";}i:34;a:5:{i:157;N;i:217;N;i:382;N;i:467;N;i:478;N;}i:25;a:3:{i:2;s:1:"4";i:6;s:1:"7";i:37;s:2:"38";}i:1;a:1:{i:37;s:2:"38";}}s:14:"groupheaderKey";a:7:{i:4;s:2:"25";i:34;s:2:"52";i:25;s:2:"17";i:1;s:2:"27";i:2;s:1:"1";i:3;s:1:"7";i:23;s:2:"17";}s:11:"groupheader";a:2:{i:2;i:1;i:3;i:1;}s:6:"gwidth";a:2:{i:14;s:17:"calc(100% - 80px)";i:15;s:17:"calc(100% - 80px)";}}}	a:1:{i:36;a:7:{s:9:"full_name";s:0:"";s:13:"email_address";s:0:"";s:13:"reply_address";s:0:"";s:13:"imap_hostname";s:0:"";s:13:"imap_username";s:0:"";s:13:"imap_password";s:0:"";s:9:"imap_port";s:0:"";}}	a:4:{s:4:"menu";a:14:{s:4:"21_0";i:1;s:4:"21_1";i:1;s:6:"1000_1";i:1;s:9:"279_27903";i:1;s:6:"1000_0";i:1;s:5:"244_0";i:1;s:5:"301_0";i:1;s:5:"244_1";i:1;s:5:"244_2";i:1;s:5:"244_3";i:1;s:6:"1000_2";i:1;s:4:"17_1";i:1;s:4:"17_0";i:1;s:4:"17_3";i:1;}s:5:"frame";a:3:{s:3:"cal";s:1:"1";s:3:"nav";s:3:"292";s:10:"multiframe";s:2:"15";}s:7:"submenu";a:56:{s:13:"17_LIMBAS CRM";i:1;s:14:"17_Demo tables";i:1;s:15:"17_Demo queries";i:1;s:12:"17_Limbassys";i:1;s:14:"17_System jobs";i:1;s:15:"17_Beispiel-CRM";i:1;s:21:"17_Tutorial-Beispiele";i:1;s:13:"244_Feldtypen";i:1;s:14:"17_System-Jobs";i:1;s:23:"244_ArtBetragPositionen";i:1;s:9:"17_Backup";i:1;s:20:"17_Tutorial-Abfragen";i:1;s:5:"17_36";i:1;s:5:"17_54";i:1;s:5:"17_56";i:1;s:5:"17_37";i:1;s:5:"17_57";i:1;s:5:"17_63";i:1;s:5:"17_64";i:1;s:5:"17_67";i:1;s:5:"17_68";i:1;s:5:"17_65";i:1;s:6:"244_25";i:1;s:5:"17_66";i:1;s:5:"17_47";i:1;s:5:"17_69";i:1;s:5:"17_46";i:1;s:5:"244_2";i:1;s:5:"17_70";i:1;s:6:"244_16";i:1;s:5:"244_0";i:1;s:5:"244_1";i:1;s:5:"244_3";i:1;s:5:"17_71";i:1;s:6:"244_12";i:1;s:5:"17_72";i:1;s:5:"17_73";i:1;s:5:"17_74";i:1;s:5:"17_53";i:1;s:5:"17_52";i:1;s:5:"244_9";i:1;s:5:"17_44";i:1;s:5:"17_50";i:1;s:5:"17_51";i:1;s:5:"17_75";i:1;s:5:"17_55";i:1;s:5:"17_79";i:1;s:5:"17_76";i:1;s:5:"17_77";i:1;s:5:"17_80";i:1;s:5:"17_78";i:1;s:5:"17_58";i:1;s:5:"17_59";i:1;s:5:"17_81";i:1;s:5:"17_61";i:1;s:5:"17_27";i:1;}s:3:"fav";a:6:{s:10:"form;23;15";i:1;s:9:"diag;10;2";i:1;s:6:"tab;1;";i:1;s:7:"rep;4;3";i:1;s:6:"tab;4;";i:1;s:7:"tab;25;";i:1;}}	\N	\N	\N	t	\N	\N
\.


--
-- Data for Name: lmb_usrgrp_lst; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_usrgrp_lst (user_id, entity_type, entity_id) FROM stdin;
\.


--
-- Data for Name: lmb_wfl; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_wfl (id, name, descr, startid, params) FROM stdin;
\.


--
-- Data for Name: lmb_wfl_history; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_wfl_history (id, erstdatum, inst_id, task_id, user_id, wfl_id, tab_id, dat_id) FROM stdin;
\.


--
-- Data for Name: lmb_wfl_inst; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_wfl_inst (id, tab_id, dat_id, task_id, wfl_id) FROM stdin;
\.


--
-- Data for Name: lmb_wfl_task; Type: TABLE DATA; Schema: public; Owner: limbasuser
--

COPY public.lmb_wfl_task (id, name, descr, wfl_id, tab_id, tasks_usable, params, sort) FROM stdin;
\.


--
-- Name: seq_adressen_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_adressen_id', 10, false);


--
-- Name: seq_artikel_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_artikel_id', 83, false);


--
-- Name: seq_aufgaben_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_aufgaben_id', 23, false);


--
-- Name: seq_auftraege_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_auftraege_id', 33, false);


--
-- Name: seq_ausgaben_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_ausgaben_id', 5, false);


--
-- Name: seq_berichtstemplate_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_berichtstemplate_id', 8, false);


--
-- Name: seq_feldtypen_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_feldtypen_id', 3, false);


--
-- Name: seq_kontakte_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_kontakte_id', 119, false);


--
-- Name: seq_korrespondenz_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_korrespondenz_id', 188, false);


--
-- Name: seq_kunden_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_kunden_id', 94, false);


--
-- Name: seq_ldms_files_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_ldms_files_id', 1, false);


--
-- Name: seq_ldms_meta_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_ldms_meta_id', 1, false);


--
-- Name: seq_lmb_custvar_depend_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_lmb_custvar_depend_id', 1, false);


--
-- Name: seq_lmb_history_action_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_lmb_history_action_id', 4, false);


--
-- Name: seq_lmb_history_update_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_lmb_history_update_id', 1, false);


--
-- Name: seq_lmb_history_user_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_lmb_history_user_id', 39, true);


--
-- Name: seq_lmb_reminder_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_lmb_reminder_id', 135, false);


--
-- Name: seq_lmb_wfl_inst_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_lmb_wfl_inst_id', 89, false);


--
-- Name: seq_meinkalender_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_meinkalender_id', 6, false);


--
-- Name: seq_mitarbeiter_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_mitarbeiter_id', 11, false);


--
-- Name: seq_nachrichten_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_nachrichten_id', 1, false);


--
-- Name: seq_positionen_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_positionen_id', 99, false);


--
-- Name: seq_projekte_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_projekte_id', 6, false);


--
-- Name: seq_raeume_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_raeume_id', 12, false);


--
-- Name: seq_raumverteilung_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_raumverteilung_id', 33, false);


--
-- Name: seq_templates_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_templates_id', 2, false);


--
-- Name: seq_verk_070140c2ecc06_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_070140c2ecc06_keyid', 3, false);


--
-- Name: seq_verk_07a6948db7d45_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_07a6948db7d45_keyid', 1, false);


--
-- Name: seq_verk_10f25cf14fe63_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_10f25cf14fe63_keyid', 4, false);


--
-- Name: seq_verk_17e64eb8914c6_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_17e64eb8914c6_keyid', 100, false);


--
-- Name: seq_verk_1fb5ab7537f76_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_1fb5ab7537f76_keyid', 8, false);


--
-- Name: seq_verk_242f6cad318bb_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_242f6cad318bb_keyid', 8, false);


--
-- Name: seq_verk_3fcf4e1eb67e5_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_3fcf4e1eb67e5_keyid', 1, false);


--
-- Name: seq_verk_442a8f1d8a126_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_442a8f1d8a126_keyid', 6, false);


--
-- Name: seq_verk_4465a9d897b7f_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_4465a9d897b7f_keyid', 92, false);


--
-- Name: seq_verk_5c73240091186_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_5c73240091186_keyid', 8, false);


--
-- Name: seq_verk_5ca376805922b_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_5ca376805922b_keyid', 40, false);


--
-- Name: seq_verk_6f91ec1c8fa36_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_6f91ec1c8fa36_keyid', 14, false);


--
-- Name: seq_verk_7a0c66d0b880b_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_7a0c66d0b880b_keyid', 4, false);


--
-- Name: seq_verk_7a74d69e7b5f2_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_7a74d69e7b5f2_keyid', 184, false);


--
-- Name: seq_verk_865cb28dc0601_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_865cb28dc0601_keyid', 5, false);


--
-- Name: seq_verk_91fb8ff20bffc_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_91fb8ff20bffc_keyid', 37, false);


--
-- Name: seq_verk_9259d5b2c1857_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_9259d5b2c1857_keyid', 2, false);


--
-- Name: seq_verk_9f0323be5cf4e_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_9f0323be5cf4e_id', 2, false);


--
-- Name: seq_verk_9f0323be5cf4e_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_9f0323be5cf4e_keyid', 4, false);


--
-- Name: seq_verk_a01fc1e65ef75_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_a01fc1e65ef75_keyid', 1, false);


--
-- Name: seq_verk_ab02c3dbf12e1_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_ab02c3dbf12e1_id', 6, false);


--
-- Name: seq_verk_ab02c3dbf12e1_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_ab02c3dbf12e1_keyid', 11, false);


--
-- Name: seq_verk_ae2df1f3eb751_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_ae2df1f3eb751_keyid', 3, false);


--
-- Name: seq_verk_b549a745c24f3_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_b549a745c24f3_keyid', 6, false);


--
-- Name: seq_verk_ed4cbeb1c927c_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_ed4cbeb1c927c_keyid', 3, false);


--
-- Name: seq_verk_f7bd3e7b4766a_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_f7bd3e7b4766a_keyid', 14, false);


--
-- Name: seq_verk_fcd12e02a5a6c_keyid; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_verk_fcd12e02a5a6c_keyid', 4, false);


--
-- Name: seq_zahlungseingang_id; Type: SEQUENCE SET; Schema: public; Owner: limbasuser
--

SELECT pg_catalog.setval('public.seq_zahlungseingang_id', 16, false);


--
-- Name: ldms_favorites ldms_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.ldms_favorites
    ADD CONSTRAINT ldms_favorites_pkey PRIMARY KEY (id);


--
-- Name: ldms_files ldms_files_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.ldms_files
    ADD CONSTRAINT ldms_files_pkey PRIMARY KEY (id);


--
-- Name: ldms_meta ldms_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.ldms_meta
    ADD CONSTRAINT ldms_meta_pkey PRIMARY KEY (id);


--
-- Name: ldms_rules ldms_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.ldms_rules
    ADD CONSTRAINT ldms_rules_pkey PRIMARY KEY (id);


--
-- Name: ldms_structure ldms_structure_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.ldms_structure
    ADD CONSTRAINT ldms_structure_pkey PRIMARY KEY (id);


--
-- Name: lmb_action_depend lmb_action_depend_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_action_depend
    ADD CONSTRAINT lmb_action_depend_pkey PRIMARY KEY (id);


--
-- Name: lmb_action lmb_action_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_action
    ADD CONSTRAINT lmb_action_pkey PRIMARY KEY (id);


--
-- Name: lmb_attribute_d lmb_attribute_d_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_attribute_d
    ADD CONSTRAINT lmb_attribute_d_pkey PRIMARY KEY (id);


--
-- Name: lmb_attribute_p lmb_attribute_p_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_attribute_p
    ADD CONSTRAINT lmb_attribute_p_pkey PRIMARY KEY (id);


--
-- Name: lmb_attribute_w lmb_attribute_w_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_attribute_w
    ADD CONSTRAINT lmb_attribute_w_pkey PRIMARY KEY (id);


--
-- Name: lmb_auth_token lmb_auth_token_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_auth_token
    ADD CONSTRAINT lmb_auth_token_pkey PRIMARY KEY (token);


--
-- Name: lmb_chart_list lmb_chart_list_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_chart_list
    ADD CONSTRAINT lmb_chart_list_pkey PRIMARY KEY (id);


--
-- Name: lmb_charts lmb_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_charts
    ADD CONSTRAINT lmb_charts_pkey PRIMARY KEY (id);


--
-- Name: lmb_code_favorites lmb_code_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_code_favorites
    ADD CONSTRAINT lmb_code_favorites_pkey PRIMARY KEY (id);


--
-- Name: lmb_colorschemes lmb_colorschemes_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_colorschemes
    ADD CONSTRAINT lmb_colorschemes_pkey PRIMARY KEY (id);


--
-- Name: lmb_conf_fields lmb_conf_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_conf_fields
    ADD CONSTRAINT lmb_conf_fields_pkey PRIMARY KEY (id);


--
-- Name: lmb_conf_groups lmb_conf_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_conf_groups
    ADD CONSTRAINT lmb_conf_groups_pkey PRIMARY KEY (id);


--
-- Name: lmb_conf_tables lmb_conf_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_conf_tables
    ADD CONSTRAINT lmb_conf_tables_pkey PRIMARY KEY (id);


--
-- Name: lmb_conf_views lmb_conf_views_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_conf_views
    ADD CONSTRAINT lmb_conf_views_pkey PRIMARY KEY (id);


--
-- Name: lmb_crontab lmb_crontab_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_crontab
    ADD CONSTRAINT lmb_crontab_pkey PRIMARY KEY (id);


--
-- Name: lmb_currency lmb_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_currency
    ADD CONSTRAINT lmb_currency_pkey PRIMARY KEY (code);


--
-- Name: lmb_currency_rate lmb_currency_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_currency_rate
    ADD CONSTRAINT lmb_currency_rate_pkey PRIMARY KEY (id);


--
-- Name: lmb_custmenu_list lmb_custmenu_list_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_custmenu_list
    ADD CONSTRAINT lmb_custmenu_list_pkey PRIMARY KEY (id);


--
-- Name: lmb_custmenu lmb_custmenu_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_custmenu
    ADD CONSTRAINT lmb_custmenu_pkey PRIMARY KEY (id);


--
-- Name: lmb_custvar_depend lmb_custvar_depend_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_custvar_depend
    ADD CONSTRAINT lmb_custvar_depend_pkey PRIMARY KEY (id);


--
-- Name: lmb_custvar lmb_custvar_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_custvar
    ADD CONSTRAINT lmb_custvar_pkey PRIMARY KEY (id);


--
-- Name: lmb_dbpatch lmb_dbpatch_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_dbpatch
    ADD CONSTRAINT lmb_dbpatch_pkey PRIMARY KEY (id);


--
-- Name: lmb_external_storage lmb_external_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_external_storage
    ADD CONSTRAINT lmb_external_storage_pkey PRIMARY KEY (id);


--
-- Name: lmb_field_types lmb_field_types_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_field_types
    ADD CONSTRAINT lmb_field_types_pkey PRIMARY KEY (id);


--
-- Name: lmb_fonts lmb_fonts_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_fonts
    ADD CONSTRAINT lmb_fonts_pkey PRIMARY KEY (id);


--
-- Name: lmb_form_list lmb_form_list_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_form_list
    ADD CONSTRAINT lmb_form_list_pkey PRIMARY KEY (id);


--
-- Name: lmb_forms lmb_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_forms
    ADD CONSTRAINT lmb_forms_pkey PRIMARY KEY (id);


--
-- Name: lmb_groups lmb_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_groups
    ADD CONSTRAINT lmb_groups_pkey PRIMARY KEY (group_id);


--
-- Name: lmb_gtab_groupdat lmb_gtab_groupdat_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_gtab_groupdat
    ADD CONSTRAINT lmb_gtab_groupdat_pkey PRIMARY KEY (id);


--
-- Name: lmb_gtab_pattern lmb_gtab_pattern_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_gtab_pattern
    ADD CONSTRAINT lmb_gtab_pattern_pkey PRIMARY KEY (id);


--
-- Name: lmb_gtab_rowsize lmb_gtab_rowsize_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_gtab_rowsize
    ADD CONSTRAINT lmb_gtab_rowsize_pkey PRIMARY KEY (id);


--
-- Name: lmb_gtab_status_save lmb_gtab_status_save_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_gtab_status_save
    ADD CONSTRAINT lmb_gtab_status_save_pkey PRIMARY KEY (id);


--
-- Name: lmb_history_action lmb_history_action_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_history_action
    ADD CONSTRAINT lmb_history_action_pkey PRIMARY KEY (id);


--
-- Name: lmb_history_backup lmb_history_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_history_backup
    ADD CONSTRAINT lmb_history_backup_pkey PRIMARY KEY (id);


--
-- Name: lmb_history_update lmb_history_update_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_history_update
    ADD CONSTRAINT lmb_history_update_pkey PRIMARY KEY (id);


--
-- Name: lmb_history_user lmb_history_user_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_history_user
    ADD CONSTRAINT lmb_history_user_pkey PRIMARY KEY (id);


--
-- Name: lmb_indize_d lmb_indize_d_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_indize_d
    ADD CONSTRAINT lmb_indize_d_pkey PRIMARY KEY (id);


--
-- Name: lmb_indize_ds lmb_indize_ds_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_indize_ds
    ADD CONSTRAINT lmb_indize_ds_pkey PRIMARY KEY (id);


--
-- Name: lmb_indize_f lmb_indize_f_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_indize_f
    ADD CONSTRAINT lmb_indize_f_pkey PRIMARY KEY (id);


--
-- Name: lmb_indize_fs lmb_indize_fs_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_indize_fs
    ADD CONSTRAINT lmb_indize_fs_pkey PRIMARY KEY (id);


--
-- Name: lmb_indize_history lmb_indize_history_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_indize_history
    ADD CONSTRAINT lmb_indize_history_pkey PRIMARY KEY (id);


--
-- Name: lmb_indize_w lmb_indize_w_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_indize_w
    ADD CONSTRAINT lmb_indize_w_pkey PRIMARY KEY (id);


--
-- Name: lmb_lang_depend lmb_lang_depend_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_lang_depend
    ADD CONSTRAINT lmb_lang_depend_pkey PRIMARY KEY (id);


--
-- Name: lmb_lang lmb_lang_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_lang
    ADD CONSTRAINT lmb_lang_pkey PRIMARY KEY (id);


--
-- Name: lmb_mimetypes lmb_mimetypes_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_mimetypes
    ADD CONSTRAINT lmb_mimetypes_pkey PRIMARY KEY (id);


--
-- Name: lmb_multitenant lmb_multitenant_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_multitenant
    ADD CONSTRAINT lmb_multitenant_pkey PRIMARY KEY (id);


--
-- Name: lmb_printers lmb_printers_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_printers
    ADD CONSTRAINT lmb_printers_pkey PRIMARY KEY (id);


--
-- Name: lmb_reminder_list lmb_reminder_list_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_reminder_list
    ADD CONSTRAINT lmb_reminder_list_pkey PRIMARY KEY (id);


--
-- Name: lmb_reminder lmb_reminder_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_reminder
    ADD CONSTRAINT lmb_reminder_pkey PRIMARY KEY (id);


--
-- Name: lmb_report_list lmb_report_list_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_report_list
    ADD CONSTRAINT lmb_report_list_pkey PRIMARY KEY (id);


--
-- Name: lmb_reports lmb_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_reports
    ADD CONSTRAINT lmb_reports_pkey PRIMARY KEY (id);


--
-- Name: lmb_revision lmb_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_revision
    ADD CONSTRAINT lmb_revision_pkey PRIMARY KEY (id);


--
-- Name: lmb_rules_action lmb_rules_action_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_rules_action
    ADD CONSTRAINT lmb_rules_action_pkey PRIMARY KEY (id);


--
-- Name: lmb_rules_dataset lmb_rules_dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_rules_dataset
    ADD CONSTRAINT lmb_rules_dataset_pkey PRIMARY KEY (keyid);


--
-- Name: lmb_rules_fields lmb_rules_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_rules_fields
    ADD CONSTRAINT lmb_rules_fields_pkey PRIMARY KEY (id);


--
-- Name: lmb_rules_repform lmb_rules_repform_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_rules_repform
    ADD CONSTRAINT lmb_rules_repform_pkey PRIMARY KEY (id);


--
-- Name: lmb_rules_tables lmb_rules_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_rules_tables
    ADD CONSTRAINT lmb_rules_tables_pkey PRIMARY KEY (id);


--
-- Name: lmb_select_d lmb_select_d_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_select_d
    ADD CONSTRAINT lmb_select_d_pkey PRIMARY KEY (id);


--
-- Name: lmb_select_p lmb_select_p_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_select_p
    ADD CONSTRAINT lmb_select_p_pkey PRIMARY KEY (id);


--
-- Name: lmb_select_w lmb_select_w_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_select_w
    ADD CONSTRAINT lmb_select_w_pkey PRIMARY KEY (id);


--
-- Name: lmb_session lmb_session_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_session
    ADD CONSTRAINT lmb_session_pkey PRIMARY KEY (id);


--
-- Name: lmb_snap lmb_snap_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_snap
    ADD CONSTRAINT lmb_snap_pkey PRIMARY KEY (id);


--
-- Name: lmb_snap_shared lmb_snap_shared_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_snap_shared
    ADD CONSTRAINT lmb_snap_shared_pkey PRIMARY KEY (id);


--
-- Name: lmb_sync_cache lmb_sync_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_sync_cache
    ADD CONSTRAINT lmb_sync_cache_pkey PRIMARY KEY (id);


--
-- Name: lmb_sync_conf lmb_sync_conf_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_sync_conf
    ADD CONSTRAINT lmb_sync_conf_pkey PRIMARY KEY (id);


--
-- Name: lmb_sync_slaves lmb_sync_slaves_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_sync_slaves
    ADD CONSTRAINT lmb_sync_slaves_pkey PRIMARY KEY (id);


--
-- Name: lmb_sync_template lmb_sync_template_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_sync_template
    ADD CONSTRAINT lmb_sync_template_pkey PRIMARY KEY (id);


--
-- Name: lmb_tabletree lmb_tabletree_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_tabletree
    ADD CONSTRAINT lmb_tabletree_pkey PRIMARY KEY (id);


--
-- Name: lmb_user_colors lmb_user_colors_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_user_colors
    ADD CONSTRAINT lmb_user_colors_pkey PRIMARY KEY (id);


--
-- Name: lmb_userdb lmb_userdb_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_userdb
    ADD CONSTRAINT lmb_userdb_pkey PRIMARY KEY (user_id);


--
-- Name: lmb_usrgrp_lst lmb_usrgrp_lst_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_usrgrp_lst
    ADD CONSTRAINT lmb_usrgrp_lst_pkey PRIMARY KEY (entity_id);


--
-- Name: lmb_wfl_history lmb_wfl_history_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_wfl_history
    ADD CONSTRAINT lmb_wfl_history_pkey PRIMARY KEY (id);


--
-- Name: lmb_wfl_inst lmb_wfl_inst_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_wfl_inst
    ADD CONSTRAINT lmb_wfl_inst_pkey PRIMARY KEY (id);


--
-- Name: lmb_wfl lmb_wfl_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_wfl
    ADD CONSTRAINT lmb_wfl_pkey PRIMARY KEY (id);


--
-- Name: lmb_wfl_task lmb_wfl_task_pkey; Type: CONSTRAINT; Schema: public; Owner: limbasuser
--

ALTER TABLE ONLY public.lmb_wfl_task
    ADD CONSTRAINT lmb_wfl_task_pkey PRIMARY KEY (id);


--
-- Name: lmbind_01217b04ccb8; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_01217b04ccb8 ON public.lmb_indize_ds USING btree (sid);


--
-- Name: lmbind_0314e7967dee; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_0314e7967dee ON public.lmb_select_w USING btree (sort);


--
-- Name: lmbind_04ce156187bf; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_04ce156187bf ON public.lmb_gtab_groupdat USING btree (dat_id);


--
-- Name: lmbind_088efa7e573d; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_088efa7e573d ON public.lmb_indize_fs USING btree (wid);


--
-- Name: lmbind_0bd11c6c8a2c; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_0bd11c6c8a2c ON public.lmb_indize_fs USING btree (fid);


--
-- Name: lmbind_26978b187133; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_26978b187133 ON public.lmb_indize_ds USING btree (wid);


--
-- Name: lmbind_2f2ee5e97d38; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_2f2ee5e97d38 ON public.lmb_select_d USING btree (dat_id);


--
-- Name: lmbind_334cacede330; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_334cacede330 ON public.lmb_indize_d USING btree (sid);


--
-- Name: lmbind_34739590a79d; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_34739590a79d ON public.lmb_indize_f USING btree (sid);


--
-- Name: lmbind_38eeeaf25327; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_38eeeaf25327 ON public.lmb_indize_f USING btree (fid);


--
-- Name: lmbind_400c234940f9; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_400c234940f9 ON public.lmb_indize_d USING btree (ref);


--
-- Name: lmbind_58f4d604caa2; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_58f4d604caa2 ON public.lmb_reminder USING btree (dat_id);


--
-- Name: lmbind_79016facda02; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_79016facda02 ON public.lmb_select_w USING btree (pool);


--
-- Name: lmbind_7c2ac7f0499b; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_7c2ac7f0499b ON public.lmb_history_action USING btree (userid);


--
-- Name: lmbind_7dde11622c42; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_7dde11622c42 ON public.lmb_select_w USING btree (wert);


--
-- Name: lmbind_7e69e22bebf1; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_7e69e22bebf1 ON public.lmb_indize_d USING btree (wid);


--
-- Name: lmbind_90142d95ea80; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_90142d95ea80 ON public.lmb_reminder USING btree (frist);


--
-- Name: lmbind_c002031e56f6; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_c002031e56f6 ON public.lmb_indize_w USING btree (metaphone);


--
-- Name: lmbind_e7316051ee6a; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_e7316051ee6a ON public.lmb_indize_ds USING btree (ref);


--
-- Name: lmbind_e880d842e2eb; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_e880d842e2eb ON public.lmb_select_d USING btree (w_id);


--
-- Name: lmbind_f64c6f0c9be4; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_f64c6f0c9be4 ON public.lmb_indize_f USING btree (wid);


--
-- Name: lmbind_fcb928ba00ba; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_fcb928ba00ba ON public.lmb_indize_fs USING btree (sid);


--
-- Name: lmbind_fec71f938036; Type: INDEX; Schema: public; Owner: limbasuser
--

CREATE INDEX lmbind_fec71f938036 ON public.lmb_indize_w USING btree (val);


--
-- PostgreSQL database dump complete
--

