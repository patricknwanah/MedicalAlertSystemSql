insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,190,80)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,190,40)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,150,80)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,190,20)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,190,80)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,100,80)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,190,70)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,190,80)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,180,80)
insert into data.bloodpressures (UserID,BloodPressureHigh,BloodPressureLow) values (1,190,50)




insert into data.BloodGlucoseLevels(UserID,BloodGlucoseLevel) values (1,10)
insert into data.BloodGlucoseLevels(UserID,BloodGlucoseLevel) values (1,8)
insert into data.BloodGlucoseLevels(UserID,BloodGlucoseLevel) values (1,4)
insert into data.BloodGlucoseLevels(UserID,BloodGlucoseLevel) values (1,15)
insert into data.BloodGlucoseLevels(UserID,BloodGlucoseLevel) values (1,2)
insert into data.BloodGlucoseLevels(UserID,BloodGlucoseLevel) values (1,9)
insert into data.BloodGlucoseLevels(UserID,BloodGlucoseLevel) values (1,12)




insert into data.HeartRate(UserID,HeartRate) values (1,49)
insert into data.HeartRate(UserID,HeartRate) values (1,82)
insert into data.HeartRate(UserID,HeartRate) values (1,60)
insert into data.HeartRate(UserID,HeartRate) values (1,55)
insert into data.HeartRate(UserID,HeartRate) values (1,76)
insert into data.HeartRate(UserID,HeartRate) values (1,55)
insert into data.HeartRate(UserID,HeartRate) values (1,63)
insert into data.HeartRate(UserID,HeartRate) values (1,49)
insert into data.HeartRate(UserID,HeartRate) values (1,82)
insert into data.HeartRate(UserID,HeartRate) values (1,60)
insert into data.HeartRate(UserID,HeartRate) values (1,55)
insert into data.HeartRate(UserID,HeartRate) values (1,76)
insert into data.HeartRate(UserID,HeartRate) values (1,55)
insert into data.HeartRate(UserID,HeartRate) values (1,63)
insert into data.HeartRate(UserID,HeartRate) values (1,49)
insert into data.HeartRate(UserID,HeartRate) values (1,82)
insert into data.HeartRate(UserID,HeartRate) values (1,60)
insert into data.HeartRate(UserID,HeartRate) values (1,55)
insert into data.HeartRate(UserID,HeartRate) values (1,76)
insert into data.HeartRate(UserID,HeartRate) values (1,55)
insert into data.HeartRate(UserID,HeartRate) values (1,63)





insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,63,(SELECT DATEADD(MONTH,-1,GETDATE())))
insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,43,(SELECT DATEADD(MONTH,-1,GETDATE())))
insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,73,(SELECT DATEADD(MONTH,-1,GETDATE())))
insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,103,(SELECT DATEADD(MONTH,-1,GETDATE())))


insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,68,(SELECT DATEADD(MONTH,-2,GETDATE())))
insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,73,(SELECT DATEADD(MONTH,-2,GETDATE())))
insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,53,(SELECT DATEADD(MONTH,-2,GETDATE())))
insert into data.HeartRate(UserID,HeartRate,DateAdded) values (1,103,(SELECT DATEADD(MONTH,-2,GETDATE())))


select * from DATA.bloodpressures
select * from REF.NormalBloodPressures
select * from data.users

select * from DATA.PatientCaretakers

insert into DATA.Users(UserType,FirstName,LastName,MiddleName,LoginName,LoginPassword,EmailAddress,MedicalConditionID,Phonenumber,DateOfBirth,Gender) 
values(3,'Mangi','Prunda','Sassha','Salona1','Eurika1','ManPri@gmail.com',2,'2674692604','1995-01-12','Male')