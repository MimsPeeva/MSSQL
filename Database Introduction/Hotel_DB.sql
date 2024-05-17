CREATE DATABASE Hotel

CREATE TABLE Employees
(Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL, 
Title NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)
INSERT INTO Employees(FirstName,LastName,Title)
VALUES('Ema','Tinova', 'First'),
('Zed','Bonev', 'Second'),
('Ana','Asenova', 'Third')

CREATE TABLE Customers 
(AccountNumber INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL, 
PhoneNumber NVARCHAR(50) NOT NULL,
EmergencyName NVARCHAR(50),
EmergencyNumber INT,
Notes NVARCHAR(MAX)
)
INSERT INTO Customers(FirstName,LastName,PhoneNumber)
VALUES('Sisi','Ruseva', '098765432'),
('Bobi','Rosenov', '0897321355'),
('Roshko','Kenov', '0879996543')

CREATE TABLE RoomStatus
(RoomStatus NVARCHAR(100) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)
INSERT INTO RoomStatus(RoomStatus)
VALUES('Free'),
('Busy'),
('Waiting')

CREATE TABLE RoomTypes
(
RoomType NVARCHAR(100) PRIMARY KEY NOT NULL,
Notes NVARCHAR(MAX)
)
INSERT INTO RoomTypes(RoomType)
VALUES('Single'),
('Two person'),
('Family')

CREATE TABLE BedTypes
(BedType NVARCHAR(100) PRIMARY KEY NOT NULL,
Notes  NVARCHAR(MAX)
)
INSERT INTO BedTypes(BedType)
VALUES('Small'),
('Large'),
('Children')

CREATE TABLE Rooms 
(RoomNumber INT PRIMARY KEY IDENTITY,
RoomType NVARCHAR(100) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
BedType  NVARCHAR(100) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
Rate INT, 
RoomStatus NVARCHAR(100) FOREIGN KEY REFERENCES RoomStatus(RoomStatus) NOT NULL,
Notes NVARCHAR(MAX)
)
INSERT INTO Rooms(RoomType,BedType,RoomStatus)
VALUES('Family', 'Large', 'Waiting'),
('Single', 'Small', 'Busy'),
('Two person', 'Children', 'Free')

CREATE TABLE Payments 
(Id INT PRIMARY KEY IDENTITY,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
PaymentDate DATE, 
AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
FirstDateOccupied DATE,
LastDateOccupied DATE, 
TotalDays INT,
AmountCharged INT,
TaxRate INT,
TaxAmount INT,
PaymentTotal INT,
Notes NVARCHAR(MAX)
)
INSERT INTO Payments(EmployeeId,AccountNumber)
VALUES(1,2),
(2,3),
(3,1)

CREATE TABLE Occupancies
(
  Id INT PRIMARY KEY IDENTITY,
  EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
  DateOccupied DATE NOT NULL,
  AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
  RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
  RateApplied DECIMAL(5, 2),
  PhoneCharge DECIMAL(5, 2),
  Notes NVARCHAR(MAX)
)
INSERT INTO Occupancies(EmployeeId,DateOccupied,AccountNumber,RoomNumber)
VALUES(1,'2022-07-12', 1, 1),
(3,'2022-01-10', 3, 3),
(2,'2022-10-15', 2, 2)

UPDATE Payments SET TaxRate-=0.03
SELECT TaxRate FROM Payments

DELETE Occupancies