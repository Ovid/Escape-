CREATE TABLE country (
    id         INTEGER PRIMARY KEY,
    iso        CHAR(2)      NOT NULL,
    url_key    VARCHAR(255) NOT NULL,
    name       VARCHAR(255) NOT NULL,
    population INTEGER          NULL,
    area       FLOAT            NULL,
    capital    VARCHAR(255) NOT NULL,
    wikipedia  VARCHAR(255) NOT NULL
);
