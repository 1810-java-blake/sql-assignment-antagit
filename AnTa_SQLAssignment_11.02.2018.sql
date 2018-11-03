-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
    SELECT * FROM emplyee;
-- Task – Select all records from the Employee table where last name is King.
    SELECT * FROM employee
    WHERE lastname ='King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
    SELECT * FROM employee 
    where firstname = 'Andrew' AND reportsto IS null;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
    SELECT title FROM album
    ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
    SELECT title FROM album
    ORDER BY title ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
    INSERT INTO genre(genreid,name) VALUES(42,'Funky Beats'),
    (43,'Less Funky Beats');
-- Task – Insert two new records into Employee table
    INSERT INTO employee(employeeid,lastname,firstname,title,reportsto,birthdate,hiredate,address,city,state)
    VALUES (665,'Devil',' Not The','Angel',665,'2018-10-31','2018-10-31','000 Cloud st','Gilbert','AZ'),
    VALUES (666,'Devil','The','Fallen Angel',666,'2018-10-31','2018-10-31','666 The Deepist Pits st','Phoenix','AZ');
-- Task – Insert two new records into Customer table
    INSERT INTO customer(customerid,firstname,lastname,company,address,city,state,country,postalcode,phone,fax,email,supportrepid)
    VALUES(60,'An','Ta', NULL, '1234 N ot my address rd','nowhere','AZ','idk the US?','88885','1+(480)620-1784','1+(480)620-1784','anta93132@gmail.com',4),
    (61,'Andy','Ta', NULL, '1234 N ot my address rd','nowhere','AZ','idk the US?','88885','1+(480)620-1784','1+(480)620-1784','anta93132@gmail.com',4);
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
    UPDATE customer 
    SET firstname = 'Robert', lastname = 'Walter'
    WHERE firstname = 'Aaron' AND lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
    UPDATE artist
    SET name = 'CCR'
    WHERE name ='Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
    SELECT * FROM invoice
    WHERE billingaddress LIKE '%T%';
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
    SELECT * FROM invoice
    WHERE total> 15 AND total<50;;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
    SELECT * FROM employee
    WHERE hiredate>'2003-06-01' AND hiredate<'2004-03-01';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
    DELETE FROM customer WHERE firstname ='Robert';

-- 3.0	SQL Functions   
-- In this section you will be using the postgreSQL system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
    CREATE OR REPLACE FUNCTION timeFunc()
    RETURNS time as $$
    BEGIN
    RETURN current_time;
    END;
    $$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
    CREATE OR REPLACE FUNCTION mediaLength(media_ID INTEGER)
    RETURNS INTEGER AS $$
    DECLARE
        mediaLength VARCHAR;
    BEGIN
        SELECT name INTO mediaLength FROM mediatype WHERE mediatypeid = media_ID;
        RETURN LENGTH(mediaLength);
    END;
    $$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
    CREATE OR REPLACE FUNCTION avgInvoice()
    RETURNS FLOAT AS $$
    DECLARE
    average FLOAT;
    BEGIN
        SELECT total INTO average FROM invoice;
        RETURN avg(average);
    END;
    $$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
    CREATE OR REPLACE FUNCTION avginvoice()
        RETURNS FLOAT AS $$
        DECLARE
        invoiceAvg FLOAT;
        BEGIN
        SELECT unitprice INTO invoiceAvg FROM invoiceline;

        RETURN avg(invoiceAvg);
    END;
    $$ LANGUAGE plpgsql;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
    CREATE OR REPLACE FUNCTION employeeBefore1968()
	RETURNS TABLE(employeeid integer, lastname varchar, firstname varchar, 
			  title varchar, reprtsto integer, birthdate timestamp, 
			  hiredate timestamp, address varchar, city varchar, 
			  state varchar, country varchar, postalcode varchar, 
			  phone varchar, fax varchar, email varchar)
	AS $$
	BEGIN
		RETURN QUERY SELECT * FROM employee where employee.birthdate > '1968-12-31';
	END;
