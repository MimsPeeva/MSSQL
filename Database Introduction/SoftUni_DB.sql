CREATE DATABASE SoftUni

CREATE TABLE Towns 
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL
)
INSERT INTO Towns(Name)
VALUES('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

CREATE TABLE Addresses 
(
Id INT PRIMARY KEY IDENTITY,
AddressText NVARCHAR(100) NOT NULL, 
TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Departments 
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL
)
INSERT INTO Departments
VALUES('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')


CREATE TABLE Employees 
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL, 
MiddleName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
JobTitle NVARCHAR(50) NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL,
HireDate DATE NOT NULL,
Salary DECIMAL(6,2) NOT NULL,
AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)
INSERT INTO Employees(FirstName,MiddleName,LastName, JobTitle,DepartmentId,HireDate,Salary)
VALUES('Ivan',' Ivanov',' Ivanov',' .NET Developer',4,  CONVERT(DATE, '02/03/2004', 103),' 3500.00'),
('Petar',' Petrov ','Petrov ','Senior Engineer',1,CONVERT(DATE,'02/03/2004 ',103),'4000.00'),
('Maria ','Petrova ','Ivanova ','Intern',5,CONVERT (DATE,'28/08/2016',103) ,'525.25'),
('Georgi',' Teziev',' Ivanov','CEO',2,CONVERT (DATE,' 09/12/2007',103),' 3000.00'),
('Peter ','Pan ','Pan ','Intern' ,3,CONVERT(DATE,'28/08/2016',103),'599.88')
 

 SELECT * FROM Towns
SELECT*FROM Departments
SELECT*FROM Employees 


 SELECT * FROM Towns ORDER BY [Name] ASC
SELECT*FROM Departments ORDER BY [Name] ASC
SELECT*FROM Employees ORDER BY [Salary] DESC

 SELECT [Name]  FROM Towns ORDER BY [Name] ASC
SELECT [Name] FROM Departments ORDER BY [Name] ASC
SELECT[FirstName], [LastName], [JobTitle], [Salary] FROM Employees ORDER BY [Salary] DESC

--UPDATE SALARY WITH 10%
UPDATE Employees SET SALARY *=1.1
SELECT [Salary] FROM Employees 





 TRUNCATE TABLE Employees

 DROP TABLE Employees
 DROP TABLE Departments
 DROP TABLE Addresses
 DROP TABLE Towns
  
  --CREATE BACKUP AND RESTORE IT
BACKUP DATABASE SoftUni
TO DISK = 'D:\MS SQL\Database Introduction\softuni-backup.bak'
DROP DATABASE SoftUni
RESTORE DATABASE SoftUni
FROM DISK = 'D:\MS SQL\Database Introduction\softuni-backup.bak'

