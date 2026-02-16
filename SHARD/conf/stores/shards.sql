CREATE TABLE stores (
    store_id BIGINT PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    manager VARCHAR(100)
);

CREATE INDEX idx_stores_city ON stores(city);

INSERT INTO stores (store_id, city, address, manager) VALUES
(1, 'Москва', 'Тверская ул., 15', 'Иванов И.И.'),
(2, 'Санкт-Петербург', 'Невский пр., 45', 'Петров П.П.'),
(3, 'Казань', 'Баумана ул., 20', 'Сидоров С.С.'),
(4, 'Новосибирск', 'Красный пр., 120', 'Козлова О.В.'),
(5, 'Екатеринбург', 'Ленина пр., 55', 'Морозов П.А.');