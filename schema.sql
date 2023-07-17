/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

USE vet_clinic;
CREATE TABLE animals (
  id INTEGER,
  name VARCHAR(255),
  date_of_birth DATE,
  escape_attempts INTEGER,
  neutered BOOLEAN,
  weight_kg DECIMAL(5,2)
  
);

