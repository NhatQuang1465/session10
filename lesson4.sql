CREATE SCHEMA IF NOT EXISTS lesson4;

CREATE TABLE lesson4.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    stock INT
);

CREATE TABLE lesson4.orders (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES lesson4.products(id),
    quantity INT
);

CREATE OR REPLACE FUNCTION lesson4.update_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE lesson4.products
        SET stock = stock - NEW.quantity
        WHERE id = NEW.product_id;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE lesson4.products
        SET stock = stock + OLD.quantity - NEW.quantity
        WHERE id = NEW.product_id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE lesson4.products
        SET stock = stock + OLD.quantity
        WHERE id = OLD.product_id;
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_stock
AFTER INSERT OR UPDATE OR DELETE ON lesson4.orders
FOR EACH ROW
EXECUTE FUNCTION lesson4.update_stock();

INSERT INTO lesson4.products (name, stock)
VALUES ('Product A', 100);

INSERT INTO lesson4.orders (product_id, quantity)
VALUES (1, 10);

UPDATE lesson4.orders
SET quantity = 5
WHERE id = 1;

DELETE FROM lesson4.orders
WHERE id = 1;

SELECT * FROM lesson4.products;