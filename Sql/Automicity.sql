-- Atomicity means that a transaction is treated as a single unit of work. Either all operations are completed successfully, or none of them are applied.

-- For example, when transferring money from one bank account to another, the amount must be deducted from the sender's account and credited to the receiver's account. If the deduction succeeds but the credit fails, the database must roll back the deduction to maintain data consistency.

-- Therefore, atomicity ensures that a transaction is either fully successful or fully rolled back, preventing partial updates to the database


--SUCESSFULL TRANSACTION

START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

-- Both operations succeed, so save both.
COMMIT;

--Execute and see the data consistency
SELECT 'SUCCESS CASE - AFTER COMMIT' AS scenario;
SELECT * FROM accounts;


-- Expected:
-- Account A = 4000
-- Account B = 4000




-- Reset for Failure case

UPDATE accounts SET balance = 5000 WHERE id = 1;
UPDATE accounts SET balance = 3000 WHERE id = 2;



-- For Failed Transaction

START TRANSACTION;

-- Operation 1 succeeds inside the transaction.
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

-- Operation 2 fails due to CHECK constraint because amount should be grater than zero.
UPDATE accounts
SET balance = -1000
WHERE id = 2;

-- IMPORTANT:
-- Execute the following ROLLBACK separately
-- after the UPDATE error.
ROLLBACK;


--Execute and see the data consistency now

SELECT 'FAILURE CASE - AFTER ROLLBACK' AS scenario;
SELECT * FROM accounts;


-- Expected:
-- Account A = 5000
-- Account B = 3000


-- Note: We will implement the same scenario in a real-time project using an ORM. The ORM transaction will handle commit and rollback based on the execution result. If all operations succeed, the transaction will be committed. If any operation fails, the transaction will be rolled back using a try-catch block. Finally, we will release the transaction or its associated resources to ensure they are not held unnecessarily.