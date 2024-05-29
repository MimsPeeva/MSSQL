CREATE DATABASE University
USE University

CREATE TABLE Subjects
(
SubjectID INT PRIMARY KEY IDENTITY,
SubjectName VARCHAR(50)
)

CREATE TABLE Majors
(
MajorID INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50)
)

CREATE TABLE Students
(
StudentID INT PRIMARY KEY IDENTITY,
StudentNumber INT,
StudentName VARCHAR(50),
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Agenda
(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
CONSTRAINT PK_STUDENT_SUBJECT PRIMARY KEY(StudentID,SubjectID)
)

CREATE TABLE Payments
(
PaymentID INT PRIMARY KEY IDENTITY,
PaymentDate DATE,
PaymentAmount DECIMAL(10,2),
StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)


--09
USE Geography
SELECT MountainRange, PeakName, Elevation
FROM Peaks
JOIN Mountains ON Peaks.MountainId = Mountains.Id
WHERE MountainId = 17
ORDER BY Elevation DESC

SELECT * FROM Peaks
SELECT * FROM Mountains