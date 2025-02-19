-- Specify the schema
use hospital_patient_record ; 

-- Drop tables if they already exist
DROP TABLES IF EXISTS encounters, procedures, organizations, payers, patients; 

--
-- Table structure 
--

-- Create the first table "encounters"
CREATE TABLE encounters (
    encounter_id VARCHAR(100) PRIMARY KEY,
    encounter_start_date DATE,
    encounter_start_time TIME,
    encounter_stop_date DATE,
    encounter_stop_time TIME,
    patient_id VARCHAR(100),
    organization_id VARCHAR(100),
    payer_id VARCHAR(100),
    encounter_class VARCHAR(15),
    encounter_code INT,
    encounter_code_description VARCHAR(200),
    encounter_base_cost DECIMAL(10,2),
    total_claim_cost DECIMAL(10,2),
    payer_coverage DECIMAL(10,2),
    encounter_reason_code BIGINT,
    encounter_reason_description VARCHAR(200) 
);


-- Create the second table "procedures"
CREATE TABLE procedures (
	procedure_start_date DATE,
	procedure_start_time TIME,
    procedure_end_date DATE,
	procedure_end_time TIME,
    patient_id VARCHAR(100),
    encounter_id VARCHAR(100),
    procedure_code BIGINT,
    procedure_code_description VARCHAR(200),
    procedure_base_cost INT,
    procedure_reason_code BIGINT,
    procedure_reason_description VARCHAR(200) 
 ); 
 
 
-- Create the third table "organizations"  
CREATE TABLE organizations (
	organization_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(200),
    address VARCHAR(200),
    city VARCHAR(50),
    state CHAR(2), 
    zip INT, 
    lat DECIMAL(10,6),
    lon DECIMAL(10,6)
); 
    
    
-- Create the forth table "payers"
CREATE TABLE payers (
	payer_id VARCHAR(100) PRIMARY KEY,
    payer_name VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(20),
    state_headquartered CHAR(2),
    zip INT,
    phone VARCHAR(20)
);  


-- Create the fifth table "patients"  
CREATE TABLE patients (
	patient_id VARCHAR(100) PRIMARY KEY,
    patient_birth_date DATE, 
    patient_death_date DATE,
    patient_prefix CHAR(4),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    patient_suffix CHAR(4),
    patient_maiden VARCHAR(20),
    patient_marital CHAR(1),
    race VARCHAR(10),
    ethnicity VARCHAR(15),
    gender CHAR(1),
    birthplace VARCHAR(200),
    address VARCHAR(200),
    city VARCHAR(20),
    state VARCHAR(13),
    country VARCHAR(50),
    zip INT, 
    lat DECIMAL(10,8),
    lon DECIMAL(10,8)
);   





-- INSERTING VALUE WITH "LOAD DATA INFILE" STATEMENTS 

-- loading data into the first table- "encounters"  
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/encounters.csv'   
INTO TABLE encounters
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(encounter_id, encounter_start_date, encounter_start_time, encounter_stop_date, encounter_stop_time, 
  patient_id, organization_id, payer_id, encounter_class, encounter_code, encounter_code_description, 
   encounter_base_cost, total_claim_cost, payer_coverage, 
    @encounter_reason_code, @encounter_reason_description) 
SET 
    encounter_reason_code = NULLIF(@encounter_reason_code, ''),
    encounter_reason_description = NULLIF(@encounter_reason_description, ''); 
    

-- loading data into the second table- "procedures" 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/procedures.csv'   
INTO TABLE procedures
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
( 	procedure_start_date, 
	procedure_start_time, 
	procedure_end_date, 
	procedure_end_time, 
	patient_id, 
	encounter_id, 
	procedure_code, 
	procedure_code_description, 
	procedure_base_cost,
	@procedure_reason_code, 
	@procedure_reason_description ) 
 SET 
    procedure_reason_code = NULLIF(@procedure_reason_code, ''),
    procedure_reason_description = NULLIF(@procedure_reason_description, '');    
    

-- loading data into the third table- "organizations"
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/organizations.csv'   
INTO TABLE organizations
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS   
( 	organization_id, name, address, city, state, zip, lat, lon ) ; 



-- loading data into the forth table- "payers"
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payers.csv'   
INTO TABLE payers 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS   
( 	payer_id, payer_name, address, city, state_headquartered, zip, phone ) ; 



-- loading data into the fifth table- "patients" 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patients.csv'   
INTO TABLE patients 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS   
( patient_id, patient_birth_date, @patient_death_date,  patient_prefix, first_name, last_name, 
  @patient_suffix, @patient_maiden, @patient_marital, race,
  ethnicity, gender, birthplace, address, city, state, country, @zip, lat, lon) 
SET 
    patient_death_date = NULLIF(@patient_death_date, ''),
    patient_suffix = NULLIF(@patient_suffix, ''),
    patient_maiden = NULLIF(@patient_maiden, ''), 
    patient_marital = NULLIF(@patient_marital, ''), 
    zip = NULLIF(@zip, '');     
    
    