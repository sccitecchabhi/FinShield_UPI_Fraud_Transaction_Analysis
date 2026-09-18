# 🛡️ FinShield – UPI Fraud Transaction Analytics

An end-to-end **UPI Fraud Transaction Analytics** project built to identify fraudulent transaction patterns, understand risk signals, measure financial exposure, and create a business-focused fraud monitoring dashboard using **Python, SQL, and Power BI**.

---

## 📌 Project Overview

FinShield converts transaction-level UPI data into actionable business insights through a complete Data Analyst workflow:

**Raw Data → Data Cleaning → Python EDA → SQL Analysis → Power BI Dashboard → Business Insights → Recommendations**

The project examines four major areas:

1. **Fraud Scale & Financial Exposure**
2. **Transaction, Device & Channel Behavior**
3. **Risk & Location Signals**
4. **Time & Operational Monitoring**

The dataset contains **50,000 transactions and 21 fields**.

### 🎯 Core Business Problem

> **How can a digital payments business identify transaction, device, location, behavioral, and risk characteristics associated with fraudulent UPI activity and use them to strengthen fraud monitoring?**

---

# 🎯 Business Objectives

The main objectives of this project are to:

* Measure total transaction volume and fraud volume.
* Calculate the overall fraud rate.
* Measure the financial value associated with fraud.
* Identify transaction types with higher observed fraud rates.
* Analyze fraud patterns across device types.
* Identify geographic and location-change patterns.
* Analyze IP and device risk scores.
* Understand time-based fraud patterns.
* Investigate behavioral signals such as transaction frequency and failed transactions.
* Identify data-quality issues in fraud classification.
* Build an interactive Power BI dashboard for fraud monitoring.

---

# 📊 Dataset Overview

The dataset contains:

* **50,000 transaction records**
* **21 columns**
* Each row represents a UPI transaction.

### Important Columns

| Category          | Columns                                                                                             |
| ----------------- | --------------------------------------------------------------------------------------------------- |
| Transaction       | `Transaction_ID`, `Transaction_Date`, `Transaction_Type`, `Amount_INR`, `Transaction_Status`        |
| Participants      | `Sender_ID`, `Receiver_ID`, `Sender_Bank`, `Receiver_Bank`                                          |
| Location & Device | `City`, `Device_Type`, `Location_Change_KM`                                                         |
| Behavioral        | `Transactions_Last_24H`, `Avg_Transaction_Amount_7D`, `Failed_Transactions_24H`, `Account_Age_Days` |
| Risk              | `IP_Risk_Score`, `Device_Risk_Score`                                                                |
| Fraud             | `Fraud_Reason`, `Fraud_Label`, `Is_Fraud`                                                           |

These fields allow the analysis to connect transaction behavior with risk, location, device, and fraud labels.

---

# 🔄 Project Workflow

## 1. Data Understanding

The raw dataset was first inspected to understand:

* Dataset shape and structure
* Column names and data types
* Missing values
* Duplicate transactions
* Transaction ID uniqueness
* Categorical consistency
* Numeric ranges
* Fraud-label fields
* Potential statistical outliers

The analysis also considered whether unusual values could represent genuine user behavior rather than data-entry errors.

---

# 🧹 2. Data Cleaning & Preparation

Python/Pandas was used to prepare the dataset for reliable analysis.

### Data Quality Checks

* Missing-value validation
* Duplicate-row validation
* Transaction ID uniqueness
* Date formatting and validation
* Categorical consistency
* Amount outlier investigation
* IP risk score validation
* Device risk score validation
* Location-change investigation
* Behavioral activity investigation
* Fraud label/reason consistency

The supplied cleaned dataset contained **no missing cells or duplicate full rows**, and transaction IDs were unique. Transaction dates were converted and validated.

### ⚠️ Important Data Quality Issue

A significant inconsistency was identified:

**1,987 fraud-labeled transactions have `Fraud_Reason = "Normal Activity"`**.

These records were retained but flagged because the issue should be investigated before using `Fraud_Reason` as a fully reliable fraud driver.

### Outlier Treatment

The project did **not automatically remove every outlier**.

Instead, unusual values were evaluated using business logic.

For example:

* A large transaction can be genuine.
* A large location change can represent genuine movement.
* High transaction activity can be a useful fraud signal.

This approach prevents potentially useful fraud signals from being removed during cleaning.

---

# 🐍 3. Python Exploratory Data Analysis

Python was used to establish the fraud baseline and identify patterns that required deeper SQL analysis and Power BI visualization.

