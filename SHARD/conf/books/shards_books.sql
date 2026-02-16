CREATE EXTENSION postgres_fdw;

/* shard 1 */
CREATE SERVER books_1_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'books_1', port '5432', dbname 'books_db');

CREATE USER MAPPING FOR "postgres"
    SERVER books_1_server
    OPTIONS (user 'postgres', password '12345');

CREATE FOREIGN TABLE books_1 (
    book_id BIGINT not null,
    title VARCHAR(200),
    author VARCHAR(100),
    type VARCHAR(50),
    price DECIMAL(10,2),
    store_id BIGINT
) SERVER books_1_server
  OPTIONS (schema_name 'public', table_name 'books');

/* shard 2 */
CREATE SERVER books_2_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'books_2', port '5432', dbname 'books_db');

CREATE USER MAPPING FOR "postgres"
SERVER books_2_server
OPTIONS (user 'postgres', password '12345');

CREATE FOREIGN TABLE books_2 (
    book_id BIGINT not null,
    title VARCHAR(200),
    author VARCHAR(100),
    type VARCHAR(50),
    price DECIMAL(10,2),
    store_id BIGINT
) SERVER books_2_server
  OPTIONS (schema_name 'public', table_name 'books');


CREATE VIEW books AS
SELECT * FROM books_1
UNION ALL
SELECT * FROM books_2;

CREATE RULE books_insert AS ON INSERT TO books
	DO INSTEAD NOTHING;
CREATE RULE books_update AS ON UPDATE TO books 
	DO INSTEAD NOTHING;
CREATE RULE books_delete AS ON DELETE TO books 
	DO INSTEAD NOTHING;


CREATE RULE books_insert_to_1 AS ON INSERT TO books
    WHERE (book_id % 2 = 0)
    DO INSTEAD INSERT INTO books_1 
	VALUES (NEW.*);

CREATE RULE books_insert_to_2 AS ON INSERT TO books
    WHERE (book_id % 2 = 1)
    DO INSTEAD INSERT INTO books_2 
	VALUES (NEW.*);


INSERT INTO books (book_id, title, author, type, price, store_id) VALUES
(101, 'Мастер и Маргарита', 'Булгаков', 'роман', 550.00, 1),
(102, 'Война и мир', 'Толстой', 'роман', 599.00, 1),
(103, 'Преступление и наказание', 'Достоевский', 'роман', 450.00, 2),
(104, 'Евгений Онегин', 'Пушкин', 'поэма', 320.00, 3),
(105, 'Собачье сердце', 'Булгаков', 'повесть', 280.00, 2),
(106, 'Анна Каренина', 'Толстой', 'роман', 650.00, 1),
(107, 'Идиот', 'Достоевский', 'роман', 480.00, 2),
(108, 'Отцы и дети', 'Тургенев', 'роман', 310.00, 3);