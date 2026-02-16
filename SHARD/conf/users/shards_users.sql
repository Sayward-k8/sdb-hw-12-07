CREATE EXTENSION IF NOT EXISTS postgres_fdw;

/* shard 1 */
CREATE SERVER users_1_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'users_1', port '5432', dbname 'users_db');

CREATE USER MAPPING FOR "postgres"
    SERVER users_1_server
    OPTIONS (user 'postgres', password '12345');

CREATE FOREIGN TABLE users_1 (
    user_id BIGINT not null,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birthday DATE,
    email VARCHAR(100),
    phone VARCHAR(20)
) SERVER users_1_server
  OPTIONS (schema_name 'public', table_name 'users');

CREATE FOREIGN TABLE user_books_1 (
    user_id BIGINT not null,
    book_id BIGINT not null,
    purchase_date TIMESTAMP
) SERVER users_1_server
  OPTIONS (schema_name 'public', table_name 'user_books');

/* shard 2 */
CREATE SERVER users_2_server
   FOREIGN DATA WRAPPER postgres_fdw
   OPTIONS (host 'users_2', port '5432', dbname 'users_db');

CREATE USER MAPPING FOR "postgres"
SERVER users_2_server
OPTIONS (user 'postgres', password '12345');

CREATE FOREIGN TABLE users_2 (
    user_id BIGINT not null,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birthday DATE,
    email VARCHAR(100),
    phone VARCHAR(20)
) SERVER users_2_server
  OPTIONS (schema_name 'public', table_name 'users');

CREATE FOREIGN TABLE user_books_2 (
    user_id BIGINT not null,
    book_id BIGINT not null,
    purchase_date TIMESTAMP
) SERVER users_2_server
  OPTIONS (schema_name 'public', table_name 'user_books');

CREATE VIEW users AS
SELECT * FROM users_1
UNION ALL
SELECT * FROM users_2;

CREATE VIEW user_books AS
SELECT * FROM user_books_1
UNION ALL
SELECT * FROM user_books_2;

CREATE RULE users_insert AS ON INSERT TO users 
	DO INSTEAD NOTHING;
CREATE RULE users_update AS ON UPDATE TO users 
	DO INSTEAD NOTHING;
CREATE RULE users_delete AS ON DELETE TO users 
	DO INSTEAD NOTHING;

CREATE RULE user_books_insert AS ON INSERT TO user_books 
	DO INSTEAD NOTHING;
CREATE RULE user_books_update AS ON UPDATE TO user_books 
	DO INSTEAD NOTHING;
CREATE RULE user_books_delete AS ON DELETE TO user_books 
	DO INSTEAD NOTHING;

CREATE RULE users_insert_to_1 AS ON INSERT TO users
    WHERE (user_id % 2 = 0)
    DO INSTEAD INSERT INTO users_1 
	VALUES (NEW.*);

CREATE RULE users_insert_to_2 AS ON INSERT TO users
    WHERE (user_id % 2 = 1)
    DO INSTEAD INSERT INTO users_2 
	VALUES (NEW.*);

CREATE RULE user_books_insert_to_1 AS ON INSERT TO user_books
    WHERE (user_id % 2 = 0)
    DO INSTEAD INSERT INTO user_books_1 
	VALUES (NEW.*);

CREATE RULE user_books_insert_to_2 AS ON INSERT TO user_books
    WHERE (user_id % 2 = 1)
    DO INSTEAD INSERT INTO user_books_2 
	VALUES (NEW.*);

INSERT INTO users (user_id, first_name, last_name, gender, birthday, email, phone) VALUES
(1, 'Иван', 'Иванов', 'male', '1990-01-15', 'ivan@mail.ru', '+7-999-123-45-67'),
(2, 'Ольга', 'Соколова', 'female', '1993-03-22', 'olga@mail.ru', '+7-999-678-90-12'),
(3, 'Петр', 'Петров', 'male', '1985-05-20', 'petr@mail.ru', '+7-999-234-56-78'),
(4, 'Алексей', 'Морозов', 'male', '1987-12-05', 'alex@mail.ru', '+7-999-789-01-23'),
(5, 'Мария', 'Сидорова', 'female', '1995-11-03', 'maria@mail.ru', '+7-999-345-67-89'),
(6, 'Елена', 'Волкова', 'female', '1991-08-17', 'elena@mail.ru', '+7-999-890-12-34');

INSERT INTO user_books (user_id, book_id, purchase_date) VALUES
(1, 101, '2023-01-10 14:23:45'),
(1, 202, '2023-02-15 10:11:22'),
(2, 102, '2023-01-12 13:24:35'),
(2, 203, '2023-02-18 11:22:33'),
(3, 101, '2023-01-20 16:30:00'),
(3, 304, '2023-03-05 12:45:10'),
(4, 102, '2023-01-22 15:40:20'),
(5, 203, '2023-02-28 09:15:33'),
(6, 305, '2023-03-08 08:55:44');
