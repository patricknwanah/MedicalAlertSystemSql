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