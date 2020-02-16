--1. non_usa_customers: query showing Customers (just their full names, customer ID and country) who are not in the US
select firstname ||" " ||lastname as FullName, CustomerId, country
from Customer
where country != "USA";

--2. brazil_customers: query only showing the Customers from Brazil
select firstname ||" " ||lastname as FullName, CustomerId, country
from Customer
where country = "Brazil";

--3. brazil_customers_invoices: query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
select firstname ||" " ||lastname as FullName, i.InvoiceId, i.InvoiceDate , i.BillingCountry 
from Customer c , Invoice i 
where c.CustomerId = i.CustomerId; 

--4. sales_agents: query showing only the Employees who are Sales Agents.
select * 
from Employee
where title="Sales Support Agent";

--5. unique_invoice_countries: query showing a unique/distinct list of billing countries from the Invoice table
select distinct BillingCountry
from Invoice;

--6. sales_agent_invoices: query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name
select e.firstname || " " || e.lastname as FullName, i.invoiceid
from Employee e, customer c, invoice i
on e.EmployeeId = c.SupportRepId and c.CustomerId =i.CustomerId
order by e.EmployeeId, i.InvoiceId;   

--7. invoice_totals.sql: query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
select i.InvoiceId, c.FirstName || " " || c.LastName as CustomerName, c.Country, e.firstname || " " || e.lastname as EmployeeName
from invoice i
left join Customer c
on i.CustomerId = c.CustomerId
left join Employee e
on c.SupportRepId = e.employeeid;

--8. total_invoices_{year}: How many Invoices were there in 2009 and 2011
select count(i.InvoiceId) as NumberInvoices
from Invoice i 
where i.InvoiceDate like "%2009%";

select count(i.InvoiceId) as NumberInvoices
from Invoice i 
where i.InvoiceDate like "%2011%";

--9. total_sales_{year}: What are the respective total sales for each of those years?
select sum(i.Total) as TotalSales
from Invoice i 
where i.InvoiceDate like "%2009%";

select sum(i.Total) as TotalSales
from Invoice i 
where i.InvoiceDate like "%2011%";

--10. invoice_37_line_item_count: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
select count(TrackId) as NumberOfLineItems
from InvoiceLine
where InvoiceId = 37;

--11. line_items_per_invoice: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
select InvoiceId, count(TrackId) as NumberOfLineItems
from InvoiceLine
group by InvoiceId;

--12. line_item_track: Provide a query that includes the purchased track name with each invoice line item.
select i.invoiceid, i.trackid, t.Name 
from Track t, InvoiceLine i
where t.TrackId = i.TrackId
order by i.InvoiceId ;

--13. line_item_track_artist.sql: query that includes the purchased track name AND artist name with each invoice line item.
select i.invoiceid, i.trackid, t.name, t.Composer
from track t, InvoiceLine i
where t.TrackId = i.TrackId 
order by i.InvoiceId; 

--14. country_invoices.sql: query that shows the # of invoices per country. HINT: GROUP BY
select BillingCountry , count(invoiceid) as NumberInvoices
from Invoice
group by BillingCountry 

--15. playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
select p.PlaylistId , p.name, count(t.trackid) as NumberOfTracks
from Playlist p, PlaylistTrack t
on p.PlaylistId = t.PlaylistId
group by p.PlaylistId 
order by p.PlaylistId ; 

--16. tracks_no_id.sql: query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
select t.name as TrackName, a.title as AlbumTitle, m.name as MediaName, g.name as GenreName
from Track t
left join album a
on t.AlbumId = a.AlbumId 
left join MediaType m
on t.MediaTypeId = m.MediaTypeId 
left join Genre g
on g.GenreId = t.GenreId;

--17. invoices_line_item_count.sql: query that shows all Invoices but includes the # of invoice line items.
select invoiceid, count(trackid) as NumberLineItems
from InvoiceLine
group by invoiceid;

--18. sales_agent_total_sales.sql: query that shows total sales made by each sales agent.
select e.firstname || " " || e.lastname as name,sum(total) as TotalSales
from Employee e, Invoice i, Customer c
where e.EmployeeId = c.SupportRepId and i.CustomerId = c.CustomerId 
group by name

--19. top_2009_agent.sql: Which sales agent made the most in sales in 2009?
select name, max(TotalSales) as HighestTotalSales
from 
(select e.firstname || " " || e.lastname as name,sum(total) as TotalSales
from Employee e, Invoice i, Customer c
where e.EmployeeId = c.SupportRepId and i.CustomerId = c.CustomerId and i.InvoiceDate LIKE "%2009%"
group by name);

--20. top_agent.sql: Which sales agent made the most in sales over all?
select name, max(totalsales) as HighestSales
from
(select e.firstname || " " || e.lastname as name,sum(total) as TotalSales
from Employee e, Invoice i, Customer c
where e.EmployeeId = c.SupportRepId and i.CustomerId = c.CustomerId
group by name);

--21. sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
select e.firstname || " " || e.lastname as name, count (distinct c.customerid) as NumberCustomers
from Invoice i, Employee e, Customer c
where i.CustomerId = c.CustomerId and e.EmployeeId = c.SupportRepId
group by name;

--22. sales_per_country.sql: query that shows the total sales per country.
select billingcountry, sum(total) as TotalSales
from Invoice
group by billingcountry; 

--23. top_country.sql: Which country's customers spent the most?
select billingcountry , max(totalSales) as TopSales
from
(select billingcountry, sum(total) as TotalSales
from Invoice
group by billingcountry); 

--24. top_2013_track.sql: query that shows the most purchased track of 2013
--there were 14 with top sales

select *
FROM 
(select track.name as trackname, sum(invoice.total) as totalsales
from track, Invoice, invoiceline
on track.trackid = invoiceline.trackid and invoice.invoiceid = invoiceline.InvoiceId 
where invoice.InvoiceDate like "%2013%"
group by track.trackid
order by totalsales desc)
limit 14;

--25. top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.

select *
FROM 
(select track.name as trackname, sum(invoice.total) as totalsales
from track, Invoice, invoiceline
on track.trackid = invoiceline.trackid and invoice.invoiceid = invoiceline.InvoiceId 
group by track.trackid
order by totalsales desc)
limit 5;

--26. top_3_artists.sql: Provide a query that shows the top 3 best selling artists.
select artistname, totalsales
FROM 
(select artist.name as artistname, sum(total) as totalsales
from artist, invoice, invoiceline, track, album
where invoice.invoiceid = invoiceline.invoiceid and invoiceline.trackid = track.trackid and track.albumid=album.albumid and album.artistid = artist.artistid
group by artist.name
order by totalsales desc) 
limit 3;

--27. top_media_type.sql: Provide a query that shows the most purchased Media Type.
select m.name, count(t.mediatypeid) as numberMedia
from MediaType m, track t, InvoiceLine i
on m.MediaTypeId = t.MediaTypeId and t.TrackId =i.TrackId 
group by m.name


