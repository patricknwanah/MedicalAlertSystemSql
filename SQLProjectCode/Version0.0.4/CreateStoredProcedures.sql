---CREATE STORED PROCEDURES
USE mats_user
GO
IF OBJECT_ID('DATA.AddUser', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.AddUser;  
GO 
CREATE PROCEDURE DATA.AddUser @FirstName varchar(50), @LastName varchar(50), @MiddleName varchar(50), @LoginName varchar(50), @LoginPassword varchar(50), @EmailAddress varchar(50), @MedicalConditionID int , @UserType int, @PhoneNumber varchar(11), @DateOfBirth varchar(10), @Gender varchar(10), @returnValue int = -1 OUTPUT
AS
	IF ((@FirstName IS NOT NULL) OR (LEN(@FirstName) > 0))  AND ((@LastName IS NOT NULL) OR (LEN(@LastName) > 0)) AND ((@LoginName IS NOT NULL) OR (LEN(@LoginName) > 0)) AND ((@LoginPassword IS NOT NULL) OR (LEN(@LoginPassword) > 0)) AND ((@EmailAddress IS NOT NULL) OR (LEN(@EmailAddress) > 0)) AND (@UserType IS NOT NULL) AND (@PhoneNumber IS NOT NULL) and (@DateOfBirth is not null) and (@Gender is not null or len(@Gender)>0)
	BEGIN
		IF NOT EXISTS(SELECT * FROM DATA.Users WHERE EmailAddress like @EmailAddress) AND NOT EXISTS(SELECT * FROM DATA.Users WHERE LoginName like @LoginName)--INSERT and checks that email and loginname does not already exist
		BEGIN
			DECLARE @temp date
			set @temp = CONVERT(date,@DateOfBirth,104)
			INSERT INTO DATA.Users (FirstName , LastName, MiddleName, LoginName, LoginPassword, EmailAddress, MedicalConditionID, UserType, PhoneNumber, DateOfBirth, Gender) VALUES (@FirstName, @LastName, @MiddleName, @LoginName, @LoginPassword, @EmailAddress, @MedicalConditionID, @UserType, @PhoneNumber, @temp, @Gender) 
			set @returnValue = 0
		END
		ELSE -- UPDATE
		BEGIN
			set @temp = CONVERT(date,@DateOfBirth,104)
			UPDATE DATA.Users SET FirstName = @FirstName, LastName = @LastName, MiddleName = @MiddleName, LoginName = @LoginName, LoginPassword  = @LoginPassword, MedicalConditionID = @MedicalConditionID, PhoneNumber = @PhoneNumber, DateOfBirth = @temp , ModificationDate = GETDATE() WHERE EmailAddress like @EmailAddress
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
		IF NOT EXISTS(SELECT * FROM DATA.Users WHERE UserID = @CareTakerID AND (UserType = 3 OR UserType = 2)) OR NOT EXISTS(SELECT * FROM DATA.Users WHERE UserID = @UserID)--PATIENT OR GUARDIANS DO NOT EXIST
		BEGIN
			RETURN 1
		END
		IF EXISTS(SELECT * FROM DATA.PatientCaretakers WHERE UserID = @UserID AND CareTakerID = @CareTakerID)
		BEGIN
			RETURN 1
		END
		ELSE
		BEGIN
			INSERT INTO DATA.PatientCaretakers (UserID, CareTakerID) VALUES (@UserID, @CareTakerID)
			DELETE FROM DATA.Notifications WHERE Origin = (select top 1 loginname from DATA.Users where userid = @UserID) and Destination = (select top 1 loginname from DATA.Users where userid = @CareTakerID) 
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
CREATE PROCEDURE DATA.AddBloodPressures @UserID int, @BloodPressureHigh int, @BloodPressureLow int
AS
	IF (@BloodPressureHigh IS NOT NULL) and (@BloodPressureLow IS NOT NULL) AND EXISTS(SELECT * FROM DATA.Users WHERE UserID = @UserID)
	BEGIN
		INSERT INTO DATA.BloodPressures (UserID, BloodPressureHigh, BloodPressureLow) VALUES (@UserID, @BloodPressureHigh, @BloodPressureLow)
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




IF OBJECT_ID('DATA.getMedicalConditions', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getMedicalConditions
GO
CREATE PROCEDURE DATA.getMedicalConditions
AS
	Select * from REF.MedicalConditions order by MedicalConditionName asc
GO

IF OBJECT_ID('DATA.getBloodPressures', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getBloodPressures
GO
CREATE PROCEDURE DATA.getBloodPressures
AS
	Select * from DATA.BloodPressures order by DateAdded asc
GO




IF OBJECT_ID('DATA.getHeartRates', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getHeartRates
GO
CREATE PROCEDURE DATA.getHeartRates	
AS
	Select * from DATA.HeartRate order by DateAdded asc
GO

IF OBJECT_ID('DATA.getBloodGlucose', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getBloodGlucose
GO
CREATE PROCEDURE DATA.getBloodGlucose
AS
	Select * from DATA.BloodGlucoseLevels order by DateAdded asc
GO



IF OBJECT_ID('DATA.getCareGivers', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getCareGivers
GO
CREATE PROCEDURE DATA.getCareGivers
AS
	select firstname, middlename, lastname, LoginName from data.Users where UserType = 2 or UserType = 3 order by loginname ASC
GO

IF OBJECT_ID('DATA.requestCareGiver', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.requestCareGiver;  
GO
CREATE PROCEDURE DATA.requestCareGiver @Origin varchar(50), @Destination varchar(50), @returnValue int = -1 OUTPUT
AS
	IF @Origin IS NOT NULL AND @Destination IS NOT NULL AND NOT EXISTS(SELECT * FROM DATA.Notifications WHERE Origin = @Origin AND Destination = @Destination)
	BEGIN
		Declare @UserID int
		set @UserID = (select userid from data.Users where loginname = @Origin)
		Declare @CareGiverID int
		set @CareGiverID = (select userid from data.Users where loginname = @Destination)
		IF EXISTS(SELECT * FROM DATA.PatientCaretakers WHERE userid = @UserID and caretakerid = @CareGiverID)
		BEGIN
			SET @returnValue = -1
		END
		ELSE
		BEGIN
			INSERT INTO DATA.Notifications (NotificationMessage, Origin, Destination) VALUES (@Origin + ' wants to add you as a caregiver', @Origin, @Destination)
			set @returnValue = 1
		END
	END
	ELSE
		set @returnValue = -1
GO


IF OBJECT_ID('DATA.getPendingCareGivers', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getPendingCareGivers
GO
CREATE PROCEDURE DATA.getPendingCareGivers @LoginName varchar(max)
AS
	select Destination from DATA.Notifications where Origin = @LoginName AND isRespondedTo = 0 order by Destination ASC
GO

IF OBJECT_ID('DATA.getUserCareGivers', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getUserCareGivers
GO
CREATE PROCEDURE DATA.getUserCareGivers @PatientName varchar(50)
AS
	Declare @UserID int
	set @UserID = (select userid from data.Users where loginname = @PatientName)
	select Userid CaretakerID, firstname, middlename, lastname, loginname  from data.users where userid in (select caretakerid from data.PatientCaretakers where userid = @UserID) order by loginname asc
GO



IF OBJECT_ID('DATA.getUser', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getUser
GO
CREATE PROCEDURE DATA.getUser @LoginName varchar(50)
AS
	select * from data.users where loginname = @LoginName order by loginname asc
GO



IF OBJECT_ID('DATA.deleteCareGiver', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.deleteCareGiver
GO
CREATE PROCEDURE DATA.deleteCareGiver @PatientName varchar(50), @CareGiverName varchar(50), @returnValue int = -1 OUTPUT
AS
	IF (@PatientName IS NOT NULL and LEN(@PatientName) > 0) and (@CareGiverName IS NOT NULL and LEN(@CareGiverName) > 0)
	begin
		Declare @UserID int
		set @UserID = (select userid from data.Users where loginname = @PatientName)
		Declare @CareGiverID int
		set @CareGiverID = (select userid from data.Users where loginname = @CareGiverName)
		delete from DATA.PatientCaretakers WHERE UserID = @UserID and CaretakerID = @CareGiverID
		if @CareGiverID = (select primarycaregiverid from data.users where userid = @UserID)
		begin
			update data.users set primarycaregiverid = null where userid = @UserID
		end
		set @returnValue = 1
	end
	else
		set @returnValue = -1
GO



IF OBJECT_ID('DATA.setPrimaryCareGiver', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.setPrimaryCareGiver
GO
CREATE PROCEDURE DATA.setPrimaryCareGiver @PatientName varchar(50), @CareGiverName varchar(50), @returnValue int = -1 OUTPUT
AS
	IF (@PatientName IS NOT NULL and LEN(@PatientName) > 0) and (@CareGiverName IS NOT NULL and LEN(@CareGiverName) > 0)
	begin
		Declare @UserID int
		set @UserID = (select userid from data.Users where loginname = @PatientName)
		Declare @CareGiverID int
		set @CareGiverID = (select userid from data.Users where loginname = @CareGiverName)
		IF @CareGiverID = (select primarycaregiverid from data.users where userid = @UserID)
		begin
			UPDATE DATA.Users SET primarycaregiverid = null where userid = @UserID
			set @returnValue = 3
		end
		else
		begin
			UPDATE DATA.Users SET primarycaregiverid = @CareGiverID where userid = @UserID
			set @returnValue = 1
		end
	end
	else
		set @returnValue = -1
GO


IF OBJECT_ID('DATA.getPrimaryCareGiver', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getPrimaryCareGiver
GO
CREATE PROCEDURE DATA.getPrimaryCareGiver @PatientName varchar(50)
AS
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	select loginname from data.Users where userid = (select primaryCaregiverid from data.Users where userid = @UserID) order by loginname asc
GO

IF OBJECT_ID('DATA.getAge', 'P') IS NOT NULL  
    DROP PROCEDURE DATA.getAge
GO
CREATE PROCEDURE DATA.getAge @PatientName varchar(50), @returnValue int output
AS
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	declare @date1 date
	set @date1 = (select dateofbirth from DATA.users where userid = @UserID)
	set @returnValue = (select DATEDIFF ( YEAR , @date1 ,GETDATE()) )
GO


drop procedure DATA.getTodaysAverage
go
create procedure DATA.getTodaysAverage @PatientName varchar(50), @ago int
as
	if @ago = null or @ago = 0
	begin
		set @ago = 24
	end
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	select BloodPressureHigh,BloodPressureLow,DateAdded from DATA.bloodpressures where userid = @UserID and DateAdded >= DATEADD(hh, -@ago, GETDATE()) order by dateadded asc
go


drop procedure DATA.getGlucoseTodaysAverage
go
create procedure DATA.getGlucoseTodaysAverage @PatientName varchar(50), @ago int
as
	if @ago = null or @ago = 0
	begin
		set @ago = 24
	end
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	select BloodGlucoseLevel,DateAdded from data.BloodGlucoseLevels where userid = @UserID and DateAdded >= DATEADD(hh, -@ago, GETDATE()) order by dateadded asc
go



drop procedure DATA.getHeartRateTodaysAverage
go
create procedure DATA.getHeartRateTodaysAverage @PatientName varchar(50), @ago int
as
	if @ago = null or @ago = 0
	begin
		set @ago = 24
	end
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	select HeartRate,DateAdded from data.HeartRate where userid = @UserID and DateAdded >= DATEADD(hh, -@ago, GETDATE()) order by dateadded asc
go




drop procedure DATA.getWeeklyAverage
go
create procedure DATA.getWeeklyAverage @PatientName varchar(50), @week int 
as
	declare @start datetime
	declare @end datetime
	if @week = 1
	begin
		set @start = DATEADD(DAY,-30,GETDATE())
		set @end = DATEADD(DAY,-23,GETDATE())
	end
	else if @week = 2
	begin
		set @start = DATEADD(DAY,-22,GETDATE())
		set @end = DATEADD(DAY,-15,GETDATE())
	end
	else if @week = 3
	begin
		set @start = DATEADD(DAY,-14,GETDATE())
		set @end = DATEADD(DAY,-7,GETDATE())
	end
	else if @week = 4
	begin
		set @start = DATEADD(DAY,-6,GETDATE())
		set @end = DATEADD(DAY,0,GETDATE())
	end
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	select BloodPressureHigh,BloodPressureLow,DATEPART(wk, dateadded) as TheWeek from DATA.bloodpressures where userid = @UserID and dateadded >= @start and dateadded <= @end
go


drop procedure DATA.getHeartRateWeeklyAverage
go
create procedure DATA.getHeartRateWeeklyAverage @PatientName varchar(50), @week int 
as
	declare @start datetime
	declare @end datetime
	if @week = 1
	begin
		set @start = DATEADD(DAY,-30,GETDATE())
		set @end = DATEADD(DAY,-23,GETDATE())
	end
	else if @week = 2
	begin
		set @start = DATEADD(DAY,-22,GETDATE())
		set @end = DATEADD(DAY,-15,GETDATE())
	end
	else if @week = 3
	begin
		set @start = DATEADD(DAY,-14,GETDATE())
		set @end = DATEADD(DAY,-7,GETDATE())
	end
	else if @week = 4
	begin
		set @start = DATEADD(DAY,-6,GETDATE())
		set @end = DATEADD(DAY,0,GETDATE())
	end
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	select HeartRate,DATEPART(wk, dateadded) as TheWeek from DATA.HeartRate where userid = @UserID and dateadded >= @start and dateadded <= @end
go


exec data.getGlucoseWeeklyAverage 'Godmode', 4

drop procedure DATA.getGlucoseWeeklyAverage
go
create procedure DATA.getGlucoseWeeklyAverage @PatientName varchar(50), @week int 
as
	declare @start datetime
	declare @end datetime
	if @week = 1
	begin
		set @start = DATEADD(DAY,-30,GETDATE())
		set @end = DATEADD(DAY,-23,GETDATE())
	end
	else if @week = 2
	begin
		set @start = DATEADD(DAY,-22,GETDATE())
		set @end = DATEADD(DAY,-15,GETDATE())
	end
	else if @week = 3
	begin
		set @start = DATEADD(DAY,-14,GETDATE())
		set @end = DATEADD(DAY,-7,GETDATE())
	end
	else if @week = 4
	begin
		set @start = DATEADD(DAY,-6,GETDATE())
		set @end = DATEADD(DAY,0,GETDATE())
	end
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	select BloodGlucoseLevel,DATEPART(wk, dateadded) as TheWeek from DATA.BloodGlucoseLevels where userid = @UserID and dateadded >= @start and dateadded <= @end
go



drop procedure DATA.getMonthlyAverage
go
create procedure DATA.getMonthlyAverage @PatientName varchar(50), @month int 
as
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	declare @start datetime
	declare @end datetime
	if @month = 1
	begin
		set @start = DATEADD(MONTH,-11,GETDATE())
	end
	else if @month = 2
	begin
		set @start = DATEADD(MONTH,-10,GETDATE())
	end
	else if @month = 3
	begin
		set @start = DATEADD(MONTH,-9,GETDATE())
	end
	else if @month = 4
	begin
		set @start = DATEADD(MONTH,-8,GETDATE())
	end
	else if @month = 5
	begin
		set @start = DATEADD(MONTH,-7,GETDATE())
	end
	else if @month = 6
	begin
		set @start = DATEADD(MONTH,-6,GETDATE())
	end
	else if @month = 7
	begin
		set @start = DATEADD(MONTH,-5,GETDATE())
	end
	else if @month = 8
	begin
		set @start = DATEADD(MONTH,-4,GETDATE())
	end
	else if @month = 9
	begin
		set @start = DATEADD(MONTH,-3,GETDATE())
	end
	else if @month = 10
	begin
		set @start = DATEADD(MONTH,-2,GETDATE())
	end
	else if @month = 11
	begin
		set @start = DATEADD(MONTH,-1,GETDATE())
	end
	else if @month = 12
	begin
		set @start = DATEADD(MONTH,0,GETDATE())
	end
	select BloodPressureHigh,BloodPressureLow,DATENAME(month, DATEADD(month, month(dateadded)-1, CAST('2008-01-01' AS datetime))) as TheMonth from DATA.bloodpressures where userid = @UserID and month(dateadded) = month(@start)
go



drop procedure DATA.getHeartRateMonthlyAverage
go
create procedure DATA.getHeartRateMonthlyAverage @PatientName varchar(50), @month int 
as
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	declare @start datetime
	declare @end datetime
	if @month = 1
	begin
		set @start = DATEADD(MONTH,-11,GETDATE())
	end
	else if @month = 2
	begin
		set @start = DATEADD(MONTH,-10,GETDATE())
	end
	else if @month = 3
	begin
		set @start = DATEADD(MONTH,-9,GETDATE())
	end
	else if @month = 4
	begin
		set @start = DATEADD(MONTH,-8,GETDATE())
	end
	else if @month = 5
	begin
		set @start = DATEADD(MONTH,-7,GETDATE())
	end
	else if @month = 6
	begin
		set @start = DATEADD(MONTH,-6,GETDATE())
	end
	else if @month = 7
	begin
		set @start = DATEADD(MONTH,-5,GETDATE())
	end
	else if @month = 8
	begin
		set @start = DATEADD(MONTH,-4,GETDATE())
	end
	else if @month = 9
	begin
		set @start = DATEADD(MONTH,-3,GETDATE())
	end
	else if @month = 10
	begin
		set @start = DATEADD(MONTH,-2,GETDATE())
	end
	else if @month = 11
	begin
		set @start = DATEADD(MONTH,-1,GETDATE())
	end
	else if @month = 12
	begin
		set @start = DATEADD(MONTH,0,GETDATE())
	end
	select HeartRate,DATENAME(month, DATEADD(month, month(dateadded)-1, CAST('2008-01-01' AS datetime))) as TheMonth from DATA.HeartRate where userid = @UserID and month(dateadded) = month(@start)
go




drop procedure DATA.getGlucoseMonthlyAverage
go
create procedure DATA.getGlucoseMonthlyAverage @PatientName varchar(50), @month int 
as
	declare @UserID int
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	declare @start datetime
	declare @end datetime
	if @month = 1
	begin
		set @start = DATEADD(MONTH,-11,GETDATE())
	end
	else if @month = 2
	begin
		set @start = DATEADD(MONTH,-10,GETDATE())
	end
	else if @month = 3
	begin
		set @start = DATEADD(MONTH,-9,GETDATE())
	end
	else if @month = 4
	begin
		set @start = DATEADD(MONTH,-8,GETDATE())
	end
	else if @month = 5
	begin
		set @start = DATEADD(MONTH,-7,GETDATE())
	end
	else if @month = 6
	begin
		set @start = DATEADD(MONTH,-6,GETDATE())
	end
	else if @month = 7
	begin
		set @start = DATEADD(MONTH,-5,GETDATE())
	end
	else if @month = 8
	begin
		set @start = DATEADD(MONTH,-4,GETDATE())
	end
	else if @month = 9
	begin
		set @start = DATEADD(MONTH,-3,GETDATE())
	end
	else if @month = 10
	begin
		set @start = DATEADD(MONTH,-2,GETDATE())
	end
	else if @month = 11
	begin
		set @start = DATEADD(MONTH,-1,GETDATE())
	end
	else if @month = 12
	begin
		set @start = DATEADD(MONTH,0,GETDATE())
	end
	select BloodGlucoseLevel,DATENAME(month, DATEADD(month, month(dateadded)-1, CAST('2008-01-01' AS datetime))) as TheMonth from DATA.BloodGlucoseLevels where userid = @UserID and month(dateadded) = month(@start)
go




Drop procedure Data.getUserAge 
go
Create procedure Data.getUserAge @PatientName varchar(50) 
as
	declare @UserID int
	declare @dob date
	set @UserID = (select userid from DATA.Users where loginname = @PatientName)
	set @dob = (select DateOfBirth from data.users where userid = @UserID)
	DECLARE @FromDate DATE = @dob
    Declare @ToDate DATE = GetDate()
	SELECT @FromDate 'From Date', @ToDate 'To Date',
	DATEDIFF(YEAR, @FromDate, @ToDate)-(CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @FromDate,@ToDate), @FromDate)> @ToDate THEN 1 ELSE 0 END) 'Age'
go


drop procedure DATA.getBpNorm --get normal blood pressure and your blood pressure anaylysis
go
create procedure DATA.getBpNorm @age int
as
	declare @bpnormh int = (select bp.BloodPresureHigh from ref.NormalBloodPressures bp where bp.age = @age)
	declare @bpnorml int = (select bp.BloodPressureLow from ref.NormalBloodPressures bp where bp.age = @age)

	select @bpnormh BpHigh,@bpnorml BpLow

go

drop procedure DATA.getAnalysis --get normal blood pressure and your blood pressure anaylysis
go
create procedure DATA.getAnalysis @high float, @low float
as

	SELECT TOP 1 BpRangeMessage FROM REF.BpRanges ORDER BY ABS( BloodPressureHigh - @high), ABS(BloodPressureLow - @low) 
go

drop procedure DATA.automatedTextApproval
go
create procedure DATA.automatedTextApproval @PatientName varchar(50), @CareGiverName varchar(50), @returnValue int output
as
	Declare @UserID int
	set @UserID = (select userid from data.Users where loginname = @PatientName)
	Declare @CareGiverID int
	set @CareGiverID = (select userid from data.Users where loginname = @CareGiverName)
	Declare @lastTest datetime
	set @lastTest = (select LastTextSent from DATA.PatientCaretakers where UserID = @UserID and CaretakerID = @CareGiverID)
	if @lastTest is not null
	begin
		Declare @dayspast int = (SELECT DATEDIFF(DAY, @lastTest, GETDATE()))
		if @dayspast >= 2--allowed to send another message
		begin
			set @returnValue = 0
			update DATA.PatientCaretakers set LastTextSent = GETDATE() where UserID = @UserID and CaretakerID = @CareGiverID
		end
		else
		begin
			set @returnValue = 1
		end
	end
	else
	begin
		set @returnValue = 0
		update DATA.PatientCaretakers set LastTextSent = GETDATE() where UserID = @UserID and CaretakerID = @CareGiverID
	end
go



drop procedure DATA.getCareGiverPhoneNumber
go
create procedure DATA.getCareGiverPhoneNumber @CareGiverName varchar(50)
as 
	Declare @CareGiverID int
	set @CareGiverID = (select userid from data.Users where loginname = @CareGiverName)

	select phonenumber from data.Users where userid = @CareGiverID
go

--exec DATA.getCareGiverPhoneNumber 'Salona1'



exec DATA.getBpNorm 23

exec DATA.getAnalysis 0,0


select * from ref.NormalBloodPressures

exec Data.getUserAge 'Godmode'

select * from data.BloodGlucoseLevels









select month(GETDATE())
SELECT DATENAME(month, DATEADD(month, month(GETDATE())-1, CAST('2008-01-01' AS datetime)))
SELECT DATEADD(MONTH,-1,GETDATE())
SELECT DATEPART(wk, GETDATE())
exec DATA.getMonthlyAverage 'Godmode', 12
exec DATA.getWeeklyAverage 'Godmode', 4
exec DATA.getTodaysAverage 'Godmode', 0





select DATEADD(DAY,6,GETDATE())
select BloodPressureHigh,BloodPressureLow, DATEPART(wk, dateadded) as TheWeek from DATA.bloodpressures where userid = 1 and (dateadded >= DATEADD(DAY,-6,GETDATE()) and dateadded <= DATEADD(DAY,0,GETDATE()))
select * from data.bloodpressures










--UPDATE DATA.Users SET primarycaregiverid = 7 where userid = 1
--Select * from data.BloodPressures
--select * from data.users where usertype = 2 or usertype = 3
--exec data.AddorUpdatePatientCaretakers 1, 2
--select * from data.Notifications
--exec data.setPrimaryCareGiver 'Godmode','htmehjuiy786'
--exec data.getPrimaryCareGiver 'Godmode'
--select * from data.Users
--select * from DATA.PatientCaretakers
--exec Data.deleteCareGiver  'Godmode', 'htmehjuiy786'






--SELECT * FROM DATA.Notifications WHERE Origin = 'Godmode' AND Destination = 'htmehjuiy786'



--select * from DATA.Notifications

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



--select * from ref.ErrorMessageCodes



--declare @temp int
--exec data.AddorUpdateGuardians 'Godless', 'Godless', 'Godless@gmail.com',  @temp output
--select @temp
--select * from data.Guardians




