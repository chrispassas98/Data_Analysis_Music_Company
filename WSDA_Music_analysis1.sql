--How many customers bought 2 tracks for 0.99$ each?
SELECT invoiceDate, BillingAddress, BillingCity, total
FROM Invoice
WHERE total = 1.98
ORDER BY InvoiceDate

--Most Common Billing Countries
SELECT BillingCountry, COUNT(InvoiceId) AS NumberOfInvoices
FROM Invoice
GROUP BY BillingCountry
ORDER BY NumberOfInvoices DESC;


--Total Revenue Over Time:
SELECT strftime('%Y-%m', InvoiceDate) AS Month, SUM(Total) AS Revenue
FROM Invoice
GROUP BY Month
ORDER BY Month;

--Best selling albums
SELECT Album.Title, Artist.Name, SUM(InvoiceLine.Quantity) AS Units_Sold
FROM InvoiceLine
LEFT JOIN Track ON InvoiceLine.TrackId = Track.TrackId
LEFT JOIN Album ON Track.AlbumId = Album.AlbumId
LEFT JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY Album.AlbumId
ORDER BY Units_Sold DESC
LIMIT 10;


--Customer Demographics and Buying Patterns

SELECT c.Country, COUNT(DISTINCT c.CustomerId) AS Number_Of_Customers, round(AVG(i.Total)) AS Average_Spend
FROM Customer AS c
JOIN Invoice AS i ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY Number_Of_Customers DESC;

--Top Selling Artists

SELECT Artist.Name, round(SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity)) AS Total_Revenue
FROM Artist
JOIN Album ON Artist.ArtistId = Album.ArtistId
JOIN Track ON Album.AlbumId = Track.AlbumId
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Artist.Name
ORDER BY Total_Revenue DESC
LIMIT 10;

--Most Popular Genres
SELECT g.Name, SUM(i.Quantity) AS Total_Sales
FROM Genre AS g
LEFT JOIN Track AS t ON g.GenreId = t.GenreId
LEFT JOIN InvoiceLine AS i ON t.TrackId = i.TrackId
GROUP BY g.Name
ORDER BY Total_Sales DESC
LIMIT 10;

--Sales Performance by Employee
SELECT e.FirstName, e.LastName, round(SUM(i.Total)) AS Total_Sales
FROM Employee AS e
LEFT JOIN Customer AS c ON e.EmployeeId = c.SupportRepId
LEFT JOIN Invoice AS i ON c.CustomerId = i.CustomerId
WHERE i.total IS NOT NULL
GROUP BY e.EmployeeId
ORDER BY Total_Sales DESC;

--Sales Performace: Which employyesd are responsible for the highest individual sales?
SELECT e.FirstName, e.LastName, e.EmployeeId, c.FirstName, c.LastName, c.SupportRepId, i.CustomerId, i.total
FROM Invoice AS i
INNER JOIN customer AS c ON i.customerId = c.CustomerId
INNER JOIN Employee AS e ON c.SupportRepId = e.EmployeeId
ORDER BY i.total DESC

--What is the average invoice totals by city?
SELECT BillingCity, round(AVG(total),2) AS Average_Invoice
FROM Invoice
WHERE BillingCity IS NOT NULL
GROUP BY BillingCity 
ORDER BY BillingCity

--How is each individual city performing against the global average sales?
SELECT BillingCity, round(AVG(total)) AS City_Average,
	(SELECT round(AVG(total)) FROM Invoice) AS Global_Average
FROM Invoice
WHERE BillingCity IS NOT NULL
GROUP BY BillingCity
ORDER BY BillingCity

--Playlist Popularity
SELECT p.Name, COUNT(pt.TrackId) AS Track_Count
FROM Playlist AS p
JOIN PlaylistTrack AS pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId
ORDER BY Track_Count DESC

--Selling tracks per country,
SELECT
c.Country,
COUNT(il.TrackId) AS TracksSold,
round(SUM(il.UnitPrice * il.Quantity)) AS TotalSales
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY c.Country
ORDER BY TracksSold DESC, TotalSales DESC;

--Invoices with a total less than the average invoice total

SELECT InvoiceDate, BillingCountry, BillingAddress, BillingCity, Total
FROM Invoice
WHERE Total < (SELECT ROUND(AVG(Total), 2) FROM Invoice)
ORDER BY Total DESC;


--Effect of Music Genre on Sales
	  
SELECT g.Name AS Genre, c.Country, COUNT(il.InvoiceLineId) AS Sales
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY Genre, c.Country
ORDER BY c.Country, Sales DESC;

--Sales by Year and Genre

SELECT
strftime('%Y', i.InvoiceDate) AS Year,
g.Name AS Genre,
ROUND(SUM(il.UnitPrice * il.Quantity)) AS TotalSales
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY Year, Genre
ORDER BY Year, TotalSales DESC;







