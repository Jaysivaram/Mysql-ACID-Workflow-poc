
-- To Crate Database
CREATE DATABASE acid_poc;

--To select the Database to use
USE acid_poc;


--To Create Table
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(12, 2) NOT NULL,
    CHECK (balance >= 0)
) ENGINE = InnoDB;

--To seed Data
INSERT INTO accounts (id, name, balance)
VALUES
    (1, 'Account A', 5000.00),
    (2, 'Account B', 3000.00);


--To view or verify the inserted initial Data
Select * from accounts