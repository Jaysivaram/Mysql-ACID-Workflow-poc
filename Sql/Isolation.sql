-- Isolation in ACID means that when multiple transactions execute
-- concurrently, each transaction should not interfere with the
-- execution of other transactions.
--
-- Isolation ensures that concurrent transactions behave as if they
-- are executing independently, preventing unwanted data inconsistencies.
--
-- MySQL supports four standard transaction isolation levels:
--
-- 1. READ UNCOMMITTED
-- 2. READ COMMITTED
-- 3. REPEATABLE READ
-- 4. SERIALIZABLE
--
-- Each isolation level provides a different degree of protection
-- against concurrency problems such as:
-- Dirty Reads, Non-Repeatable Reads, and Phantom Reads.


CREATE DATABASE IF NOT EXISTS isolation_poc;
USE isolation_poc;


DROP TABLE IF EXISTS accounts;


CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(12, 2) NOT NULL
) ENGINE = InnoDB;

INSERT INTO accounts (id, name, balance)
VALUES
    (1, 'Account A', 5000.00),
    (2, 'Account B', 3000.00);



-- Check initial account balances
SELECT * FROM accounts;


-- To View default Isolation levels
select @@transaction_ISOLATION;


--Open to Terminals to check the cases

--CASE 1 READ UNCOMMITED(Dirty READ)

-- We'll deliberately use READ UNCOMMITTED, which permits a transaction to read another transaction's uncommitted changes

USE isolation_poc;


-- Terminal1(T1)
START TRANSACTION;

UPDATE accounts
SET balance = 2000
WHERE id = 1;

-- Do not commit yet!



-- Terminal2(T2)

USE isolation_poc;

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

-- Execute the query you will see uncommited value of T1
SELECT * FROM accounts WHERE id = 1;



----CASE 1 READ COMMITED(To prevent Dirty READ)

-- In T1 start again

START TRANSACTION;

UPDATE accounts
SET balance = 2000
WHERE id = 1;

-- Do not commit yet!

-- In T2 set up the session transaction level

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

-- execute in T2 you will see last commited  value because ongoing tranction not yet commited

SELECT * FROM accounts WHERE id = 1;


-- Commit T1

COMMIT;


-- execute in T2 you will initial value because tranction is commited

SELECT * FROM accounts WHERE id = 1;













