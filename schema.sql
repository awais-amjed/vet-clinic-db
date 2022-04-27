/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name TEXT,
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
