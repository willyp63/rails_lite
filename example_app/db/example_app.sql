CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE toys (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  dog_id INTEGER NOT NULL,

  FOREIGN KEY(dog_id) REFERENCES dogs(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  session_token VARCHAR(255) NOT NULL
);

INSERT INTO
  dogs (id, name)
VALUES
  (1, "Breakfast"),
  (2, "Earl");

INSERT INTO
  toys (id, name, dog_id)
VALUES
  (1, "Rope", 1),
  (2, "Tire", 1),
  (3, "Squishy Ball", 2),
  (4, "Bone", 2),
  (5, "Stuffed Animal", 1);
