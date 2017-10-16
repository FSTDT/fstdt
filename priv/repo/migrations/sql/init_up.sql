CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(1024) NOT NULL
);

CREATE TABLE fundies (
  fundie_id SERIAL PRIMARY KEY,
  name VARCHAR(1024) NOT NULL
);

CREATE TABLE boards (
  board_id SERIAL PRIMARY KEY,
  name VARCHAR(1024) NOT NULL
);

CREATE TABLE quotes (
  quote_id SERIAL PRIMARY KEY,
  text_input_type INT NOT NULL DEFAULT 1,
  text_input TEXT NOT NULL,
  text_cooked_html TEXT NULL DEFAULT NULL,
  submitter_user_id INT NOT NULL REFERENCES users,
  fundie_id INT NOT NULL REFERENCES fundies,
  board_id INT NOT NULL REFERENCES boards,
  url TEXT NOT NULL
);
COMMENT ON COLUMN quotes.text_input_type IS '0=PLAINTEXT,1=GFM,2=YSCODE';
