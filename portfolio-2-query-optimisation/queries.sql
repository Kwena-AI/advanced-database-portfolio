USE library_db;

-- Q1: Full catalogue with authors and categories (JOINs)
SELECT b.Title, a.AuthorName, c.CategoryName, b.AvailableCopies
FROM Book b
JOIN Book_Author ba ON b.BookID = ba.BookID
JOIN Author a       ON ba.AuthorID = a.AuthorID
JOIN Category c     ON b.CategoryID = c.CategoryID
ORDER BY b.Title;

-- Q2: Number of loans per member (GROUP BY aggregation)
SELECT m.FullName, COUNT(l.LoanID) AS TotalLoans
FROM Member m
LEFT JOIN Loan l ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.FullName
ORDER BY TotalLoans DESC;

-- Q3: Currently overdue loans (date functions)
SELECT m.FullName, b.Title, l.DueDate,
       DATEDIFF(CURDATE(), l.DueDate) AS DaysOverdue
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b   ON l.BookID   = b.BookID
WHERE l.ReturnDate IS NULL
  AND l.DueDate < CURDATE();

-- Q4: Books that have never been borrowed (subquery)
SELECT Title FROM Book
WHERE BookID NOT IN (SELECT DISTINCT BookID FROM Loan);

-- Q5: Total fines collected (aggregate function)
SELECT SUM(FineAmount) AS TotalFines FROM Loan;




EXPLAIN SELECT * FROM Member WHERE Email = 'adaeze.o@email.com';

CREATE INDEX idx_member_email ON Member(Email);

EXPLAIN SELECT * FROM Member WHERE Email = 'adaeze.o@email.com';





EXPLAIN SELECT * FROM Loan WHERE MemberID = 1;          -- before: type=ALL
CREATE INDEX idx_loan_member ON Loan(MemberID);
EXPLAIN SELECT * FROM Loan WHERE MemberID = 1;          -- after: type=ref
