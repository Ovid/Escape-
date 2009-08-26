-- Grr! SQLite doesn't allow you to drop columns.
ALTER TABLE country DROP COLUMN longitude;
ALTER TABLE country DROP COLUMN latitude;

DROP TABLE city;
DROP TABLE region;
