DROP TRIGGER DATA.TrBloodGlucoseLevels
GO
CREATE TRIGGER DATA.TrBloodGlucoseLevels 
ON DATA.BloodGlucoseLevels 
AFTER INSERT, UPDATE, DELETE   
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @operation as varchar(1);
	DECLARE @id as int;
	DECLARE @change xml;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		IF EXISTS (SELECT 1 FROM deleted)
		BEGIN
			set @operation = 'U';
			set @id = (SELECT BloodGlucoseLevelID FROM deleted);
			set @change = (SELECT * FROM deleted FOR XML AUTO);
			INSERT INTO AUDIT.BloodGlucoseLevels (BloodGlucoseLevelID, Operation, Change) Values (@id, @operation, @change)
			-- I am an update
		END
		ELSE
		BEGIN
			set @Operation = 'I'
			set @id = (SELECT BloodGlucoseLevelID FROM inserted);
			set @change = (SELECT * FROM inserted FOR XML AUTO);
			INSERT INTO AUDIT.BloodGlucoseLevels (BloodGlucoseLevelID, Operation, Change) Values (@id, @operation, @change)
			-- I am an insert
		END
	END
	ELSE
	BEGIN
		set @Operation = 'D'
		set @id = (SELECT BloodGlucoseLevelID FROM deleted);
		set @change = (SELECT * FROM deleted FOR XML AUTO);
		INSERT INTO AUDIT.BloodGlucoseLevels (BloodGlucoseLevelID, Operation, Change) Values (@id, @operation, @change)
		-- I am a delete
	END
END
GO

DROP TRIGGER DATA.TrBloodPressures
GO
CREATE TRIGGER DATA.TrBloodPressures
ON DATA.BloodPressures 
AFTER INSERT, UPDATE, DELETE   
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @operation as varchar(1);
	DECLARE @id as int;
	DECLARE @change xml;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		IF EXISTS (SELECT 1 FROM deleted)
		BEGIN
			set @operation = 'U';
			set @id = (SELECT BloodPressureID FROM deleted);
			set @change = (SELECT * FROM deleted FOR XML AUTO);
			INSERT INTO AUDIT.BloodPressures (BloodPressureID, Operation, Change) Values (@id, @operation, @change)
			-- I am an update
		END
		ELSE
		BEGIN
			set @Operation = 'I'
			set @id = (SELECT BloodPressureID FROM inserted);
			set @change = (SELECT * FROM inserted FOR XML AUTO);
			INSERT INTO AUDIT.BloodPressures (BloodPressureID, Operation, Change) Values (@id, @operation, @change)
			-- I am an insert
		END
	END
	ELSE
	BEGIN
		set @Operation = 'D'
		set @id = (SELECT BloodPressureID FROM deleted);
		set @change = (SELECT * FROM deleted FOR XML AUTO);
		INSERT INTO AUDIT.BloodPressures (BloodPressureID, Operation, Change) Values (@id, @operation, @change)
		-- I am a delete
	END
END 
GO



DROP TRIGGER DATA.TrPatientCaretakers
GO
CREATE TRIGGER DATA.TrPatientCaretakers
ON DATA.PatientCaretakers
AFTER INSERT, UPDATE, DELETE   
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @operation as varchar(1);
	DECLARE @id as int;
	DECLARE @change xml;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		IF EXISTS (SELECT 1 FROM deleted)
		BEGIN
			set @operation = 'U';
			set @id = (SELECT PatientCaretakerID FROM deleted);
			set @change = (SELECT * FROM deleted FOR XML AUTO, BINARY BASE64);
			INSERT INTO AUDIT.PatientCaretakers (PatientCaretakerID, Operation, Change) Values (@id, @operation, @change)
			-- I am an update
		END
		ELSE
		BEGIN
			set @Operation = 'I'
			set @id = (SELECT PatientCaretakerID FROM inserted);
			set @change = (SELECT * FROM inserted FOR XML AUTO, BINARY BASE64);
			INSERT INTO AUDIT.PatientCaretakers (PatientCaretakerID, Operation, Change) Values (@id, @operation, @change)
			-- I am an insert
		END
	END
	ELSE
	BEGIN
		set @Operation = 'D'
		set @id = (SELECT PatientCaretakerID FROM deleted);
		set @change = (SELECT * FROM deleted FOR XML AUTO, BINARY BASE64);
		INSERT INTO AUDIT.PatientCaretakers (PatientCaretakerID, Operation, Change) Values (@id, @operation, @change)
		-- I am a delete
	END
END
GO


DROP TRIGGER DATA.TrUsers
GO
CREATE TRIGGER DATA.TrUsers
ON DATA.Users
AFTER INSERT, UPDATE, DELETE   
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @operation as varchar(1);
	DECLARE @id as int;
	DECLARE @change xml;
	IF EXISTS (SELECT 1 FROM inserted)
	BEGIN
		IF EXISTS (SELECT 1 FROM deleted)
		BEGIN
			set @operation = 'U';
			set @id = (SELECT UserID FROM deleted);
			set @change = (SELECT * FROM deleted FOR XML AUTO, BINARY BASE64);
			INSERT INTO AUDIT.Users (UserID, Operation, Change) Values (@id, @operation, @change)
			-- I am an update
		END
		ELSE
		BEGIN
			set @Operation = 'I'
			set @id = (SELECT UserID FROM inserted);
			set @change = (SELECT * FROM inserted FOR XML AUTO, BINARY BASE64);
			INSERT INTO AUDIT.Users (UserID, Operation, Change) Values (@id, @operation, @change)
			-- I am an insert
		END
	END
	ELSE
	BEGIN
		set @Operation = 'D'
		set @id = (SELECT UserID FROM deleted);
		set @change = (SELECT * FROM deleted FOR XML AUTO, BINARY BASE64);
		INSERT INTO AUDIT.Users (UserID, Operation, Change) Values (@id, @operation, @change)
		-- I am a delete
	END
END