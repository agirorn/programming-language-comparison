CREATE DATABASE nodejs WITH ENCODING 'UTF8';
CREATE DATABASE rust WITH ENCODING 'UTF8';
\connect nodejs
CREATE TABLE IF NOT EXISTS events (
  id    SERIAL PRIMARY KEY,
  time  varchar(250) NOT NULL
);

\connect rust
CREATE TABLE IF NOT EXISTS events (
  id    SERIAL PRIMARY KEY,
  time  varchar(250) NOT NULL
);
