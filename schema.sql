/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name TEXT,
    date_of_birth DATE,
    neutered BIT,
    weight_kg DECIMAL,
    PRIMARY KEY(id)
);
