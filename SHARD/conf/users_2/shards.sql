CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    birthday DATE,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    CONSTRAINT user_id_even_check CHECK (user_id % 2 = 0)
);

CREATE TABLE user_books (
    user_id BIGINT,
    book_id BIGINT,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX idx_user_books_user_id ON user_books(user_id);
CREATE INDEX idx_user_books_purchase_date ON user_books(purchase_date);