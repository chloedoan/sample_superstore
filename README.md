 # 🛒 Superstore Sales Analysis

## 📌 Overview

This project analyzes the **Superstore retail dataset** to uncover actionable insights on sales, customer behavior, returns, and product performance. The analysis combines **SQL** (for business queries) and **Python** (for exploratory data analysis and visualizations).

---

## 🔍 Dataset Summary

- **Source**: [Kaggle - Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Key Fields**:
  - `Order ID`, `Customer ID`, `Order Date`, `Product ID`, `Sales`, `Profit`, `Category`, `Segment`, `Region`, `Returns`

| Column         | Description                                      |
|----------------|--------------------------------------------------|
| Order ID       | Unique order identifier                         |
| Order Date     | Date when the order was placed                  |
| Ship Date      | Date when the product was shipped               |
| Customer ID    | Unique customer identifier                      |
| Customer Name  | Name of the customer                            |
| Segment        | Market segment (Consumer, Corporate, Home Office)|
| Product Name   | Name of the product                             |
| Category       | Category of the product                         |
| Sub-Category   | More granular product classification            |
| Sales          | Total sales amount                              |
| Profit         | Profit from the order                           |
| Quantity       | Number of items sold                            |
| Discount       | Discount applied                                |
| Region, City   | Geographical fields                             |
| Returns        | Return activity (via linked return table)       |

---

## 🧠 Key Analyses

### 🧾 SQL Business Queries

Structured SQL queries used to address business goals:

1. **Segment Analysis** – Total sales and profit by segment  
2. **Top Products** – Best-selling and most returned products  
3. **Customer-Level Metrics** – Orders, technology sales, revenue per order  
4. **Return Behavior** – Return volume, city-wise sales loss  
5. **Monthly Revenue Growth** – Customer-level trends, ranking, growth  
6. **Customer Retention** – Inactivity flags, return delays, order gaps  
7. **RFM Segmentation** – Behavior-based customer clustering

> Key SQL Features: `GROUP BY`, `JOIN`, `CASE`, `WINDOW FUNCTIONS`, `DATE FUNCTIONS`, `CTEs`

---

### 📊 Python EDA

Performed in Jupyter Notebook using:

- `pandas`, `datetime` – data cleaning and transformation  
- `matplotlib`, `seaborn` – trend charts, heatmaps, bar plots  

#### 🔍 Insights:
- **Sales Trends** – Time-series patterns (monthly, quarterly)
- **Profitability** – Category and sub-category margin analysis
- **Discount Impact** – Correlation between discount and profit
- **Regional Performance** – Heatmaps by state and city

---

## 🛠️ Tools Used

| Tool            | Purpose                                 |
|-----------------|-----------------------------------------|
| **SQL**         | Business analysis, aggregations         |
| **Python**      | EDA, data manipulation & visualization  |
| **Tableau**     | Optional – dashboard & storytelling     |
| **Jupyter**     | Python notebook environment             |

---

## 📈 Business Outcomes

- Discover top-performing segments and customers  
- Identify high-return products and regions  
- Segment customers for personalized marketing  
- Spot at-risk or inactive customers  
- Quantify discount impact on profitability
