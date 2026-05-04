CREATE TABLE lesson2.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    last_modified TIMESTAMP
);

CREATE OR REPLACE FUNCTION lesson2.update_last_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_last_modified
BEFORE UPDATE ON lesson2.products
FOR EACH ROW
EXECUTE FUNCTION lesson2.update_last_modified();

INSERT INTO lesson2.products (name, price, last_modified)
VALUES 
('Laptop', 1500, NOW()),
('Mouse', 25, NOW());

SELECT * FROM lesson2.products;

UPDATE lesson2.products
SET price = 1600
WHERE id = 1;

SELECT * FROM lesson2.products;