CREATE TABLE lesson5.customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE lesson5.customers_log (
    log_id SERIAL PRIMARY KEY,
    customer_id INT,
    operation VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    changed_by TEXT,
    change_time TIMESTAMP
);

CREATE OR REPLACE FUNCTION lesson5.log_customer_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO lesson5.customers_log(customer_id, operation, new_data, changed_by, change_time)
        VALUES (NEW.id, 'INSERT', to_jsonb(NEW), current_user, NOW());
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO lesson5.customers_log(customer_id, operation, old_data, new_data, changed_by, change_time)
        VALUES (NEW.id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW), current_user, NOW());
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO lesson5.customers_log(customer_id, operation, old_data, changed_by, change_time)
        VALUES (OLD.id, 'DELETE', to_jsonb(OLD), current_user, NOW());
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_customers
AFTER INSERT OR UPDATE OR DELETE ON lesson5.customers
FOR EACH ROW
EXECUTE FUNCTION lesson5.log_customer_changes();

INSERT INTO lesson5.customers (name, email, phone, address)
VALUES ('Quang', 'quang@gmail.com', '0123456789', 'Hanoi');

UPDATE lesson5.customers
SET phone = '0987654321'
WHERE id = 1;

DELETE FROM lesson5.customers
WHERE id = 1;

SELECT * FROM lesson5.customers_log;