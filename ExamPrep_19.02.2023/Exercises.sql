CREATE DATABASE Boardgames
GO
USE Boardgames
GO

--01
CREATE TABLE Categories
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 [StreetName] NVARCHAR(100) NOT NULL,
 [StreetNumber] INT NOT NULL,
 Town VARCHAR(30) NOT NULL,
 [Country] VARCHAR(50) NOT NULL,
 ZIP INT NOT NULL
)

CREATE TABLE Publishers
(
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
 [Name] VARCHAR(30) NOT NULL,
 [AddressId] INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id),
 [Website] NVARCHAR(40),
 [Phone] NVARCHAR(20)
)

CREATE TABLE PlayersRanges
(
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
[PlayersMin] INT NOT NULL,
[PlayersMax] INT NOT NULL
)

CREATE TABLE Boardgames
(
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
 [Name] NVARCHAR(30) NOT NULL,
 [YearPublished] INT NOT NULL,
 [Rating] DECIMAL(18,2) NOT NULL,
 [CategoryId] INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
 [PublisherId] INT NOT NULL FOREIGN KEY REFERENCES Publishers(Id),
 [PlayersRangeId] INT NOT NULL FOREIGN KEY REFERENCES PlayersRanges(Id)
)

CREATE TABLE Creators
(
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
 [FirstName] NVARCHAR(30) NOT NULL,
 [LastName]  NVARCHAR(30) NOT NULL,
 [Email] NVARCHAR(30) NOT NULL
)

CREATE TABLE CreatorsBoardgames
(
[CreatorId] INT NOT NULL FOREIGN KEY REFERENCES Creators(Id),
[BoardgameId] INT NOT NULL FOREIGN KEY REFERENCES Boardgames(Id),
CONSTRAINT PK_CreatorsBoardgames PRIMARY KEY (CreatorId,BoardgameID)
)

--02
INSERT INTO Boardgames ([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId) VALUES
('Deep Blue', 2019, 5.67, 1, 15, 7),
('Paris', 2016, 9.78, 7, 1, 5),
('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers ([Name], AddressId, Website, Phone) VALUES
('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

--03
UPDATE PlayersRanges
SET PlayersMax += 1
WHERE PlayersMin >=2 AND PlayersMax <=2

UPDATE Boardgames
SET Name = Name + 'V2'
WHERE YearPublished >= 2020

--04
CREATE TABLE [TempTableAddressesTempTable]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [AddressId] INT
)

INSERT INTO [TempTableAddressesTempTable]([AddressId])
SELECT [Id]
FROM [Addresses]
WHERE [Town] LIKE 'L%'

DECLARE @addressToRemove INT = 
(
	SELECT
    [AddressId]
    FROM [TempTableAddressesTempTable]
    WHERE [Id] = 1
)

DELETE FROM [CreatorsBoardgames]
WHERE [BoardgameId] IN
(
	SELECT b.[Id]
    FROM [Boardgames] AS b
    LEFT JOIN [Publishers] AS p ON p.[Id] = b.[PublisherId]
    WHERE p.[AddressId] IN (@addressToRemove)
)

DELETE FROM [Boardgames]
WHERE [PublisherId] IN
(
	SELECT [Id]
	FROM [Publishers]
	WHERE [AddressId] IN (@addressToRemove)
)

DELETE FROM [Publishers]
WHERE [AddressId] IN (@addressToRemove)

DELETE FROM [Addresses]
WHERE [Id] IN (@addressToRemove)

--05
SELECT [Name],Rating 
FROM Boardgames
ORDER BY YearPublished, [Name] DESC

--06
SELECT b.Id, b.[Name], YearPublished, c.[Name]
FROM Boardgames AS b
JOIN Categories AS c ON c.Id = b.CategoryId
WHERE c.[Name] = 'Strategy Games' OR c.[Name] = 'Wargames'
ORDER BY YearPublished DESC

--07
SELECT c.Id, CONCAT_WS(' ', c.FirstName,c.LastName) AS [CreatorName], c.Email 
FROM Creators as c
LEFT JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
WHERE cb.BoardgameId IS NULL
ORDER BY CreatorName

--08
SELECT TOP (5) b.[Name], b.Rating, c.[Name] AS [CategoryName]
FROM Boardgames AS b
JOIN Categories AS c ON c.Id = b.CategoryId
WHERE (Rating > 7.00 AND b.[Name] LIKE '%a%') OR 
(Rating>7.50 AND b.PlayersRangeId>=2 AND b.PlayersRangeId <=5)
ORDER BY b.[Name], Rating DESC

--09
SELECT  CONCAT_WS(' ', c.FirstName,c.LastName) AS [FullName], c.Email, MAX(b.Rating) AS [Rating]
FROM Creators AS c
JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
JOIN Boardgames AS b ON cb.BoardgameId = b.Id
WHERE Email LIKE '%.com'
GROUP BY c.FirstName,c.LastName,c.Email
ORDER BY FullName

--10
SELECT c.LastName, CEILING(AVG(b.Rating)) AS [AverageRating], p.[Name] AS [PublisherName]
FROM Creators as c
JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
JOIN Boardgames AS b ON cb.BoardgameId = b.Id
JOIN Publishers AS p ON b.PublisherId = p.Id
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC

--11
CREATE OR ALTER FUNCTION udf_CreatorWithBoardgames(@CreatorsFirstName NVARCHAR(20))
RETURNS INT
AS
BEGIN

DECLARE @CreatorId INT =
	(
	SELECT [Id]
	FROM [Creators]
	WHERE [FirstName] = @CreatorsFirstName
	)

RETURN 
(
SELECT COUNT(*)
FROM CreatorsBoardgames 
WHERE CreatorId = @creatorId
)
END

SELECT dbo.udf_CreatorWithBoardgames('Bruno')

--12
CREATE OR ALTER PROC usp_SearchByCategory(@CategoryName VARCHAR(50))
AS
	BEGIN
SELECT b.[Name], b.YearPublished, b.Rating, c.[Name], p.[Name], 
 CONCAT(pr.[PlayersMin], ' ', 'people') AS [MinPlayers],
  CONCAT(pr.[PlayersMax], ' ', 'people') AS [MaxPlayers]
  FROM Boardgames AS b
JOIN Categories AS c ON c.Id = b.CategoryId
JOIN Publishers AS p ON b.PublisherId = p.Id
JOIN PlayersRanges AS pr ON b.PlayersRangeId = pr.Id
WHERE c.[Name]  = (@CategoryName)
ORDER BY p.[Name], b.YearPublished DESC
	END

EXEC usp_SearchByCategory 'Wargames'