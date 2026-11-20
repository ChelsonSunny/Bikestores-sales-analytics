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
│ Create schema│  --->  │ Join 8 tables │  --->  │ Main_query_    │ --->  │ Executive        │
│ Load data    │        │ into one flat │        │ result + pivot │       │ Dashboard        │
│ (9 tables)   │        │ result set    │        │ tables         │       │ (10 worksheets)  │
└──────────────┘        └───────────────┘        └────────────────┘       └──────────────────┘
```
 
1. **Build** the `BikeStores` database (schemas, tables, sample data).
2. **Query** the database with `Query_Build.sql` to produce one denormalised result set.
3. **Export** the result to Excel (`Main_query_result` sheet), then build pivot tables and a summary dashboard.
4. **Visualise** the same data in Tableau, which connects directly to the Excel file.

## Repository Contents
 
| File | Purpose |
|------|---------|
| `BikeStores_Sample_Database_-_create_objects.sql` | Creates the `sales` and `production` schemas and all nine tables with keys and constraints. |
| `BikeStores_Sample_Database_-_load_data.sql` | Loads the sample data (about 9,000 `INSERT` statements). |
| `BikeStores_Sample_Database_-_drop_all_objects.sql` | Drops all tables and schemas, for resetting the database. |
| `Query_Build.sql` | The analytical query that joins the tables into a single flat dataset. |
| `BikeStores_Data_Transformed(AutoRecovered)(AutoRecovered).xlsx` | The query output (`Main_query_result`) plus a `Pivot Table` sheet and an `Dashboard` sheet with Excel charts. |
| `Bike_Store_Data_Charts_v2026.1.twb` | Tableau workbook with the worksheets and the *Executive Dashboard*. |


## Database Schema
 
The database has two schemas and nine tables.
 
**`production` schema**
 
| Table | Description |
|-------|-------------|
| `brands` | Product brands (`brand_id`, `brand_name`) |
| `categories` | Product categories (`category_id`, `category_name`) |
| `products` | Products with brand, category, model year and list price |
| `stocks` | Stock quantity of each product at each store |
 
**`sales` schema**
 
| Table | Description |
|-------|-------------|
| `customers` | Customer name, contact details and address |
| `stores` | Store name, contact details and address |
| `staffs` | Staff members, their store and their manager (self-referencing) |
| `orders` | Order header: customer, status, dates, store and staff |
| `order_items` | Order lines: product, quantity, list price and discount |
 
Order status codes in `orders.order_status`: `1` = Pending, `2` = Processing, `3` = Rejected, `4` = Completed.
 
### Relationships
 
```
brands ──< products >── categories
              │
              ├──< order_items >── orders >── customers
              │                      ├────── stores ──< staffs
              │                      └────── staffs
              └──< stocks >── stores
```
 
### Row counts (from the load script)
 
| Table | Rows |
|-------|-----:|
| `production.brands` | 9 |
| `production.categories` | 7 |
| `production.products` | 320 |
| `production.stocks` | 215 |
| `sales.customers` | 2,889 |
| `sales.stores` | 3 |
| `sales.staffs` | 10 |
| `sales.orders` | 1,615 |
| `sales.order_items` | 4,156 |
 
## Getting Started
 
### Prerequisites
 
- Microsoft SQL Server (the scripts use T-SQL features such as `IDENTITY`, `GO` and `DROP ... IF EXISTS`) and a client such as SQL Server Management Studio or Azure Data Studio
- Microsoft Excel
- Tableau Desktop (the workbook was saved with version 18.1 files)
### Set up the database
 
1. Create and select an empty database, for example `BikeStores`.
2. Run the scripts in this order:
   1. `BikeStores_Sample_Database_-_create_objects.sql`
   2. `BikeStores_Sample_Database_-_load_data.sql`
3. To start over, run `BikeStores_Sample_Database_-_drop_all_objects.sql`, then repeat step 2.
### Generate the analysis dataset
 
1. Run `Query_Build.sql` against the `BikeStores` database.
2. Export the result to Excel on a sheet named `Main_query_result`.
