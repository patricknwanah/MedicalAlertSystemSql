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

IF object_id('DATA.Patients') IS NULL
BEGIN
	CREATE TABLE DATA.Patients 
	(
		PatientID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
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
	ALTER TABLE DATA.Patients ADD isHidden BINARY NOT NULL DEFAULT 0 -- (false) in binary 1 means true and 0 means false
END
GO



IF object_id('DATA.BloodPressures') IS NULL
BEGIN
	CREATE TABLE DATA.BloodPressures
	(
		BloodPressureID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		PatientID INT,
		BloodPressure varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (PatientID) REFERENCES DATA.Patients(PatientID)
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
		PatientID INT,
		BloodGlucoseLevel varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (PatientID) REFERENCES DATA.Patients(PatientID)
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


IF object_id('DATA.Guardians') IS NULL
BEGIN
	CREATE TABLE DATA.Guardians
	(
		GuardianID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		LoginName VARCHAR(50),
		LoginPassword VARCHAR(50),
		EmailAddress VARCHAR(100),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
	)
	ALTER TABLE DATA.Guardians ADD isHidden BINARY NOT NULL DEFAULT 0 -- (false) in binary 1 means true and 0 means false
END
GO

--ALTER TABLE DATA.Guardians drop column patientID

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
--		PatientID INT,
--		BloodGlucoseLevelID INT,
--		BloodPressureID INT,
--		MedicalConditionID INT,
--		DateAdded DATETIME DEFAULT GETDATE(),
--		ModificationDate DATETIME DEFAULT GETDATE(),
--		FOREIGN KEY (PatientID) REFERENCES DATA.Patients(PatientID),
--		FOREIGN KEY (BloodGlucoseLevelID) REFERENCES DATA.BloodGlucoseLevels(BloodGlucoseLevelID),
--		FOREIGN KEY (BloodPressureID) REFERENCES DATA.BloodPressures(BloodPressureID),
--		FOREIGN KEY (MedicalConditionID) REFERENCES REF.MedicalConditions(MedicalConditionID)
--	)
--END
--GO






---CREATE AUDIT TABLES

IF object_id('AUDIT.Patients') IS NULL
BEGIN
	CREATE TABLE AUDIT.Patients
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		PatientID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (PatientID) REFERENCES DATA.Patients(PatientID)
	)
END
GO

IF object_id('AUDIT.Guardians') IS NULL
BEGIN
	CREATE TABLE AUDIT.Guardians
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		GuardianID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (GuardianID) REFERENCES DATA.Guardians(GuardianID)
	)
END
GO


IF object_id('DATA.PatientCaretakers') IS NULL
BEGIN
	CREATE TABLE DATA.PatientCaretakers
	(
		PatientCaretakerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		PatientID INT,
		GuardianID INT,
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
		FOREIGN KEY (PatientID) REFERENCES DATA.Patients(PatientID),
		FOREIGN KEY (GuardianID) REFERENCES DATA.Guardians(GuardianID)
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
		PatientID INT,
		HeartRate varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (PatientID) REFERENCES DATA.Patients(PatientID)
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
		PatientID INT,
		AlertMessageID INT,
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (PatientID) REFERENCES DATA.Patients(PatientID),
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



--exec sp_rename 'DATA.PatientCaretaker', 'DATA.PatientCaretakers' --for renaming tables


--CREATE REPORT VIEW LATER

