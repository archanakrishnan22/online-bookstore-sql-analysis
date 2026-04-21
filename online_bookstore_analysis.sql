-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);




/*-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM  '/Users/archanakrishnan/Downloads/30 Day - SQL Practice Files/Books.csv'
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\Course Updates\30 Day Series\SQL\CSV\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\Course Updates\30 Day Series\SQL\CSV\Orders.csv' 
CSV HEADER;*/
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT title, author, genre 
FROM Books
WHERE genre='Fiction';


-- 2) Find books published after the year 1950:
SELECT title, author, genre, published_year
FROM Books
WHERE published_year>1950
ORDER BY published_year;

-- 3) List all customers from the Canada:
SELECT name, city 
FROM Customers
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY order_date;

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS total_book_stock
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
where total_amount>20
order by total_amount;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre AS ALL_GENRE 
FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM BOOKS
ORDER BY STOCK 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT * FROM BOOKS;
SELECT * FROM ORDERS;

SELECT b.genre, SUM(o.quantity) AS total_books_sold 
FROM Orders o
JOIN Books b
ON o.book_id=b.book_id
group by b.genre;


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT genre, AVG(price) AS avg_price
FROM books
where genre='Fantasy'
group by genre;


-- 3) List customers who have placed at least 2 orders:
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;

SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)>=2;

--OR

SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Customers c 
ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.name
HAVING COUNT(o.order_id)>=2;


-- 4) Find the most frequently ordered book: --JIS BOOK ID KA SABSE ZYADA ORDER ID HO
SELECT * FROM books;
SELECT * FROM ORDERS;

SELECT BOOK_ID, COUNT(ORDER_ID)AS ORDER_COUNT
FROM ORDERS
GROUP BY BOOK_ID
ORDER BY ORDER_COUNT DESC
LIMIT 1;

--or
SELECT o.book_id, b.title, b.author, b.genre, COUNT(o.order_id)AS order_count
FROM orders o
JOIN Books b
ON o.book_id=b.book_id
GROUP BY o.book_id, b.title,b.author, b.genre
ORDER BY order_count DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author: BOOK ID KA QUANTITY
SELECT * FROM BOOKS;
SELECT * FROM ORDERS;

SELECT o.book_id, b.author, SUM(o.quantity)AS total_quantity
FROM Orders o
JOIN Books b 
ON o.book_id=b.book_id
GROUP BY o.book_id, b.author;

-- 7) List the cities where customers who spent over $30 are located: TOTAL AMOUNT, CITIES
SELECT * FROM CUSTOMERS;


SELECT DISTINCT c.city
FROM orders o
JOIN customers c
ON c.customer_id=o.customer_id
GROUP BY c.city,c.customer_id
HAVING SUM(o.total_amount)>30;


-- 8) Find the customer who spent the most on orders: id, name, amount, order
SELECT c.customer_id,c.name, sum(o.total_amount)as total_spend, COUNT(o.order_id) AS total_orders
from orders o
join customers c
on c.customer_id=o.customer_id
group by c.customer_id, c.name
order by total_spend desc
limit 1;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT * FROM BOOKS;
SELECT * FROM ORDERS;

SELECT b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity, 
	b.stock - coalesce(sum(o.quantity),0) as remaining_stock
FROM  books b
left join orders o
on b.book_id=o.book_id
group by b.book_id,b.title, b.stock;







