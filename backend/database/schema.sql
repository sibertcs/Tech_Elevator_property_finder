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

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('admin@gmail.com', 'admin', 'admin', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'admin');

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('renter@gmail.com', 'renter', 'renter', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('maintenance@gmail.com', 'maintenance', 'maintenance', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'maintenance');

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('landlord@gmail.com', 'landlord', 'landlord', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'landlord');
COMMIT TRANSACTION;

SELECT * FROM users;

