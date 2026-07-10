CREATE DATABASE AlzheimerDBS13;
USE AlzheimerDBS13;

-- =========================
-- DIMENSION TABLES
-- =========================

-- DIM PATIENT
CREATE TABLE Patient (
    PatientKey INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT,
    Age INT,
    Gender VARCHAR(20),
    Ethnicity VARCHAR(50),
    EducationLevel VARCHAR(50),
    BMI DECIMAL(5,2),
    Smoking VARCHAR(10),
    AlcoholConsumption DECIMAL(5,2),
    PhysicalActivity DECIMAL(5,2),
    DietQuality DECIMAL(5,2),
    SleepQuality DECIMAL(5,2)
);

-- DIM DOCTOR
CREATE TABLE Doctor (
    DoctorKey INT IDENTITY(1,1) PRIMARY KEY,
    DoctorInCharge VARCHAR(50)
);

-- DIM MEDICAL HISTORY
CREATE TABLE MedicalHistory (
    MedicalHistoryKey INT IDENTITY(1,1) PRIMARY KEY,
    FamilyHistoryAlzheimers VARCHAR(10),
    CardiovascularDisease VARCHAR(10),
    Diabetes VARCHAR(10),
    Depression VARCHAR(10),
    HeadInjury VARCHAR(10),
    Hypertension VARCHAR(10)
);

-- DIM SYMPTOMS
CREATE TABLE Symptoms (
    SymptomsKey INT IDENTITY(1,1) PRIMARY KEY,
    MemoryComplaints VARCHAR(10),
    BehavioralProblems VARCHAR(10),
    Confusion VARCHAR(10),
    Disorientation VARCHAR(10),
    PersonalityChanges VARCHAR(10),
    DifficultyCompletingTasks VARCHAR(10),
    Forgetfulness VARCHAR(10)
);


CREATE TABLE FactDiagnosis (
    FactID INT IDENTITY(1,1) PRIMARY KEY,

    PatientKey INT,
    DoctorKey INT,
    MedicalHistoryKey INT,
    SymptomsKey INT,

    SystolicBP varchar(50),
    DiastolicBP varchar(50),
    MMSE DECIMAL(5,2),
    FunctionalAssessment DECIMAL(5,2),
    ADL DECIMAL(5,2),
    CholesterolTotal varchar(50),
    CholesterolLDL varchar(50),
    CholesterolHDL varchar(50),
    CholesterolTriglycerides varchar(50),

    Diagnosis VARCHAR(10),

    FOREIGN KEY (PatientKey) REFERENCES Patient(PatientKey),
    FOREIGN KEY (DoctorKey) REFERENCES Doctor(DoctorKey),
    FOREIGN KEY (MedicalHistoryKey) REFERENCES MedicalHistory(MedicalHistoryKey),
    FOREIGN KEY (SymptomsKey) REFERENCES Symptoms(SymptomsKey)
);
insert into Patient(
PatientID,
    Age,
    Gender,
    Ethnicity,
    EducationLevel,
    BMI,
    Smoking,
    AlcoholConsumption,
    PhysicalActivity,
    DietQuality,
    SleepQuality 
    )
    select distinct
      PatientID
      ,Age
      ,Gender
      ,Ethnicity
      ,EducationLevel
      ,BMI
      ,Smoking
      ,AlcoholConsumption
      ,PhysicalActivity
      ,DietQuality
      ,SleepQuality
      
      from Cleaned_alzheimers_disease_data;
     -- doctor
     insert into Doctor (DoctorInCharge)
          select distinct
DoctorInCharge
      from Cleaned_alzheimers_disease_data;
      --MedicalHistory
      insert into MedicalHistory(
    FamilyHistoryAlzheimers,
    CardiovascularDisease,
    Diabetes,
    Depression,
    HeadInjury,
    Hypertension
      )
      select distinct
        FamilyHistoryAlzheimers
      ,CardiovascularDisease
      ,Diabetes
      ,Depression
      ,HeadInjury
      ,Hypertension
      from Cleaned_alzheimers_disease_data;
      --SYMPTOMS
insert into Symptoms(
    MemoryComplaints,
    BehavioralProblems,
    Confusion,
    Disorientation,
    PersonalityChanges,
    DifficultyCompletingTasks,
    Forgetfulness 
)
select distinct
MemoryComplaints
      ,BehavioralProblems
      ,Confusion
      ,Disorientation
      ,PersonalityChanges
      ,DifficultyCompletingTasks
      ,Forgetfulness
