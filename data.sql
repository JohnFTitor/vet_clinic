/* Populate database with sample data. */

INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
  ('Agumon', '3-feb-2020', 0, true, 10.23),
  ('Gabumon', '15-nov-2018', 2, true, 8),
  ('Pikachu', '7-jan-2021', 1, false, 15.04),
  ('Devimon', '12-may-2017', 5, true, 11),
  ('Charmander', '8-feb-2020', 0, false, -11),
  ('Plantmon', '15-nov-2021', 2, true, -5.7),  
  ('Squirtle', '2-apr-1993', 3, false, -12.13),
  ('Angemon', '12-jun-2005', 1, true, -45),
  ('Boarmon', '7-jun-2005', 7, true, 20.4),
  ( 'Blossom', '13-oct-1998', 3, true, 17),
  ( 'Ditto', '14-may-2022', 4, true, 22);

/* Insert data into owners table */
BEGIN;

INSERT INTO owners(full_name, age)
VALUES 
  ('Sam Smith', 34),
  ('Jennifer Orwell', 19),
  ('Bob', 45),
  ('Melody Pond', 77),
  ('Dean Winchester', 14),
  ('Jodie Whittaker', 38);

COMMIT;

BEGIN;

INSERT INTO species(name)
VALUES
  ('Pokemon'),
  ('Digimon');

COMMIT;  

/*  Add species_id */

BEGIN;

UPDATE animals
SET species_id = 1;

UPDATE animals
SET species_id = 2
WHERE name LIKE '%mon%';

COMMIT;

BEGIN;

UPDATE animals
SET owner_id = 1
WHERE name = 'Agumon';

SAVEPOINT OW1;

UPDATE animals
SET owner_id = 2
WHERE name IN ('Gabumon', 'Pikachu');

SAVEPOINT OW2;

UPDATE animals
SET owner_id = 3
WHERE name IN ('Devimon', 'Plantmon');

SAVEPOINT OW3;

UPDATE animals
SET owner_id = 4
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

SAVEPOINT OW4;

UPDATE animals
SET owner_id = 5
WHERE name IN ('Angemon','Boarmon');

SAVEPOINT OW5;

COMMIT;