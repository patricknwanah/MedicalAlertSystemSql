DROP VIEW DATA.ReportView
go
CREATE VIEW DATA.ReportView
AS
SELECT 
	p.FirstName, 
	p.MiddleName, 
	p.LastName, 
	p.PatientID,
	(select medicalconditionname from ref.MedicalConditions where medicalconditionid = p.MedicalConditionID) as MedicalCondition,
	bg.BloodGlucoseLevel,
	bp.BloodPressure,
	bg.dateadded as BloodGlucoselevelDateAdded,
	bp.dateadded as BloodPressureDateAdded
	from data.patients p 
INNER JOIN DATA.BloodGlucoseLevels bg on p.PatientID = bg.PatientID
INNER JOIN DATA.BloodPressures bp on p.PatientID = bp.PatientID
where p.isHidden = 0

select * from data.ReportView

