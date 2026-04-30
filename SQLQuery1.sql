select * from production.brands  
select *from production.categories
select *from production.categories
select *from production.products
select *from production.stocks
select *from sales.customers
select *from sales.order_items
select *from sales.orders
select *from sales.staffs
select *from sales.stores

SELECT TOP 1 product_name, list_price
FROM production.products
ORDER BY list_price DESC;