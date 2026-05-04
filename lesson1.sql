CREATE TABLE lesson1.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    last_modified TIMESTAMP
);

CREATE OR REPLACE FUNCTION lesson1.update_last_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_last_modified
BEFORE UPDATE ON lesson1.products
FOR EACH ROW
EXECUTE FUNCTION lesson1.update_last_modified();

INSERT INTO lesson1.products (name, price, last_modified)
VALUES 
('Product A', 100, NOW()),
('Product B', 200, NOW());

SELECT * FROM lesson1.products;

UPDATE lesson1.products
SET price = 150
WHERE id = 1;

SELECT * FROM lesson1.products;