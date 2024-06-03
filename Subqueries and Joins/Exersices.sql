USE SoftUni

--01
SELECT TOP 5 
e.EmployeeID,e.JobTitle,a.AddressID,a.AddressText 
FROM Employees AS e
LEFT JOIN  Addresses AS a
ON e.AddressID = a.AddressID
ORDER BY AddressID

--02
SELECT TOP 50
e.FirstName, e.LastName,t.[Name], a.AddressText
FROM Employees AS e
 JOIN Addresses AS a
ON e.AddressID = a.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID
ORDER BY FirstName,
LastName

--03
SELECT TOP 50
 e.EmployeeID ,e.FirstName, e.LastName, d.[Name]
FROM Employees AS e
 JOIN Departments AS d
 ON e.DepartmentID = d.DepartmentID
 WHERE d.[Name] = 'Sales'
 ORDER BY EmployeeID

 --04
 SELECT TOP 5
 e.EmployeeID ,e.FirstName, e.Salary, d.[Name] AS 'DepartmentName'
FROM Employees AS e
 JOIN Departments AS d
 ON e.DepartmentID = d.DepartmentID
 WHERE e.Salary > 15000
 ORDER BY d.DepartmentID 

 --05
  SELECT TOP 3
 EmployeeID ,FirstName
FROM Employees 
 WHERE EmployeeID NOT IN (SELECT DISTINCT EmployeeID FROM EmployeesProjects)
 
 --06
 SELECT FirstName, LastName, HireDate, d.[Name]
 FROM Employees AS e
 JOIN Departments AS d
 ON e.DepartmentID = d.DepartmentID
 WHERE HireDate > '01.01.1999' AND 
 d.Name IN ('Sales','Finance')
 ORDER BY HireDate

 --07
 SELECT TOP 5
 e.EmployeeID, FirstName, [Name]
 FROM Employees AS e
 JOIN EmployeesProjects AS ep
 ON e.EmployeeID = ep.EmployeeID
 JOIN Projects AS p
 ON ep.ProjectID = p.ProjectID
 WHERE StartDate > '2002-08-13' AND EndDate IS NULL
 ORDER BY e.EmployeeID

 --08
 SELECT 
 e.EmployeeID, FirstName, [Project Name] = 
 CASE 
   WHEN DATEPART(YEAR, StartDate) > 2004 THEN NULL
   ELSE [Name]
END
 FROM Employees AS e
 JOIN EmployeesProjects AS ep
 ON e.EmployeeID = ep.EmployeeID
 JOIN Projects AS p
 ON ep.ProjectID = p.ProjectID
 WHERE E.EmployeeID = 24

 --09
 SELECT emp.EmployeeID,emp.FirstName,mng.EmployeeID AS 'ManagerID',mng.FirstName AS 'ManagerName'
 FROM Employees AS emp
 LEFT JOIN Employees AS mng
 ON emp.ManagerID = mng.EmployeeID
 WHERE emp.ManagerID IN (3,7)
 ORDER BY EmployeeID

 --10
  SELECT TOP 50
  emp.EmployeeID, CONCAT_WS(' ',emp.FirstName,emp.LastName) AS [EmployeeName],
  CONCAT_WS(' ', mng.FirstName,mng.LastName) AS [ManagerName],
  d.[Name] AS [DepartmentName]
 FROM Employees AS emp
 LEFT JOIN Employees AS mng
 ON emp.ManagerID = mng.EmployeeID
 Left JOIN Departments AS d
 ON emp.DepartmentID = d.DepartmentID
 ORDER BY EmployeeID

 --11

 SELECT TOP 1 AVG(Salary) AS MinAverageSalary
 FROM Employees
 GROUP BY DepartmentID
 ORDER BY MinAverageSalary

 USE Geography
 --12
 SELECT c.CountryCode,
       m.MountainRange,
       p.PeakName,
       p.Elevation
FROM Countries AS c
     JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
     JOIN Mountains AS m ON mc.MountainId = m.Id
     JOIN Peaks AS p ON p.MountainId = m.Id
WHERE c.CountryName = 'Bulgaria'
      AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--13
SELECT mc.CountryCode,
       COUNT(m.MountainRange) AS MountainRanges
FROM MountainsCountries AS mc
JOIN Mountains as m
ON mc.MountainId = m.Id
WHERE mc.CountryCode IN('US', 'RU', 'BG')
GROUP BY CountryCode

--14
SELECT TOP 5 c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr 
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r 
ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY CountryName




--16
--first option
--SELECT COUNT(*)
--FROM Countries AS c
--LEFT JOIN MountainsCountries AS cm
--ON c.CountryCode = cm.CountryCode
--WHERE cm.CountryCode IS NULL

SELECT COUNT(c.CountryCode) AS Count
FROM Countries AS c
LEFT JOIN MountainsCountries AS cm
ON c.CountryCode = cm.CountryCode
WHERE cm.CountryCode IS NULL

--17
SELECT TOP 5 c.CountryName,
MAX(Elevation) AS HighestPeakElevation,
MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers as r ON r.Id = CR.RiverId
GROUP BY CountryName
ORDER BY HighestPeakElevation DESC,
LongestRiverLength DESC,
CountryName