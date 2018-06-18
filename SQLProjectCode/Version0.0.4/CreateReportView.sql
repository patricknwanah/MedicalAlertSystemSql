DROP VIEW DATA.ReportView
go
CREATE VIEW DATA.ReportView
AS
SELECT 
	u.FirstName, 
	u.MiddleName, 
	u.LastName, 
	u.UserID,
	(select medicalconditionname from ref.MedicalConditions where medicalconditionid = u.MedicalConditionID) as MedicalCondition,
	bg.BloodGlucoseLevel,
	bp.BloodPressure,
	bg.dateadded as BloodGlucoselevelDateAdded,
	bp.dateadded as BloodPressureDateAdded
	from DATA.Users u 
INNER JOIN DATA.BloodGlucoseLevels bg on u.UserID = bg.UserID
INNER JOIN DATA.BloodPressures bp on u.UserID = bp.UserID
where u.isHidden = 0

