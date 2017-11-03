
-- table: ip_addresses
--    this will collect ip addresses from 
--    submissions, quotes, comments, registrations, etc.

create table ip_addresses (
    id                  bigserial not null primary key,
    address             character (16) unique not null
);

-- table: banned_IPs
--     contains banned ip addresses and address ranges
--     supports wildcards ? and *
--     set date expires to 0000/00/00 00:00 for permaban ?

create table banned_IPs (
    id                  bigserial primary key,
    address             character (16) unique not null,
    date_banned         timestamp without time zone not null,
    date_expires        timestamp without time zone not null,
    banned_by           bigint references users (id) not null,
    remarks             character varying (512)
);

-- table: users
--
--    since users can enter a name without being registered,
--    this table is somewhat weird and a not of fields are missing "not null"s
--    because they don't apply to unregistered users.
--
--    should we split this table?
--    id 0 := anonymous?
--
--    also, account types:
--    0: locked / banned username
--    1: unregistered user
--    2: registered user 
--    3: registered user with pubadmin access
--    4: mod
--    5: admin

create table users (
    id                  bigserial primary key,
    username            character varying (128) not null,
    nlzd_name           character varying (128),
    is_registered       boolean not null,
    date_registered     timestamp without time zone,
    email               character varying (512),
    registration_ip     bigint references ip_addresses (id),
    pw_hash             character (512),
    pw_salt             character (512),
    account_type        smallint not null,
    submission_count    bigint not null,
    comment_count       bigint not null,
    unique (username, is_registered)
);

create table fundies (
    id                  bigserial primary key,
    name                character varying (128) not null unique,
    nlzd_name           character varying (128) not null
);

create table sites (
    id                  bigserial primary key,
    name                character varying (128) not null unique,
    nlzd_name           character varying (128) not null
);

create table categories (
    id                  smallserial primary key,
    name                character varying (64) not null unique,
    abbreviation        character varying (8) not null unique,
    description         character varying (128) not null unique
);

create table quotes (
    id                  bigserial primary key,
    date_posted         timestamp without time zone not null,
    submitter           bigint references users (id) not null,
    submitter_ip        bigint references ip_addresses (id) not null,
    fundie              bigint references fundies (id) not null,
    site                bigint references sites (id) not null,
    text                character varying (65536) not null,
    votes_yay           bigint not null,
    votes_nay           bigint not null,
    unique_views        bigint not null,
    total_views         bigint not null,
    is_visible          boolean not null,
    is_locked           boolean not null,
    use_yscodes         boolean not null
);

create table quotes_categories_link (
    quote_id            bigint references quotes (id) not null,
    category_id         bigint references categories (id) not null,
    primary key (quote_id, category_id)
);

create table comments (
    id                  bigserial primary key,
    quote               bigint references quotes (id),
    author              bigint references users (id),
    ip_address          bigint references ip_addresses (id),
    date_posted         timestamp without time zone not null,
    date_modified       timestamp without time zone,
    text                character varying (65536) not null,     
    is_visible          boolean not null
);

create table stats_useragents (
    id                  BIGSERIAL primary key,
    string              character varying (512) not null unique,
    unique_users        bigint not null,
    total_users         bigint not null
);

create table stats_displays (
    id                  bigserial primary key,
    size_small          integer not null,
    size_large          integer not null,
    is_landscape        integer not null,
    is_portrait         integer not null,
    unique_users        bigint not null,
    total_users         bigint not null,
    unique (size_small, size_large)
);
