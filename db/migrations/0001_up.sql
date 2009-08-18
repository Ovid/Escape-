CREATE TABLE user (
    id            INTEGER PRIMARY KEY,
    username      TEXT,
    password      TEXT,
    email_address TEXT,
    first_name    TEXT,
    last_name     TEXT,
    active        INTEGER
);
CREATE TABLE role (
    id   INTEGER PRIMARY KEY,
    role TEXT
);
CREATE TABLE user_role (
    user_id INTEGER,
    role_id INTEGER,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (role_id) REFERENCES role(id)
);
INSERT INTO role VALUES (1, 'user');
INSERT INTO role VALUES (2, 'admin');

