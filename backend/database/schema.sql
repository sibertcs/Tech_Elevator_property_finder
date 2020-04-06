BEGIN TRANSACTION;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id serial PRIMARY KEY,
  email varchar(255) NOT NULL UNIQUE,     -- Email
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  phone_number varchar(10) NOT NULL,
  password varchar(32) NOT NULL,      -- Password
  salt varchar(256) NOT NULL,          -- Password Salt
  role varchar(255) NOT NULL default('renter'),
  CHECK (role IN ('renter', 'landlord', 'maintenance', 'admin'))
);

--INSERT INTO users (email, first_name, last_name, phone_number, password, )
COMMIT TRANSACTION;

SELECT * FROM users;

