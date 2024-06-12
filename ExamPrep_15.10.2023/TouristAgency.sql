CREATE DATABASE TouristAgency


--01
CREATE TABLE Countries
(
Id INT PRIMARY KEY IDENTITY,
[NAME] NVARCHAR(50) NOT NULL
)

CREATE TABLE Destinations
(
Id INT PRIMARY KEY IDENTITY,
[NAME] VARCHAR(50) NOT NULL,
CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries(Id) 
)

CREATE TABLE Rooms
(
Id INT PRIMARY KEY IDENTITY,
[Type] VARCHAR(40) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
BedCount INT NOT NULL
CHECK(BedCount > 0 AND BedCount <=10)
)

CREATE TABLE Hotels
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
DestinationId INT NOT NULL FOREIGN KEY REFERENCES Destinations(Id)
)

CREATE TABLE Tourists
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(80) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Email VARCHAR(80) NOT NULL,
CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

--ALTER TABLE Tourists
--ALTER COLUMN Email VARCHAR(80)

CREATE TABLE Bookings
(
Id INT PRIMARY KEY IDENTITY,
ArrivalDate DATETIME2 NOT NULL,
DepartureDate DATETIME2 NOT NULL,
AdultsCount INT NOT NULL
CHECK(AdultsCount >=1 AND AdultsCount<=10),
ChildrenCount INT NOT NULL
CHECK(ChildrenCount >=0 AND ChildrenCount<=9),
TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists(Id),
HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id),
RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms(Id)
)

CREATE TABLE HotelsRooms
(
HotelId INT NOT NULL ,
RoomId INT NOT NULL,
CONSTRAINT PK_HotelsRooms PRIMARY KEY(HotelId,RoomId),
CONSTRAINT FK_HotelsRooms_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
CONSTRAINT FK_HotelsRooms_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
)

--second variant
--CREATE TABLE HotelsRooms
--(
--HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id) ,
--RoomId INT NOT NULL FOREIGN KEY (RoomId) REFERENCES Rooms(Id),
--CONSTRAINT PK_HotelsRooms PRIMARY KEY(HotelId,RoomId),
 --)

