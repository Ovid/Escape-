CREATE TABLE city (
    id         INTEGER PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    latitude   FLOAT        NOT NULL,
    longitude  FLOAT        NOT NULL,
    region_id  INTEGER          NULL,
    FOREIGN KEY (region_id) REFERENCES region(id)
);
CREATE TABLE country (
    id         INTEGER PRIMARY KEY,
    iso        CHAR(2)      NOT NULL,
    url_key    VARCHAR(255) NOT NULL,
    name       VARCHAR(255) NOT NULL,
    population INTEGER          NULL,
    area       FLOAT            NULL,
    capital    VARCHAR(255) NOT NULL,
    wikipedia  VARCHAR(255) NOT NULL
, latitude  FLOAT, longitude FLOAT);
CREATE TABLE poll (
    id            INTEGER PRIMARY KEY,
    title         VARCHAR(255) NOT NULL,
    date          DATETIME NOT NULL
);
CREATE TABLE poll_question (
    id            INTEGER PRIMARY KEY,
    question      VARCHAR(255),
    sort_order    INTEGER,
    poll_id       INTEGER,
    FOREIGN KEY (poll_id) REFERENCES poll(id)
);
CREATE TABLE region (
    id         INTEGER PRIMARY KEY,
    code       CHAR(2)      NOT NULL,
    name       VARCHAR(255)     NULL, -- temp hack, I hope
    country_id INTEGER      NOT NULL, 
    FOREIGN KEY (country_id) REFERENCES country(id)
);
CREATE TABLE role (
    id   INTEGER PRIMARY KEY,
    role TEXT
);
CREATE TABLE user (
    id            INTEGER PRIMARY KEY,
    username      TEXT,
    password      TEXT,
    email_address TEXT,
    first_name    TEXT,
    last_name     TEXT,
    active        INTEGER
);
CREATE TABLE user_poll (
    id            INTEGER PRIMARY KEY,
    user_id       INTEGER,
    poll_id       INTEGER,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (poll_id) REFERENCES poll(id)
);
CREATE TABLE user_role (
    user_id INTEGER,
    role_id INTEGER,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (role_id) REFERENCES role(id)
);
