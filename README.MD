# MySQL ACID Workflow POC

A small project I made to understand ACID properties in MySQL. It uses a simple example of moving money from one bank account to another.

![ACID mind map](docs/Acid-mindmap)

## What is ACID

- **Atomicity** - all steps of a transaction happen, or none of them happen.
- **Consistency** - the data always follows the rules (no negative balance, no duplicate ids, etc).
- **Isolation** - two transactions running at the same time don't mess with each other.
- **Durability** - once committed, the data stays even if the server restarts.

## What you need

- MySQL 8.0.16 or newer
- Any MySQL client (terminal, Workbench, DBeaver...)

## How to use

1. Run `Sql/schema.sql` first. It creates the `acid_poc` database and two accounts.
2. Open any of the files below and run the queries one by one.
3. Read the comments in the file and check the result with the expected output.

Don't run a whole file at once. Some queries are meant to fail.

## Files

- `Sql/Automicity.sql` - a transfer that commits, and a transfer that fails and rolls back.
- `Sql/Consistency.sql` - tries to break constraints (primary key, not null, unique, check, foreign key) and shows MySQL stops it.
- `Sql/Durability.sql` - restart MySQL before and after commit and see what stays.
- `Sql/Isolation.sql` - open two terminals and try the four isolation levels: read uncommitted, read committed, repeatable read and serializable.
