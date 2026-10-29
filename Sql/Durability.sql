-- Durability in ACID means that once a transaction is committed,
-- the changes are permanently saved in the database.
-- Even if the database server restarts or crashes, the committed
-- data remains persistent and is not lost.


-- Imagine a banking application:
-- 1. Your account balance is ₹5,000.
-- 2. You transfer ₹1,000 to another account.
-- 3. MySQL executes COMMIT.
-- 4. The transfer succeeds, and the new balances are ₹4,000 and ₹4,000.
-- 5. The MySQL server unexpectedly restarts.
-- 6. After MySQL starts again, the balances should still be ₹4,000 and ₹4,000.
-- That is Durability: committed data should survive a restart.


CREATE DATABASE IF NOT EXISTS durability_poc;
USE durability_poc;

-- Create accounts table
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(12, 2) NOT NULL
) ENGINE = InnoDB;


-- Insert initial data
INSERT INTO accounts (id, name, balance)
VALUES
    (1, 'Account A', 5000.00),
    (2, 'Account B', 3000.00);


-- Start a transaction
START TRANSACTION;


-- Transfer 1000 from Account A to Account B
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;


-- dont commit just try to restart the mysql server and see that difference(open duplicate terminal near)
--Amount would't be changed will be in the initial state data
-- again do same but commit


-- Start a transaction
START TRANSACTION;

-- Transfer 1000 from Account A to Account B
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

-- Permanently commit the changes
COMMIT;


-- Verify the committed data
SELECT * FROM accounts;