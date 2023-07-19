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


