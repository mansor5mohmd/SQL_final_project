---1) Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
select top 1 product_name, list_price
from production.products
order by list_price DESC

---How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?
select COUNT(*) AS total_customers
from sales.customers;
--we need to remove repeated data
select COUNT(DISTINCT customer_id) AS active_customers
from sales.orders;
--How many stores does BikeStore have?
select COUNT(*) AS total_stores
from sales.stores;
--(4) What is the total price spent per order?
--(1-discount) wich means give you output for the actual price after disount
select 
    order_id,
    sum(quantity * list_price * (1 - discount)) AS total_price
from sales.order_items
group by order_id;
--5) What’s the sales/revenue per store?
-- we need to get data from anthor table so that is why u used the command join 
select s.store_id,s.store_name ,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
from sales.stores s
join sales.orders o
on s.store_id=o.store_id
join sales.order_items oi
on o.order_id=oi.order_id
group by s.store_id,s.store_name
order by total_revenue desc
--6) Which category is most sold?
select top 1
    c.category_name,
    SUM(oi.quantity) AS total_quantity_sold
from production.categories c
join production.products p
    on c.category_id = p.category_id
join sales.order_items oi
    on p.product_id = oi.product_id
group by  c.category_name
order by total_quantity_sold DESC
--7) Which category rejected more orders?
--
select top 1
    c.category_name,
    COUNT(DISTINCT o.order_id) AS rejected_orders
from production.categories c
join production.products p
    on c.category_id = p.category_id
join sales.order_items oi
    on p.product_id = oi.product_id
join sales.orders o
    on oi.order_id = o.order_id
where o.order_status = 3
group by c.category_name
order by rejected_orders DESC
--Which bike is the least sold?
-- he asked about least one so that's why we used ASC
select top 1
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
from production.products p
join sales.order_items oi
    on p.product_id = oi.product_id
group by p.product_name
order by total_quantity_sold ASC
--9) What’s the full name of a customer with ID 259?
select 
    customer_id,
    first_name + ' ' + last_name AS full_name
from sales.customers
where customer_id = 259
--What did the customer on question 9 buy and when? What’s the status of this order?
-- Use WHEN to define conditions in a CASE expression 
select 
    o.order_date,
    case o.order_status
        when 1 then 'Pending'
        when 2 then 'Processing'
        when 3 then 'Rejected'
        when 4 then 'Completed'
    end as order_status,
    p.product_name
from sales.orders o
join sales.order_items oi
    on o.order_id = oi.order_id
join production.products p
    on oi.product_id = p.product_id
where o.customer_id = 259
---Which staff processed the order of customer 259? And from which store?
select 
    o.order_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    st.store_name
from sales.orders o
join sales.staffs s
    on o.staff_id = s.staff_id
join sales.stores st
    on o.store_id = st.store_id
where o.customer_id = 259
--How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?
-- we know the manager cuz his data was NULL
select count (*) from sales.staffs as total_satff
select s.staff_id,s.manager_id,s.first_name+' '+s.last_name as fullname
from sales.staffs s
where manager_id is null 
--13) Which brand is the most liked?
select top 1
    b.brand_name,
    SUM(oi.quantity) AS total_sold
from production.brands b
join production.products p
    on b.brand_id = p.brand_id
join sales.order_items oi
    on p.product_id = oi.product_id
group by b.brand_name
order by total_sold DESC
--How many categories does BikeStore have, and which one is the least liked?
select top 1
c.category_name,
    SUM(oi.quantity) AS total_sold
 from production.categories c
 join production.products p
 on c.category_id= p.category_id
 join sales.order_items oi
 on p.product_id= oi.product_id
 group by c.category_name 
 order by total_sold asc
 --15) Which store still have more products of the most liked brand?
 select top 1
 p.brand_id,b.brand_name,
 SUM(oi.quantity) AS total_sold
from production.brands b
join production.products p
        on b.brand_id = p.brand_id
join sales.order_items oi
        on p.product_id = oi.product_id
    group by p.brand_id, b.brand_name
    order by total_sold DESC
    -- after that we need to devide the total sold for eash store 
select s.store_name, b.brand_name,
    SUM(st.quantity) AS amount_available
from production.brands b
join production.products p ON b.brand_id = p.brand_id
join production.stocks st ON p.product_id = st.product_id
join sales.stores s ON st.store_id = s.store_id
where b.brand_name = 'Electra' 
group by s.store_name, b.brand_name
order by amount_available DESC
--16) Which state is doing better in terms of sales?

select top 1
st.state,
sum(oi.quantity * oi.list_price *(1-oi.discount)) as best_sate

from sales.orders o
join sales.order_items oi
on o.order_id=oi.order_id
join sales.stores st
       ON o.store_id = st.store_id
group by st.state
order by best_sate DESC
--17) What’s the discounted price of product id 259?
select 
product_id,
list_price,
discount,
  list_price *(1 - discount) AS discounted_price

from sales.order_items
where order_id=259
--18) What’s the product name, quantity, price, category, model year and brand name of product number 44
select 
    p.product_id,
    p.product_name,
    st.quantity,
    p.list_price AS price,
    c.category_name,
    p.model_year,
    b.brand_name
from production.products p
join production.categories c
    on p.category_id = c.category_id
join production.brands b
    on p.brand_id = b.brand_id
join production.stocks st
    on p.product_id = st.product_id
where p.product_id = 44
--19) What’s the zip code of CA?
select distinct 
    state,
    zip_code
from sales.stores
where state = 'CA'
--20) How many states does BikeStore operate in?
select distinct state
from sales.stores
--21) How many bikes under the children category were sold in the last 8 months?
select 
    SUM(oi.quantity) AS children_bikes_sold_last_8_months
from sales.orders o
join sales.order_items oi
    on o.order_id = oi.order_id
join production.products p
    on oi.product_id = p.product_id
join production.categories c
    on p.category_id = c.category_id
where c.category_name = 'Children Bicycles'
--22) What’s the shipped date for the order from customer 523
select shipped_date
from sales.orders
where customer_id = 523;
--23) How many orders are still pending?
select COUNT(*) AS pending_orders
from sales.orders
where order_status = 1
--24) What’s the names of category and brand does "Electra white water 3i -2018" fall under?
select 
    c.category_name,
    b.brand_name
from production.products p
join production.categories c 
    on p.category_id = c.category_id
join production.brands b 
    on p.brand_id = b.brand_id
where p.product_name = 'Electra White Water 3i - 2018'