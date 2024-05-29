CREATE DATABASE Table_Relations_Ex
USE Table_Relations_Ex

--01
CREATE TABLE Passports
(
PassportID INT PRIMARY KEY IDENTITY(101,1),
PassportNumber NVARCHAR(50) NOT NULL
)

CREATE TABLE Persons
(
PersonID  INT PRIMARY KEY IDENTITY,
FirstName  VARCHAR(50) NOT NULL,
Salary DECIMAL (10,2),
PassportID INT UNIQUE FOREIGN KEY REFERENCES Passports(PassportID)
)
INSERT INTO Passports
VALUES('N34FG21B')
,('K65LO4R7')
,('ZE657QP2')

INSERT INTO Persons
VALUES
('Roberto',43300,102)
,('Tom',56100,103)
,('Yana',60200,101)

SELECT * FROM Persons
SELECT * FROM Passports


--02
CREATE TABLE Manufacturers
(
ManufacturerID INT PRIMARY KEY IDENTITY,
Name VARCHAR(20) NOT NULL,
EstablishedOn DATE
)
--DROP TABLE Manufacturers
INSERT INTO Manufacturers
VALUES('BMW','07/03/1916')
,('Tesla','01/01/2003')
,('Lada','01/05/1966')

SELECT * FROM Manufacturers

CREATE TABLE Models
(
ModelID INT PRIMARY KEY IDENTITY(101,1),
Name VARCHAR(20) NOT NULL,
ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)
SELECT * FROM Models
INSERT INTO Models
VALUES('X1',1)
,('i6',1)
,('Model S',2)
,('Model X',2)
,('Model 3',2)
,('Nova',3)

--03
CREATE TABLE Students
(
StudentID INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Exams
(
ExamID INT PRIMARY KEY IDENTITY(101,1),
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams
(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
ExamID  INT FOREIGN KEY REFERENCES Exams(ExamID)
CONSTRAINT PK_Stidents_Exams PRIMARY KEY (StudentID,ExamID)
)

INSERT INTO Students
VALUES('Mila')
,('Toni')
,('Ron')

INSERT INTO Exams
VALUES('SpringMVC')
,('Neo4j')
,('Oracle 11g')

INSERT INTO StudentsExams
VALUES(1,101)
,(1,102)
,(2,101)
,(3,103)
,(2,102)
,(2,103)

--04
CREATE TABLE Teachers
(
TeacherID INT PRIMARY KEY IDENTITY(101,1),
[Name] VARCHAR(50) NOT NULL,
ManagerID INT REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers
VALUES('John',NULL)
,('Maya',NULL)
,('Silvia',NULL)
,('Ted',NULL)
,('Mark',NULL)
,('Greta',NULL)

UPDATE Teachers
SET ManagerID = 106
WHERE TeacherID IN (102,103)

UPDATE Teachers
SET ManagerID = 101
WHERE TeacherID IN (105,106)

UPDATE Teachers
SET ManagerID = 105
WHERE TeacherID = 104

SELECT * FROM Teachers