--02
INSERT INTO Tourists([Name], PhoneNumber,Email,CountryId)
VALUES ('John Rivers','653-551-1555', 'john.rivers@example.com', 6),
('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
('Eden Smith','551-874-2234','eden.smith@example.com', 6)

INSERT INTO Bookings(ArrivalDate, DepartureDate,AdultsCount, ChildrenCount, TouristId, HotelId,RoomId)
	VALUES
('2024-03-01', '2024-03-11', 1, 0, 21, 3, 5),
('2023-12-28', '2024-01-06', 2, 1, 22, 13, 3),
('2023-11-15', '2023-11-20', 1, 2, 23, 19, 7),
('2023-12-05', '2023-12-09', 4, 0, 24, 6, 4),
('2024-05-01', '2024-05-07', 6, 0, 25, 14, 6)

--03
UPDATE Bookings
SET DepartureDate = DATEADD(DAY,1,DepartureDate)
WHERE  MONTH([DepartureDate]) = 12

UPDATE Tourists
SET Email = NULL
WHERE [NAME] LIKE '%MA%'
--second option
--UPDATE Bookings
--SET DepartureDate = DATEADD(DAY,1,DepartureDate)
--WHERE DepartureDate >='2023-12-01' AND DepartureDate <= '2023-12-31'

--04

DECLARE @TouristsToDelete TABLE (Id INT)

INSERT INTO @TouristsToDelete(Id)
SELECT Id
FROM Tourists
WHERE [Name] LIKE '%Smith%'

DELETE FROM Bookings
WHERE TouristId IN (SELECT Id FROM @TouristsToDelete)

DELETE FROM Tourists	
WHERE [Name] LIKE '%Smith%'

--05
SELECT FORMAT(b.ArrivalDate,'yyyy-MM-dd') AS [ArrivalDate], b.AdultsCount, b.ChildrenCount
FROM Bookings AS b
JOIN Rooms AS r ON b.RoomId = r.Id
ORDER BY r.Price DESC,
b.ArrivalDate 

--06
SELECT h.Id, h.[Name]
FROM Hotels AS h
JOIN HotelsRooms AS hr ON hr.HotelId = h.Id
JOIN Rooms AS r ON r.Id = hr.RoomId
JOIN Bookings AS b ON b.HotelId = h.Id
 WHERE 
	   r.[Type] = 'VIP Apartment'
   GROUP BY 
	   h.[Id], h.[Name]
   ORDER BY
		COUNT(b.[Id]) DESC

--07
SELECT t.Id, t.[Name], t.PhoneNumber
FROM Tourists AS t
LEFT JOIN Bookings AS b
ON b.TouristId = t.Id
WHERE b.Id IS NULL
ORDER BY t.[Name]
 
 --second option
-- SELECT Id, [Name], PhoneNumber
--FROM Tourists AS t
--WHERE Id NOT IN(SELECT TouristId FROM Bookings)
--ORDER BY t.[Name]


--08
SELECT TOP (10) h.[Name], d.[Name], c.[Name]
FROM Bookings AS b 
 JOIN Hotels AS h ON h.Id = b.HotelId
 JOIN Destinations AS d ON d.Id = h.DestinationId
 JOIN Countries AS c ON c.Id = d.CountryId
 WHERE b.ArrivalDate < '2023-12-31' AND h.Id % 2 = 1
 ORDER BY c.[Name], b.ArrivalDate
 
--09
SELECT h.[Name], r.Price
FROM Tourists AS t
JOIN Bookings AS b ON t.Id = b.TouristId
JOIN Hotels AS h ON b.HotelId = h.Id
JOIN Rooms AS r ON b.RoomId = r.Id
WHERE t.[Name] NOT LIKE '%EZ'
ORDER BY r.Price DESC

--10
SELECT h.[Name] AS [HotelName], (SUM(r.Price*DATEDIFF(DAY,b.ArrivalDate,b.DepartureDate)))AS [TotalRevenue] 
FROM Bookings AS b 
JOIN Hotels AS h ON b.HotelId = h.Id
JOIN Rooms AS r ON b.RoomId = r.Id
GROUP BY h.[Name]
ORDER BY TotalRevenue DESC

--11
CREATE OR ALTER FUNCTION udf_RoomsWithTourists (@RoomType VARCHAR(50))
RETURNS INT
AS 
	BEGIN
	DECLARE @TotalTouristsCount INT
	SELECT @TotalTouristsCount = SUM(b.ChildrenCount + b.AdultsCount)
	FROM Bookings AS b 
JOIN Rooms AS r ON b.RoomId = r.Id
	WHERE r.[Type] = @RoomType

	IF @TotalTouristsCount IS NULL
	SET @TotalTouristsCount = 0

	RETURN @TotalTouristsCount

	END 
--second option
--CREATE OR ALTER FUNCTION udf_RoomsWithTourists (@RoomType VARCHAR(50))
--RETURNS INT
--AS 
--	BEGIN
--	RETURN(
--	SELECT sum(b.ChildrenCount + b.AdultsCount)
--	FROM Bookings AS b 
--JOIN Rooms AS r ON b.RoomId = r.Id
--	WHERE r.[Type] = @RoomType
--)

--	END 
	--SELECT dbo.udf_RoomsWithTourists('Double Room')

--12
CREATE OR ALTER PROC usp_SearchByCountry(@country VARCHAR(50))
  AS
SELECT t.[Name], t.PhoneNumber,t.Email,COUNT(b.Id)  AS [CountOfBookings]
FROM Tourists AS t
JOIN Bookings AS b ON t.Id = b.TouristId
JOIN Countries AS c ON c.Id = t.CountryId
WHERE c.NAME = @country
 GROUP BY 
	   t.[Name], t.[PhoneNumber], t.[Email]
ORDER BY t.Name, CountOfBookings DESC

EXEC usp_SearchByCountry 'Greece'