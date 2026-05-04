CREATE TABLE lesson3.employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    salary NUMERIC(10,2)
);

CREATE TABLE lesson3.employees_log (
    log_id SERIAL PRIMARY KEY,
    employee_id INT,
    operation VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    change_time TIMESTAMP
);

CREATE OR REPLACE FUNCTION lesson3.log_employee_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO lesson3.employees_log(employee_id, operation, new_data, change_time)
        VALUES (NEW.id, 'INSERT', to_jsonb(NEW), NOW());
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO lesson3.employees_log(employee_id, operation, old_data, new_data, change_time)
        VALUES (NEW.id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW), NOW());
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO lesson3.employees_log(employee_id, operation, old_data, change_time)
        VALUES (OLD.id, 'DELETE', to_jsonb(OLD), NOW());
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_employee
AFTER INSERT OR UPDATE OR DELETE ON lesson3.employees
FOR EACH ROW
EXECUTE FUNCTION lesson3.log_employee_changes();

INSERT INTO lesson3.employees (name, position, salary)
VALUES ('Quang', 'Developer', 1000);

UPDATE lesson3.employees
SET salary = 1200
WHERE id = 1;

DELETE FROM lesson3.employees
WHERE id = 1;

SELECT * FROM lesson3.employees_log;