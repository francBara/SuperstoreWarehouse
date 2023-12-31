--Total Profit and Sales per city - DA
SELECT l.Country, l.City, l.State, l.Region, SUM(spo.Profit) as Profit, SUM(spo.Sales) as Sales FROM sales_per_order spo join location l on spo.LocationID=l.LocationID GROUP BY l.Country, l.City, l.State, l.Region;

--Monthly total profit/sales per day - DA
SELECT year, month, SUM(Profit) as Profit, SUM(Sales) as Sales from sales_per_order spo join time t on spo.ShipDateID=t.TimeID group by t.year, t.month order by year, month;

--Total profit/sales per user segment - DA
SELECT Segment, SUM(Profit) as Profit, SUM(Sales) as Sales from sales_per_order natural join customer group by Segment;

--Profit Margin per month and year
SELECT year, month, SUM(Profit) / SUM(Sales) * 100 as 'Profit Margin' from sales_per_order spo, time t where spo.ShipDateID=t.TimeID group by t.year, t.month order by year, month;

--Number of customores per segment - DA
select Segment, count(*) as Customers from customer group by Segment;

--Most profitable products per segment - DA
SELECT 
    c.Segment, 
    p.ProductID, 
    p.Name as ProductName, 
    SUM(spi.Profit) as Profit, 
    SUM(spi.Sales) as Sales 
FROM 
    sales_per_item spi 
    JOIN customer c ON spi.CustomerID = c.CustomerID 
    JOIN product p ON spi.ProductID = p.ProductID 
    JOIN (
        SELECT 
            spi2.ProductID, 
            c2.Segment,
            RANK() OVER (PARTITION BY c2.Segment ORDER BY SUM(spi2.Profit) DESC) as ProfitRank
        FROM 
            sales_per_item spi2 
            JOIN customer c2 ON spi2.CustomerID = c2.CustomerID 
        GROUP BY 
            spi2.ProductID, c2.Segment
    ) as RankedProducts ON p.ProductID = RankedProducts.ProductID AND c.Segment = RankedProducts.Segment
WHERE 
    RankedProducts.ProfitRank <= 5
GROUP BY 
    c.Segment, 
    p.ProductID order by c.Segment, SUM(spi.Profit) DESC;



--Number of locations per customer - DA
SELECT c.CustomerID, c.Name, COUNT(DISTINCT l.LocationID) as LocationsNumber from sales_per_order spi, customer c, location l where spi.CustomerID=c.CustomerID
and spi.LocationID=l.LocationID group by c.CustomerID order by LocationsNumber desc;


--Most profitable cities during time - DA
SELECT l.Country, l.State, l.Region, l.City, t.Year, t.Month, SUM(spo.Profit) as Profit, SUM(spo.Sales) as Sales
from location l, sales_per_order spo, time t where l.LocationID=spo.LocationID and t.TimeID=spo.ShipDateID
group by l.Country, l.State, l.Region, l.City, t.Year, t.Month order by t.Year ASC, t.Month ASC, Profit DESC;

--Total profit/sales per product subcategory each month, ranked by profit - DA
SELECT p.Category, p.Subcategory, t.year, t.month, SUM(spi.Profit) as Profit, SUM(spi.Sales) as Sales from sales_per_item spi, product p, time t
where spi.ProductID=p.ProductID and spi.OrderDateID=t.TimeID group by p.Category, p.Subcategory, t.year, t.month order by t.year asc, t.month asc,
Profit desc;

--Total number of products sold per category
SELECT p.Category, SUM(i.Quantity) as Quantity FROM store.product as p JOIN store.item_sales as i on p.ProductID=i.ProductID group by p.Category;

--Total sales and profit per product category
SELECT p.Category, SUM(i.Sales) as Sales, SUM(i.Profit) as Profit FROM store.product as p JOIN store.item_sales as i on p.ProductID=i.ProductID group by p.Category;

--Moving average on profit with window of 5, per month
select year, month, sum(profit) as profit, avg(sum(profit)) over(order by t.year, t.month rows between 5 preceding and current row) as ma_profit from sales_per_item spi, time t
where spi.orderdateid=t.timeid group by t.year, t.month