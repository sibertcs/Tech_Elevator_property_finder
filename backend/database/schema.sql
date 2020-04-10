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

CREATE TABLE property_feature (
  property_id integer,
  feature_id integer,
  CONSTRAINT property_feature_pk PRIMARY KEY(property_id, feature_id),
  CONSTRAINT prop_feature_fk_prop_id FOREIGN KEY(property_id) REFERENCES property(property_id),
  CONSTRAINT prop_feature_fk_feature_id FOREIGN KEY(feature_id) REFERENCES feature(feature_id)
);

CREATE TABLE lease (
  lease_id serial PRIMARY KEY,
  user_id integer NOT NULL,
  unit_id integer NOT NULL,
  signed_date date NOT NULL,
  rent_length integer NOT NULL,
  rent_amount decimal NOT NULL,
  late_fee decimal NOT NULL,
  status varchar(255) NOT NULL,
  CONSTRAINT lease_fk_user_id FOREIGN KEY(user_id) REFERENCES users(user_id),
  CONSTRAINT lease_fk_unit_id FOREIGN KEY(unit_id) REFERENCES unit(unit_id),
  CHECK (status IN ('Active', 'Expired', 'Terminated'))
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
  priority integer NOT NULL,
  date_requested timestamp NOT NULL,     
  assigned_user_id integer,     
  is_completed boolean NOT NULL default(false),     
  CONSTRAINT fk_maintenance_requests_unit FOREIGN KEY(unit_id) REFERENCES unit(unit_id), 
  CONSTRAINT fk_maintenance_requests_requested FOREIGN KEY(request_user_id) REFERENCES users(user_id),
  CONSTRAINT fk_maintenance_requests_assigned FOREIGN KEY(assigned_user_id) REFERENCES users(user_id)
);


INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('admin@gmail.com', 'admin', 'admin', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'admin');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('renter@gmail.com', 'renter', 'renter', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('maintenance@gmail.com', 'maintenance', 'maintenance', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'maintenance');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('landlord@gmail.com', 'landlord', 'landlord', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'landlord');

INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('landlord_1@gmail.com', 'Landlord', 'One', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'landlord');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('landlord_2@gmail.com', 'Landlord', 'Two', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'landlord');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('renter_1@gmail.com', 'Renter', 'One', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('renter_2@gmail.com', 'Renter', 'Two', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('renter_3@gmail.com', 'Renter', 'Three', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('renter_4@gmail.com', 'Renter', 'Four', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('renter_5@gmail.com', 'Renter', 'Five', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('renter_6@gmail.com', 'Renter', 'Six', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'renter');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('maintenance_1@gmail.com', 'Maint', 'One', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'maintenance');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('maintenance_2@gmail.com', 'Maint', 'Two', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'maintenance');
INSERT INTO users (email, first_name, last_name, phone_number, password, salt, role) VALUES ('maintenance_3@gmail.com', 'Maint', 'Three', '1234567890', 'nRNoeCGP0JropBPpDDfIcQ==', 'mbaSqD88vwLEkM/GKKwTOKUWJEcpzZoyvrRz8R2Z1sC1OLLUHdg53/ylzLDq9waiweLaZLigBNDtLYgdKH6kDEEuth5wisTwoS1b/yewubMfnMS+gpQuCj+haoVlJ/zYXM4lEDA73LLkjE6Jp1Em++DD7491T5qJxfwVB4o8nyI=', 'maintenance');

INSERT INTO property (landlord_id, street_address, city, state, zip_code, property_name, photo_path, location) VALUES (4, '630 Vine St', 'Cincinnati', 'OH', '45202', 'The Provident Apartments' , '../assets/images/properties/1/', 'Downtown');
INSERT INTO property (landlord_id, street_address, city, state, zip_code, property_name, photo_path, location) VALUES (5, '2251 Washington Ave', 'Cincinnati', 'OH', '45212', '2251 Washington Ave' , '../assets/images/properties/2/', 'East Side');
INSERT INTO property (landlord_id, street_address, city, state, zip_code, property_name, photo_path, location) VALUES (6, '5601 Viewpointe', 'Cincinnati', 'OH', '45213', 'Hilltop Apartments' , '../assets/images/properties/3/', 'North Side');
INSERT INTO property (landlord_id, street_address, city, state, zip_code, property_name, photo_path, location) VALUES (6, '1500 Groesbeck Rd', 'Cincinnati', 'OH', '45224', 'The Bradford Apartments' , '../assets/images/properties/4/', 'North Side');
INSERT INTO property (landlord_id, street_address, city, state, zip_code, property_name, photo_path, location) VALUES (5, '2496 Queen City Ave', 'Cincinnati', 'OH', '45238', 'Lisa Ridge Apartments' , '../assets/images/properties/5/', 'West Side');

INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('0211', 1, 0, 1, 1040, 430, true);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('0220', 1, 1, 1, 1410, 650, true);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('1001', 1, 2, 2, 2145, 1052, true);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('2', 2, 3, 1, 1395, 1400, true);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('5633C', 3, 2, 2, 1429, 1171, false);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('5653B', 3, 2, 2, 1279, 1033, true);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('511', 4, 1, 1, 710, 525, true);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('621', 4, 0, 1, 475, 425, false);
INSERT INTO unit (unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available) VALUES ('2486-02', 5, 2, 1, 760, 705, true);

INSERT INTO lease (user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status) VALUES (5, 8, '2019-09-15', 3, 525, 10, 'Expired');
INSERT INTO lease (user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status) VALUES (5, 8, '2019-12-15', 12, 475, 5, 'Active');
INSERT INTO lease (user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status) VALUES (6, 5, '2020-01-20', 12, 1429, 5, 'Active');
INSERT INTO lease (user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status) VALUES (7, 3, '2020-01-28', 24, 2145, 2, 'Terminated');

INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested, assigned_user_id, is_completed) VALUES (8, 5, 'My toilet is clogged.', 1, '2019-10-15', 13, true);
INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested, assigned_user_id, is_completed) VALUES (5, 6, 'My bedroom door will not close all the way.', 3, '2020-02-15', 13, true);
INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested, assigned_user_id, is_completed) VALUES (5, 6, 'There are ants coming in through the bedroom window.', 2, '2020-03-03', 13, true);
INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested, assigned_user_id, is_completed) VALUES (3, 7, 'Lock on main door is broken.', 1, '2020-03-08', 14, true);
INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested, assigned_user_id, is_completed) VALUES (8, 5, 'My toilet is clogged.', 1, '2020-04-01', 14, true);
INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested, assigned_user_id, is_completed) VALUES (5, 6, 'Kitchen sink is clogged.', 1, '2020-04-07', 14, false);
INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested, assigned_user_id, is_completed) VALUES (8, 5, 'Air conditioning not working', 2, '2020-04-08', 15, false);

INSERT INTO feature (feature_name) VALUES ('Controlled Access');
INSERT INTO feature (feature_name) VALUES ('Elevator');
INSERT INTO feature (feature_name) VALUES ('Laundry Facility');
INSERT INTO feature (feature_name) VALUES ('Multi Use Room');
INSERT INTO feature (feature_name) VALUES ('Online Services');
INSERT INTO feature (feature_name) VALUES ('Picnic Area');
INSERT INTO feature (feature_name) VALUES ('Storage Space');
INSERT INTO feature (feature_name) VALUES ('Air Conditioning');
INSERT INTO feature (feature_name) VALUES ('Broadband Internet');
INSERT INTO feature (feature_name) VALUES ('Cable or Satellite');
INSERT INTO feature (feature_name) VALUES ('Cats and Dogs Allowed');
INSERT INTO feature (feature_name) VALUES ('Disability Access');
INSERT INTO feature (feature_name) VALUES ('Heating');
INSERT INTO feature (feature_name) VALUES ('Kitchen');
INSERT INTO feature (feature_name) VALUES ('Linen Closet');
INSERT INTO feature (feature_name) VALUES ('Oven/Range');
INSERT INTO feature (feature_name) VALUES ('Patio or Deck');
INSERT INTO feature (feature_name) VALUES ('Refrigerator/Freezer');
INSERT INTO feature (feature_name) VALUES ('Security System');
INSERT INTO feature (feature_name) VALUES ('W/D Hookup');