from Cleaned_alzheimers_disease_data;
--fact 
insert into FactDiagnosis(
    PatientKey,
    DoctorKey,
    MedicalHistoryKey,
    SymptomsKey,
    
    SystolicBP,
    DiastolicBP,
    MMSE,
    FunctionalAssessment,
    ADL,
    CholesterolTotal,
    CholesterolLDL,
    CholesterolHDL,
    CholesterolTriglycerides,
    Diagnosis
    )
    select Patient.PatientKey,Doctor.DoctorKey,MedicalHistory.MedicalHistoryKey,
    Symptoms.SymptomsKey,Cleaned_alzheimers_disease_data.SystolicBP,
    Cleaned_alzheimers_disease_data.DiastolicBP,
    Cleaned_alzheimers_disease_data.MMSE,
    Cleaned_alzheimers_disease_data.FunctionalAssessment,
    Cleaned_alzheimers_disease_data.ADL,
    Cleaned_alzheimers_disease_data.CholesterolTotal_1,
    Cleaned_alzheimers_disease_data.CholesterolLDL_1,
    Cleaned_alzheimers_disease_data.CholesterolHDL_1,
    Cleaned_alzheimers_disease_data.CholesterolTriglycerides_1,
    Cleaned_alzheimers_disease_data.Diagnosis
    from Cleaned_alzheimers_disease_data
    
    join Patient on Cleaned_alzheimers_disease_data.PatientId=Patient.PatientID 
    
    
    join Doctor on Cleaned_alzheimers_disease_data.DoctorInCharge=Doctor.DoctorInCharge
    
  join MedicalHistory on Cleaned_alzheimers_disease_data.FamilyHistoryAlzheimers=MedicalHistory.FamilyHistoryAlzheimers     
  and Cleaned_alzheimers_disease_data.CardiovascularDisease=MedicalHistory.CardiovascularDisease 
  and Cleaned_alzheimers_disease_data.Diabetes=MedicalHistory.Diabetes
  and Cleaned_alzheimers_disease_data.Depression=MedicalHistory.Depression
  and Cleaned_alzheimers_disease_data.HeadInjury=MedicalHistory.HeadInjury
  and Cleaned_alzheimers_disease_data.Hypertension=MedicalHistory.Hypertension
    
      join Symptoms on Cleaned_alzheimers_disease_data.BehavioralProblems=Symptoms.BehavioralProblems  
      and Cleaned_alzheimers_disease_data.MemoryComplaints=Symptoms.MemoryComplaints
      and Cleaned_alzheimers_disease_data.Confusion=Symptoms.Confusion
      and Cleaned_alzheimers_disease_data.Disorientation=Symptoms.Disorientation
      and Cleaned_alzheimers_disease_data.PersonalityChanges=Symptoms.PersonalityChanges
      and Cleaned_alzheimers_disease_data.DifficultyCompletingTasks=Symptoms.DifficultyCompletingTasks
      and Cleaned_alzheimers_disease_data.Forgetfulness=Symptoms.Forgetfulness
      ;
SELECT TOP 1 *
FROM Cleaned_alzheimers_disease_data;
-- Q1: How many patients have Alzheimer's?
SELECT COUNT(*) AS Alzheimer_Patients
FROM FactDiagnosis
WHERE Diagnosis = 'Yes';

-- =============================================

-- Q2: Average age of Alzheimer's patients
SELECT AVG(p.Age) AS Avg_Age
FROM FactDiagnosis fd
JOIN Patient p ON fd.PatientKey = p.PatientKey
WHERE fd.Diagnosis = 'Yes';

-- =============================================

-- Q3: Count of patients with family history of Alzheimer's
SELECT mh.FamilyHistoryAlzheimers,
       COUNT(*) AS Patient_Count
FROM FactDiagnosis fd
JOIN MedicalHistory mh ON fd.MedicalHistoryKey = mh.MedicalHistoryKey
GROUP BY mh.FamilyHistoryAlzheimers;

-- =============================================

-- Q4: How many Alzheimer's patients have memory complaints?
SELECT COUNT(*) AS Memory_Complaint_Alzheimer
FROM FactDiagnosis fd
JOIN Symptoms s ON fd.SymptomsKey = s.SymptomsKey
WHERE fd.Diagnosis = 'Yes'
  AND s.MemoryComplaints = 'Yes';

-- =============================================

-- Q5: Count of patients per age stage
SELECT
  CASE
    WHEN p.Age BETWEEN 0  AND 40 THEN 'Under 40'
    WHEN p.Age BETWEEN 41 AND 50 THEN '41–50'
    WHEN p.Age BETWEEN 51 AND 60 THEN '51–60'
    WHEN p.Age BETWEEN 61 AND 70 THEN '61–70'
    WHEN p.Age BETWEEN 71 AND 80 THEN '71–80'
    ELSE 'Over 80'
  END AS Age_Stage,
  COUNT(*) AS Patient_Count
