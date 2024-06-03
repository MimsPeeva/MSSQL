USE Gringotts
--01
SELECT COUNT(*)
FROM WizzardDeposits

--02
SELECT  MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

--03
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup 

--04
SELECT TOP 2 DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--05
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

--06
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--7
SELECT DepositGroup,SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family' 
GROUP BY DepositGroup
HAVING SUM([DepositAmount]) < 150000
ORDER BY TotalSum DESC

--08
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup,MagicWandCreator
ORDER BY DepositGroup, MagicWandCreator

SELECT * FROM WizzardDeposits

--09
SELECT AgeGroup, COUNT(AgeGroup) AS WizardCount
FROM
(
  SELECT
		CASE
			WHEN [Age] <= 10 THEN '[0-10]'
			WHEN [Age] > 10 AND [Age] <= 20 THEN '[11-20]'
			WHEN [Age] > 20 AND [Age] <= 30 THEN '[21-30]'
			WHEN [Age] > 30 AND [Age] <= 40 THEN '[31-40]'
			WHEN [Age] > 40 AND [Age] <= 50 THEN '[41-50]'
			WHEN [Age] > 50 AND [Age] <= 60 THEN '[51-60]'
			ELSE '[61+]'
  END AS [AgeGroup]
FROM WizzardDeposits
)
AS A GROUP BY AgeGroup

--10
SELECT SUBSTRING(FirstName,1,1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY SUBSTRING(FirstName,1,1)
ORDER BY FirstLetter

--11
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS 'AverageInterest'
FROM WizzardDeposits
WHERE DepositStartDate > '01-01-1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC,
IsDepositExpired

--12


USE SoftUni
--13
SELECT * FROM Employees

SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14
SELECT DepartmentID, MIN(Salary) AS MinimumSalary
FROM Employees
WHERE DepartmentID IN (2,5,7)
AND HireDate > '01-01-2000'
GROUP BY DepartmentID

--15
SELECT * INTO RichEmployees
FROM Employees
WHERE Salary > 30000

DELETE FROM RichEmployees
WHERE ManagerID = 42

UPDATE RichEmployees 
SET Salary = Salary + 5000
WHERE DepartmentID =1 


SELECT DepartmentID , AVG(Salary) AS AverageSalary
FROM RichEmployees
GROUP BY DepartmentID
--16
SELECT DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17
SELECT COUNT(*) AS Count
FROM Employees
WHERE ManagerID IS NULL
