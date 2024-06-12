CREATE DATABASE RailwaysDb
USE RailwaysDb

--01
CREATE TABLE Passengers
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
[Name] NVARCHAR(80) NOT NULL
)

CREATE TABLE Towns
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE RailwayStations
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
TownId INT NOT NULL FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Trains
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
HourOfDeparture VARCHAR(5) NOT NULL,
HourOfArrival VARCHAR(5) NOT NULL,
DepartureTownId INT NOT NULL FOREIGN KEY REFERENCES Towns(Id),
ArrivalTownId INT NOT NULL FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE TrainsRailwayStations
(
TrainId INT NOT NULL FOREIGN KEY REFERENCES Trains(Id),
RailwayStationId INT NOT NULL FOREIGN KEY REFERENCES RailwayStations(Id),
PRIMARY KEY([TrainId],[RailwayStationId])
)

CREATE TABLE MaintenanceRecords
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
DateOfMaintenance DATE NOT NULL,
Details VARCHAR(2000) NOT NULL,
TrainId INT NOT NULL FOREIGN KEY REFERENCES Trains(Id)
)

CREATE TABLE Tickets
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
Price DECIMAL(18,2) NOT NULL,
DateOfDeparture DATE NOT NULL,
DateOfArrival DATE NOT NULL,
TrainId INT NOT NULL FOREIGN KEY REFERENCES Trains(Id),
PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id)
)

--02
INSERT INTO Trains(HourOfDeparture,HourOfArrival, DepartureTownId,ArrivalTownId)
VALUES
('07:00', '19:00', 1, 3),
('08:30', '20:30', 5, 6),
('09:00', '21:00', 4, 8),
('06:45', '03:55', 27, 7),
('10:15', '12:15', 15, 5)

INSERT INTO TrainsRailwayStations(TrainId,RailwayStationId)
VALUES
(36, 1),
(36, 4),
(36, 31),
(36, 57), 
(36, 7), 
(37, 13),
(37, 54),
(37, 60),
(37, 16),
(38, 10),
(38, 50),
(38, 52),
(38, 22),
(39, 68),
(39, 3),
(39, 31),
(39, 19),
(40, 41),
(40, 7),
(40, 52),
(40, 13)

INSERT INTO [Tickets]([Price], [DateOfDeparture], [DateOfArrival], [TrainId], [PassengerId])
	VALUES
	(90.00, '2023-12-01', '2023-12-01', 36, 1),
	(115.00, '2023-08-02', '2023-08-02', 37, 2),
	(160.00, '2023-08-03', '2023-08-03', 38, 3),
	(255.00, '2023-09-01', '2023-09-02', 39, 21),
	(95.00, '2023-09-02', '2023-09-03', 40, 22)

--03
UPDATE Tickets
SET DateOfArrival = DATEADD(DAY,7,DateOfArrival)
WHERE DateOfArrival > '2023-10-31'

UPDATE Tickets
SET DateOfDeparture = DATEADD(DAY,7,DateOfDeparture)
WHERE DateOfDeparture > '2023-10-31'

--04
DECLARE @BerlinId INT
DECLARE @TrainId INT


SELECT @BerlinId = Id
FROM Towns 
WHERE Name = 'Berlin'

SELECT @TrainId = Id
FROM Trains
WHERE DepartureTownId = @BerlinId

DELETE FROM TrainsRailwayStations
WHERE TrainId = @TrainId

DELETE FROM MaintenanceRecords
WHERE TrainId = @TrainId

DELETE FROM Tickets
WHERE TrainId = @TrainId

DELETE FROM Trains
WHERE Id = @TrainId

--05
SELECT DateOfDeparture,Price
FROM Tickets
ORDER BY Price, DateOfDeparture DESC

--06
SELECT p.Name AS [PassengerName], t.Price AS [TicketsPrice], t.DateOfDeparture, t.TrainId AS [TrainID]
FROM Tickets AS t 
JOIN Passengers AS p ON p.Id = t.PassengerId
ORDER BY Price DESC, p.[Name]

--07
SELECT t.[Name], rws.[Name]
FROM RailwayStations AS rws
JOIN Towns AS t  ON t.Id = rws.TownId
WHERE rws.Id NOT IN (SELECT RailwayStationId FROM TrainsRailwayStations)
ORDER BY t.[Name], rws.[Name]

--08
SELECT TOP(3) t.Id,t.HourOfDeparture, tick.Price,tw.[Name] AS [Destination]
FROM Trains AS t
JOIN Tickets AS tick ON t.Id = tick.TrainId
JOIN Towns AS tw ON tw.Id = t.ArrivalTownId
WHERE t.HourOfDeparture >= '08:00' AND t.HourOfDeparture<='08:59'
--SECOND OPTION  tr.[HourOfDeparture] LIKE '08:%' AND tc.[Price] > 50
AND tick.Price > 50
ORDER BY tick.Price

--09
SELECT t.[Name] AS [TownName], COUNT(*) AS [PassengersCount]
FROM Passengers AS p
JOIN Tickets AS tick ON p.Id = tick.PassengerId
JOIN Trains AS tr ON tick.TrainId = tr.Id
JOIN Towns AS t ON t.Id = tr.ArrivalTownId
WHERE tick.Price > 76.99
GROUP BY t.[Name]
ORDER BY t.[Name]

--10
SELECT tr.Id AS [TrainId], t.[Name] AS [DepartureTown], mr.Details
FROM Trains AS tr
JOIN Towns AS t ON tr.DepartureTownId = t.Id
JOIN MaintenanceRecords AS mr ON mr.TrainId = tr.Id
WHERE mr.Details LIKE '%inspection%'
ORDER BY tr.Id

--11
CREATE OR ALTER FUNCTION udf_TownsWithTrains(@TownName  VARCHAR(50))
RETURNS INT
AS 
BEGIN

   DECLARE @result INT;

SELECT @result = COUNT(TR.Id)
FROM Trains AS tr
JOIN Towns AS t ON tr.ArrivalTownId = t.Id
JOIN Towns AS tw ON tr.DepartureTownId = tw.Id
WHERE t.[Name] = @TownName OR tw.[Name] = @TownName

RETURN @result
END

SELECT dbo.udf_TownsWithTrains('Paris')
--12
CREATE OR ALTER PROC usp_SearchByTown(@TownName VARCHAR(50))
AS
	BEGIN
	SELECT p.[Name] AS [PassengerName], t.DateOfDeparture, tr.HourOfDeparture
	FROM Passengers AS p
	JOIN Tickets AS t ON p.Id = t.PassengerId
	JOIN Trains AS tr ON t.TrainId = tr.Id
	JOIN Towns AS tw ON tr.ArrivalTownId = tw.Id
	WHERE tw.[Name] = @TownName 
	ORDER BY t.DateOfDeparture DESC, p.[Name]
	END

	EXEC usp_SearchByTown 'Berlin'
