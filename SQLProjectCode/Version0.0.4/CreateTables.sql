USE mats_user
GO
drop table REF.NormalHeartRatesMen
go
drop table REF.NormalHeartRatesWomen
go
drop table REF.BpRanges
go
drop table REF.BpTypes
go
drop table REF.NormalBloodPressures
go
drop table DATA.Alerts
go
drop table ref.UserTypes
go
drop table data.Notifications
go
DROP table AUDIT.HeartRate
GO
DROP table AUDIT.BloodGlucoseLevels
GO
DROP table AUDIT.BloodPressures
GO
DROP table AUDIT.Users
GO
DROP table DATA.BloodPressures
GO
DROP table DATA.BloodGlucoseLevels
GO
DROP table DATA.HeartRate
GO
DROP table REF.ErrorMessageCodes
GO
DROP table DATA.PatientCaretakers
GO
DROP table DATA.Users
GO
DROP table REF.MedicalConditions
GO
drop table ref.AlertMessages
go





	CREATE TABLE REF.MedicalConditions
	(
		MedicalConditionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
		MedicalConditionName VARCHAR(max),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
		
	)

GO

--ALTER TABLE REF.MedicalConditions
--ALTER COLUMN MedicalConditionName varchar(max);


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
		isHidden BINARY NOT NULL DEFAULT 0,
		Phonenumber varchar(11),
		PrimaryCaregiverID int,
		DateOfBirth DATE,
		Gender varchar(10),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (MedicalConditionID) REFERENCES REF.MedicalConditions(MedicalConditionID)
	)

GO


	CREATE TABLE AUDIT.Users
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)

GO





	CREATE TABLE DATA.BloodPressures
	(
		BloodPressureID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		BloodPressureHigh INT,
		BloodPressureLow INT,
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)

GO


	CREATE TABLE AUDIT.BloodPressures
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		BloodPressureID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (BloodPressureID) REFERENCES DATA.BloodPressures(BloodPressureID)
	)

GO


	CREATE TABLE DATA.BloodGlucoseLevels
	(
		BloodGlucoseLevelID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		BloodGlucoseLevel varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)

GO


	CREATE TABLE AUDIT.BloodGlucoseLevels
	(
		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		BloodGlucoseLevelID INT,
		Operation varchar(1),
		Change XML,
		DateAdded DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (BloodGlucoseLevelID) REFERENCES DATA.BloodGlucoseLevels(BloodGlucoseLevelID)
	)

GO



--ALTER TABLE DATA.Guardians drop column UserID


	CREATE TABLE REF.ErrorMessageCodes
	(
		ErrorMessageCodeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CodeMessage VARCHAR(MAX),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
	)

GO





CREATE TABLE DATA.PatientCaretakers
(
		PatientCaretakerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		CaretakerID INT,
		canViewBp bit default 0,
		canViewBGp bit default 0,
		canViewHr bit default 0,
		LastTextSent Datetime,
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE()
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID),
	FOREIGN KEY (CaretakerID) REFERENCES DATA.Users(UserID)
)
	ALTER TABLE DATA.PatientCaretakers ADD isHidden BINARY NOT NULL DEFAULT 0 --  1 means true and 0 means false. This is (false) in bit

GO



--IF object_id('AUDIT.PatientCaretakers') IS NULL
--BEGIN
--	CREATE TABLE AUDIT.PatientCaretakers
--	(
--		AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
--		PatientCaretakerID INT,
--		Operation varchar(1),
--		Change XML,
--		DateAdded DATETIME DEFAULT GETDATE(),
--		FOREIGN KEY (PatientCaretakerID) REFERENCES DATA.PatientCaretakers(PatientCaretakerID)
--	)
--END
--GO


	CREATE TABLE DATA.HeartRate
	(
		HeartRateID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserID INT,
		HeartRate varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
		FOREIGN KEY (UserID) REFERENCES DATA.Users(UserID)
	)

GO



CREATE TABLE AUDIT.HeartRate
(
	AuditID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	HeartRateID INT,
	Operation varchar(1),
	Change XML,
	DateAdded DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (HeartRateID) REFERENCES DATA.HeartRate(HeartRateID)
)
GO


	CREATE TABLE REF.AlertMessages
	(
		AlertMessageID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		AlertMessage varchar(50),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
	)

GO


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

GO







	CREATE TABLE REF.UserTypes
	(
		UserTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		UserTypeMessage varchar(max),
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
	)

GO




IF object_id('DATA.Notifications') IS NULL
BEGIN
	CREATE TABLE DATA.Notifications
	(
		NotificationID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		NotificationMessage varchar(max),
		Origin varchar(50),
		Destination varchar(50),
		isRespondedTo BINARY NOT NULL DEFAULT 0, -- (false) in binary 1 means true and 0 means false
		DateAdded DATETIME DEFAULT GETDATE(),
		ModificationDate DATETIME DEFAULT GETDATE(),
	)
END
GO
create table REF.BpTypes
(
	BpTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	BpType varchar(50),
	DateAdded DATETIME DEFAULT GETDATE(),
	ModificationDate DATETIME DEFAULT GETDATE()
)
go
insert into REF.BpTypes (BpType) values ('Low')
insert into REF.BpTypes (BpType) values ('Normal')
insert into REF.BpTypes (BpType) values ('High')
go

