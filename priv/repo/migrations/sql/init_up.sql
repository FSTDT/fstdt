-- TODO: Split this huge-ass file into smaller ones and combine them using \i.

CREATE TABLE "stats_IPs" (
    "id"                 BIGSERIAL PRIMARY KEY,
    "address"            CHARACTER (16) UNIQUE NOT NULL,
    "date_first_seen"    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

/*  
    Table: "stats_UAs_nvi"
    Useragent strings with no version information
    
    This is a table of useragents with all version information removed.
    It is here as a convenience to prevent stripping version information
    repeatedly when working with statistics. The full useragent table
    is below this one because it references this one.
    
    Useragent strings are prenormalized to extent that they are all 
    converted to entirely lowercase, and all excessive whitespasce is
    removed from them in the unlikely event any is present. Regular
    useragent strings (see table below) follow the same format. 
    
    Relevant side node:
    You can use WITH...AS to join a self-referencing table with itself.
    This is relevant to both useragent tables, and it will popup again in KPA.
*/
   
CREATE TABLE "stats_UAs_nvi" (
    "id"                BIGSERIAL PRIMARY KEY,
    "string"            CHARACTER VARYING (512) UNIQUE NOT NULL,
    "date_first_seen"   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "predecessor"       BIGINT DEFAULT NULL REFERENCES "stats_UAs_nvi" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT                          
);

CREATE TABLE "stats_UAs" (
    "id"                BIGSERIAL PRIMARY KEY,
    "string"            CHARACTER VARYING (512) UNIQUE NOT NULL,
    "string_nvi"        BIGINT NOT NULL REFERENCES "stats_UAs_nvi" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT,
    "date_first_seen"   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "predecessor"       BIGINT DEFAULT NULL REFERENCES "stats_UAs" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT
);

/*
    Table: "stats_displays"
    Contains screen-resolution information collected from visitors
    
    AFAIK, display info can only be retrieved from JavaScript and sent by:   
    + Inserting hidden-input elements before POSTing a form (not really creepy to me)
    + Playing with cookies using JS (kinda creepy)
    + using JS + AJAX + HTML headers (very creepy)
*/

CREATE TABLE "stats_displays" (
    "id"                BIGSERIAL PRIMARY KEY,
    "dimension_hi"      BIGINT NOT NULL,
    "dimension_lo"      BIGINT NOT NULL,
    "ar_portrait"       DOUBLE PRECISION NOT NULL,
    "ar_landscape"      DOUBLE PRECISION NOT NULL,
    "is_portrait"       BOOLEAN NOT NULL DEFAULT FALSE,
    "is_landscape"      BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE ("dimension_hi", "dimension_lo") 
);

/*  
    Table "stats_langs": Language statistics.
    This table contains language codes. 
    
    Example: For "en-us," the code is "en," while the subcode is "us." 
    Subcodes may be and often are left unspecified. 
    
    Languages can be collected from both HTTP headers and JavaScript.
    Collecting them from JavaScript has the same caveat as above.
    The language JavaScript reports virtually always contains one of the HTTP header languages.
    When it doesn't, that's a red flag. 

*/
    
CREATE TABLE "stats_langs" (
    "id"                BIGSERIAL PRIMARY KEY,
    "code"              CHARACTER VARYING (4) NOT NULL,
    "subcode"           CHARACTER VARYING (4),
    UNIQUE ("code", "subcode")
);


/*  
    Table: "stats_session_IDs"
    Contains session IDs stored in cookies to map stastical information to unique users.
    
    In order to count unique visitors and hits, each visitor *must* have some kind of 
    ridiculously persistent cookie (e.g. one that expires 12/31/9999 23:59:59) with a
    unique value, and we *must* be able to retrieve the value of that cookie and store 
    it in the database so it can be linked to the information associated with it. 
    Keeping a reasonable track of who's unique and who's not is simply not possible 
    without this. IPs alone are very inaccurate: users may have more than one IP, and 
    one IP may have more than one user. 
    
    To achieve this end, we generate a 256 character random value and store it using
    <https://hexdocs.pm/phoenix/Phoenix.Token.html> and a cookie. By detaching session
    IDs from phoenix's session store, we can implement the logout button by wiping the
    session store without allowing users to game the SPAM filter by banging logout.
    
    Sessions in the database exist independently of their implementation in the code. 
    All the database cares about is whether session identifiers are unique, have the
    data type specified for them in the database schema, and meet all other constraints 
    that the schema has defined for them. It makes no effort to verify whether what the 
    application code is feeding it is actually being properly generated, set, and
    retrieved. 
    
    This table of session identifiers here presumes that they are strings of 256 
    characters whose combinations are unique for each session. How that is achieved is
    let entirely up to the server. Changing it to some other format is trivially easy. 
    
    HTTP headers can specify multiple languages in descending order of preference. 
    Only the first three are collected here.
    
 */
 
CREATE TABLE "stats_session_IDs" (
    "id"                BIGINT PRIMARY KEY,
    "string"            CHARACTER (256) NOT NULL UNIQUE,
    "date_set"          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_expires"      TIMESTAMP NOT NULL DEFAULT '9999/12/31 12:59:59',
    "original_IP"       BIGINT NOT NULL REFERENCES "stats_IPs" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT,
    "original_UA"       BIGINT NOT NULL REFERENCES "stats_UAs" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT,
    "original_lang_1"   BIGINT REFERENCES "stats_langs" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT,
    "original_lang_2"   BIGINT REFERENCES "stats_langs" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT,
    "original_lang_3"   BIGINT REFERENCES "stats_langs" ("id") ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Table for currently active sessions will go here
-- Will contain IP address information and should replace IP address fields in tables that have it.
-- CREATE TABLE "sessions" ();

-- These most likely won't be fully created or used unless an extraordinarily determined Pepe-like creature appears again.
-- CREATE TABLE "stats_SID_IP_links ();
-- CREATE TABLE "stats_SID_UA_links ();
-- CREATE TABLE "stats_SID_lang_links ();
-- CREATE TABLE "stats_SID_display_links ();
-- CREATE TABLE "stats_SID_IP1_IP2_links ();
-- CREATE TABLE "stats_SID_UA1_UA2_links ();
-- CREATE TABLE "stats_IP_UA_lang_display_links ();

create table "users" (
    "id"                BIGSERIAL PRIMARY KEY,
    "username"          CHARACTER VARYING (128) NOT NULL,
    "normalized"        CHARACTER VARYING (128) NOT NULL,
    "is_registered"     BOOLEAN NOT NULL DEFAULT FALSE,
    "date_first_seen"   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE              ("is_registered", "username"),
    UNIQUE              ("is_registered", "normalized")
);

INSERT INTO "users" ("id", "username", "normalized", "is_registered", "date_first_seen") 
    VALUES (0, '(anonymous)', 'anonymous', TRUE, '0001/01/01 00:00');

-- Differences in account types will be documented elsewhere.
-- "username" and "normalized" are strategic redundancy taken from the users table. 

-- `account_type` determines the level of privilege that the user gets
--
-- 0 (anon) - an account with this level is equivalent to an anonymous user
-- 1 (noob) - this is the level of privilege that a user gets immediately upon signing up
-- 2 (user) - users automatically gain this level of privilege after awhile
-- 3 (leader) - admins and moderators can grant this level of privilege to users
-- 4 (mod) - admins grant this level of privilege to users
-- 5 (admin) - with this level, users can run arbitrary code on the server
--
-- You'll notice that there's nothing here for "banned users."
-- Bans are handled in a separate table.
CREATE TABLE "accounts" (
    "id"                    BIGSERIAL PRIMARY KEY,
    "user_id"               BIGINT UNIQUE NOT NULL REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
    "username"              CHARACTER VARYING (128) UNIQUE NOT NULL,
    "normalized"            CHARACTER VARYING (128) UNIQUE NOT NULL,
    "password_hash"         CHARACTER (256) UNIQUE NOT NULL,
    "password_salt"         CHARACTER (256) UNIQUE NOT NULL,                                                                     
    "registration_date"     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- "registration_session"  BIGINT NOT NULL REFERENCES "sessions" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
    "registration_email"    CHARACTER VARYING (256) NOT NULL,
    "current_email"         CHARACTER VARYING (256) NOT NULL,
    "account_type"          BIGINT NOT NULL DEFAULT 1                                                                                        
);                                                                                      
                                                                                                
INSERT INTO "accounts" 
    ("id", "user_id", "username", "normalized", "password_hash", "password_salt", "registration_date",
     "registration_email", "current_email", "account_type")
VALUES
    (0, 0, '(anonymous)', 'anonymous', '0', '0', '0001/01/01 00:00', 'none@fstdt.org', 'none@fstdt.org', 0);
     
-- CREATE TABLE "account_requests" 
-- TODO: Create views and SPs for each of these.
                                                                                                
CREATE TABLE "banned_content" (
    "id"                BIGSERIAL PRIMARY KEY,
    "text"              CHARACTER VARYING (512) UNIQUE NOT NULL,
    "is_ip_address"     BOOLEAN NOT NULL DEFAULT FALSE,
    "is_comment_text"   BOOLEAN NOT NULL DEFAULT FALSE,
    "is_quote_text"     BOOLEAN NOT NULL DEFAULT FALSE,
    "is_sotdt_text"     BOOLEAN NOT NULL DEFAULT FALSE,
    "is_issues_text"    BOOLEAN NOT NULL DEFAULT FALSE,
    "is_fundie"         BOOLEAN NOT NULL DEFAULT FALSE,
    "is_site"           BOOLEAN NOT NULL DEFAULT FALSE,
    "is_url"            BOOLEAN NOT NULL DEFAULT FALSE,
    "is_useragent"      BOOLEAN NOT NULL DEFAULT FALSE,
    "is_username"       BOOLEAN NOT NULL DEFAULT FALSE,
    "is_password"       BOOLEAN NOT NULL DEFAULT FALSE,
    "is_email"          BOOLEAN NOT NULL DEFAULT FALSE,
    "is_shadowbanned"   BOOLEAN NOT NULL DEFAULT FALSE,
    "expires"           BOOLEAN NOT NULL DEFAULT FALSE,
    "date_expires"      TIMESTAMP   
);
                                                                                                
CREATE TABLE "fundies" (
    "id"               BIGSERIAL PRIMARY KEY,
    "name"             CHARACTER VARYING (128) UNIQUE NOT NULL,
    "normalized"       CHARACTER VARYING (128) UNIQUE NOT NULL
);

CREATE TABLE "site_names" (
    "id"                BIGSERIAL PRIMARY KEY,
    "name"              CHARACTER VARYING (128) UNIQUE NOT NULL,
    "normalized"        CHARACTER VARYING (128) UNIQUE NOT NULL
);

create table "categories" (
    id                  BIGSERIAL PRIMARY KEY,
    name                CHARACTER VARYING (64) UNIQUE NOT NULL,
    abbreviation        CHARACTER VARYING (8) UNIQUE NOT NULL,
    description         CHARACTER VARYING (128) UNIQUE NOT NULL
);
                                                                                                                                                                                        

CREATE TABLE "quotes" (
    "id"                    BIGSERIAL PRIMARY KEY,
    "date_posted"           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "submitter"             BIGINT NOT NULL DEFAULT 0 REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
    "fundie"                BIGINT NOT NULL REFERENCES "fundies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
    "site_name"             BIGINT NOT NULL REFERENCES "site_names" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
    "url_original"          CHARACTER VARYING (2048) NOT NULL, -- yeah, i have seriously seen links borderline this long... 
    "url_content"           CHARACTER VARYING (2048) NOT NULL, -- for media posts only. 
    "url_mirror"            CHARACTER VARYING (2048) NOT NULL, -- archive.is link
    "is_image_post"         BOOLEAN NOT NULL DEFAULT FALSE,
    "is_video_post"         BOOLEAN NOT NULL DEFAULT FALSE,
    "text"                  CHARACTER VARYING (65536) NOT NULL,
    "text_html"             CHARACTER VARYING (65536) NOT NULL, -- automatically cache compiled markdown
    "note_submitter"        CHARACTER VARYING (65536), -- if allowing nulls is unacceptable, use sentinel values to hide these, e.g. "(none)"
    "note_submitter_html"   CHARACTER VARYING (65536),
    "note_moderator"        CHARACTER VARYING (65536),
    "note_moderator_html"   CHARACTER VARYING (65536),
    "votes_yay"             BIGINT NOT NULL DEFAULT 0,
    "votes_nay"             BIGINT NOT NULL DEFAULT 0,
    "votes_total"           BIGINT NOT NULL DEFAULT 0,  -- votes_total = votes_yay + votes_nay
    "votes_calculated"      BIGINT NOT NULL DEFAULT 0,  -- votes_calculated = votes_yay - votes_nay
    "views_unique"          BIGINT NOT NULL DEFAULT 0,
    "views_total"           BIGINT NOT NULL DEFAULT 0,
    "is_visible"            BOOLEAN NOT NULL DEFAULT TRUE,
    "is_thread_locked"      BOOLEAN NOT NULL DEFAULT FALSE,
    "is_thread_visible"     BOOLEAN NOT NULL DEFAULT TRUE,
    "use_yscodes"           BOOLEAN NOT NULL DEFAULT FALSE
);
                                                                                                
-- CREATE TABLE "quote_votes" ();
-- CREATE TABLE "quote_visits" ();
                                                                                                
CREATE TABLE "quotes_categories_link" (
    quote_id            BIGINT REFERENCES "quotes" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
    category_id         BIGINT REFERENCES "categories" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY ("quote_id", "category_id")
);

-- CREATE TABLE "submissions" ();
-- CREATE TABLE "submission_info" ();
-- CREATE TABLE "submissions_categories_link ();
-- CREATE TABLE "submission_issues" ();
-- CREATE TABLE "submission_votes" ();
   
CREATE TABLE "comments" (
    "id"                BIGSERIAL PRIMARY KEY,
    "quote_id"          BIGINT REFERENCES "quotes" ("id"),
    "author_id"         BIGINT REFERENCES "users" ("id"),
    -- "session_id"        BIGINT REFERENCES "sessions" ("id"),
    "date_posted"       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_modified"     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "text"              CHARACTER VARYING (65536) NOT NULL,
    "text_html"         CHARACTER VARYING (65536) NOT NULL,
    "is_visible"        BOOLEAN NOT NULL DEFAULT TRUE,
    "is_locked"         BOOLEAN NOT NULL DEFAULT FALSE, -- means submitter cannot edit or delete it
    "is_shadowbanned"   BOOLEAN NOT NULL DEFAULT FALSE, -- redundancy used to speed up a stored procedure
    "use_yscodes"       BOOLEAN NOT NULL DEFAULT FALSE
);
                                                                                                
-- CREATE TABLE "sotdt" ();
-- CREATE TABLE "site_issues" ();
-- CREATE TABLE "site_log" ();
