CREATE DATABASE FinShield_UPI_Fraud_Transaction ;
USE FinShield_UPI_Fraud_Transaction;

select * from upi_fraud_transaction;

----------- Create view for KPI -----------------
create view KPI as
select 
count(Transaction_ID) as Total_Transaction,
round(sum( Amount_INR),2) as Total_Transaction_Amount,
max(Amount_INR) as maximum_amount_transaction,
min(Amount_INR) as minimum_amount_transaction,
count(case when Is_Fraud=1 then 1 end) as total_Fraud_Transaction, 
round(sum(case when Is_Fraud=1 then Amount_INR end),2) as total_Fraud_Transaction_Amount,
sum(case when Is_Fraud=1 then 1 end) /count(Transaction_ID) *100 as fraud_rate_pct,
round(sum(case when Is_Fraud=1 then Amount_INR end)/(sum(Amount_INR)),2)*100 as fraud_rate_amount_pct,
max(Account_Age_Days) as maximum_account_age,
min(Account_Age_Days) as minimum_account_age,
count(distinct Sender_Bank) as Total_Sender_Bank,
count(distinct Receiver_Bank) as Total_Receiver_Bank,
count(distinct city) as Total_city,
count(distinct Device_Type) as Total_Device_Type,
count(distinct Transaction_Type) as Total_Transaction_Type,
count(distinct Fraud_Reason) as Total_Fraud_Reason
from upi_fraud_transaction;
 
select * from kpi;


select * from upi_fraud_transaction;

-- Transaction Analysis

-- 1. Fraud transaction by Transaction_Type
SELECT  Transaction_Type, COUNT(*) AS Fraud_Count FROM upi_fraud_transaction
WHERE Is_Fraud = 1
GROUP BY Transaction_Type
ORDER BY Fraud_Count DESC;

-- 2. Fraud rate by Transaction_Type
SELECT Transaction_Type,
COUNT(*) AS Total_Transactions,
SUM(CASE WHEN Is_Fraud = 1 THEN 1 ELSE 0 END) AS Fraud_Transactions,
SUM(CASE WHEN Is_Fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)  AS Fraud_Rate,
ROUND(SUM(CASE WHEN Is_Fraud = 1 THEN Amount_INR ELSE 0 END),2) AS Fraud_Amount
FROM upi_fraud_transaction
GROUP BY Transaction_Type
ORDER BY Fraud_Rate DESC;

-- 3. Fraud transaction by Transaction_Status
SELECT  Transaction_Status, COUNT(*) AS Fraud_Count FROM upi_fraud_transaction
WHERE Is_Fraud = 1
GROUP BY Transaction_Status
ORDER BY Fraud_Count DESC;

-- 4. Fraud rate by Transaction_Status
SELECT Transaction_Status,
COUNT(*) AS Total_Transactions,
SUM(CASE WHEN Is_Fraud = 1 THEN 1 ELSE 0 END) AS Fraud_Transactions,
SUM(CASE WHEN Is_Fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)  AS Fraud_Rate
FROM upi_fraud_transaction
GROUP BY Transaction_Status
ORDER BY Fraud_Rate DESC;

-- 5. Fraud transaction by Transactions_Last_24H
SELECT  Transactions_Last_24H,
COUNT(Transaction_ID) AS Total_Transactions,
COUNT(CASE WHEN Is_Fraud = 1 THEN 1 END) AS Fraud_Transactions,
ROUND(100.0 * COUNT(CASE WHEN Is_Fraud = 1 THEN 1 END)/ COUNT(Transaction_ID),2) AS Fraud_Rate_Pct
FROM upi_fraud_transaction
GROUP BY Transactions_Last_24H
ORDER BY Transactions_Last_24H;

-- 6. Fraud transaction by Failed_Transactions_24H
SELECT  Failed_Transactions_24H, COUNT(*) AS Fraud_Count FROM upi_fraud_transaction
WHERE Is_Fraud = 1
GROUP BY Failed_Transactions_24H
ORDER BY Fraud_Count DESC;

