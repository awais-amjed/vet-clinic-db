/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered IS TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > '10.5';
SELECT * FROM animals WHERE neutered IS TRUE;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg BETWEEN '10.4' AND '17.3';

-- Transactions
BEGIN;
    DELETE FROM animals;
ROLLBACK;
BEGIN;
    DELETE FROM animals WHERE date_of_birth > '2022-01-01';
    SAVEPOINT s1;
    UPDATE animals SET weight_kg = weight_kg*-1;
    ROLLBACK TO s1;
    UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg < 0;
COMMIT;

-- Queries
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered FROM (
    SELECT neutered, SUM(escape_attempts) AS total_escape_attempts from animals GROUP BY neutered ORDER BY total_escape_attempts DESC
) as subQuery LIMIT 1;

-- JOIN Queries
SELECT full_name, name FROM owners o JOIN animals a on o.id = a.owner_id WHERE full_name = 'Melody Pond';
SELECT a.name FROM animals a JOIN species s on s.id = a.species_id WHERE s.name = 'Pokemon';
SELECT full_name, name FROM owners LEFT JOIN animals a on owners.id = a.owner_id;
SELECT s.name, count(species_id) FROM species s JOIN animals a on s.id = a.species_id GROUP BY s.name;
SELECT name FROM animals a JOIN owners o on o.id = a.owner_id WHERE full_name = 'Jennifer Orwell';
SELECT name FROM animals a JOIN owners o on o.id = a.owner_id WHERE escape_attempts = '0' AND full_name = 'Dean Winchester';
SELECT full_name FROM (
    SELECT full_name, COUNT(owner_id) as count FROM owners o JOIN animals a on o.id = a.owner_id GROUP BY full_name ORDER BY count DESC
) as subQuery LIMIT 1;
