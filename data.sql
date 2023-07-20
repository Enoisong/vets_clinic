/* Populate database with sample data. */

INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg, species)
VALUES
  (1, 'Agumon', '2020-02-03', 0, true, 10.23, NULL),
  (2, 'Gabumon', '2018-11-15', 2, true, 8, NULL),
  (3, 'Pikachu', '2021-01-07', 1, false, 15.04, NULL),
  (4, 'Devimon', '2017-05-12', 5, true, 11, NULL);
  (5, 'Charmander', '2020-02-08', -11, FALSE, 0, NULL);
  (6, 'Plantmon', '2021-11-15', -5.7, TRUE, 2, NULL);
  (7, 'Squirtle', '1993-04-02', -12.13, FALSE, 3, NULL);
  (8, 'Angemon', '2005-06-12', -45, TRUE, 1, NULL);
  (9, 'Boarmon', '2005-06-07', 20.4, TRUE, 7, NULL);
  (10, 'Blossom', '1998-10-13', 17, TRUE, 3, NULL);
  (11, 'Ditto', '2022-05-14', 22, TRUE, 4, NULL); 
  
  -- Insert data into the owners table
  INSERT INTO owners (full_name, age)
  VALUES
       ('Sam Smith', 34),
       ('Jennifer Orwell', 19),
       ('Bob', 45),
       ('Melody Pond', 77),
       ('Dean Winchester'. 14),
       ('Jodie Whittaker', 38);
  -- Insert data into the species table
  INSERT INTO SPECIES (name)
  VALUES
       ('Pokemon'),
       ('Digimon');
  
  -- Update animals table to include species_id values
  UPDATE animals
  SET species_id = (
    CASE
       WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
       ELSE (SELECT id FROM species WHERE name = 'Pokemon')
    END
       );
    

    -- Update animals table to include owner_id values
    UPDATE animals
    SET owner_id = (
      CASE
           WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
           WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id from owners WHERE full_name = 'Jennifer Orwell')
           WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id from owners WHERE full_name = 'Bob')
           WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
           WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id from owners WHERE full_name = 'Dean Winchester')
      END

    );
  