-- 7. Fraud transaction by Device Type
SELECT  Device_Type, COUNT(*) AS Fraud_Count FROM upi_fraud_transaction
WHERE Is_Fraud = 1
GROUP BY Device_Type
ORDER BY Fraud_Count DESC;

-- Location/Time Analysis

-- 8. Fraud transaction by City
select City , count(is_fraud) as Fraud_Count from upi_fraud_transaction
where is_fraud =1
group by City
order by Fraud_Count desc;

-- 9. Fraud rate by City
select City , 
count(*) as Total_fraud_Transaction,
sum(case when Is_Fraud = 1 then 1 else 0 end) AS Fraud_Transactions,
sum(case when Is_Fraud = 1 then 1 else 0 end) * 100.0 / count(*)  AS Fraud_Rate
from upi_fraud_transaction
group by City;

-- 10. Fraud transaction by Fraud_Reason
select Fraud_Reason , count(*) as Fraud_Count from upi_fraud_transaction
where is_fraud =1
group by Fraud_Reason
order by Fraud_Count desc;

-- 11. Most Fraud Sender bank  
select Sender_Bank, COUNT(*) as Fraud_Count from upi_fraud_transaction
where Is_Fraud = 1
group by Sender_Bank
order by Fraud_Count DESC;
	
-- 12. Monthly fraud trend
select year(Transaction_Date) as Transaction_Year, month(Transaction_Date) as Transaction_Month, count(*) as Fraud_Transactions, sum(Amount_INR) as Fraud_Amount
from upi_fraud_transaction
where Is_Fraud = 1
group by year(Transaction_Date), month(Transaction_Date)
order by Transaction_Year,Transaction_Month;

-- 13. Fraud rate by transaction type + device
select transaction_type, device_type,
count(*) as total_transactions,
sum(case when is_fraud = 1 then 1 else 0 end) as fraud_count,
sum(case when is_fraud = 1 then 1 else 0 end) * 100.0 / count(*) as fraud_rate
from upi_fraud_transaction
group by transaction_type, device_type
order by fraud_rate desc;

-- 14. Find risky transaction combinations
select transaction_type, device_type,
count(*) as total_transactions,
sum(case when is_fraud = 1 then 1 else 0 end) as fraud_count,
sum(case when is_fraud = 1 then 1 else 0 end) * 100.0 / count(*) as fraud_rate
from upi_fraud_transaction
group by transaction_type, device_type
having count(*) >= 10 and sum(case when is_fraud = 1 then 1 else 0 end) * 100.0 / count(*) > 10
order by fraud_rate desc;

-- 15. Which fraud reasons cause the highest financial loss?
select fraud_reason,
count(*) as fraud_count,
sum(amount_inr) as fraud_amount
from upi_fraud_transaction
where is_fraud = 1
group by fraud_reason
order by fraud_amount desc;

-- 16. Identify transactions that may need investigation
select transaction_id, amount_inr, transaction_type, device_type, city, sender_bank,receiver_bank, is_fraud,
case 
	when is_fraud = 1 and amount_inr >= 50000 then 'high risk'
	when is_fraud = 1 then 'fraud'
	when amount_inr >= 50000 then 'review' 
	else 'normal'
end as risk_category
from upi_fraud_transaction;

-- 17. differ between fraud and non-fraud transactions?
SELECT  Is_Fraud,
COUNT(Transaction_ID) AS Total_Transactions,
ROUND(AVG(Amount_INR), 2) AS Avg_Transaction_Amount,
ROUND(MIN(Amount_INR), 2) AS Min_Amount,
ROUND(MAX(Amount_INR), 2) AS Max_Amount,
ROUND(SUM(Amount_INR), 2) AS Total_Amount
FROM upi_fraud_transaction
GROUP BY Is_Fraud;

