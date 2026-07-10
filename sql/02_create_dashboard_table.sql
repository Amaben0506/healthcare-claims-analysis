/*
Healthcare Claims Analysis

Purpose:
Create one analysis-ready table for the Looker Studio
executive dashboard.
*/

CREATE OR REPLACE TABLE
  `symbolic-truth-501920-j2.healthcare_claims.claims_dashboard` AS

SELECT
  c.claim_id,
  c.claim_amount,
  c.status,
  c.processing_days,
  c.service_date,

  FORMAT_DATE(
    '%Y-%m',
    c.service_date
  ) AS service_month,

  p.provider_name,
  p.specialty,

  pt.state AS patient_state,
  pt.gender,
  pt.age,

  ip.plan_name,

  d.diagnosis,
  d.category

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS c

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.providers` AS p
  ON c.provider_id = p.provider_id

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.patients` AS pt
  ON c.patient_id = pt.patient_id

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.insurance_plans` AS ip
  ON c.insurance_plan_id = ip.plan_id

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.diagnoses` AS d
  ON c.diagnosis_code = d.diagnosis_code;
