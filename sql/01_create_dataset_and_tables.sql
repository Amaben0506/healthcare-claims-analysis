/*
Healthcare Claims Analysis
Author: Amanda Benavidez

Purpose:
Create a synthetic healthcare claims dataset in Google BigQuery
for analytics and dashboard development.

Note:
All records are fictional and contain no real patient information.
*/

-- Create the healthcare claims dataset.
CREATE SCHEMA IF NOT EXISTS
  `symbolic-truth-501920-j2.healthcare_claims`;


-- Create insurance plans.
CREATE OR REPLACE TABLE
  `symbolic-truth-501920-j2.healthcare_claims.insurance_plans` AS

SELECT 1 AS plan_id, 'Bronze' AS plan_name,
       6500.00 AS deductible, 60 AS coverage_percent

UNION ALL
SELECT 2, 'Silver', 4000.00, 70

UNION ALL
SELECT 3, 'Gold', 2000.00, 80

UNION ALL
SELECT 4, 'Platinum', 750.00, 90

UNION ALL
SELECT 5, 'Medicare Advantage', 1500.00, 85;


-- Create diagnosis records.
CREATE OR REPLACE TABLE
  `symbolic-truth-501920-j2.healthcare_claims.diagnoses` AS

SELECT 'D001' AS diagnosis_code,
       'Hypertension' AS diagnosis,
       'Cardiology' AS category,
       650.00 AS base_cost

UNION ALL
SELECT 'D002', 'Heart Disease', 'Cardiology', 5200.00

UNION ALL
SELECT 'D003', 'Diabetes Type 2', 'Endocrinology', 1200.00

UNION ALL
SELECT 'D004', 'Hypothyroidism', 'Endocrinology', 480.00

UNION ALL
SELECT 'D005', 'Asthma', 'Respiratory', 900.00

UNION ALL
SELECT 'D006', 'Anxiety', 'Mental Health', 350.00

UNION ALL
SELECT 'D007', 'Depression', 'Mental Health', 420.00

UNION ALL
SELECT
  'D008',
  'Autism Spectrum Disorder',
  'Developmental Health',
  850.00

UNION ALL
SELECT 'D009', 'Back Pain', 'Orthopedics', 900.00

UNION ALL
SELECT
  'D010',
  'Emergency Visit',
  'Emergency Medicine',
  2100.00;


-- Create healthcare providers.
CREATE OR REPLACE TABLE
  `symbolic-truth-501920-j2.healthcare_claims.providers` AS

SELECT 1 AS provider_id,
       'Lone Star Primary Care' AS provider_name,
       'Primary Care' AS specialty,
       'Dallas' AS city,
       'TX' AS state

UNION ALL
SELECT
  2,
  'North Texas Cardiology',
  'Cardiology',
  'Fort Worth',
  'TX'

UNION ALL
SELECT
  3,
  'Riverbend Respiratory Clinic',
  'Respiratory',
  'Austin',
  'TX'

UNION ALL
SELECT
  4,
  'Oak Valley Behavioral Health',
  'Mental Health',
  'Houston',
  'TX'

UNION ALL
SELECT
  5,
  'Central Pediatric Wellness',
  'Pediatrics',
  'Dallas',
  'TX'

UNION ALL
SELECT
  6,
  'Premier Orthopedic Center',
  'Orthopedics',
  'San Antonio',
  'TX'

UNION ALL
SELECT
  7,
  'Unity Emergency Care',
  'Emergency Medicine',
  'Houston',
  'TX'

UNION ALL
SELECT
  8,
  'Bright Path Developmental Clinic',
  'Developmental Health',
  'Austin',
  'TX'

UNION ALL
SELECT
  9,
  'Westside Endocrinology',
  'Endocrinology',
  'Dallas',
  'TX'

UNION ALL
SELECT
  10,
  'South Plains Family Medicine',
  'Primary Care',
  'Lubbock',
  'TX';


-- Generate 5,000 synthetic patient records.
CREATE OR REPLACE TABLE
  `symbolic-truth-501920-j2.healthcare_claims.patients` AS

SELECT
  patient_id,

  CASE MOD(patient_id, 5)
    WHEN 0 THEN 'Amanda'
    WHEN 1 THEN 'Maria'
    WHEN 2 THEN 'James'
    WHEN 3 THEN 'Sarah'
    ELSE 'Daniel'
  END AS first_name,

  CASE MOD(patient_id, 5)
    WHEN 0 THEN 'Garcia'
    WHEN 1 THEN 'Johnson'
    WHEN 2 THEN 'Smith'
    WHEN 3 THEN 'Martinez'
    ELSE 'Brown'
  END AS last_name,

  CASE MOD(patient_id, 2)
    WHEN 0 THEN 'Female'
    ELSE 'Male'
  END AS gender,

  18 + MOD(patient_id, 70) AS age,

  CASE MOD(patient_id, 5)
    WHEN 0 THEN 'TX'
    WHEN 1 THEN 'CA'
    WHEN 2 THEN 'FL'
    WHEN 3 THEN 'NY'
    ELSE 'GA'
  END AS state,

  1 + MOD(patient_id, 5) AS insurance_plan_id

FROM UNNEST(GENERATE_ARRAY(1, 5000)) AS patient_id;


-- Generate 75,000 synthetic healthcare claims.
CREATE OR REPLACE TABLE
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS

SELECT
  claim_id,

  1 + MOD(claim_id, 5000) AS patient_id,

  1 + MOD(claim_id, 10) AS provider_id,

  FORMAT(
    'D%03d',
    1 + MOD(claim_id, 10)
  ) AS diagnosis_code,

  1 + MOD(claim_id, 5) AS insurance_plan_id,

  ROUND(
    CASE MOD(claim_id, 10)
      WHEN 0 THEN 650
      WHEN 1 THEN 5200
      WHEN 2 THEN 1200
      WHEN 3 THEN 480
      WHEN 4 THEN 900
      WHEN 5 THEN 350
      WHEN 6 THEN 420
      WHEN 7 THEN 850
      WHEN 8 THEN 900
      ELSE 2100
    END * (0.75 + RAND() * 0.75),
    2
  ) AS claim_amount,

  CASE
    WHEN RAND() < 0.78 THEN 'Approved'
    WHEN RAND() < 0.92 THEN 'Denied'
    ELSE 'Pending'
  END AS status,

  CAST(
    2 + RAND() * 45 AS INT64
  ) AS processing_days,

  DATE_ADD(
    DATE '2025-01-01',
    INTERVAL CAST(RAND() * 364 AS INT64) DAY
  ) AS service_date

FROM UNNEST(GENERATE_ARRAY(1, 75000)) AS claim_id;
