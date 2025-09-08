 # 🛒 Superstore Sales Analysis

## 📌 Overview

This project analyzes the **Superstore retail dataset** to uncover actionable insights on sales, customer behavior, returns, and product performance. The analysis combines **Tableau** (for visualization), **SQL** (for business queries) and **Python** (for exploratory data analysis and visualizations).

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

## 📁 Tableau Dashboard

### 🛠️ Tableau Public Link: 

[Sample Superstore - Revenue and Profit KPI](https://public.tableau.com/app/profile/chloe.doan/viz/SampleSuperstore-RevenueProfitKPI/Dashboard6?publish=yes)

### 🔍 Overview

<img width="1393" height="799" alt="Screenshot 2025-07-27 at 4 46 23 PM" src="https://github.com/user-attachments/assets/cd01ac5f-90bd-4d7e-a155-8a2d0d1beb72" />


#### Key Insights
- MTD Sales: $85,175 as of Dec 30, 2025, showing an **-11.98% YoY decline**, signaling weaker December performance compared to last year.  
- Pre-Month Sales: November closed at $123,786, a **+55.88% YoY increase**, indicating a strong month before the December drop.  
- YTD Sales: $745,568, reflecting a **+21.59% YoY growth**, meaning the business remains on track overall despite the December dip.  

- Sales Trend (Months): Peaks in **November ($353K)** and notable low in **February (~$60K)** highlight seasonal fluctuations.  
- MTD by State: California is the top contributor ($19,318 sales, $3,859 profit), while Illinois shows a loss (-$3,145).  
- MTD by Category: Chairs dominate category sales ($14,966), while other sub-categories show smaller but stable contributions.  

**Key Takeaway**: Strong YoY growth overall (+21.6%), but December underperformed. Focus on managing seasonal volatility and addressing unprofitable states (e.g., Illinois).

**Business Suggestions**
- Seasonality Management December underperformance (-12% YoY) suggests a need for targeted promotions or bundled offers in Q4 to stabilize end-of-year sales.  
- Geographic Focus: Expand efforts in California (highest sales & profit) and investigate reasons for Illinois losses (-$3,145), possibly renegotiating supplier terms or adjusting pricing.  
- Category Optimization: Chairs drive the highest sales ($14,966). Consider cross-selling complementary categories (tables, furnishings) to increase average order value.  
- Profitability Monitoring: Implement margin-based KPIs in Tableau to flag low-profit states/categories in real time for faster corrective action.  


### 🔗 Customer

<img width="1358" height="773" alt="Screenshot 2025-07-27 at 4 46 39 PM" src="https://github.com/user-attachments/assets/29181e56-1074-4653-971e-abc717f2d449" />


#### Key Insights
- YTD Sales: $745,568 from Jan–Dec 2025, a **+21.59% YoY increase**, showing healthy overall performance.  
- Customer Segments: Consumer and Corporate drive the bulk of sales, while Home Office lags behind, suggesting potential growth opportunities.  
- YTD Customers: 704 customers, an **+7.98% YoY increase**, reflecting expansion in the customer base.  

- Monthly Orders: Customer orders show consistent growth throughout the year, with strong peaks in **September–December**.  
- Top Customers:  
  - Sean Miller (Jacksonville) generated the highest single sales ($23,661) but at a **negative profit ratio (-7.56%)**.  
  - Tamara Chand (Lafayette) and Raymond Buch (Seattle) achieved strong **profit ratios of ~48%**, making them highly valuable.  
  - Tom Ashbrook (NYC) contributed $13,716 with a healthy **33.5% profit margin**, but order is still processing.  

**Key Takeaway**: Growth is driven by Consumer/Corporate segments and profitable customers like Tamara Chand & Raymond Buch. However, negative-margin customers (e.g., Sean Miller, Becky Martin) need closer monitoring.

**Business Suggestions**

- Customer Segments: Invest more in **Consumer and Corporate** segments while designing targeted campaigns to grow the underperforming **Home Office** segment.  
- Customer Profitability: Focus retention efforts on high-margin customers like Tamara Chand (+47.8%) and Raymond Buch (+47.9%), while revisiting discount structures for loss-making accounts like Sean Miller (-7.6%).  
- Order Patterns: Capitalize on strong Q3–Q4 peaks with loyalty offers or seasonal promotions to boost sales further during high-demand months.  
- Data-driven Targeting: Use segmentation in Tableau to identify top 20% of customers by profit contribution and prioritize them in account management strategies.  


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
