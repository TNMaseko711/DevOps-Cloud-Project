CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price NUMERIC(10,2) NOT NULL
);

INSERT INTO products (name, price)
VALUES ('Cloud T-Shirt', 29.99), ('DevOps Mug', 14.99)
ON CONFLICT DO NOTHING;
