CREATE DATABASE CarRental

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY,
CategoryName VARCHAR(200) NOT NULL,
DailyRate INT,
WeeklyRate INT,
MonthlyRate INT,
WeekendRate INT
)
INSERT INTO Categories(CategoryName)
VALUES('Sport'),
('Executive '),
('City car')

CREATE TABLE Cars
(
Id INT PRIMARY KEY IDENTITY,
PlateNumber VARCHAR(100) NOT NULL,
Manufacturer VARCHAR(100), 
Model VARCHAR(100),
CarYear INT,
CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL, 
Doors INT,
Picture IMAGE, 
Condition NVARCHAR(200), 
Available BIT
)
INSERT INTO Cars(PlateNumber,CategoryId)
VALUES('KB4321AA', 2),
('IU7554PO',3),
('MM9080LL',1)

CREATE TABLE Employees
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(100) NOT NULL,
LastName  NVARCHAR(100) NOT NULL, 
Title  NVARCHAR(100) NOT NULL, 
Notes  NVARCHAR(MAX)
)
INSERT INTO Employees(FirstName,LastName,Title)
VALUES('Ed','Sama','One'),
('Ema','Totir','Two'),
('Rio','Ace','Three')


CREATE TABLE Customers
(Id INT PRIMARY KEY IDENTITY,
DriverLicenceNumber INT NOT NULL,
FullName NVARCHAR(100) NOT NULL, 
[Address] NVARCHAR(100),
City NVARCHAR(100),
ZIPCode INT,
Notes NVARCHAR(MAX)
)

INSERT INTO Customers(DriverLicenceNumber,FullName)
VALUES(432,'Ed'),
(49684,'Ani'),
(897,'Bobo')
CREATE TABLE RentalOrders
(
Id INT PRIMARY KEY IDENTITY,
EmployeeId INT FOREIGN KEY REFERENCES EmployeeS(Id) NOT NULL,
CustomerId  INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL, 
CarId  INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
TankLevel INT, 
KilometrageStart INT,
KilometrageEnd INT,
TotalKilometrage INT,
StartDate INT, 
EndDate DATE, 
TotalDays DATE, 
RateApplied INT,
TaxRate INT,
OrderStatus NVARCHAR(100),
Notes NVARCHAR(MAX)
)
INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId)
VALUES(1,3,2),
(1,1,2),
(3,3,3)