## 📌 Headline KPIs

| KPI                           |           Result |
| ----------------------------- | ---------------: |
| Total Transactions            |           50,000 |
| Fraudulent Transactions       |            2,794 |
| Fraud Rate                    |            5.59% |
| Total Transaction Amount      | ≈ ₹40.77 Million |
| Fraudulent Transaction Amount |  ≈ ₹2.23 Million |
| Fraud-Labeled Value Share     |            5.47% |
| Average Transaction Amount    |        ≈ ₹815.48 |
| Average Fraud Amount          |        ≈ ₹798.84 |

Fraud-labeled transactions represent approximately **5.47% of total transaction value**. The average fraud transaction amount is close to the overall average, indicating that **transaction amount alone does not clearly separate fraud from legitimate activity**.

---

# 🔍 Fraud Analysis by Transaction Type

| Transaction Type | Observed Fraud Rate |
| ---------------- | ------------------: |
| Collect Request  |               7.40% |
| UPI ID           |               5.73% |
| QR Code          |               5.64% |
| Mobile Number    |               5.58% |

**Collect Request** has the highest observed fraud rate among the listed transaction types.

---

# 📱 Fraud Analysis by Device Type

| Device Type | Observed Fraud Rate |
| ----------- | ------------------: |
| Web         |               9.13% |
| Android     |               5.41% |
| iOS         |               5.38% |

Web transactions show a higher observed fraud rate in this dataset.

---

# 🌍 Fraud Analysis by City

| City      | Observed Fraud Rate |
| --------- | ------------------: |
| Bhopal    |               6.09% |
| Kolkata   |               5.99% |
| Hyderabad |               5.86% |
| Bangalore |               5.76% |
| Chennai   |               5.67% |
| Pune      |               5.62% |
| Delhi     |               5.59% |
| Jaipur    |               5.55% |
| Ahmedabad |               5.54% |
| Mumbai    |               5.37% |

These figures represent **observed associations within the project dataset** and should not be interpreted as evidence that a city causes fraud.

---

# ⚠️ Risk Score Analysis

## IP Risk Score

| IP Risk Band | Observed Fraud Rate |
| ------------ | ------------------: |
| 0–20         |               2.52% |
| 21–40        |               3.37% |
| 41–60        |               4.68% |
| 61–80        |               6.56% |
| 81–100       |              10.44% |

## Device Risk Score

| Device Risk Band | Observed Fraud Rate |
| ---------------- | ------------------: |
| 0–20             |               2.51% |
| 21–40            |               3.42% |
| 41–60            |               4.62% |
| 61–80            |               6.42% |
| 81–100           |               9.53% |

Observed fraud rates increase across the higher IP and device-risk bands.

---

# 📍 Location Change Analysis

| Location Change | Observed Fraud Rate |
| --------------- | ------------------: |
| 0–5 km          |               5.52% |
| 6–10 km         |               5.50% |
| 11–20 km        |               5.68% |
| 21–40 km        |               5.99% |
| 41+ km          |               9.07% |

Transactions with **41+ km location change** show a higher observed fraud rate and can be combined with other risk signals for investigation.

---

# 🕐 Time-Based Analysis

The project analyzed fraud patterns by transaction hour and month.

The highest observed hourly fraud rates were:

* **20:00 → 6.92%**
* **02:00 → 6.71%**

Time-based analysis helps identify periods where monitoring intensity may need to change.

---

# 🗄️ 4. SQL Business Analysis

SQL was used to convert Python EDA findings into **structured and reproducible business analysis**.

### SQL Analysis Areas

* Total Transactions
* Fraudulent Transactions
* Fraud Rate
* Total Transaction Amount
* Fraudulent Transaction Amount
* Fraud Rate by Transaction Type
* Fraud Rate by Device Type
* Fraud Rate by City
* IP Risk Range Analysis
* Device Risk Range Analysis
* Location Change Analysis
* Fraud by Transaction Hour

The SQL layer provides consistent calculations that can be reused for reporting and dashboard development.

### Key SQL Business Questions

1. What is the total number of transactions?
2. How many transactions are fraudulent?
3. What is the overall fraud rate?
4. What is the total transaction value?
5. What amount is associated with fraud?
6. Which transaction types show higher fraud rates?
7. Which device types show higher fraud rates?
8. Which cities show higher observed fraud rates?
9. How does fraud rate change across IP risk ranges?
10. How does fraud rate change across device risk ranges?
11. Does location change relate to observed fraud?
12. How does fraud rate vary by transaction hour?

