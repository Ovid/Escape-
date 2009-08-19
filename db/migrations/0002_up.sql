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

CREATE TABLE user_poll (
    id            INTEGER PRIMARY KEY,
    user_id       INTEGER,
    poll_id       INTEGER,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (poll_id) REFERENCES poll(id)
);
