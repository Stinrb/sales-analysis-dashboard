# 📌 Sales Data Analysis - Power BI & SQL

## 📖 Overview
A dynamic sales analytics project leveraging SQL for database creation, data cleaning, and key insights extraction, followed by Power BI for visualization. This project offers valuable insights into sales performance, team efficiency, and customer behavior.

## 🛠️ Tools Used

- SQL – Database Creation, Data Cleaning, and Validation
- Power BI – Interactive Dashboard Visualization  
- DAX – Dynamic Measures & Calculations  

## 📂 Dataset
- Customers: Personal details & demographics  
- Sales Orders: Order details & revenue  
- Salespersons: Performance & contributions  
- Products: Inventory & sales tracking  
- Items: Individual product variations  
- Product Types: Product classification
- Sales Items – Line-item details for each order

## 🔎 Data Cleaning & Validation
- Removed duplicates  
- Handled NULL/missing values  
- Standardized formats  
- Ensured data integrity  

## 📊 Power BI Dashboard
- Sales Performance: Revenue trends & top products  
- Team Performance: Salesperson leaderboard & efficiency  
- Customer Insights: Segmentation & product popularity  

## 📥 How to Use
1. Run SQL scripts for data preparation  
2. Import cleaned data into Power BI  
3. Explore the interactive dashboard  

## 📈 Key Insights & Findings
### 🛍️ Sales Trends & Performance (2016-2018)
**1. Overall Sales Performance:**
  - A total of 86 orders were placed between 2016-2018.  
  - 302 items were sold, generating a total revenue of $44,830.43.  

**2. Yearly Revenue & Order Trends:**  
  - 2016 had the highest revenue at $17,075.78, with 116 items sold across 29 orders.  
  - 2017 saw a decline in both sales and revenue ($9,794.84), indicating a potential slowdown.  
  - 2018 rebounded with the highest order count (37 orders) and revenue reaching $17,959.81, suggesting renewed demand.

**3. Quarterly Revenue Trends:**  
  - The highest sales spike was observed in Q3 2018 ($6,737.74 revenue).  
  - The lowest revenue quarter was Q2 2017, with just $1,390.30 in sales.  
  - Revenue fluctuations suggest potential seasonal demand shifts or marketing impacts.

**4. Top-Selling Products**  
- The best-performing product was Malek, generating $7,184.19 in total revenue.  
- Other top-selling products include:  
  - Clarkston ($6,587.17)  
  - Ghost 12 ($5,037.66)  
  - Air Max 270 React ($4,943.16)  
- The lowest-selling product was Venetian Loafer, with only $1,240.89 in revenue.  

### :information_desk_person: Team Performance (2016-2018)
**1. Top Salesperson by Orders & Revenue**
  - Samantha Moore handled the most orders (23) but ranked 4th in revenue.  
  - Brittany Jackson had the highest revenue ($12,182.53) despite handling fewer orders (19).

**2. Average Order Value (AOV) per Salesperson**
  - Brittany Jackson led with the highest AOV ($641.19), indicating she likely sold higher-ticket items.  
  - Samantha Moore had the lowest AOV ($463.74), suggesting she processed more frequent but lower-value orders.

**3. Total Orders Over the Period**
  - 86 total orders were placed between 2016-2018.

**4. Revenue Trend by Salesperson (Yearly & Monthly)**
  - Revenue fluctuates, with some months showing significant spikes.
  - Notable high-earning periods:
    - Samantha Moore (May 2016 - $2068.51, June 2016 - $1509.88)
    - Michael Robinson (Nov 2016 - $2297.93)
    - Brittany Jackson (July 2018 - $1936.68, Oct 2018 - $1598.97)
  
### 🛒 Customer Insights (2016-2018)

**1. Total Customers**
  - A total of 19 unique customers made purchases during the sales period.

**2. Customer Age Distribution:**
  - The largest customer group is 65+ years old (8 customers), followed by 25-34 years old (4 customers).  
  - This indicates a significant portion of sales comes from an older customer base.

**3. Customer Location:**
  - The majority of customers are from Texas (10 customers), followed by California (4 customers).  
  - Texas alone accounts for over 50% of the total customer base.

**4. Average Order Value (AOV) by Age Group:**
  - 35-44 years old customers have the highest AOV ($649.61), suggesting they make fewer but higher-value purchases.
  - The 65+ age group generates the most revenue ($16,716.23) but has an AOV of $477.61.

**5. Customer Segmentation:**
  - High-Value Customers: 65+ and 35-44 age groups, contributing the most revenue.
  - Middle-Value Customers: 55-64 and 25-34 age groups.
  - Low-Value Customers: 45-54 age group.

**6. Total Revenue by Location:**
  - Texas generated the highest revenue ($25,009.56), followed by California ($8,690.60).
  - The sales distribution highlights a strong regional demand in TX and CA.

**7. Top-Selling Products by Age Group:**
  - 25-34 years old → Ghost 12 ($1,879.35 revenue, 4 orders).
  - 35-44 years old → Air Max 270 React ($1,129.68 revenue, 4 orders).
  - 45-54 years old → Joyride ($1,014.57 revenue, 5 orders).
  - 55-64 years old → Malek ($1,981.80 revenue, 9 orders).
  - 65+ years old → Clarkston ($2,949.90 revenue, 11 orders).
  - Different age groups have distinct preferences, with Clarkston and Malek being the most popular high-revenue products.


### 📌 Future Improvements
- Sales Forecasting using revenue trend prediction or seasonality analysis can help in projecting future sales based on historical trends  or peak and slow periods.


### ⚠️ Dataset Weaknesses & Cleaning Adjustments
- During data validation, several inconsistencies were found and addressed:

**1️. Missing or Orphaned Records**
- Customer Table
  - Issue Found: 1 orphaned customer (never placed an order)
  - Removed Christopher Robinson (customer_id 20)
  
- Salesperson Table
  - Issue Found: 1 orphaned salesperson (no sales made)
  - Resolution: Removed Jessica Thompson (sales_person_id 5)
    
- Product Table
  - Issue Found: 1 product with no associated items (discontinued)
  - Resolution: Removed product_id 13
    
- Item Table
  - Issue Found: 3 orphaned items (never sold)
  - Resolution: Removed item_id 28, 3, 50
    
- Sales Order Table
  - Issue Found: 14 sales_order_id with no sales item record (invalid orders)
  - Resolution: Removed sales_order_id: 12, 16, 18, 19, 30, 31, 52, 62, 89, 93, 95, 96, 97, 100 

**2️. Unaffected Tables**
- Product Type – No inconsistencies found.  
- Sales Item - No inconsistencies found.

**3️. Dataset Limitations**
- **Small Sample Size** – The dataset contains only 86 valid sales orders over a span of 3 years (2016-2018), limiting the ability to generalize trends or make accurate predictions.
- **Limited Salesperson & Customer Pool** – Only 4 active salespersons and 19 customers are included, which may not fully represent real-world business diversity.
- **No Seasonal or Promotional Data** – The dataset lacks information on promotions or seasonal campaigns, which are crucial factors in real-world sales analysis.