---

# 📈 5. Power BI Dashboard

Power BI was used as the final **decision-support and fraud-monitoring layer**.

The dashboard contains **three pages**.

---

## 🏠 Page 1 – Home

### Business Question

**What is the overall fraud picture?**

### KPIs

* Total Transactions
* Total Fraud Transactions
* Fraud Rate %
* Total Fraud Amount
* Average Fraud Amount

### Visuals

* Fraud vs Non-Fraud
* Hourly Fraud Trend
* Monthly Fraud Trend
* Fraud by Device Type
* Fraud by Transaction Type
* Fraud by City

This page provides a management-level overview of fraud activity.

---

## ⚠️ Page 2 – Risk Analysis

### Business Question

**Which risk signals are associated with fraud?**

### Analysis

* IP Risk Score vs Device Risk Score
* IP Risk Range
* Device Risk Range
* Transaction Frequency Range
* Device/Transaction Type breakdowns
* City/Transaction Type breakdowns

This page supports risk-based monitoring.

---

## 📍 Page 3 – Transaction & Location

### Business Question

**Where and when is fraud activity concentrated?**

### Analysis

* Location Change Ranges
* Fraud Amount by Hour
* Device/Transaction Type Analysis
* City Analysis
* Risk vs Amount
* Location Change vs Amount

Scatter plots help explore relationships between risk, transaction amount and location behavior.

---

# 🧮 DAX Measures

The Power BI dashboard uses reusable DAX measures.

### Total Transactions

```DAX
Total Transactions =
COUNTROWS(UPI_Transactions)
```

### Total Fraud Transactions

```DAX
Total Fraud Transaction =
CALCULATE(
    COUNTROWS(UPI_Transactions),
    UPI_Transactions[Is_Fraud] = 1
)
```

### Fraud Rate

```DAX
Fraud Rate % =
DIVIDE(
    [Total Fraud Transaction],
    [Total Transactions],
    0
)
```

### Total Fraud Amount

```DAX
Total Fraud Amount =
CALCULATE(
    SUM(UPI_Transactions[Amount_INR]),
    UPI_Transactions[Is_Fraud] = 1
)
```

### Average Fraud Amount

```DAX
Average Fraud Amount =
CALCULATE(
    AVERAGE(UPI_Transactions[Amount_INR]),
    UPI_Transactions[Is_Fraud] = 1
)
```

### Average Transaction Amount

```DAX
Average Transaction Amount =
AVERAGE(UPI_Transactions[Amount_INR])
```

These measures allow dashboard KPIs to respond dynamically to filters and slicers.

---

# 💡 Key Business Insights

### Fraud Scale

The dataset contains **50,000 transactions**, including **2,794 fraud-labeled transactions**, resulting in a **5.59% observed fraud rate**.

### Financial Exposure

Fraud-labeled transactions represent approximately **₹2.23M**, or **5.47% of total transaction value**.

### Transaction Type

**Collect Request** has the highest observed fraud rate at **7.40%** among the listed transaction types.

### Device Type

**Web** transactions have an observed fraud rate of **9.13%**.

### IP Risk

Observed fraud rate increases from **2.52%** in the 0–20 IP-risk band to **10.44%** in the 81–100 band.

### Device Risk

Observed fraud rate increases from **2.51%** in the 0–20 device-risk band to **9.53%** in the 81–100 band.

### Location Behavior

Transactions with **41+ km location change** show a **9.07% observed fraud rate**, compared with **5.52%** for 0–5 km.

### Transaction Amount

The average fraud transaction amount (**₹798.84**) is close to the overall average (**₹815.48**), so amount alone is not a strong discriminator.

### Data Quality

**1,987 fraud-labeled transactions** have `Fraud_Reason = "Normal Activity"`, which should be investigated before automated use.

---

# 🎯 Business Recommendations

Based on the analysis:

1. **Strengthen risk-based monitoring** for transactions in higher IP and device-risk bands.
2. **Monitor web transactions** closely because of their higher observed fraud rate in this dataset.
3. **Review Collect Request activity** as it shows the highest observed fraud rate among the listed transaction types.
4. **Investigate large location changes**, especially the 41+ km segment, together with other risk signals.
5. **Use time-based monitoring** because observed fraud rates vary across transaction hours.
6. **Do not rely on transaction amount alone**; combine amount with behavioral and risk signals.
7. **Resolve the Fraud_Reason data-quality issue** affecting 1,987 fraud-labeled transactions.
8. **Use Power BI as a recurring monitoring framework** to track fraud rate, fraud amount, risk bands, device type, transaction type, city, location change and time patterns.

