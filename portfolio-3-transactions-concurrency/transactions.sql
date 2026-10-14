-- ============================================================
-- DEMO 1 — COMMIT (successful borrow)
-- ============================================================
START TRANSACTION;

INSERT INTO Loan (BookID, MemberID, StaffID, LoanDate, DueDate, ReturnDate, FineAmount)
VALUES (4, 2, 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 0.00);

UPDATE Book SET AvailableCopies = AvailableCopies - 1 WHERE BookID = 4;

COMMIT;

-- Proof both changes landed together:
SELECT b.Title, b.AvailableCopies FROM Book b WHERE BookID = 4;
-- 📸 t1-commit.png — Foundation should now show 1 copy (was 2).

-- ============================================================
-- DEMO 2 — ROLLBACK (cancelled borrow)
-- ============================================================
START TRANSACTION;

INSERT INTO Loan (BookID, MemberID, StaffID, LoanDate, DueDate)
VALUES (6, 3, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

UPDATE Book SET AvailableCopies = AvailableCopies - 1 WHERE BookID = 6;

-- Librarian notices the wrong member was selected — undo EVERYTHING:
ROLLBACK;

-- Proof nothing changed:
SELECT COUNT(*) AS LoanCount FROM Loan;            -- should be 5 (not 6)
SELECT AvailableCopies FROM Book WHERE BookID = 6; -- should be 3 (not 2)
-- 📸 t2-rollback-proof.png

-- ============================================================
-- DEMO 3 — Error mid-transaction (atomicity)
-- ============================================================
START TRANSACTION;

UPDATE Book SET AvailableCopies = AvailableCopies - 1 WHERE BookID = 5;

INSERT INTO Member (FullName, Email) VALUES ('Test User', 'adaeze.o@email.com');
-- ↑ Error Code 1062: duplicate email (UNIQUE constraint) — statement fails

-- MySQL does NOT undo automatically — the failed transaction is still open:
ROLLBACK;

SELECT AvailableCopies FROM Book WHERE BookID = 5; -- back to 5
-- 📸 t3-error-rollback.png — capture the error and the final proof query.

-- ============================================================
-- DEMO 4 — Isolation (READ COMMITTED) — TWO TABS
-- ============================================================

-- TAB A:
START TRANSACTION;
UPDATE Member SET Phone = '08099998888' WHERE MemberID = 1;
-- DO NOT COMMIT yet — switch to Tab B

-- TAB B:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT Phone FROM Member WHERE MemberID = 1;   -- shows OLD: 08031234567

-- Back to TAB A:
COMMIT;

-- TAB B again:
SELECT Phone FROM Member WHERE MemberID = 1;   -- NOW shows: 08099998888
-- 📸 t4-isolation.png — best shot: both tabs side-by-side
--   (old value in B before commit / new value after).

-- ============================================================
-- DEMO 5 — Concurrency control with locking — TWO TABS
-- ============================================================

-- TAB A:
START TRANSACTION;
SELECT AvailableCopies FROM Book WHERE BookID = 2 FOR UPDATE;  -- locks the row; shows 2
UPDATE Book SET AvailableCopies = 1 WHERE BookID = 2;
-- DO NOT COMMIT — switch to Tab B

-- TAB B:
START TRANSACTION;
SELECT AvailableCopies FROM Book WHERE BookID = 2 FOR UPDATE;
-- ↑ BLOCKED — it waits for Tab A's lock. Screenshot NOW (within ~30s)

-- Quickly back to TAB A:
COMMIT;

-- TAB B: query finally completes → now shows 1.
ROLLBACK;  -- it only read, so nothing to undo — but closes the transaction

-- 📸 t5-lock-wait.png (B stuck waiting) and t5-lock-after.png (B returns 1)
