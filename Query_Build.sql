
-- Query to get all the data from the tables

SELECT
	orders.order_id,
    CONCAT(cus.first_name, ' ', cus.last_name) AS 'Customer_Name',
    cus.city,
    cus.state,
    orders.order_date,
    SUM(items.quantity) AS 'Total_units',
    SUM(items.quantity * items.list_price ) AS 'Revenue',
    products.product_name,
    category.category_name,
    store.store_name,
    CONCAT(staff.first_name, ' ', staff.last_name) as 'Staff_name',
    brands.brand_name
FROM sales.orders orders
JOIN sales.customers cus 
	ON orders.customer_id = cus.customer_id
JOIN sales.order_items items 
	ON orders.order_id = items.order_id
JOIN production.products as products
	ON items.product_id = products.product_id
JOIN production.categories category
	ON products.category_id = category.category_id
JOIN sales.stores store
	ON orders.store_id = store.store_id
JOIN sales.staffs staff
	ON orders.staff_id = staff.staff_id
JOIN production.brands brands
	ON products.brand_id = brands.brand_id
GROUP BY 
	 cus.city, 
     orders.order_date,
     cus.state,
     orders.order_id,
     products.product_name,
     category.category_name,
     store.store_name,
     brands.brand_name
     
     