---

# 📊 Fraud Monitoring Framework

| Monitoring Area | KPI / View                                     | Purpose                                        |
| --------------- | ---------------------------------------------- | ---------------------------------------------- |
| Fraud Scale     | Fraud Rate %, Fraud Count, Fraud Amount        | Track overall fraud exposure                   |
| Risk            | IP Risk Range, Device Risk Range               | Detect higher-risk concentrations              |
| Behavior        | Transactions Last 24H, Failed Transactions 24H | Identify unusual recent activity               |
| Channel         | Fraud Rate by Transaction Type / Device        | Monitor channel-specific patterns              |
| Location        | Fraud Rate by City / Location Change           | Identify geographic and movement patterns      |
| Time            | Fraud Rate by Hour / Month                     | Identify periods requiring enhanced monitoring |
| Data Quality    | Fraud Label vs Fraud Reason                    | Prevent incorrect interpretation               |

---

# 🛠️ Tools & Technologies

### Programming & Analysis

* Python
* Pandas
* NumPy
* Matplotlib
* Seaborn

### Database & Querying

* SQL
* Aggregation
* `COUNT`
* `SUM`
* `CASE`
* `GROUP BY`
* Segmentation
* Date/Time Analysis

### Visualization

* Power BI
* KPI Cards
* Slicers
* Charts
* Trend Analysis
* Scatter Plots
* Risk Segmentation

### DAX

* `COUNTROWS`
* `CALCULATE`
* `SUM`
* `AVERAGE`
* `DIVIDE`

### Data Sources

* CSV
* Excel

---
FinShield-UPI-Fraud-Transaction-Analysis/
│
├── 📂 Business Problem/
│   └── Business problem and objectives
│
├── 📂 Raw Data/
│   └── Original UPI fraud transaction dataset
│
├── 📂 Cleaned Data/
│   └── Cleaned and validated dataset
│
├── 📂 Python EDA/
│   └── Python notebook containing data cleaning and exploratory data analysis
│
├── 📂 SQL Analysis/
│   └── SQL queries used for KPI and business analysis
│
├── 📂 Power-BI/
│   └── Power BI dashboard file
│
├── 📂 FinShield Report/
│   └── Detailed project report
│
└── 📄 README.md
    └── Project documentation

---

# 🔁 End-to-End Analytical Approach

```text
Raw UPI Transaction Data
          ↓
Data Understanding
          ↓
Data Cleaning & Validation
          ↓
Python EDA
          ↓
Business Questions
          ↓
SQL Analysis
          ↓
KPI & Risk Analysis
          ↓
Power BI Dashboard
          ↓
Business Insights
          ↓
Monitoring Recommendations
```

---

# 🏆 Skills Demonstrated

| Area              | Skills                                                                                                                   |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Data Cleaning     | Missing-value checks, duplicate checks, datetime conversion, categorical validation, range checks, outlier investigation |
| Python            | Pandas, aggregation, grouping, fraud-rate calculations, descriptive analysis, business-focused EDA                       |
| SQL               | COUNT, SUM, CASE, GROUP BY, segmentation, fraud-rate calculations, date/time analysis                                    |
| Power BI          | Dashboard design, KPI cards, slicers, charts, scatter plots, risk segmentation                                           |
| DAX               | COUNTROWS, CALCULATE, SUM, AVERAGE, DIVIDE                                                                               |
| Business Analysis | KPI selection, risk-segment analysis, pattern identification, recommendations, data-quality interpretation               |
| Communication     | Converting technical analysis into business problems, insights, recommendations and an interview-ready project story     |

---

# ⚠️ Project Limitations

* This is a **project dataset** and should not be interpreted as actual RBI/NPCI production transaction data.
* Fraud rates are **descriptive associations within the supplied dataset** and do not establish causation.
* The `Fraud_Reason` field contains an inconsistency where **1,987 fraud-labeled records** are marked `"Normal Activity"`.
* Risk thresholds such as **81+** are analytical monitoring bands used for this project and should be calibrated against real-world model performance before operational deployment.
* The dashboard should be refreshed and monitored over time rather than treated as a one-time fraud conclusion.

---

# 📌 Project Note

The supplied dataset is a **project dataset created for analytics practice**. This project does not claim that the data represents actual RBI/NPCI production transactions.
