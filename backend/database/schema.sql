BEGIN TRANSACTION;

DROP TABLE IF EXISTS maintenance_request;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS rent_cycle;
DROP TABLE IF EXISTS lease;
DROP TABLE IF EXISTS property_feature;
DROP TABLE IF EXISTS property_landlord;
DROP TABLE IF EXISTS feature;
DROP TABLE IF EXISTS unit;
DROP TABLE IF EXISTS property;
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

CREATE TABLE property (
  property_id serial PRIMARY KEY,
  landlord_id integer NOT NULL,
  street_address varchar(255) NOT NULL UNIQUE,
  city varchar(255) NOT NULL,
  state varchar(255) NOT NULL,
  zip_code varchar(10) NOT NULL,
  property_name varchar(255),
  photo_path varchar(255) NOT NULL,
  location varchar(255) NOT NULL,
  CHECK (location IN ('Downtown', 'East Side', 'West Side', 'North Side', 'NKY')),
  CONSTRAINT property_fk_landlord_id FOREIGN KEY(landlord_id) REFERENCES users(user_id)
);

CREATE TABLE unit ( 
  unit_id serial PRIMARY KEY, 
  unit_number varchar(10) NOT NULL, 
  property_id integer NOT NULL, 
  bed_count integer NOT NULL, 
  bath_count decimal NOT NULL, 
  price decimal NOT NULL, 
  sq_ft integer NOT NULL, 
  is_available boolean NOT NULL,
  CONSTRAINT unit_fk_property_id FOREIGN KEY(property_id) REFERENCES property(property_id) 
);


CREATE TABLE feature (
  feature_id serial PRIMARY KEY,
  feature_name varchar(255) NOT NULL
);

CREATE TABLE property_landlord (
  property_id integer,
  user_id integer,
  CONSTRAINT property_landlord_pk PRIMARY KEY(property_id, user_id),
  CONSTRAINT property_landlord_fk_property_id FOREIGN KEY(property_id) REFERENCES property(property_id),
  CONSTRAINT property_landlord_fk_user_id FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE property_feature (
  property_id integer,
  feature_id integer,
  CONSTRAINT property_feature_pk PRIMARY KEY(property_id, feature_id),
  CONSTRAINT prop_feature_fk_prop_id FOREIGN KEY(property_id) REFERENCES property(property_id),
  CONSTRAINT prop_feature_fk_feature_id FOREIGN KEY(feature_id) REFERENCES feature(feature_id)
);

CREATE TABLE lease (
  lease_id integer PRIMARY KEY,
  user_id integer NOT NULL,
  unit_id integer NOT NULL,
  signed_date date NOT NULL,
  rent_length integer NOT NULL,
  rent_amount decimal NOT NULL,
  late_fee decimal NOT NULL,
  CONSTRAINT lease_fk_user_id FOREIGN KEY(user_id) REFERENCES users(user_id),
  CONSTRAINT lease_fk_unit_id FOREIGN KEY(unit_id) REFERENCES unit(unit_id)
);

CREATE TABLE rent_cycle (
  rent_cycle_id serial PRIMARY KEY,
  lease_id integer NOT NULL,
  start_date date NOT NULL,
  balance decimal NOT NULL,
  due_date date NOT NULL,
  rent_status varchar(255) NOT NULL,
  CONSTRAINT rent_cycle_fk_lease_id FOREIGN KEY(lease_id) REFERENCES lease(lease_id)
);

CREATE TABLE payment (
  payment_id serial PRIMARY KEY,
  rent_cycle_id integer NOT NULL,
  amount_paid decimal NOT NULL,
  date_paid timestamp NOT NULL,
  CONSTRAINT payments_fk_rent_cycle_id FOREIGN KEY(rent_cycle_id) REFERENCES rent_cycle(rent_cycle_id)
);

CREATE TABLE maintenance_request (
  request_id serial NOT NULL PRIMARY KEY,     
  unit_id integer NOT NULL,     
  request_user_id integer NOT NULL,     
  request_desc varchar(1000) NOT NULL,     
  urgency integer NOT NULL,
  date_requested timestamp NOT NULL,     
  assigned_user_id integer,     
  is_completed boolean NOT NULL default(false),     
  CONSTRAINT fk_maintenance_requests_unit FOREIGN KEY(unit_id) REFERENCES unit(unit_id), 
  CONSTRAINT fk_maintenance_requests_requested FOREIGN KEY(request_user_id) REFERENCES users(user_id),
  CONSTRAINT fk_maintenance_requests_assigned FOREIGN KEY(assigned_user_id) REFERENCES users(user_id)
);

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('admin@gmail.com', 'admin', 'admin', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'admin');

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('renter@gmail.com', 'renter', 'renter', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('maintenance@gmail.com', 'maintenance', 'maintenance', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'maintenance');

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role)
VALUES ('landlord@gmail.com', 'landlord', 'landlord', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'landlord');

INSERT INTO property (landlord_id, street_address, city, state, zip_code, property_name, photo_path, location)
VALUES ('1', '123 Main Street', 'Cincinnati', 'OH', '45073', 'Lisa Ridge' , '/630VineSt-01.jpg', 'Downtown');

COMMIT TRANSACTION;




SELECT * FROM users;
SELECT * FROM property;

