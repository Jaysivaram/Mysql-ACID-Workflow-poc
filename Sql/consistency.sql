-- Consistency in ACID means that a transaction moves the database
-- from one valid state to another valid state.
-- Whether the transaction succeeds or fails, all database constraints
-- and rules must remain satisfied.


-- Constraint 0: CREATE DATABASE IF NOT EXISTS ensures that the database
-- is created only if it does not already exist.
-- This makes database creation safe to execute multiple times.
-- However, this is not an example of ACID consistency; it is an
-- idempotent database creation operation.

CREATE DATABASE IF NOT EXISTS acid_poc;
USE acid_poc;



-- 1. Reset tables
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;

-- To verify the table list
SHOW TABLES;


-- 2. Create accounts table with constraints
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    balance DECIMAL(12, 2) NOT NULL,
    CHECK (balance >= 0)
) ENGINE = InnoDB;


-- 3. Create transactions table
CREATE TABLE transactions (
    id INT PRIMARY KEY,
    account_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',

    CHECK (amount > 0),
    CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED')),

    FOREIGN KEY (account_id) REFERENCES accounts(id)
) ENGINE = InnoDB;


-- To verify the table list
SHOW TABLES;

-- 4. Seed data
INSERT INTO accounts (id, name, email, balance)
VALUES
    (1, 'Account A', 'a@example.com', 5000.00),
    (2, 'Account B', 'b@example.com', 3000.00);

INSERT INTO transactions (id, account_id, amount, status)
VALUES
    (101, 1, 1000.00, 'SUCCESS'),
    (102, 2, 500.00, 'PENDING');


-- 5. Verify initial data
SELECT 'INITIAL ACCOUNTS' AS scenario;
SELECT * FROM accounts;

SELECT 'INITIAL TRANSACTIONS' AS scenario;
SELECT * FROM transactions;


-- Execute the queries below and observe how database consistency
-- is maintained in both successful and failed transaction scenarios.

-- TEST 1: PRIMARY KEY
-- Prevent duplicate account IDs
-- Expected: ERROR

INSERT INTO accounts
VALUES (1, 'Duplicate', 'duplicate@example.com', 1000);


-- TEST 2: NOT NULL
-- Name cannot be NULL
-- Expected: ERROR

INSERT INTO accounts
VALUES (3, NULL, 'c@example.com', 1000);


-- TEST 3: UNIQUE
-- Email cannot be duplicated
-- Expected: ERROR

INSERT INTO accounts
VALUES (3, 'Account C', 'a@example.com', 1000);

-- TEST 4: CHECK
-- Balance cannot be negative
-- Expected: ERROR

UPDATE accounts
SET balance = -500
WHERE id = 1;


-- TEST 5: CHECK
-- Transaction amount must be positive
-- Expected: ERROR

INSERT INTO transactions (id, account_id, amount)
VALUES (103, 1, -100);


-- TEST 6: FOREIGN KEY
-- Account must exist
-- Expected: ERROR

INSERT INTO transactions (id, account_id, amount)
VALUES (104, 999, 500);


-- TEST 7: DEFAULT
-- Omitted status becomes PENDING
-- Expected: SUCCESS

INSERT INTO transactions (id, account_id, amount)
VALUES (105, 1, 250.00);

SELECT * FROM transactions
WHERE id = 105;

-- Expected status: PENDING


-- TEST 8: VALID UPDATE
-- Positive balance remains valid
-- Expected: SUCCESS

UPDATE accounts
SET balance = balance - 500
WHERE id = 1
  AND balance >= 500;

SELECT * FROM accounts;

-- FINAL VALIDATION

SELECT 'FINAL ACCOUNTS' AS scenario;
SELECT * FROM accounts;

SELECT 'FINAL TRANSACTIONS' AS scenario;
SELECT * FROM transactions;

SELECT
    SUM(balance) AS total_balance
FROM accounts;

-- Expected total balance: 7500.00


--NOTE

-- Consistency does not mean every SQL query must succeed. It means the database must preserve the rules that define valid data.

-- For example, if Account A has ₹5,000, a withdrawal of ₹6,000 should not leave a negative balance when overdrafts are prohibited. The CHECK constraint protects the balance, while the update condition prevents an invalid withdrawal from being attempted.

-- One important limitation: a database constraint cannot enforce every business rule. For example, ensuring that every debit has a corresponding credit requires transaction logic and appropriate application or database design.