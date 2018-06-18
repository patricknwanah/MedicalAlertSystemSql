---CREATE STORED PROCEDURES
USE mats_user
GO
IF OBJECT_ID('DATA.AddUser', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddUser;  
GO 
CREATE PROCEDURE DATA.AddUser @FirstName varchar(50), @LastName varchar(50), @MiddleName varchar(50), @LoginName varchar(50), @LoginPassword varchar(50), @EmailAddress varchar(50), @MedicalConditionID int , @UserType int, @returnValue int = -1 OUTPUT
AS
	IF ((@FirstName IS NOT NULL) OR (LEN(@FirstName) > 0))  AND ((@LastName IS NOT NULL) OR (LEN(@LastName) > 0)) AND ((@LoginName IS NOT NULL) OR (LEN(@LoginName) > 0)) AND ((@LoginPassword IS NOT NULL) OR (LEN(@LoginPassword) > 0)) AND ((@EmailAddress IS NOT NULL) OR (LEN(@EmailAddress) > 0)) AND (@UserType IS NOT NULL)
	BEGIN
		IF NOT EXISTS(SELECT * FROM DATA.Users WHERE EmailAddress like @EmailAddress) AND NOT EXISTS(SELECT * FROM DATA.Users WHERE LoginName like @LoginName)--INSERT and checks that email and loginname does not already exist
		BEGIN
			INSERT INTO DATA.Users (FirstName , LastName, MiddleName, LoginName, LoginPassword, EmailAddress, MedicalConditionID, UserType) VALUES (@FirstName, @LastName, @MiddleName, @LoginName, @LoginPassword, @EmailAddress, @MedicalConditionID, @UserType) 
			set @returnValue = 0
		END
		ELSE -- UPDATE
		BEGIN 
			UPDATE DATA.Users SET FirstName = @FirstName, LastName = @LastName, MiddleName = @MiddleName, LoginName = @LoginName, LoginPassword  = @LoginPassword, MedicalConditionID = @MedicalConditionID, ModificationDate = GETDATE() WHERE EmailAddress like @EmailAddress
			set @returnValue = 1
		END
	END
	ELSE
		set @returnValue = 1
GO




IF OBJECT_ID('DATA.AddorUpdatePatientCaretakers', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddorUpdatePatientCaretakers
GO
CREATE PROCEDURE DATA.AddorUpdatePatientCaretakers @UserID int, @CareTakerID int
AS
	IF (@UserID IS NOT NULL) AND (@CareTakerID IS NOT NULL)
	BEGIN
		IF NOT EXISTS(SELECT * FROM DATA.Users WHERE UserID = @CareTakerID AND (UserType = 3 OR UserType = 2)) OR NOT EXISTS(SELECT * FROM DATA.Users WHERE UserID = @UserID) --PATIENT OR GUARDIANS DO NOT EXIST
		BEGIN
			RETURN 1
		END
		ELSE
		BEGIN
			INSERT INTO DATA.PatientCaretakers (UserID, CareTakerID) VALUES (@UserID, @CareTakerID)
		END
		RETURN 0
	END
	ELSE
		RETURN 1
GO

--select * from ref.UserTypes

--insert into ref.UserTypes(UserTypeMessage)values('Patient')
--insert into ref.UserTypes(UserTypeMessage)values('CareTaker')
--insert into ref.UserTypes(UserTypeMessage)values('Patient/CareTaker')



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
CREATE PROCEDURE DATA.AddBloodPressures @UserID int, @BloodPressure varchar(50)
AS
	IF ((@BloodPressure IS NOT NULL) OR (LEN(@BloodPressure) > 0)) AND EXISTS(SELECT * FROM DATA.Users WHERE UserID = @UserID)
	BEGIN
		INSERT INTO DATA.BloodPressures (UserID, BloodPressure) VALUES (@UserID, @BloodPressure)
		RETURN 0
	END
	ELSE
		RETURN 1
GO

IF OBJECT_ID('DATA.AddBloodGlucoseLevels', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddBloodGlucoseLevels;  
GO
CREATE PROCEDURE DATA.AddBloodGlucoseLevels @UserID int, @BloodGlucoseLevel varchar(50)
AS
	IF ((@BloodGlucoseLevel IS NOT NULL) OR (LEN(@BloodGlucoseLevel) > 0)) AND EXISTS(SELECT * FROM DATA.Users WHERE UserID = @UserID)
	BEGIN
		INSERT INTO DATA.BloodGlucoseLevels (UserID, BloodGlucoseLevel) VALUES (@UserID, @BloodGlucoseLevel)
		RETURN 0
	END
	ELSE
		RETURN 1
GO

IF OBJECT_ID('DATA.GetPatientReport', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.GetPatientReport;  
GO
CREATE PROCEDURE DATA.GetPatientReport @UserID int
AS
	IF (@UserID IS NOT NULL) AND EXISTS(SELECT * FROM DATA.Users WHERE UserID = @UserID)
	begin
		select * from DATA.ReportView where UserID = @UserID
	end
	else
		return 1
GO

IF OBJECT_ID('DATA.UserLogin ', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.UserLogin 
GO
CREATE PROCEDURE DATA.UserLogin  @LoginName varchar(max), @LoginPassword varchar(max), @returnValue int = -1 OUTPUT
AS
	IF (@LoginName IS NOT NULL) AND (@LoginPassword IS NOT NULL) AND EXISTS(SELECT * FROM DATA.Users WHERE LoginName = @LoginName AND LoginPassword = @LoginPassword)
	begin
		set @returnValue = (select top(1) ErrorMessageCodeID from ref.ErrorMessageCodes where ErrorMessageCodeID = 1)
	end
	else
		set @returnValue = (select top(1) ErrorMessageCodeID from ref.ErrorMessageCodes where ErrorMessageCodeID = 3)
GO




--IF OBJECT_ID('DATA.getMedicalConditions', 'P') IS NOT NULL  
--    DROP PROCEDURE DATA.getMedicalConditions
--GO
--CREATE PROCEDURE DATA.getMedicalConditions
--AS
--	Select * from REF.MedicalConditions
--GO

--create stored procedure ref.adddatatypes, ref.adderrormsg, for new ref and data tables

--declare @th int
--exec DATA.AddUser 'Patrick','Nwanah','Chukwudi','Godmode32','Godmode', 'Godmode4322@yahoo.com', 1, 1, @th output
--select @th
--go

--declare @th int
--exec Data.UserLogin 'Godmode','Godmode', @th output
--select @th

--select * from data.Users
--select * from ref.ErrorMessageCodes
--select * from ref.UserTypes

--declare @th int
--set @th = (select top(1) ErrorMessageCodeID from ref.ErrorMessageCodes where ErrorMessageCodeID = 1)
--go

--select top(1) ErrorMessageCodeID from ref.ErrorMessageCodes where ErrorMessageCodeID = 1




--select * from data.Users

--exec DATA.GetPatientReport 1
--select * from data.Users
--select * from data.reportview
--exec DATA.AddorUpdateUsers 'fsd','fd','asdf','dasf','dsfa','fda',1
--exec REF.AddorUpdateMedicalConditions 'None'


--IF OBJECT_ID('DATA.AddReports', 'P') IS NOT NULL  
--    DROP PROCEDURE DATA.AddReports;  
--GO
--CREATE PROCEDURE DATA.AddReportS @UserID int, @BloodGlucoseLevelID int, @BloodPressureID int , @MedicalConditionID int
--AS
--	IF (@UserID IS NOT NULL) 
--	BEGIN
--		INSERT INTO DATA.Reports (UserID, BloodGlucoseLevelID, BloodPressureID, @MedicalConditionID) VALUES (@UserID, @BloodGlucoseLevelID, @BloodPressureID, @MedicalConditionID)
--		RETURN 0
--	END
--	ELSE
--		RETURN 1
--GO

--need to create procedure for adding and dropping patient to guardian

--select * from sysobjects where xtype ='P' 

--select * from data.Users

--select * from ref.ErrorMessageCodes

--INSERT INTO REF.ErrorMessageCodes (CodeMessage) VALUES ('This is a Patient-Code 1') 
--INSERT INTO REF.ErrorMessageCodes (CodeMessage) VALUES ('This is a Caregiver-Code 2') 
--INSERT INTO REF.ErrorMessageCodes (CodeMessage) VALUES ('Login Failure-Code 3') 

--select * from ref.ErrorMessageCodes



--declare @temp int
--exec data.AddorUpdateGuardians 'Godless', 'Godless', 'Godless@gmail.com',  @temp output
--select @temp
--select * from data.Guardians




