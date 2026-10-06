CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

CREATE TABLE Category (
    CategoryID   INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Publisher (
    PublisherID   INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Author (
    AuthorID   INT AUTO_INCREMENT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL
);

CREATE TABLE Book (
    BookID          INT AUTO_INCREMENT PRIMARY KEY,
    ISBN            VARCHAR(17)  NOT NULL UNIQUE,
    Title           VARCHAR(200) NOT NULL,
    PublicationYear SMALLINT,
    CategoryID      INT,
    PublisherID     INT,
    TotalCopies     INT NOT NULL DEFAULT 1 CHECK (TotalCopies >= 0),
    AvailableCopies INT NOT NULL DEFAULT 1 CHECK (AvailableCopies >= 0),
    FOREIGN KEY (CategoryID)  REFERENCES Category(CategoryID),
    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);

CREATE TABLE Book_Author (
    BookID   INT NOT NULL,
    AuthorID INT NOT NULL,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID)   REFERENCES Book(BookID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Member (
    MemberID       INT AUTO_INCREMENT PRIMARY KEY,
    FullName       VARCHAR(100) NOT NULL,
    Email          VARCHAR(100) NOT NULL UNIQUE,
    Phone          VARCHAR(20),
    MembershipType ENUM('Standard','Premium') DEFAULT 'Standard',
    JoinDate       DATE NOT NULL
);

CREATE TABLE Staff (
    StaffID   INT AUTO_INCREMENT PRIMARY KEY,
    StaffName VARCHAR(100) NOT NULL,
    Role      VARCHAR(50)  NOT NULL,
    Email     VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Loan (
    LoanID     INT AUTO_INCREMENT PRIMARY KEY,
    BookID     INT NOT NULL,
    MemberID   INT NOT NULL,
    StaffID    INT,
    LoanDate   DATE NOT NULL,
    DueDate    DATE NOT NULL,
    ReturnDate DATE NULL,
    FineAmount DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (BookID)   REFERENCES Book(BookID),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (StaffID)  REFERENCES Staff(StaffID)
);
