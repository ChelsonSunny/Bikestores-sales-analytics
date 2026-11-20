# Bikestores-sales-analytics
An end-to-end sales analytics project built on the **BikeStores** sample database (from [sqlservertutorial.net](http://www.sqlservertutorial.net/load-sample-database/)). Raw relational data is modelled in SQL Server, flattened into a single analysis-ready dataset with SQL, summarised in Excel, and visualised in an interactive Tableau dashboard.


## Project Overview
 
BikeStores is a fictional bicycle retailer with three stores, a staff team, a product catalogue and a customer order history. This project answers business questions such as:
 
- How has revenue changed by year and by month?
- Which stores, states, brands and product categories drive the most revenue?
- Who are the top customers and top-performing salespeople?



## Workflow
 
```
 SQL Server                 SQL query                 Excel                   Tableau
┌──────────────┐        ┌───────────────┐        ┌────────────────┐       ┌──────────────────┐
│ Create schema │  --->  │ Join 8 tables │  --->  │ Main_query_    │ --->  │ Executive         │
│ Load data     │        │ into one flat │        │ result + pivot │       │ Dashboard         │
│ (9 tables)    │        │ result set    │        │ tables         │       │ (10 worksheets)   │
└──────────────┘        └───────────────┘        └────────────────┘       └──────────────────┘
```
 
1. **Build** the `BikeStores` database (schemas, tables, sample data).
2. **Query** the database with `Query_Build.sql` to produce one denormalised result set.
3. **Export** the result to Excel (`Main_query_result` sheet), then build pivot tables and a summary dashboard.
4. **Visualise** the same data in Tableau, which connects directly to the Excel file.
