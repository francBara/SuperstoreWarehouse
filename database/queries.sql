--Total Profit and Sales per city
SELECT l.Country, l.City, l.State, l.Region, SUM(spo.Profit) as Profit, SUM(spo.Sales) as Sales FROM sales_per_order spo join location l on spo.LocationID=l.LocationID GROUP BY l.Country, l.City, l.State, l.Region;

--Monthly total profit/sales per day
SELECT year, month, SUM(Profit) as Profit, SUM(Sales) as Sales from sales_per_order spo join time t on spo.ShipDateID=t.TimeID group by t.year, t.month order by year, month;

--Total profit/sales per user segment
SELECT Segment, SUM(Profit) as Profit, SUM(Sales) as Sales from sales_per_order natural join customer group by Segment;

--Most profitable products per segment
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