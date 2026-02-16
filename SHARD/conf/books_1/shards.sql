CREATE TABLE books (
    book_id BIGINT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    store_id BIGINT,
    CONSTRAINT book_id_even_check CHECK (book_id % 2 = 0)
);

CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_store_id ON books(store_id);