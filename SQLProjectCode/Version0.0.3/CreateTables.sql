USE mats_user
GO

IF object_id('REF.MedicalConditions') IS NULL
BEGIN
	CREATE TABLE REF.MedicalConditions
	(
		MedicalConditionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
		MedicalConditionName VARCHAR(max),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
		
	)
END
GO

--ALTER TABLE REF.MedicalConditions
--ALTER COLUMN MedicalConditionName varchar(max);

IF object_id('DATA.Users') IS NULL
BEGIN
	CREATE TABLE DATA.Users
	(
		UserID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
		UserType int,
		FirstName VARCHAR(50),
		LastName VARCHAR(50),
		MiddleName VARCHAR(50),
		LoginName VARCHAR(50) NOT NULL UNIQUE,
		LoginPassword VARCHAR(50),
		EmailAddress VARCHAR(100),
		MedicalConditionID INT,
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (MedicalConditionID) REFERENCES REF.MedicalConditions(MedicalConditionID)
	)
	ALTER TABLE DATA.Users ADD isHidden BINARY NOT NULL DEFAULT 0 -- (false) in binary 1 means true and 0 means false
END
GO

IF object_id('AUDIT.Users') IS NULL
BEGIN
	CREATE TABLE AUDIT.Users
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)
END
GO




IF object_id('DATA.BloodPressures') IS NULL
BEGIN
	CREATE TABLE DATA.BloodPressures
	(
		BloodPressureID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		BloodPressure varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)
END
GO

IF object_id('AUDIT.BloodPressures') IS NULL
BEGIN
	CREATE TABLE AUDIT.BloodPressures
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		BloodPressureID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (BloodPressureID) REFERENCES DATA.BloodPressures(BloodPressureID)
	)
END
GO

IF object_id('DATA.BloodGlucoseLevels') IS NULL
BEGIN
	CREATE TABLE DATA.BloodGlucoseLevels
	(
		BloodGlucoseLevelID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		BloodGlucoseLevel varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)
END
GO


IF object_id('AUDIT.BloodGlucoseLevels') IS NULL
BEGIN
	CREATE TABLE AUDIT.BloodGlucoseLevels
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		BloodGlucoseLevelID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (BloodGlucoseLevelID) REFERENCES DATA.BloodGlucoseLevels(BloodGlucoseLevelID)
	)
END
GO



--ALTER TABLE DATA.Guardians drop column UserID

IF object_id('REF.ErrorMessageCodes') IS NULL
BEGIN
	CREATE TABLE REF.ErrorMessageCodes
	(
		ErrorMessageCodeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CodeMessage VARCHAR(MAX),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
	)
END
GO



--IF object_id('DATA.Reports') IS NULL
--BEGIN
--	CREATE TABLE DATA.Reports
--	(
--		ReportID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
--		UserID INT,
--		BloodGlucoseLevelID INT,
--		BloodPressureID INT,
--		MedicalConditionID INT,
--		DateAdded DATETIME DEFAULT GETDATE(),
--		ModificationDate DATETIME DEFAULT GETDATE(),
--		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID),
--		FOREIGN KEY (BloodGlucoseLevelID) REFERENCES DATA.BloodGlucoseLevels(BloodGlucoseLevelID),
--		FOREIGN KEY (BloodPressureID) REFERENCES DATA.BloodPressures(BloodPressureID),
--		FOREIGN KEY (MedicalConditionID) REFERENCES REF.MedicalConditions(MedicalConditionID)
--	)
--END
--GO





IF object_id('DATA.PatientCaretakers') IS NULL
BEGIN
	CREATE TABLE DATA.PatientCaretakers
	(
		PatientCaretakerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		CaretakerID INT,
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID),
		FOREIGN KEY (CaretakerID) REFERENCES DATA.Users(UserID)
	)
	ALTER TABLE DATA.PatientCaretakers ADD isHidden BINARY NOT NULL DEFAULT 0 -- (false) in binary 1 means true and 0 means false
END
GO

IF object_id('AUDIT.PatientCaretakers') IS NULL
BEGIN
	CREATE TABLE AUDIT.PatientCaretakers
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		PatientCaretakerID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (PatientCaretakerID) REFERENCES DATA.PatientCaretakers(PatientCaretakerID)
	)
END
GO

IF object_id('DATA.HeartRate') IS NULL
BEGIN
	CREATE TABLE DATA.HeartRate
	(
		HeartRateID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		HeartRate varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)
END
GO


IF object_id('AUDIT.HeartRate') IS NULL
BEGIN
	CREATE TABLE AUDIT.HeartRate
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		HeartRateID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (HeartRateID) REFERENCES DATA.HeartRate(HeartRateID)
	)
END
GO


IF object_id('DATA.Alerts') IS NULL
BEGIN
	CREATE TABLE DATA.Alerts
	(
		AlertID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		AlertMessageID INT,
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID),
		FOREIGN KEY (AlertMessageID) REFERENCES REF.AlertMessages(AlertMessageID)
	)
END
GO


IF object_id('REF.AlertMessages') IS NULL
BEGIN
	CREATE TABLE REF.AlertMessages
	(
		AlertMessageID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		AlertMessage varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
	)
END
GO


IF object_id('REF.UserTypes') IS NULL
BEGIN
	CREATE TABLE REF.UserTypes
	(
		UserTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserTypeMessage varchar(max),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
	)
END
GO


--alter table Data.Users add UserType int
--EXEC sp_RENAME 'DATA.Users','UserID','PatientID'
--select * from data.Users
--exec sp_rename 'DATA.Users', 'DATA.Users' --for renaming tables
--drop table data.bloodpressures



--DECLARE @sql NVARCHAR(MAX);
--SET @sql = N'';
--
--SELECT @sql = @sql + N'
--  ALTER TABLE ' + QUOTENAME(s.name) + N'.'
--  + QUOTENAME(t.name) + N' DROP CONSTRAINT '
--  + QUOTENAME(c.name) + ';'
--FROM sys.objects AS c
--INNER JOIN sys.tables AS t
--ON c.parent_object_id = t.[object_id]
--INNER JOIN sys.schemas AS s 
--ON t.[schema_id] = s.[schema_id]
--WHERE c.[type] IN ('D','C','F','PK','UQ')
--ORDER BY c.[type];

--PRINT @sql;
--go

select * from data.Users


