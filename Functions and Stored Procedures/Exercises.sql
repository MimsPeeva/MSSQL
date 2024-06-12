USE SoftUni
--01
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName FROM Employees
WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000

--02
CREATE OR ALTER PROC usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18,4)
AS
BEGIN
SELECT FirstName, LastName FROM Employees
WHERE Salary >= @Number
END
EXEC usp_GetEmployeesSalaryAboveNumber 48100

--03

CREATE OR ALTER PROC usp_GetTownsStartingWith @StrToStart VARCHAR(MAX)
AS
BEGIN
SELECT [Name] FROM Towns
WHERE [Name] LIKE @StrToStart + '%'
END

--04
CREATE OR ALTER PROC usp_GetEmployeesFromTown @TownName VARCHAR(MAX)
AS
BEGIN
SELECT FirstName,LastName FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
JOIN Towns AS t
ON t.TownID = a.TownID
WHERE t.Name = @TownName
END

EXEC usp_GetEmployeesFromTown Sofia

--05
CREATE OR ALTER FUNCTION [ufn_GetSalaryLevel](@salary DECIMAL(18,4))
RETURNS VARCHAR(10) AS
BEGIN
DECLARE @result VARCHAR(10) = 'Average'

IF(@salary < 30000)
BEGIN
SET @result = 'Low'
END

ELSE IF(@salary > 50000)
BEGIN
SET @result = 'High'
END

RETURN @result
END

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) AS SalaryLevel
FROM Employees

--06
CREATE OR ALTER PROC usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(MAX))
AS
BEGIN
SELECT FirstName, LastName
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary)= @SalaryLevel
END

EXEC usp_EmployeesBySalaryLevel low

--07
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT 
 AS
BEGIN
DECLARE @Interator INT = 1
DECLARE @WordLength INT = LEN(@word)
WHILE(@Interator<=@WordLength)
  BEGIN
  DECLARE @CurrSymbol CHAR = SUBSTRING(@word,@Interator,1)
  IF CHARINDEX(@CurrSymbol, @setOfLetters) = 0
  BEGIN
  RETURN 0
  END

  SET @Interator +=1;
END
RETURN 1
END

--08
CREATE OR ALTER PROC  usp_DeleteEmployeesFromDepartment (@departmentId INT)
		AS
	 BEGIN
			ALTER TABLE [Departments]
		   ALTER COLUMN [ManagerID] INT NULL
	
				 DELETE 
				   FROM [EmployeesProjects]
				  WHERE [EmployeeID] IN
					(
						SELECT [EmployeeID] 
						  FROM [Employees]
						 WHERE [DepartmentID] = @departmentId
					)

				UPDATE [Employees]
				   SET [ManagerID] = NULL
				 WHERE [ManagerID] IN
					(
						SELECT [EmployeeID] 
						  FROM [Employees]
						 WHERE [DepartmentID] = @departmentId
					)
	
			   UPDATE [Departments]
				  SET [ManagerID] = NULL
				WHERE [DepartmentID] = @departmentId
	
 			   DELETE
			     FROM [Employees]
				WHERE [DepartmentID] = @departmentId

			   DELETE 
			     FROM [Departments]
			    WHERE [DepartmentID] = @departmentId

			   SELECT COUNT(*) 
			     FROM [Employees]
				WHERE [DepartmentID] = @departmentId
		END


USE Bank
--09
CREATE OR ALTER PROC usp_GetHoldersFullName
AS
SELECT CONCAT_WS(' ', FirstName,LastName) AS [Full Name]
FROM AccountHolders

EXEC usp_GetHoldersFullName

--10
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan(@Parameter DECIMAL(10,2))
AS 
SELECT FirstName, LastName, SUM(a.Balance)
FROM AccountHolders AS ah
JOIN Accounts AS a
ON a.AccountHolderId = ah.Id
GROUP BY FirstName, LastName
HAVING SUM(a.Balance) > @Parameter
ORDER BY FirstName, LastName


--CREATE OR ALTER PROC [usp_GetHoldersWithBalanceHigherThan] @number DECIMAL(10,2)
--	   AS
--	BEGIN
--			SELECT ah.[FirstName] AS [First Name],
--				   ah.[LastName] AS [Last Name]
--			     FROM [AccountHolders] AS ah
--	             JOIN
--				   (
--					SELECT [AccountHolderId],
--					   SUM([Balance]) AS [TotalMoney]
--					  FROM [Accounts]
--				  GROUP BY [AccountHolderId]
--				   ) AS a ON ah.[Id] = a.[AccountHolderId]

--			 WHERE a.[TotalMoney] > @number
--		 ORDER BY ah.[FirstName], 
--				  ah.[LastName]
--	  END
EXEC usp_GetHoldersWithBalanceHigherThan 1000


--11
CREATE FUNCTION ufn_CalculateFutureValue(@Sum DECIMAL(10,4), @YearlyInterestRate FLOAT, @NumberOfYears INT)
RETURNS DECIMAL(10,4)
 AS
  BEGIN
    RETURN @Sum*POWER(1+@YearlyInterestRate, @NumberOfYears)
  END


--12
CREATE PROC usp_CalculateFutureValueForAccount(@AccountId INT, @YearlyInterestRate FLOAT)
  AS
     BEGIN
	  SELECT ah.Id AS [AccountId], 
	  ah.FirstName, ah.LastName, 
	  a.Balance AS [Current Balance],
	  dbo.ufn_CalculateFutureValue(a.Balance, @YearlyInterestRate,5) AS [Balance in 5 years]
	     FROM AccountHolders AS ah
      JOIN Accounts AS a ON a.AccountHolderId = ah.Id
		 --GROUP BY ah.FirstName,ah.LastName
		 --HAVING a.Id = @AccountId
		 WHERE a.Id = @AccountId
	END