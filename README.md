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


### Open the Tableau dashboard
 
1. Open `Bike_Store_Data_Charts_v2026.1.twb` in Tableau Desktop.
2. The workbook's data source points to the original author's local copy of the Excel file. Tableau will prompt you to locate it: choose the `.xlsx` in this project (**Edit Data Source > Browse**) and select the `Main_query_result` sheet.
## The Analytical Query
 
`Query_Build.sql` produces one row per **order, product, store and staff member**. It joins seven lookup tables onto `sales.orders`:
 
| Joined table | Alias | Join key |
|--------------|-------|----------|
| `sales.customers` | `cus` | `customer_id` |
| `sales.order_items` | `items` | `order_id` |
| `production.products` | `products` | `items.product_id` |
| `production.categories` | `category` | `products.category_id` |
| `sales.stores` | `store` | `orders.store_id` |
| `sales.staffs` | `staff` | `orders.staff_id` |
| `production.brands` | `brands` | `products.brand_id` |
 
Two measures are calculated:
 
- **`Total_units`** = `SUM(quantity)`
- **`Revenue`** = `SUM(quantity * list_price)`

## Transformed Dataset
 
The `Main_query_result` sheet of the Excel file holds the query output: **4,156 rows** covering **1,427 orders**.
 
| Column | Description |
|--------|-------------|
| `order_id` | Order identifier |
| `Customer_Name` | Customer first and last name |
| `city`, `state` | Customer location |
| `order_date` | Date the order was placed |
| `Total_units` | Units sold on the line |
| `Revenue` | Line revenue (`quantity * list_price`) |
| `product_name` | Product sold |
| `category_name` | Product category |
| `store_name` | Store that took the order |
| `Staff_name` | Salesperson on the order |
| `brand_name` | Product brand |


## Excel Workbook
 
The workbook has three sheets:
 
- **`Main_query_result`**: the flat dataset described above.
- **`Pivot Table`**: pivot tables of revenue by year and month, state, store, brand, category, top customers and salesperson.
- **`Dashboard`**: an *Executive Dashboard* with seven Excel charts built from the pivots (line, column, pie and bar charts).
## Tableau Dashboard
 
The Tableau workbook connects to `Main_query_result` and contains one dashboard, **Executive Dashboard**, built from these worksheets:
 
| Worksheet | Shows |
|-----------|-------|
| Title / Banner | Dashboard header elements |
| Revenue per year | Yearly revenue trend |
| Revenue per month | Monthly revenue trend |
| Revenue / store | Revenue by store |
| Total Revenue / State | Revenue by state (map) |
| Revenue /Brand_Name | Revenue by brand |
| Revenue/Category | Revenue by product category |
| Revenue_Per_Sales | Revenue by salesperson (adjustable **Top N Salesman** parameter) |
| Revenue_Top_Customers | Top customers by revenue (adjustable **Top N Customers** parameter) |
| Year | Year filter |


## Key Figures
 
Calculated from `Main_query_result`:
 
| Metric | Value |
|--------|------:|
| Total revenue | $7,295,598 |
| Total units sold | 6,233 |
| Orders | 1,427 |
| Revenue 2016 | $2,709,484 |
| Revenue 2017 | $3,845,515 |
| Revenue 2018 (to 7 March) | $740,599 |
 
Revenue by store: Baldwin Bikes $5.06M, Santa Cruz Bikes $1.40M, Rowlett Bikes $0.83M.
Top brand: Trek ($4.27M). Top category: Mountain Bikes ($2.77M).


## Tools Used
 
- Microsoft SQL Server (T-SQL)
- Microsoft Excel (pivot tables and charts)
- Tableau Desktop
## Credits
 
The BikeStores sample database is © 2017 [sqlservertutorial.net](http://www.sqlservertutorial.net/load-sample-database/). All rights reserved by the original author; it is used here for learning and portfolio purposes.
