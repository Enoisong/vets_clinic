/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon"

SELECT * FROM animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu"
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered
SELECT * FROM animals WHERE neutered = true;

-- Find all animals not named Gabumon
SELECT * FROM animals WHERE name <> 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including animals with weights precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

----------------------------------------FIRST TRANSACTION---------------------------------------------------
--- Begin transaction
BEGIN;

-- Update the species column to "unspecified"
UPDATE animals SET species = 'unspecified';

--Verify the change
SELECT * FROM animals;

-- Rollback the transaction
ROLLBACK;

-- Verify the species column reverted to its previous state
SELECT * FROM animals;

----------------------------------------SECOND TRANSACTION---------------------------------------------------
--- Begin transaction
BEGIN;

-- Update the species column to "digimon" for animals with name ending in "mon"
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

-- Update the species column to "pokemon" for animals without a species
UPDATE animals SET SPECIES = 'pokemon' WHERE species IS NULL OR species = '';

-- Commit the transaction
COMMIT;

-- Verify the changes
SELECT * FROM animals;

----------------------------------------THIRD TRANSACTION---------------------------------------------------
--- Begin transaction
BEGIN;

-- Delete all records from the animals table
DELETE FROM animals;

-- Roll back the transaction
ROLLBACK;

-- Verify if all records still exist
SELECT * FROM animals;

----------------------------------------FOURTH TRANSACTION---------------------------------------------------
--- Begin transaction
BEGIN;

-- Delete all animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint
SAVEPOINT my_savepoint;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO my_savepoint;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals SET weight_kg * -1 WHERE weight_kg < 0;

-- Commit the transaction
COMMIT;

----------------------------------------QUERIES---------------------------------------------------
-- How many animals are there?
SELECT COUNT(*) AS total_animals FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) AS animals_no_escape FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) AS average_weight FROM animals;

-- Who escapes the most, neutered or not netered animals?
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts FROM animals GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min-weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS average_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- What animals belong to Melody Pond?
SELECT a.name
FROM animals a 
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name ='Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT a.name
FROM animals a 
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- List all owners and their animals, including those that don't own any animal.
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- How many animals are there per species?
SELECT s.name, COUNT(a.id) AS animal_count
FROM species s
LEFT JOIN animals a ON s.id = a. species_id
GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT a.name AS last_animal_seen_by_william_tatcher
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets w ON v.vet_id = w.id
WHERE w.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS number_of_animals_seen_by_stephanie_mendez
FROM visits v
JOIN vets s ON v.vet_id = s.id
WHERE s.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, s.name AS specialty_name
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets s ON v.vet_id = s.id
WHERE s.name = 'Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name AS most_visited_animal, COUNT(*) AS number_of_visits
FROM animals a
JOIN visits v ON a.id = v.animal_id
GROUP BY a.name
ORDER BY number_of_visits DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.name AS maisy_smith_first_visit
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets m ON v.vet_id = m.id
WHERE m.name = 'Maisy Smith'
ORDER BY v.visit_date ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, v.name AS vet_name, v.visit_date AS date_of_visit
FROM animals a
JOIN visits v ON a.id = v.animal_id
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS number_of_visits_without_specialty
FROM visits v
LEFT JOIN specializations sp ON v.vet_id = sp.vet_id AND v.animal_id = sp.species_id
WHERE sp.vet_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
vet_clinics=# SELECT s.name, COUNT(*) AS num_visits
vet_clinics-# FROM visits AS v
vet_clinics-# INNER JOIN animals AS a ON v.animal_id = a.id
vet_clinics-# INNER JOIN species AS s ON a.species_id = s.id
vet_clinics-# WHERE v.vet_id IN (SELECT id FROM vets WHERE name = 'Maisy Smith')
vet_clinics-# GROUP BY s.name
vet_clinics-# ORDER BY num_visits DESC
vet_clinics-# LIMIT 1;