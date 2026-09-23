SELECT
CustomerId,
    COUNT(*) AS occurrences
FROM clean_bank_churn
GROUP BY CustomerId
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS total_customers
FROM clean_bank_churn;

SELECT
    COUNT(*) FILTER (WHERE CustomerId IS NULL) AS customerid_nulls,
    COUNT(*) FILTER (WHERE CreditScore IS NULL) AS creditscore_nulls,
    COUNT(*) FILTER (WHERE Geography IS NULL) AS geography_nulls,
    COUNT(*) FILTER (WHERE Gender IS NULL) AS gender_nulls,
    COUNT(*) FILTER (WHERE Age IS NULL) AS age_nulls,
    COUNT(*) FILTER (WHERE Tenure IS NULL) AS tenure_nulls,
    COUNT(*) FILTER (WHERE Balance IS NULL) AS balance_nulls,
    COUNT(*) FILTER (WHERE NumOfProducts IS NULL) AS products_nulls,
    COUNT(*) FILTER (WHERE EstimatedSalary IS NULL) AS salary_nulls,
    COUNT(*) FILTER (WHERE Exited IS NULL) AS exited_nulls
FROM clean_bank_churn;

--CHECKING CATEGORICAL VALUES
SELECT DISTINCT geography
FOM FROM clean_bank_churn;

SELECT DISTINCT gender
FROM clean_bank_churn;

SELECT DISTINCT exited
FROM clean_bank_churn;

--CHECKING RANGES
SELECT
    MIN(CreditScore) AS min_credit_score,
    MAX(CreditScore) AS max_credit_score,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    MIN(Tenure) AS min_tenure,
    MAX(Tenure) AS max_tenure,
    MIN(Balance) AS min_balance,
    MAX(Balance) AS max_balance,
    MIN(NumOfProducts) AS min_products,
    MAX(NumOfProducts) AS max_products,
    MIN(EstimatedSalary) AS min_salary,
    MAX(EstimatedSalary) AS max_salary
FROM clean_bank_churn;

--EDA process
SELECT exited, COUNT(*) AS total_customers
from clean_bank_churn group by exited;

--CHURN RATE/ 20.37%
SELECT SUM(exited) AS churned_customers,
COUNT(*) AS total_customers,
ROUND(100.0 * SUM(exited) / COUNT(*), 2)
FROM clean_bank_churn;

--CHURN RATE/geography/ Germany-32.44%
SELECT 
    geography,
    SUM(exited) AS churned_customers,
    COUNT(*) - SUM(exited) AS active_customers,
    COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
   FROM clean_bank_churn
   GROUP BY geography
   ORDER BY churn_rate DESC;

--So after doing churn analysis.
--what insight did i found here ?

-- churn rate is higher on germany side,
--we have almost same number of churned customers on both germany and france,
--but also germany has lower customers than what we have in france.
--So we have almost same churned volume but different churn rate.

--Churn rate/age/age_grp/50-59 = 54.04%
SELECT
CASE
    WHEN age < 30 THEN '18-29'
    WHEN age < 40 THEN '30-39'
    WHEN age < 50 THEN '40-49'
    WHEN age < 60 THEN '50-59'
    ELSE '60+'
END AS age_grp,
COUNT(*) total_customers,
SUM(exited) AS churned_customers,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
GROUP BY age_grp
ORDER BY age_grp ;

--Churn rate/geography/Germany/age-wise -> 50-59 = 70.04%
SELECT
geography,
CASE
    WHEN age < 30 THEN '18-29'
    WHEN age < 40 THEN '30-39'
    WHEN age < 50 THEN '40-49'
    WHEN age < 60 THEN '50-59'
    ELSE '60+'
END AS age_grp,
COUNT(*) total_customers,
SUM(exited) AS churned_customers,
ROUND(100.0 * SUM(exited) / COUNT(*), 
2) AS churn_rate
FROM clean_bank_churn
GROUP BY geography, age_grp
ORDER BY geography, MIN(age) ;

--Churn rate of active and inactive customers.
-- BASELINE churn rate 20.37%.
--Inactive churn rate 26.85%, which is higher that BASELINE.
SELECT 
isactivemember,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
GROUP BY isactivemember;

--So far we have:
--Overall churn
--20.37%

--Geography
--Germany: 32.44%

--Age
--50–59: 56.04%

--Geography × Age
--Germany + 50–59: 70.04%

--Activity
--Inactive customers: 26.85%

--churn rate/ product-wise
SELECT NumOfProducts,
count(*) AS total_customers,
SUM(exited) AS churn_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
group by NumOfProducts
ORDER BY NumOfProducts;
--now we know that we have a non-linear relation 
--between product count and churn

-- churn rate/credit-card wise
SELECT hascrcard,
count(*) AS total_customers,
SUM(exited) AS churn_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
group by hascrcard
ORDER BY hascrcard;

--churnn rate/gender
SELECT Gender,
count(*) AS total_customers,
SUM(exited) AS churn_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
group by Gender
ORDER BY Gender;

--churn rate/balance-wise
SELECT
    CASE
        WHEN balance = 0 THEN '0'
        WHEN balance < 50000 THEN '1-49999'
        WHEN balance < 100000 THEN '50000-99999'
        WHEN balance < 200000 THEN '100000-199999'
        ELSE '200000+'
    END AS balance_grp,
    COUNT(*) AS total_customers,
    SUM(exited) AS churned_customers,
    ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
GROUP BY balance_grp
ORDER BY MIN(balance);

--churn rate/creditscore-wise
SELECT
CASE
WHEN creditscore < 500 THEN '350-499'
WHEN creditscore < 600 THEN '500-599'
WHEN creditscore < 700 THEN '600-699'
WHEN creditscore < 800 THEN '700-799'
ELSE '800+'
END AS credit_score,
COUNT(*) AS total_customer,
SUM(exited) AS churned_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
GROUP BY credit_score 
ORDER BY MIN(creditscore);

churn rate/tanure
SELECT tenure,
count(*) AS total_customers,
SUM(exited) AS churn_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
group by tenure
ORDER BY tenure;

--churn rate/estimatedsalary
SELECT 
CASE
WHEN estimatedsalary < 50000 THEN 'O-49999'
WHEN estimatedsalary < 100000 THEN '50000-99999'
WHEN estimatedsalary < 150000 THEN '100000-149999'
WHEN estimatedsalary < 200000 THEN '150000-199999'
ELSE '200000+'
END AS salary_grp,
count(*) AS total_customers,
SUM(exited) AS churn_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
group by salary_grp
ORDER BY MIN(estimatedsalary);

--churn rate between(numofproducts x isactivemember)
SELECT numofproducts,
isactivemember,
count(*) AS total_customers,
SUM(exited) AS churn_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
group by numofproducts, isactivemember
ORDER BY numofproducts, isactivemember;

--churn rate between(geography x isactivemember)
SELECT geography,
isactivemember,
count(*) AS total_customers,
SUM(exited) AS churn_customer,
ROUND(100.0 * SUM(exited) / COUNT(*), 2) AS churn_rate
FROM clean_bank_churn
group by geography, isactivemember
ORDER BY geography, isactivemember;