$$ LANGUAGE plpgsql;

-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
    CREATE OR REPLACE FUNCTION employeeName()
        RETURNS TABLE(firstname varchar,lastname varchar) AS $$
        BEGIN
            
            RETURN QUERY SELECT employee.firstname,employee.lastname FROM employee;
    END;
    $$ LANGUAGE plpgsql;
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
        CREATE OR REPLACE FUNCTION updatePersonal(id INTEGER, last_name varchar, first_name varchar )
        RETURNS VOID AS $$
        BEGIN
            UPDATE employee
            SET lastname = last_name, firstname = first_name
            WHERE employeeid = id;
        END;
        $$ LANGUAGE plpgsql;

-- Task – Create a stored procedure that returns the managers of an employee.
    CREATE OR REPLACE FUNCTION manager(employee_Id INTEGER)
        RETURNS TABLE(lastname varchar, firstname varchar) AS $$
        DECLARE 
            managerID INTEGER;
        BEGIN
            SELECT reportsto INTO managerID FROM employee WHERE employeeid = employee_id;
            
            RETURN QUERY SELECT firstname,lastname FROM employee WHERE employeeid = managerID;
        END;
        $$ LANGUAGE plpgsql


-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
    CREATE OR REPLACE FUNCTION customerAlign(custId INTEGER)
        RETURNS TABLE(firstname varchar, lastname varchar,company varchar) AS $$
    BEGIN
        RETURN QUERY SELECT customer.firstname,customer.lastname,customer.company FROM customer WHERE customerid = custId;
    END;
    $$ LANGUAGE plpgsql	

-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
    CREATE OR REPLACE FUNCTION delInvoiceTrans(invoice_id INTEGER)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM invoice WHERE invoiceid = invoice_id; 
	
    END;
    $$ LANGUAGE plpgsql;
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
    CREATE OR REPLACE FUNCTION insertCustomer(customerid integer,firstname varchar, lastname varchar, company varchar, 
							address varchar, city varchar, state varchar, country varchar,
							postalcode varchar,phone varchar, fax varchar, email varchar, supportreid integer)
							
    RETURNS VOID AS $$
    BEGIN
	INSERT INTO customer(customerid,firstname, lastname, company, 
							address, city, state, country,
							postalcode,phone, fax, email, supportrepid)
		    VALUES (customerid,firstname,lastname,company,address,city,state,country,postalcode,phone,fax,email,supportreid);
    END;
    $$ LANGUAGE plpgsql
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
    CREATE TRIGGER checkForInsert
	AFTER UPDATE ON employee
	FOR EACH STATEMENT
	EXECUTE PROCEDURE procedureCheck();
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
    CREATE TRIGGER checkForUpdate
	AFTER UPDATE ON album
	FOR EACH ROW
	EXECUTE PROCEDURE procedureCheck();
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
    CREATE TRIGGER checkForDelete
	AFTER DELETE ON customer
	FOR EACH ROW
	EXECUTE PROCEDURE procedureCheck();
-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.
    CREATE OR REPLACE FUNCTION procedureCheck()
    RETURNS TRIGGER AS $$
    BEGIN
        IF(old.total > 50)
        THEN RAISE EXCEPTION 'cannot delete if price is over 50';
        RETURN OLD;
        END IF;
        
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql


    CREATE TRIGGER checkForDelete
        BEFORE DELETE ON invoice
        FOR EACH ROW
        EXECUTE PROCEDURE procedureCheck();
	
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
        SELECT firstname,lastname,invoiceid FROM customer 
        INNER JOIN invoice USING(customerid);
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
    SELECT customerId,firstname,lastname,invoiceId, total FROM customer
    FULL OUTER JOIN invoice USING(customerid);
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
        SELECT name,title FROM artist
        RIGHT JOIN album USING(artistid);
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
        SELECT * FROM artist CROSS JOIN album ORDER BY  name asc;

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
    SELECT * FROM employee em1
    INNER JOIN employee em2 USING(reportsto);