-- 18.  IP risk score correspond with a higher fraud rate?
select 
case
	when ip_risk_score < 20 then 'low (0-19)'
	when ip_risk_score < 40 then 'medium-low (20-39)'
	when ip_risk_score < 60 then 'medium (40-59)'
	when ip_risk_score < 80 then 'high (60-79)'
	else 'very high (80-100)'
end as ip_risk_band,
count(transaction_id) as total_transactions,
count(case when is_fraud = 1 then 1 end) as fraud_transactions,
round( 100.0 * count(case when is_fraud = 1 then 1 end)/ count(transaction_id),2) as fraud_rate_pct
from upi_fraud_transaction
group by 
case
	when ip_risk_score < 20 then 'low (0-19)'
	when ip_risk_score < 40 then 'medium-low (20-39)'
	when ip_risk_score < 60 then 'medium (40-59)'
	when ip_risk_score < 80 then 'high (60-79)'
	else 'very high (80-100)'
end
order by fraud_rate_pct desc;

-- 19. device risk score correspond with a higher fraud rate?
select 
case
	when Device_Risk_Score  < 20 then 'low (0-19)'
	when Device_Risk_Score  < 40 then 'medium-low (20-39)'
	when Device_Risk_Score  < 60 then 'medium (40-59)'
	when Device_Risk_Score  < 80 then 'high (60-79)'
	else 'very high (80-100)'
end as ip_risk_band,
count(transaction_id) as total_transactions,
count(case when is_fraud = 1 then 1 end) as fraud_transactions,
round( 100.0 * count(case when is_fraud = 1 then 1 end)/ count(transaction_id),2) as fraud_rate_pct
from upi_fraud_transaction
group by 
case
	when Device_Risk_Score  < 20 then 'low (0-19)'
	when Device_Risk_Score  < 40 then 'medium-low (20-39)'
	when Device_Risk_Score  < 60 then 'medium (40-59)'
	when Device_Risk_Score  < 80 then 'high (60-79)'
	else 'very high (80-100)'
end
order by fraud_rate_pct desc;

-- 20.  unusual location change associated with fraud?
select 
case
	WHEN Location_Change_KM < 2 THEN '0-2 KM'
	WHEN Location_Change_KM < 10 THEN '2-10 KM'
	WHEN Location_Change_KM < 50 THEN '10-50 KM'
	WHEN Location_Change_KM < 100 THEN '50-100 KM'
	ELSE '100+ KM'
END AS Location_Change_Band,
count(transaction_id) as total_transactions,
count(case when is_fraud = 1 then 1 end) as fraud_transactions,
round( 100.0 * count(case when is_fraud = 1 then 1 end)/ count(transaction_id),2) as fraud_rate_pct
from upi_fraud_transaction
group by 
case
	WHEN Location_Change_KM < 2 THEN '0-2 KM'
	WHEN Location_Change_KM < 10 THEN '2-10 KM'
	WHEN Location_Change_KM < 50 THEN '10-50 KM'
	WHEN Location_Change_KM < 100 THEN '50-100 KM'
	ELSE '100+ KM'
    END 
order by fraud_rate_pct desc;

-- 21 . Which hours have the highest fraud rate?
select 
hour(transaction_date)  as Transaction_Hour,
count(transaction_id) as total_transactions,
count(case when is_fraud = 1 then 1 end) as fraud_transactions,
round( 100.0 * count(case when is_fraud = 1 then 1 end)/ count(transaction_id),2) as fraud_rate_pct
from upi_fraud_transaction
group by Transaction_Hour
order by fraud_rate_pct desc;

-- 22. Which transactions should be considered high-risk for monitoring?
select transaction_id, amount_inr, ip_risk_score, device_risk_score, location_change_km, transactions_last_24h, failed_transactions_24h, is_fraud
from upi_fraud_transaction
where ip_risk_score >= 70  and device_risk_score >= 70  and location_change_km >= 50
order by amount_inr desc;

