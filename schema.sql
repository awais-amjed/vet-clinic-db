/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOL,
    weight_kg DECIMAL,
    species_id INT,
    owner_id INT,
    PRIMARY KEY (id),
    CONSTRAINT fk_species
        FOREIGN KEY (species_id)
            REFERENCES species(id),
    CONSTRAINT fk_owners
        FOREIGN KEY (owner_id)
            REFERENCES owners(id)
);

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(250),
    age INT,
    PRIMARY KEY (id)
);

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250),
    PRIMARY KEY (id)
);

CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250),
    age INT,
    date_of_graduation DATE,
    PRIMARY KEY (id)
);

CREATE TABLE specializations (
    species_id INT,
    vet_id INT,
    CONSTRAINT fk_species
        FOREIGN KEY (species_id)
            REFERENCES species(id),
    CONSTRAINT fk_vets
        FOREIGN KEY (vet_id)
            REFERENCES vets(id)
);

CREATE TABLE visits (
    animal_id INT,
    vet_id INT,
    date_of_visit DATE,
    CONSTRAINT fk_animals
        FOREIGN KEY (animal_id)
            REFERENCES animals(id),
    CONSTRAINT fk_vets
        FOREIGN KEY (vet_id)
            REFERENCES vets(id)
);
