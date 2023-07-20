/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    date_of_birth DATE,
    weight_kg FLOAT,
    neutered BOOLEAN,
    escape_attempts INTEGER,
);
    
-- Add the species column to the animals table
ALTER TABLE animals 
ADD species VARCHAR(50);

-- Create owners table in Vet_Clinic Database
CREATE TABLE owners (
    id PRIMARY KEY SERIAL,
    full_name VARCHAR(100),
    age INTEGER    
);

-- Create species Table in vet_clinic Database
CREATE TABLE species (
    id PRIMARY KEY SERIAL,
    name VARCHAR(100)
);

-- Remove the column species
ALTER TABLE animals
DROP COLUMN species;

-- Add column species_id as a foreign key referencing the species table
ALTER TABLE animals
ADD COLUMN species_id INT REFERENCES species(id);

-- Add column owner_id as a foreign key referencing the owners table
ALTER TABLE animals
ADD COLUMN owner_id INT REFERENCES owners(id);

-- Create vets Table in vet_clinic Database

CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER,
    date_of_graduation DATE
);

-- create a join table called specializations to handle the many-to-many relationship between 
--the species and vets tables

CREATE TABLE specializations (
  vet_id INTEGER,
  species_id INTEGER,
  PRIMARY KEY (vet_id, species_id),
  FOREIGN KEY (vet_id) REFERENCES vets (id),
  FOREIGN KEY (species_id) REFERENCES species (id)
);

-- Create a join table called "visits" to handle the many-to-many relationship between the "animals" and "vets" 
-- tables, including tracking the date of the visit.

CREATE TABLE visits (
  vet_id INTEGER,
  animal_id INTEGER,
  visit_date DATE,
  FOREIGN KEY (vet_id) REFERENCES vets (id),
  FOREIGN KEY (animal_id) REFERENCES animals (id)
);

