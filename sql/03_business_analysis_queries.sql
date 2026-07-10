/*
Healthcare Claims Analysis

Purpose:
Answer the primary business questions used in the
executive dashboard and case study.
*/


-- 1. Overall executive KPIs.
SELECT
  COUNT(*) AS total_claims,
  ROUND(SUM(claim_amount), 2) AS total_claim_amount,
  ROUND(AVG(claim_amount), 2) AS average_claim_amount,
  ROUND(AVG(processing_days), 2) AS average_processing_days

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims`;


-- 2. Which providers generated the highest claim amounts?
SELECT
  p.provider_name,
  p.specialty,
  COUNT(*) AS total_claims,
  ROUND(SUM(c.claim_amount), 2) AS total_claim_amount

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS c

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.providers` AS p
  ON c.provider_id = p.provider_id

GROUP BY
  p.provider_name,
  p.specialty

ORDER BY
  total_claim_amount DESC

LIMIT 10;


-- 3. Which diagnoses generated the highest costs?
SELECT
  d.diagnosis,
  d.category,
  COUNT(*) AS total_claims,
  ROUND(SUM(c.claim_amount), 2) AS total_claim_amount,
  ROUND(AVG(c.claim_amount), 2) AS average_claim_amount

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS c

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.diagnoses` AS d
  ON c.diagnosis_code = d.diagnosis_code

GROUP BY
  d.diagnosis,
  d.category

ORDER BY
  total_claim_amount DESC;


-- 4. What percentage of claims were approved, denied, or pending?
SELECT
  status,
  COUNT(*) AS total_claims,

  ROUND(
    COUNT(*) * 100.0 /
    SUM(COUNT(*)) OVER (),
    2
  ) AS percentage_of_claims

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims`

GROUP BY
  status

ORDER BY
  total_claims DESC;


-- 5. How long did claims take to process by status?
SELECT
  status,
  COUNT(*) AS total_claims,
  ROUND(AVG(processing_days), 2) AS average_processing_days

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims`

GROUP BY
  status

ORDER BY
  average_processing_days DESC;


-- 6. Which patient states generated the highest claim spending?
SELECT
  pt.state,
  COUNT(*) AS total_claims,
  ROUND(SUM(c.claim_amount), 2) AS total_claim_amount,
  ROUND(AVG(c.claim_amount), 2) AS average_claim_amount

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS c

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.patients` AS pt
  ON c.patient_id = pt.patient_id

GROUP BY
  pt.state

ORDER BY
  total_claim_amount DESC;


-- 7. Which insurance plans generated the highest spending?
SELECT
  ip.plan_name,
  COUNT(*) AS total_claims,
  ROUND(SUM(c.claim_amount), 2) AS total_claim_amount,
  ROUND(AVG(c.claim_amount), 2) AS average_claim_amount

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS c

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.insurance_plans` AS ip
  ON c.insurance_plan_id = ip.plan_id

GROUP BY
  ip.plan_name

ORDER BY
  total_claim_amount DESC;


-- 8. Which diagnosis categories had the highest average claim amount?
SELECT
  d.category,
  COUNT(*) AS total_claims,
  ROUND(SUM(c.claim_amount), 2) AS total_claim_amount,
  ROUND(AVG(c.claim_amount), 2) AS average_claim_amount

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS c

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.diagnoses` AS d
  ON c.diagnosis_code = d.diagnosis_code

GROUP BY
  d.category

ORDER BY
  average_claim_amount DESC;


-- 9. What were the monthly healthcare spending trends?
SELECT
  DATE_TRUNC(service_date, MONTH) AS service_month,
  COUNT(*) AS total_claims,
  ROUND(SUM(claim_amount), 2) AS total_claim_amount,
  ROUND(AVG(claim_amount), 2) AS average_claim_amount

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims`

GROUP BY
  service_month

ORDER BY
  service_month;


-- 10. Which providers processed the largest number of claims?
SELECT
  p.provider_name,
  p.specialty,
  COUNT(*) AS total_claims

FROM
  `symbolic-truth-501920-j2.healthcare_claims.claims` AS c

INNER JOIN
  `symbolic-truth-501920-j2.healthcare_claims.providers` AS p
  ON c.provider_id = p.provider_id

GROUP BY
  p.provider_name,
  p.specialty

ORDER BY
  total_claims DESC

LIMIT 10;