FROM FactDiagnosis fd
JOIN Patient p ON fd.PatientKey = p.PatientKey
GROUP BY
  CASE
    WHEN p.Age BETWEEN 0  AND 40 THEN 'Under 40'
    WHEN p.Age BETWEEN 41 AND 50 THEN '41–50'
    WHEN p.Age BETWEEN 51 AND 60 THEN '51–60'
    WHEN p.Age BETWEEN 61 AND 70 THEN '61–70'
    WHEN p.Age BETWEEN 71 AND 80 THEN '71–80'
    ELSE 'Over 80'
  END
ORDER BY Age_Stage;

-- =============================================

-- Q6: Effect of sleep quality on Alzheimer's
SELECT
  CASE
    WHEN p.SleepQuality BETWEEN 0 AND 4  THEN 'Poor (0–4)'
    WHEN p.SleepQuality BETWEEN 4 AND 7  THEN 'Average (4–7)'
    WHEN p.SleepQuality BETWEEN 7 AND 10 THEN 'Good (7–10)'
  END AS Sleep_Level,
  fd.Diagnosis,
  COUNT(*) AS Patient_Count
FROM FactDiagnosis fd
JOIN Patient p ON fd.PatientKey = p.PatientKey
GROUP BY
  CASE
    WHEN p.SleepQuality BETWEEN 0 AND 4  THEN 'Poor (0–4)'
    WHEN p.SleepQuality BETWEEN 4 AND 7  THEN 'Average (4–7)'
    WHEN p.SleepQuality BETWEEN 7 AND 10 THEN 'Good (7–10)'
  END,
  fd.Diagnosis
ORDER BY Sleep_Level, fd.Diagnosis;

-- =============================================

-- Q7: Number of patients by BMI level
SELECT
  CASE
    WHEN p.BMI < 18.5                    THEN 'Underweight (<18.5)'
    WHEN p.BMI BETWEEN 18.5 AND 24.9     THEN 'Normal (18.5–24.9)'
    WHEN p.BMI BETWEEN 25   AND 29.9     THEN 'Overweight (25–29.9)'
    ELSE 'Obese (30+)'
  END AS BMI_Level,
  fd.Diagnosis,
  COUNT(*) AS Patient_Count
FROM FactDiagnosis fd
JOIN Patient p ON fd.PatientKey = p.PatientKey
GROUP BY
  CASE
    WHEN p.BMI < 18.5                    THEN 'Underweight (<18.5)'
    WHEN p.BMI BETWEEN 18.5 AND 24.9     THEN 'Normal (18.5–24.9)'
    WHEN p.BMI BETWEEN 25   AND 29.9     THEN 'Overweight (25–29.9)'
    ELSE 'Obese (30+)'
  END,
  fd.Diagnosis
ORDER BY BMI_Level;

-- =============================================

-- Q8: Number of patients by education level
SELECT
  p.EducationLevel,
  fd.Diagnosis,
  COUNT(*) AS Patient_Count
FROM FactDiagnosis fd
JOIN Patient p ON fd.PatientKey = p.PatientKey
GROUP BY p.EducationLevel, fd.Diagnosis
ORDER BY p.EducationLevel, fd.Diagnosis;

-- =============================================

-- Q9: Number of patients by smoking status per age stage
SELECT
  CASE
    WHEN p.Age BETWEEN 0  AND 40 THEN 'Under 40'
    WHEN p.Age BETWEEN 41 AND 50 THEN '41–50'
    WHEN p.Age BETWEEN 51 AND 60 THEN '51–60'
    WHEN p.Age BETWEEN 61 AND 70 THEN '61–70'
    WHEN p.Age BETWEEN 71 AND 80 THEN '71–80'
    ELSE 'Over 80'
  END AS Age_Stage,
  p.Smoking,
  fd.Diagnosis,
  COUNT(*) AS Patient_Count
FROM FactDiagnosis fd
JOIN Patient p ON fd.PatientKey = p.PatientKey
GROUP BY
  CASE
    WHEN p.Age BETWEEN 0  AND 40 THEN 'Under 40'
    WHEN p.Age BETWEEN 41 AND 50 THEN '41–50'
    WHEN p.Age BETWEEN 51 AND 60 THEN '51–60'
    WHEN p.Age BETWEEN 61 AND 70 THEN '61–70'
    WHEN p.Age BETWEEN 71 AND 80 THEN '71–80'
    ELSE 'Over 80'
  END,
  p.Smoking, fd.Diagnosis
ORDER BY Age_Stage, p.Smoking;

-- =============================================

-- Q10: Number of patients by depression status
SELECT
  mh.Depression,
  fd.Diagnosis,
  COUNT(*) AS Patient_Count
FROM FactDiagnosis fd
JOIN MedicalHistory mh ON fd.MedicalHistoryKey = mh.MedicalHistoryKey
GROUP BY mh.Depression, fd.Diagnosis
ORDER BY mh.Depression, fd.Diagnosis;