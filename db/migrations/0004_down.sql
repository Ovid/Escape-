CREATE TABLE region (
    id         INTEGER PRIMARY KEY,
    code       CHAR(2)      NOT NULL,
    name       VARCHAR(255)     NULL, -- temp hack, I hope
    url_key    VARCHAR(255) NOT NULL,
    country_id INTEGER      NOT NULL, 
    FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE city (
    id         INTEGER PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    url_key    VARCHAR(255) NOT NULL,
    latitude   FLOAT        NOT NULL,
    longitude  FLOAT        NOT NULL,
    region_id  INTEGER          NULL,
    FOREIGN KEY (region_id) REFERENCES region(id)
);
