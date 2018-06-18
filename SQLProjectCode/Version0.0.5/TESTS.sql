INSERT INTO REF.MedicalConditions (MedicalConditionName) VALUES ('Abdominal Aortic Aneurysm')
INSERT INTO DATA.Patients (FirstName , LastName, MiddleName, LoginName, LoginPassword, EmailAddress, MedicalConditionID) VALUES ('GOD', 'MODE', 'PAT', 'Godmode', 'Godmode', 'godmode@yahoo.com', 1) 

SELECT * FROM REF.MedicalConditions
SELECT * FROM DATA.Patients
SELECT * FROM AUDIT.Patients