INSERT INTO property_feature (property_id, feature_id) VALUES (1, 1);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 2);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 3);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 4);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 5);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 6);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 7);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 8);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 9);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 10);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 11);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 12);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 13);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 14);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 15);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 16);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 17);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 18);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 19);
INSERT INTO property_feature (property_id, feature_id) VALUES (1, 20);

INSERT INTO property_feature (property_id, feature_id) VALUES (2, 3);
INSERT INTO property_feature (property_id, feature_id) VALUES (2, 7);
INSERT INTO property_feature (property_id, feature_id) VALUES (2, 9);
INSERT INTO property_feature (property_id, feature_id) VALUES (2, 13);
INSERT INTO property_feature (property_id, feature_id) VALUES (2, 14);
INSERT INTO property_feature (property_id, feature_id) VALUES (2, 16);
INSERT INTO property_feature (property_id, feature_id) VALUES (2, 17);
INSERT INTO property_feature (property_id, feature_id) VALUES (2, 18);

INSERT INTO property_feature (property_id, feature_id) VALUES (3, 5);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 6);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 7);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 8);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 11);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 12);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 13);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 14);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 16);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 17);
INSERT INTO property_feature (property_id, feature_id) VALUES (3, 18);

INSERT INTO property_feature (property_id, feature_id) VALUES (4, 1);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 3);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 4);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 5);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 6);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 7);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 8);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 9);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 10);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 11);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 12);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 13);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 14);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 15);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 16);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 18);
INSERT INTO property_feature (property_id, feature_id) VALUES (4, 19);

INSERT INTO property_feature (property_id, feature_id) VALUES (5, 1);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 3);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 5);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 6);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 7);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 8);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 9);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 10);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 11);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 12);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 13);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 14);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 15);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 16);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 17);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 18);
INSERT INTO property_feature (property_id, feature_id) VALUES (5, 19);

INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (1, '2019-10-01', 525, '2019-10-31', 'Paid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (1, '2019-11-01', 525, '2019-11-30', 'Paid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (1, '2019-12-01', 525, '2019-12-31', 'Paid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (2, '2020-01-01', 475, '2020-01-31', 'Paid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (2, '2020-02-01', 475, '2020-02-29', 'Paid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (3, '2020-02-01', 1429, '2020-02-29', 'Paid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (4, '2020-02-01', 2145, '2020-02-29', 'Overdue');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (2, '2020-03-01', 475, '2020-03-31', 'Overdue');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (3, '2020-03-01', 1429, '2020-03-31', 'Paid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (4, '2020-03-01', 2145, '2020-03-31', 'Overdue');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (2, '2020-04-01', 475, '2020-04-30', 'Unpaid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (3, '2020-04-01', 1429, '2020-04-30', 'Unpaid');
INSERT INTO rent_cycle (lease_id, start_date, balance, due_date, rent_status) VALUES (4, '2020-04-01', 2145, '2020-04-30', 'Unpaid');

INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) VALUES (1, 525, '2019-10-31 12:00:00');
INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) VALUES (2, 525, '2019-11-30 12:00:00');
INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) VALUES (3, 525, '2019-12-31 12:00:00');
INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) VALUES (4, 475, '2020-01-31 12:00:00');
INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) VALUES (5, 475, '2020-02-29 12:00:00');
INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) VALUES (6, 1429, '2020-02-29 12:00:00');
INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) VALUES (9, 1429, '2020-03-31 12:00:00');


<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
COMMIT TRANSACTION;

--SELECT * FROM property;



SELECT * FROM property;

SELECT * FROM unit;
<<<<<<< Updated upstream
=======

Update unit Set is_available = false WHERE unit_id = 12;

>>>>>>> Stashed changes
