CREATE TABLE region (
    id         INTEGER PRIMARY KEY,
    name       VARCHAR(255)     NULL, -- temp hack, I hope
    country_id INTEGER      NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE city (
    id         INTEGER PRIMARY KEY,
    country_id INTEGER      NOT NULL, 
    name       VARCHAR(255) NOT NULL,
    lat        FLOAT        NOT NULL,
    long       FLOAT        NOT NULL,
    region_id  INTEGER          NULL,
    FOREIGN KEY (country_id) REFERENCES country(id),
    FOREIGN KEY (region_id)  REFERENCES region(id)
);
