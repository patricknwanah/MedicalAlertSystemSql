---CREATE STORED PROCEDURES
USE mats_user
GO
IF OBJECT_ID('DATA.AddPatient', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddPatient;  
GO 
CREATE PROCEDURE DATA.AddPatient @FirstName varchar(50), @LastName varchar(50), @MiddleName varchar(50), @LoginName varchar(50), @LoginPassword varchar(50), @EmailAddress varchar(50), @MedicalConditionID int ,@returnValue int = -1 OUTPUT
AS
	IF ((@FirstName IS NOT NULL) OR (LEN(@FirstName) > 0))  AND ((@LastName IS NOT NULL) OR (LEN(@LastName) > 0)) AND ((@LoginName IS NOT NULL) OR (LEN(@LoginName) > 0)) AND ((@LoginPassword IS NOT NULL) OR (LEN(@LoginPassword) > 0)) AND ((@EmailAddress IS NOT NULL) OR (LEN(@EmailAddress) > 0))
	BEGIN
		IF NOT EXISTS(SELECT * FROM DATA.Patients WHERE EmailAddress like @EmailAddress) --INSERT
		BEGIN
			INSERT INTO DATA.Patients (FirstName , LastName, MiddleName, LoginName, LoginPassword, EmailAddress, MedicalConditionID) VALUES (@FirstName, @LastName, @MiddleName, @LoginName, @LoginPassword, @EmailAddress, @MedicalConditionID) 
			set @returnValue = 0
		END
		ELSE -- UPDATE
		BEGIN 
			--UPDATE DATA.Patients SET FirstName = @FirstName, LastName = @LastName, MiddleName = @MiddleName, LoginName = @LoginName, LoginPassword  = @LoginPassword, MedicalConditionID = @MedicalConditionID, ModificationDate = GETDATE() WHERE EmailAddress like @EmailAddress
			set @returnValue = 1
		END
	END
	ELSE
		set @returnValue = 1
GO



IF OBJECT_ID('DATA.AddorUpdateGuardians', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddorUpdateGuardians;  
GO
CREATE PROCEDURE DATA.AddorUpdateGuardians @LoginName varchar(50), @LoginPassword varchar(50), @EmailAddress varchar(100)
AS
	IF ((@LoginName IS NOT NULL) OR (LEN(@LoginName) > 0)) AND ((@LoginPassword IS NOT NULL) OR (LEN(@LoginPassword) > 0)) AND ((@EmailAddress IS NOT NULL) OR (LEN(@EmailAddress) > 0))
	BEGIN
		IF NOT EXISTS(SELECT * FROM DATA.Guardians WHERE EmailAddress like @EmailAddress) --INSERT
		BEGIN
			INSERT INTO DATA.Guardians (LoginName, LoginPassword, EmailAddress) VALUES (@LoginName, @LoginPassword, @EmailAddress)
		END
		ELSE --UPDATE
		BEGIN
			UPDATE DATA.Guardians SET LoginName = @LoginName, LoginPassword  = @LoginPassword, ModificationDate = GETDATE() WHERE EmailAddress like @EmailAddress
		END
		RETURN 0
	END
	ELSE
		RETURN 1
GO


IF OBJECT_ID('DATA.AddorUpdatePatientCaretakers', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddorUpdatePatientCaretakers
GO
CREATE PROCEDURE DATA.AddorUpdatePatientCaretakers @PatientID int, @GuardianID int
AS
	IF (@PatientID IS NOT NULL) AND (@GuardianID IS NOT NULL)
	BEGIN
		IF NOT EXISTS(SELECT * FROM DATA.Guardians WHERE GuardianID = @GuardianID) OR NOT EXISTS(SELECT * FROM DATA.Patients WHERE PatientID = @PatientID) --PATIENT OR GUARDIANS DO NOT EXIST
		BEGIN
			RETURN 1
		END
		ELSE
		BEGIN
			INSERT INTO DATA.PatientCaretakers (PatientID, GuardianID) VALUES (@PatientID, @GuardianID)
		END
		RETURN 0
	END
	ELSE
		RETURN 1
GO


IF OBJECT_ID('REF.AddorUpdateMedicalConditions', 'P') IS NOT NULL  
    DROP PROCEDURE REF.AddorUpdateMedicalConditions;  
GO
CREATE PROCEDURE REF.AddorUpdateMedicalConditions @MedicalConditionName varchar(max)
AS
	IF ((@MedicalConditionName IS NOT NULL) OR (LEN(@MedicalConditionName) > 0))
	BEGIN
		IF NOT EXISTS(SELECT * FROM REF.MedicalConditions WHERE MedicalConditionName like @MedicalConditionName)
		BEGIN
			INSERT INTO REF.MedicalConditions (MedicalConditionName) VALUES (@MedicalConditionName)
		END
		ELSE
		BEGIN
			UPDATE REF.MedicalConditions SET MedicalConditionName = @MedicalConditionName, ModificationDate = GETDATE() WHERE MedicalConditionName LIKE @MedicalConditionName
		END
		RETURN 0
	END
	ELSE
		RETURN 1
GO

IF OBJECT_ID('DATA.AddBloodPressures', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddBloodPressures;  
GO
CREATE PROCEDURE DATA.AddBloodPressures @PatientID int, @BloodPressure varchar(50)
AS
	IF ((@BloodPressure IS NOT NULL) OR (LEN(@BloodPressure) > 0)) AND EXISTS(SELECT * FROM DATA.Patients WHERE PatientID = @PatientID)
	BEGIN
		INSERT INTO DATA.BloodPressures (PatientID, BloodPressure) VALUES (@PatientID, @BloodPressure)
		RETURN 0
	END
	ELSE
		RETURN 1
GO

IF OBJECT_ID('DATA.AddBloodGlucoseLevels', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddBloodGlucoseLevels;  
GO
CREATE PROCEDURE DATA.AddBloodGlucoseLevels @PatientID int, @BloodGlucoseLevel varchar(50)
AS
	IF ((@BloodGlucoseLevel IS NOT NULL) OR (LEN(@BloodGlucoseLevel) > 0)) AND EXISTS(SELECT * FROM DATA.Patients WHERE PatientID = @PatientID)
	BEGIN
		INSERT INTO DATA.BloodGlucoseLevels (PatientID, BloodGlucoseLevel) VALUES (@PatientID, @BloodGlucoseLevel)
		RETURN 0
	END
	ELSE
		RETURN 1
GO

IF OBJECT_ID('DATA.GetPatientReport', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.GetPatientReport;  
GO
CREATE PROCEDURE DATA.GetPatientReport @PatientID int
AS
	IF (@PatientID IS NOT NULL) AND EXISTS(SELECT * FROM DATA.Patients WHERE PatientID = @PatientID)
	begin
		select * from DATA.ReportView where PatientID = @PatientID
	end
	else
		return 1
GO

IF OBJECT_ID('DATA.PatientLogin', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.PatientLogin 
GO
CREATE PROCEDURE DATA.PatientLogin @LoginName varchar(max), @LoginPassword varchar(max), @returnValue int = -1 OUTPUT
AS
	IF (@LoginName IS NOT NULL) AND (@LoginPassword IS NOT NULL) AND EXISTS(SELECT * FROM DATA.Patients WHERE LoginName = @LoginName AND LoginPassword = @LoginPassword)
	begin
		set @returnValue = 0
	end
	else
		set @returnValue = 1
GO


IF OBJECT_ID('DATA.getMedicalConditions', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getMedicalConditions
GO
CREATE PROCEDURE DATA.getMedicalConditions
AS
	Select * from REF.MedicalConditions
GO


--exec DATA.GetPatientReport 1
--select * from data.Patients
--select * from data.reportview
--exec DATA.AddorUpdatePatients 'fsd','fd','asdf','dasf','dsfa','fda',1
--exec REF.AddorUpdateMedicalConditions 'None'


--IF OBJECT_ID('DATA.AddReports', 'P') IS NOT NULL  
--    DROP PROCEDURE DATA.AddReports;  
--GO
--CREATE PROCEDURE DATA.AddReportS @PatientID int, @BloodGlucoseLevelID int, @BloodPressureID int , @MedicalConditionID int
--AS
--	IF (@PatientID IS NOT NULL) 
--	BEGIN
--		INSERT INTO DATA.Reports (PatientID, BloodGlucoseLevelID, BloodPressureID, @MedicalConditionID) VALUES (@PatientID, @BloodGlucoseLevelID, @BloodPressureID, @MedicalConditionID)
--		RETURN 0
--	END
--	ELSE
--		RETURN 1
--GO

--need to create procedure for adding and dropping patient to guardian

select * from sysobjects where xtype ='P' 

select * from data.Patients