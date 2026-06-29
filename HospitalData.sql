CREATE DATABASE HospitalAnalysis;
GO
USE HospitalAnalysis;
GO
CREATE TABLE HospitalData (
    Patient_ID INT PRIMARY KEY,
    Age INT,
    Gender NVARCHAR(10),
    Condition NVARCHAR(100),
    Procedure_Name NVARCHAR(100),
    Cost INT,
    Length_of_Stay INT,
    Readmission NVARCHAR(3),
    Outcome NVARCHAR(20),
    Satisfaction INT,
    Age_Group NVARCHAR(20),
    Cost_Category NVARCHAR(20),
    Stay_Category NVARCHAR(20)
);
GO
SELECT COUNT(*) AS TotalRows
FROM HospitalData;
SELECT DB_NAME() AS CurrentDatabase;
SELECT @@VERSION;
SELECT @@SERVERNAME AS ServerName;
SELECT name
FROM sys.tables;
SELECT @@SERVERNAME AS ServerName;
SELECT SERVERPROPERTY('InstanceDefaultDataPath') AS DefaultDataPath;
BULK INSERT HospitalData
FROM 'C:\SQLData\hospital_cleaned.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
SELECT COUNT(*) AS TotalPatients
FROM HospitalData;
SELECT *
FROM HospitalData;
-- total number of patients
SELECT COUNT(*) AS TotalPatients
FROM HospitalData;
--average treatment cost
SELECT AVG(Cost) AS AverageCost
FROM HospitalData;
--Hidhest and lowest cost
SELECT
    MIN(Cost) AS LowestCost,
    MAX(Cost) AS HighestCost
FROM HospitalData;
--patient by gender
SELECT
    Gender,
    COUNT(*) AS TotalPatients
FROM HospitalData
GROUP BY Gender;
--Which condition generated the highest treatment cost? cancer
SELECT Condition,
       SUM(Cost) AS TotalCost
FROM HospitalData
GROUP BY Condition
ORDER BY TotalCost DESC;
--Which age group has the highest average treatment cost? 66+
SELECT Age_Group,
       AVG(Cost) AS AverageCost
FROM HospitalData
GROUP BY Age_Group
ORDER BY AverageCost DESC;
--Readmission rate by condition
SELECT Condition,
       Readmission,
       COUNT(*) AS Patients
FROM HospitalData
GROUP BY Condition, Readmission
ORDER BY Condition;
--Average satisfaction by outcome
SELECT Outcome,
       AVG(Satisfaction) AS AvgSatisfaction
FROM HospitalData
GROUP BY Outcome;
--Top 5 most expensive conditions
SELECT TOP 5 Procedure_Name,
       AVG(Cost) AS AverageCost
FROM HospitalData
GROUP BY Procedure_Name
ORDER BY AverageCost DESC;
--Which conditions are associated with the most patient readmissions? heartAttack
SELECT
    Condition,
    COUNT(*) AS ReadmittedPatients
FROM HospitalData
WHERE Readmission = 'Yes'
GROUP BY Condition
ORDER BY ReadmittedPatients DESC;
--Average Length of Stay for Each Condition
SELECT
    Condition,
    AVG(Length_of_Stay) AS AverageStay
FROM HospitalData
GROUP BY Condition
ORDER BY AverageStay DESC;
--Which Procedures Have the Highest Patient Satisfaction?
SELECT
    Procedure_Name,
    AVG(Satisfaction) AS AverageSatisfaction
FROM HospitalData
GROUP BY Procedure_Name
ORDER BY AverageSatisfaction DESC;
--Number of Patients by Age Group and Gender
SELECT
    Age_Group,
    Gender,
    COUNT(*) AS TotalPatients
FROM HospitalData
GROUP BY Age_Group, Gender
ORDER BY Age_Group, Gender;
--Patients with Above-Average Treatment Costs
SELECT
    Patient_ID,
    Condition,
    Cost
FROM HospitalData
WHERE Cost > (
    SELECT AVG(Cost)
    FROM HospitalData
)
ORDER BY Cost DESC;