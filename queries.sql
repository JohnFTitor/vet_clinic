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

CREATE VIEW filtered AS
  SELECT O.full_name as Owner_name, COUNT(A.id) as animals_owned 
  FROM owners O
  JOIN animals A ON O.id = A.owner_id
  GROUP BY O.full_name;

SELECT Owner_name
FROM filtered
WHERE animals_owned = 
  (
    SELECT MAX (animals_owned)
    FROM filtered
);

/* New set of queries */

SELECT Ve.name, A.name, Vi.date_of_visit  
FROM animals A
JOIN visits Vi ON Vi.animal_id = A.id
JOIN vets Ve ON Vi.vets_id = Ve.id
WHERE Ve.name = 'William Tatcher'
ORDER BY Vi.date_of_visit DESC
LIMIT 1;  


CREATE VIEW stephanie_visits AS
  SELECT A.name, COUNT(A.name) 
  FROM animals A
  JOIN visits Vi ON Vi.animal_id = A.id
  JOIN vets Ve ON Vi.vets_id = Ve.id
  WHERE Ve.name = 'Stephanie Mendez'
  GROUP BY A.name;

SELECT COUNT(name) FROM stephanie_visits;

SELECT Ve.name as Vet, S.name as Speciality
FROM vets Ve
LEFT JOIN specialization ON Ve.id = specialization.vets_id
LEFT JOIN species S ON S.id = specialization.species_id; 

SELECT A.name as animal, Vi.date_of_visit  
FROM animals A
JOIN visits Vi ON Vi.animal_id = A.id
JOIN vets Ve ON Vi.vets_id = Ve.id
WHERE Ve.name = 'Stephanie Mendez' AND Vi.date_of_visit BETWEEN '1-4-2020' AND '30-8-2020';

SELECT A.name, COUNT(A.name) as number_of_visits
FROM animals A
JOIN visits Vi ON Vi.animal_id = A.id
JOIN vets Ve ON Vi.vets_id = Ve.id
GROUP BY A.name
ORDER BY number_of_visits DESC
LIMIT 1;

SELECT A.name as animal, Vi.date_of_visit  
FROM animals A
JOIN visits Vi ON Vi.animal_id = A.id
JOIN vets Ve ON Vi.vets_id = Ve.id
WHERE Ve.name = 'Maisy Smith'
ORDER BY Vi.date_of_visit
LIMIT 1;

SELECT A.name as animal, S.name as type, A.date_of_birth as birth_date, A.escape_Attempts, A.neutered, 
A.weight_kg, O.full_name as Owner, Ve.name as Vet, Ve.age as Vet_age, Ve.date_of_graduation, Vi.date_of_visit  
FROM animals A
JOIN visits Vi ON Vi.animal_id = A.id
JOIN vets Ve ON Vi.vets_id = Ve.id
JOIN species S ON A.species_id = S.id
JOIN owners O ON A.owner_id = O.id
ORDER BY Vi.date_of_visit DESC
LIMIT 1;


CREATE VIEW speciality AS
  SELECT innerVe.name as Vet
  FROM vets innerVe
  LEFT JOIN specialization ON innerVe.id = specialization.vets_id
  LEFT JOIN species innerS ON innerS.id = specialization.species_id;

SELECT COUNT(Vi.date_of_visit)
FROM animals A
JOIN visits Vi ON Vi.animal_id = A.id
JOIN vets Ve ON Ve.id = Vi.vets_id
LEFT JOIN specialization Sp ON Ve.id = Sp.vets_id
WHERE (A.species_id != Sp.species_id OR Sp.species_id IS NULL) AND 2 != (
  SELECT COUNT(speciality.vet)
  FROM speciality
  WHERE speciality.vet = Ve.name 
);

SELECT S.name, COUNT(S.name) as visits
FROM animals A
JOIN visits Vi ON Vi.animal_id = A.id
JOIN vets Ve ON Vi.vets_id = Ve.id
JOIN species S ON S.id = A.species_id
WHERE Ve.name = 'Maisy Smith'
GROUP BY S.name
ORDER BY visits DESC
LIMIT 1;
