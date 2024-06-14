CREATE DATABASE Accounting 
GO
USE Accounting 
GO

--01
CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	[StreetName] NVARCHAR(20) NOT NULL,
	[StreetNumber] INT, 
	[PostCode] INT NOT NULL,
	[City] VARCHAR(25) NOT NULL,
	[CountryId] INT NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Vendors
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	[NumberVAT] NVARCHAR(15) NOT NULL,
	[AddressId] INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	[NumberVAT] NVARCHAR(15) NOT NULL,
	[AddressId] INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Products
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(35) NOT NULL,
	[Price] DECIMAL(18,2) NOT NULL,
	[CategoryId] INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
	[VendorId] INT NOT NULL FOREIGN KEY REFERENCES Vendors(Id)
)

CREATE TABLE Invoices
(
	Id INT PRIMARY KEY IDENTITY,
	[Number] INT NOT NULL,
	[IssueDate] DATETIME2 NOT NULL,
	[DueDate] DATETIME2 NOT NULL,
	[Amount] DECIMAL(18,2) NOT NULL,
	[Currency] VARCHAR(5) NOT NULL,
	[ClientId] INT NOT NULL FOREIGN KEY REFERENCES Clients(Id)
)

CREATE TABLE ProductsClients
(
	[ProductId] INT NOT NULL FOREIGN KEY REFERENCES Products(Id),
	[ClientId] INT NOT NULL FOREIGN KEY REFERENCES Clients(Id)
	CONSTRAINT PK_ProductsClients PRIMARY KEY (ProductId, ClientId)
)

--02
INSERT INTO Products ([Name], Price, CategoryId, VendorId) VALUES 
('SCANIA Oil Filter XD01', 78.69, 1, 1),
('MAN Air Filter XD01', 97.38, 1, 5),
('DAF Light Bulb 05FG87', 55.00, 2, 13),
('ADR Shoes 47-47.5', 49.85, 3, 5),
('Anti-slip pads S', 5.87, 5, 7)

INSERT INTO Invoices (Number, Amount, IssueDate, DueDate, Currency, ClientId) VALUES
(1219992181, 180.96, '2023-03-01', '2023-04-30', 'BGN', 3),
(1729252340, 158.18, '2022-11-06', '2023-01-04', 'EUR', 13),
(1950101013, 615.15, '2023-02-17', '2023-04-18', 'USD', 19)

--03

UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE Year(IssueDate) = 2022 AND Month(IssueDate) = 11

UPDATE Clients
SET AddressId = 3
WHERE [Name] LIKE '%CO%'

--04
CREATE TABLE Temp(Id INT)
INSERT INTO Temp(Id)
(
SELECT Id FROM Clients
WHERE NumberVAT LIKE 'IT%'
)
 DELETE FROM ProductsClients 
WHERE ClientId IN (SELECT Id FROM Temp)


DELETE FROM Invoices 
WHERE ClientId IN (SELECT Id FROM Temp)

DELETE FROM Clients
WHERE NumberVAT LIKE 'IT%'
--SECOND OPTION
--DECLARE @clientId INT =
--(
--	SELECT [Id] FROM [Clients]
--	WHERE [NumberVAT] LIKE 'IT%'
--)

--DELETE FROM [ProductsClients]
--WHERE [ClientId] = @clientId

--DELETE FROM [Invoices]
--WHERE [ClientId] = @clientId

--DELETE FROM [Clients]
--WHERE [NumberVAT] LIKE 'IT%'



--05
SELECT Number, Currency
FROM Invoices
order by Amount DESC, DueDate

--06
SELECT p.Id, p.[Name], Price, c.[Name]
FROM Products AS p
JOIN Categories AS c ON c.Id = p.CategoryId
WHERE c.[Name] = 'ADR' OR
c.[Name] = 'Others'
ORDER BY Price DESC

--07
SELECT c.Id,c.[Name],
CONCAT(a.StreetName, ' ', a.StreetNumber, ', ', a.City, ', ', a.PostCode, ', ', ct.[Name]) AS [Address]
FROM Clients AS c
LEFT JOIN ProductsClients AS pc ON c.Id = pc.ClientId
LEFT JOIN Products as p ON p.Id = pc.ProductId
JOIN Addresses AS a ON a.Id = c.AddressId
join Countries AS ct ON ct.Id = a.CountryId
WHERE pc.ProductId IS NULL
ORDER BY c.Name

--08
SELECT TOP (7) i.Number, i.Amount,c.[Name]
FROM Invoices AS i
JOIN Clients AS c ON i.ClientId = c.Id
WHERE (i.IssueDate <='2023-01-01'
AND i.Currency = 'EUR') OR
 (i.Amount > 500 AND c.NumberVAT LIKE'DE%')
 ORDER BY i.Number, i.Amount DESC

 --09
 SELECT c.[Name],MAX(p.Price), c.NumberVAT
 FROM Clients AS c
 JOIN ProductsClients AS pc ON c.Id = pc.ClientId
 JOIN Products AS p ON p.Id = pc.ProductId
 WHERE c.[Name] NOT LIKE '%KG'
 GROUP BY c.[Name], c.NumberVAT
 ORDER BY MAX(p.Price) DESC

 --10
  SELECT c.[Name],FLOOR(AVG(p.Price))
 FROM Clients AS c
LEFT JOIN ProductsClients AS pc ON c.Id = pc.ClientId
 JOIN Products AS p ON p.Id = pc.ProductId
 JOIN Vendors AS v ON v.Id = p.VendorId
 WHERE v.NumberVAT LIKE '%FR%'
 GROUP BY c.[Name]
 ORDER BY AVG(p.Price),c.[Name] DESC

 --11
 CREATE OR ALTER FUNCTION udf_ProductWithClients(@ProductName NVARCHAR(50))
	 RETURNS INT AS
		 BEGIN
	    DECLARE  @TotalCount INT = 
		 (
		 SELECT COUNT(*)
		 FROM Clients AS c
		 LEFT JOIN ProductsClients AS pc ON c.Id = pc.ClientId
		 JOIN Products AS p ON p.Id = pc.ProductId
		 WHERE p.[Name] = @ProductName
		 )
		 RETURN @TotalCount
		 END

SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')

--12
CREATE OR ALTER PROC usp_SearchByCountry(@country NVARCHAR(20))
	AS
		BEGIN
		SELECT v.[Name], v.NumberVAT,CONCAT_WS(' ', a.StreetName,a.StreetNumber),CONCAT_WS(' ', a.City,a.PostCode)
		FROM Vendors AS v
		JOIN Addresses AS a ON a.Id = v.AddressId
		JOIN Countries AS c ON c.Id = a.CountryId
		WHERE c.Name = @country
		ORDER BY v.Name, a.City
		END

		EXEC usp_SearchByCountry 'France'