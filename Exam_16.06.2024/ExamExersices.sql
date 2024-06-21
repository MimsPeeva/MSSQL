CREATE DATABASE LibraryDb
GO
USE LibraryDb
GO

--01
CREATE TABLE Genres
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Contacts
(
[Id] INT PRIMARY KEY IDENTITY,
[Email] NVARCHAR(100),
[PhoneNumber] NVARCHAR(20),
[PostAddress] NVARCHAR(200),
[Website] NVARCHAR(50)
)

CREATE TABLE Libraries
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL,
[ContactId] INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL

)

CREATE TABLE Authors
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(100) NOT NULL,
[ContactId] INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL
)

CREATE TABLE Books
(
[Id] INT PRIMARY KEY IDENTITY,
[Title] NVARCHAR(100) NOT NULL,
[YearPublished] INT NOT NULL,
[ISBN] NVARCHAR(13) NOT NULL,
[AuthorId] INT FOREIGN KEY REFERENCES Authors(Id) NOT NULL,
[GenreId] INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL
)

CREATE TABLE LibrariesBooks
(
[LibraryId] INT FOREIGN KEY REFERENCES Libraries(Id) NOT NULL,
[BookId] INT FOREIGN KEY REFERENCES Books(Id) NOT NULL,
CONSTRAINT PK_LibrariesBooks PRIMARY KEY(LibraryId,BookId)
)

--02
INSERT INTO Contacts(Email,PhoneNumber,PostAddress,Website)
VALUES(NULL,	NULL,	NULL,	NULL),
(NULL,	NULL,	NULL,	NULL),
('stephen.king@example.com',	'+4445556666',	'15 Fiction Ave, Bangor, ME',	'www.stephenking.com'),
('suzanne.collins@example.com',	'+7778889999',	'10 Mockingbird Ln, NY, NY',	'www.suzannecollins.com')

INSERT INTO Authors([Name],ContactId)
VALUES
('George Orwell',	21),
('Aldous Huxley',	22),
('Stephen King',	23),
('Suzanne Collins',	24)

INSERT INTO Books(Title,YearPublished,ISBN,AuthorId,GenreId)
VALUES
('1984',	1949,	'9780451524935',	16,	2),
('Animal Farm',	1945,	'9780451526342',		16,	2),
('Brave New World',	1932,	'9780060850524',	17,	2),
('The Doors of Perception',	1954,	'9780060850531',	17,	2),
('The Shining',	1977,	'9780307743657',	18,	9),
('It',	1986,	'9781501142970',	18,	9),
('The Hunger Games',	2008,	'9780439023481',	19,	7),
('Catching Fire',	2009,	'9780439023498',	19,	7),
('Mockingjay',	2010,	'9780439023511',	19,	7)

INSERT INTO LibrariesBooks
VALUES
(1,	36),
(1,	37),
(2,	38),
(2,	39),
(3,	40),
(3,	41),
(4,	42),
(4,	43),
(5,	44)

--03
UPDATE Contacts
SET Website = 'www.' + LOWER(REPLACE(a.[NAME],' ','')) + '.com'
FROM Authors AS a
JOIN Contacts AS c ON c.Id = a.ContactId
WHERE Website IS NULL

--04
CREATE TABLE TempAuthorId(Id INT)
INSERT INTO TempAuthorId(Id)
(
SELECT Id FROM Authors
WHERE [Name] = 'Alex Michaelides'
)
--select * from TempAuthorId
CREATE TABLE TempBooksId(Id INT)
INSERT INTO TempBooksId(Id)
(
SELECT Id FROM Books
WHERE AuthorId IN(SELECT Id FROM TempAuthorId)

)

--judge
DELETE FROM LibrariesBooks
WHERE BookId = 1
--select * from TempBooksId
DELETE FROM Books
WHERE AuthorId = 1


DELETE FROM Authors
WHERE [Name] = 'Alex Michaelides'

--05
SELECT Title,ISBN, YearPublished 
FROM Books
ORDER BY YearPublished DESC, Title

--06
SELECT b.Id,b.Title, b.ISBN, g.[Name]
FROM Books AS b
JOIN Genres AS g ON g.Id = b.GenreId
WHERE g.[Name] = 'Biography' OR g.[Name] = 'Historical Fiction' 
ORDER BY g.Name, b.Title

--07
SELECT l.[Name], c.Email
FROM Libraries AS l
JOIN LibrariesBooks AS lb ON l.Id = lb.LibraryId
JOIN Books AS b ON b.Id = lb.BookId
JOIN Genres AS g ON g.Id = b.GenreId
JOIN Contacts AS c ON c.Id = l.ContactId
GROUP BY l.[Name], c.Email
HAVING SUM(CASE WHEN b.GenreId = 1 THEN 1 ELSE 0 END) = 0
ORDER BY l.[Name]

--08
SELECT TOP (3) b.Title, b.YearPublished, g.[Name]
FROM Libraries AS l
JOIN LibrariesBooks AS lb ON l.Id = lb.LibraryId
JOIN Books AS b ON b.Id = lb.BookId
JOIN Genres AS g ON g.Id = b.GenreId
WHERE (b.YearPublished > 2000 and B.Title LIKE '%a%' )
OR 
(b.YearPublished < 1950 AND g.[Name] LIKE 'Fantasy')
ORDER BY b.Title, B.YearPublished DESC

--09
SELECT a.[Name], c.Email, c.PostAddress
FROM Authors AS a
JOIN  Contacts AS c ON a.ContactId = c.Id
WHERE c.PostAddress LIKE '%UK%'
ORDER BY a.[Name]

--10
SELECT a.[Name], b.Title, l.[Name], c.PostAddress
FROM Books AS b
JOIN Genres AS g ON g.Id = b.GenreId
JOIN LibrariesBooks AS lb ON lb.BookId = b.Id
JOIN Libraries AS l ON l.Id = lb.LibraryId
JOIN Contacts AS c ON c.Id = l.ContactId
JOIN Authors AS a ON b.AuthorId = a.Id
WHERE g.[Name] LIKE 'Fiction' AND
c.PostAddress LIKE '%Denver%'
ORDER BY b.Title

--11
CREATE  OR ALTER FUNCTION udf_AuthorsWithBooks(@AuthorName NVARCHAR(20))
RETURNS INT AS
BEGIN
DECLARE @TotalBooksNumber INT = 
(
SELECT COUNT(*)
FROM Books AS b
JOIN Authors AS a ON b.AuthorId = a.Id
WHERE a.[Name] = @AuthorName
)
RETURN @TotalBooksNumber
END

SELECT dbo.udf_AuthorsWithBooks('J.K. Rowling')

--12
CREATE OR ALTER PROC usp_SearchByGenre(@genreName NVARCHAR(30))
AS
BEGIN
SELECT b.Title, b.YearPublished, b.ISBN, a.[Name], g.[Name]
FROM Books AS b
JOIN Genres AS g ON b.GenreId = g.Id
JOIN Authors AS a ON b.AuthorId = a.Id
WHERE g.[Name] = @genreName
ORDER BY b.Title
END

EXEC usp_SearchByGenre 'Fantasy'