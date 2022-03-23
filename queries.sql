/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE EXTRACT (YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

/* TRANSACTIONS */

/* Setting species to unspecified */

/* PREVIOUS EXERCISE
BEGIN;

UPDATE animals
SET species = 'unspecified';

SELECT name, species FROM animals;

ROLLBACK;

SELECT name, species FROM animals; */

/* DELETE ALL RECORDS */

BEGIN;

DELETE FROM animals;
SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;
/*  Do multiple actions in one transaction */

BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SELECT name, date_of_birth FROM animals; 

SAVEPOINT DELETE_AFTER_DATE_1;

UPDATE animals
SET weight_kg = weight_kg * -1;
SELECT name, weight_kg FROM animals;

ROLLBACK TO DELETE_AFTER_DATE_1;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

SELECT name, weight_kg FROM animals;

/* Logical Queries */

SELECT COUNT(*) as quantity_of_animals FROM animals;

SELECT COUNT(*) as quantity_of_animals_who_has_not_escaped FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) as average_weight FROM animals;

SELECT neutered, SUM(escape_attempts) as escape_Attempts FROM animals
GROUP BY neutered;

/* PREVIOUS EXERCISE
SELECT species, MIN(weight_kg) as min_weight, MAX(weight_kg) as max_weight FROM animals
GROUP BY species;

SELECT species, AVG(escape_Attempts) as avergage_escape_attempts FROM animals
WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000
GROUP BY species; */

/*  Queries using JOIN */ 

SELECT full_name as Owner_name, name as Animal_name
FROM owners O
JOIN animals A ON O.id = A.owner_id
WHERE O.full_name = 'Melody Pond';

SELECT A.name, S.name as type
FROM species S
JOIN animals A ON S.id = A.species_id
WHERE S.name = 'Pokemon';

SELECT full_name as Owner_name, name as Animal_name
FROM owners O
LEFT JOIN animals A ON O.id = A.owner_id;

SELECT S.name as type, COUNT(A.id)
FROM species S
JOIN animals A ON S.id = A.species_id
GROUP BY S.name;

SELECT O.full_name as Owner_name, A.name as Animal_name
FROM owners O
JOIN animals A ON O.id = A.owner_id
JOIN species S ON S.id = A.species_id
WHERE S.name = 'Digimon' AND O.full_name = 'Jennifer Orwell'; 

SELECT O.full_name as Owner_name, name as Animal_name
FROM owners O
JOIN animals A ON O.id = A.owner_id
WHERE A.escape_Attempts = 0 AND O.full_name = 'Dean Winchester';

SELECT filtered.Owner_name
FROM (
  SELECT O.full_name as Owner_name, COUNT(A.id) as animals_owned 
  FROM owners O
  JOIN animals A ON O.id = A.owner_id
  GROUP BY O.full_name
) AS filtered
WHERE filtered.animals_owned = 
  (
    SELECT MAX (filtered.animals_owned)
    FROM (
      SELECT O.full_name as Owner_name, COUNT(A.id) as animals_owned 
      FROM owners O
      JOIN animals A ON O.id = A.owner_id
      GROUP BY O.full_name
    ) AS filtered
);
