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

-- Many to Many Relationship Queries
-- Who was the last animal seen by William Tatcher?
SELECT a_name as last_animal_seen FROM (
    SELECT animals.name a_name, date_of_visit FROM vets
    JOIN visits on vets.id = visits.vet_id
    JOIN animals on visits.animal_id = animals.id
    WHERE vets.name = 'William Tatcher'
) as sub_query ORDER BY date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT a_name) as count FROM (
    SELECT animals.name as a_name FROM vets
    JOIN visits on vets.id = visits.vet_id
    JOIN animals on animals.id = visits.animal_id
    WHERE vets.name = 'Stephanie Mendez'
) as sub_query;

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name as vet, s2.name as speciality FROM vets v
LEFT JOIN specializations s on v.id = s.vet_id
JOIN species s2 on s2.id = s.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name as animals FROM animals a
JOIN visits v on a.id = v.animal_id
JOIN vets v2 on v2.id = v.vet_id
WHERE v2.name = 'Stephanie Mendez' AND v.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT name as animal_with_most_visits FROM animals a JOIN (
    SELECT animal_id, COUNT(animal_id) as count
    FROM visits GROUP BY animal_id ORDER BY count DESC LIMIT 1
) as sub_query on a.id = sub_query.animal_id;

-- Who was Maisy Smith's first visit?
SELECT a.name as name FROM animals a
JOIN visits v2 on a.id = v2.animal_id
JOIN vets v on v2.vet_id = v.id
WHERE v.name = 'Maisy Smith'
ORDER BY v2.date_of_visit LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name, v.name, v2.date_of_visit FROM animals a
JOIN visits v2 on a.id = v2.animal_id
JOIN vets v on v2.vet_id = v.id
ORDER BY v2.date_of_visit DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM (
    SELECT a.species_id, v2.animal_id, v2.vet_id, s.species_id
    FROM animals a
    JOIN visits v2 on a.id = v2.animal_id
    JOIN specializations s on v2.vet_id = s.vet_id
    WHERE a.species_id != s.species_id
) as sub_query;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT name as speciality FROM species s
JOIN (
    SELECT a.species_id, COUNT(a.species_id) as visit_count FROM visits v2
    JOIN vets v on v.id = v2.vet_id
    JOIN animals a on a.id = v2.animal_id
    WHERE v.name = 'Maisy Smith'
    GROUP BY a.species_id ORDER BY visit_count DESC LIMIT 1
) as sub_query on s.id = sub_query.species_id;

-- Explain analyze queries
explain analyze SELECT COUNT(*) FROM visits where animal_id = 4;
explain analyze SELECT * FROM visits where vet_id = 2;
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';

-- Improvements
explain analyze SELECT COUNT(1) FROM visits where animal_id = 4; -- Use count(1) instead of count(*)
CREATE INDEX vet_id_asc ON visits(vet_id ASC);
CREATE INDEX email_asc ON owners(email ASC);