create table REF.BpRanges
(
	BpRange INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	BloodPressureHigh int,
	BloodPressureLow int,
	BpRangeMessage varchar(max),
	BpTypeID int,
	DateAdded DATETIME DEFAULT GETDATE(),
	ModificationDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (BpTypeID) REFERENCES REF.BpTypes(BpTypeID)
)
go
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (90,60,'Borderline Low blood Pressure',1)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (60,40,'Too Low Blood Pressure',1)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (50,33,'Dangerously Low Blood Pressure',1)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (130,85,'High Normal Blood Pressure',2)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (120,80,'Normal Blood Pressure',2)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (110,75,'Low Normal Blood Pressure',2)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (210,120,'Stage 4 Hypertension',3)--HyperTension
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (180,110,'Stage 3 Hypertension',3)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (160,100,'Stage 2 Hypertension',3)
insert into REF.BpRanges (BloodPressureHigh,BloodPressureLow,BpRangeMessage,BpTypeID) values (140,90,'Stage 1 Hypertension',3)
go


create table REF.NormalBloodPressures
(
	NormalBp INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	Age INT NOT NULL UNIQUE,
	BloodPresureHigh int,
	BloodPressureLow int,
	DateAdded DATETIME DEFAULT GETDATE(),
	ModificationDate DATETIME DEFAULT GETDATE()
)
go

create table REF.NormalHeartRatesMen
(
	NormalHr INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	Age INT NOT NULL UNIQUE,
	Athlete varchar(10),
	Excellent varchar(10),
	Good varchar(10),
	AboveAverage varchar(10),
	Average varchar(10),
	BelowAverage varchar(10),
	Poor varchar(10),
	DateAdded DATETIME DEFAULT GETDATE(),
	ModificationDate DATETIME DEFAULT GETDATE()
)
go


create table REF.NormalHeartRatesWomen
(
	NormalHr INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	Age INT NOT NULL UNIQUE,
	Athlete varchar(10),
	Excellent varchar(10),
	Good varchar(10),
	AboveAverage varchar(10),
	Average varchar(10),
	BelowAverage varchar(10),
	Poor varchar(10),
	DateAdded DATETIME DEFAULT GETDATE(),
	ModificationDate DATETIME DEFAULT GETDATE()
)
go




insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (1,119,75);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (2,119,75);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (3,119,75);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (4,116,76);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (5,116,76);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (6,116,76);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (7,122,78);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (8,122,78);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (9,122,78);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (10,122,78);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (11,126,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (12,126,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (13,126,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (14,136,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (15,136,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (16,136,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (17,120,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (18,120,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (19,120,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (20,120,79);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (21,120,79);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (22,120,79);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (23,120,79);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (24,120,79);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (25,121,80);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (26,121,80);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (27,121,80);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (28,121,80);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (29,121,80);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (30,122,81);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (31,122,81);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (32,122,81);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (33,122,81);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (34,122,81);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (35,123,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (36,123,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (37,123,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (38,123,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (39,123,82);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (40,125,83);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (41,125,83);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (42,125,83);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (43,125,83);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (44,125,83);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (45,127,84);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (46,127,84);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (47,127,84);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (48,127,84);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (49,127,84);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (50,129,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (51,129,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (52,129,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (53,129,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (54,129,85);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (55,131,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (56,131,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (57,131,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (58,131,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (59,131,86);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (60,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (61,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (62,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (63,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (64,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (65,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (66,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (67,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (68,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (69,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (70,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (71,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (72,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (73,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (74,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (75,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (76,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (77,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (78,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (79,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (80,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (81,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (82,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (83,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (84,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (85,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (86,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (87,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (88,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (89,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (90,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (91,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (92,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (93,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (94,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (95,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (96,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (97,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (98,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (99,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (100,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (101,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (102,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (103,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (104,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (105,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (106,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (107,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (108,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (109,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (110,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (111,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (112,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (113,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (114,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (115,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (116,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (117,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (118,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (119,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (120,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (121,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (122,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (123,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (124,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (125,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (126,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (127,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (128,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (129,134,87);
insert into REF.NormalBloodPressures (age,BloodPresureHigh,BloodPressureLow) values (130,134,87);


go



exec ref.AddorUpdateMedicalConditions 'Diabetes Type A'
go
exec ref.AddorUpdateMedicalConditions 'Diabetes Type B'
go
exec ref.AddorUpdateMedicalConditions 'High Blood Pressure'
go
exec ref.AddorUpdateMedicalConditions 'Low Blood Pressure'
go

insert into ref.UserTypes(UserTypeMessage)values('Patient')
go
insert into ref.UserTypes(UserTypeMessage)values('CareTaker')
go
insert into ref.UserTypes(UserTypeMessage)values('Patient/CareTaker')
go



INSERT INTO REF.ErrorMessageCodes (CodeMessage) VALUES ('This is a Patient-Code 1') 
go
INSERT INTO REF.ErrorMessageCodes (CodeMessage) VALUES ('This is a Caregiver-Code 2') 
go
INSERT INTO REF.ErrorMessageCodes (CodeMessage) VALUES ('Login Failure-Code 3') 
go