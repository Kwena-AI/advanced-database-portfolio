USE library_db;

INSERT INTO Category (CategoryName) VALUES
('Fiction'), ('Science'), ('History'), ('Technology'), ('Mathematics');

INSERT INTO Publisher (PublisherName) VALUES
('Penguin Books'), ('Oxford University Press'), ('McGraw-Hill'), ('Springer');

INSERT INTO Author (AuthorName) VALUES
('Chinua Achebe'), ('J.K. Rowling'), ('George Orwell'),
('Thomas Cormen'), ('Isaac Asimov'), ('Stephen Hawking');

INSERT INTO Book (ISBN, Title, PublicationYear, CategoryID, PublisherID, TotalCopies, AvailableCopies) VALUES
('978-0-14-118688-7', 'Things Fall Apart', 1958, 1, 1, 3, 3),
('978-0-7475-3269-9', 'Harry Potter and the Philosopher''s Stone', 1997, 1, 1, 2, 2),
('978-0-452-28423-4', '1984', 1949, 1, 1, 4, 4),
('978-0-553-29335-7', 'Foundation', 1951, 2, 4, 2, 2),
('978-0-262-03384-8', 'Introduction to Algorithms', 2009, 4, 3, 5, 5),
('978-0-19-515931-8', 'A Brief History of Time', 1988, 2, 2, 3, 3);

INSERT INTO Book_Author (BookID, AuthorID) VALUES
(1,1), (2,2), (3,3), (4,5), (5,4), (6,6);

INSERT INTO Member (FullName, Email, Phone, MembershipType, JoinDate) VALUES
('Adaeze Okonkwo', 'adaeze.o@email.com', '08031234567', 'Premium',  '2026-01-15'),
('Tunde Balogun',  'tunde.b@email.com',  '08039876543', 'Standard', '2026-02-03'),
('Mary Johnson',   'mary.j@email.com',   '08104561234', 'Standard', '2026-03-22');

INSERT INTO Staff (StaffName, Role, Email) VALUES
('Mrs. Ngozi Eze', 'Head Librarian',    'n.eze@library.com'),
('Mr. Ibrahim Musa', 'Library Assistant', 'i.musa@library.com');

INSERT INTO Loan (BookID, MemberID, StaffID, LoanDate, DueDate, ReturnDate, FineAmount) VALUES
(1, 1, 2, '2026-09-01', '2026-09-15', '2026-09-14', 0.00),   -- returned on time
(3, 2, 2, '2026-09-10', '2026-09-24', NULL,        0.00),   -- still out (overdue)
(5, 3, 1, '2026-08-20', '2026-09-03', '2026-09-10', 700.00),-- returned late, fine charged
(2, 1, 2, '2026-09-25', '2026-10-09', NULL,        0.00);   -- currently borrowed
