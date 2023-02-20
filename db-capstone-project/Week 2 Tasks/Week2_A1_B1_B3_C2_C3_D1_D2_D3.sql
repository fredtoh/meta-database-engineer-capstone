DELIMITER $$

CREATE PROCEDURE GetMaxQuantity ()
BEGIN
SELECT Quantity as `Max Quantity in Order` FROM Orders
ORDER BY Quantity DESC
LIMIT 1;
END$$

CREATE PROCEDURE CancelOrder ()
BEGIN
IF EXISTS(SELECT 1 FROM Orders WHERE OrderID = id)
THEN
DELETE FROM Orders WHERE OrderID = id; 
SELECT CONCAT("Order ", id, " is cancelled.") AS Confirmation;
ELSE
SELECT CONCAT("Order ", id, " does not exist.") AS Response;
END IF;
END$$

CREATE PROCEDURE CheckBooking(IN booking_date DATE, IN table_no INT)
BEGIN
IF EXISTS(SELECT 1 FROM Bookings WHERE BookingDate = booking_date AND TableNumber = table_no)
THEN 
SELECT CONCAT("Table " , table_no, " is already booked.") AS `Booking status`; 
ELSE
SELECT CONCAT("Table " , table_no, " is not yet booked.") AS `Booking status`; 
END IF;
END$$

CREATE PROCEDURE AddValidBooking(IN booking_date DATE, IN table_no INT, IN customer INT)
BEGIN
START TRANSACTION;
SELECT BookingID INTO @id FROM Bookings ORDER BY BookingID DESC LIMIT 1;
SET @id = @id + 1;
IF EXISTS(SELECT 1 FROM Bookings WHERE (BookingDate = booking_date AND TableNumber = table_no))
THEN
SELECT CONCAT("Table " , table_no, " is already booked - booking cancelled.") AS `Booking status`; 
ROLLBACK;
ELSE
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
VALUES (@id, booking_date, table_no, customer);
COMMIT;
SELECT CONCAT("Booking for table " , table_no, " is successful.") AS `Booking status`; 
END IF;
END$$

CREATE PROCEDURE AddBooking (IN booking_id INT, IN customer INT, IN table_no INT, IN booking_date DATE)
BEGIN
START TRANSACTION;
IF EXISTS(SELECT 1 FROM Bookings WHERE (BookingID = booking_id))
THEN
SELECT CONCAT("Booking " , booking_id, " already exists - booking cancelled.") AS `Booking status`;
ROLLBACK;
ELSEIF EXISTS(SELECT 1 FROM Bookings WHERE (BookingDate = booking_date AND TableNumber = table_no))
THEN SELECT CONCAT("Table " , table_no, " already booked - booking cancelled.") AS `Booking status`;
ROLLBACK;
ELSE
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
VALUES (booking_id, booking_date, table_no, customer);
COMMIT;
SELECT CONCAT("New booking added.") AS `Confirmation`; 
END IF;
END$$

CREATE PROCEDURE UpdateBooking (IN booking_id INT, IN booking_date DATE)
BEGIN
START TRANSACTION;
IF NOT EXISTS(SELECT 1 FROM Bookings WHERE (BookingID = booking_id))
THEN
SELECT CONCAT("Booking " , booking_id, " does not exist.") AS `Message`;
ROLLBACK;
ELSE
UPDATE Bookings SET BookingDate = booking_date WHERE BookingID = booking_id;
COMMIT;
SELECT CONCAT("Booking ", booking_id ," updated.") AS `Confirmation`; 
END IF; 
END$$

CREATE PROCEDURE CancelBooking (IN booking_id INT)
BEGIN
START TRANSACTION;
IF NOT EXISTS(SELECT 1 FROM Bookings WHERE (BookingID = booking_id))
THEN
SELECT CONCAT("Booking " , booking_id, " does not exist.") AS `Message`;
ROLLBACK;
ELSE
DELETE FROM Bookings WHERE BookingID = booking_id;
COMMIT;
SELECT CONCAT("Booking ", booking_id ," cancelled.") AS `Confirmation`; 
END IF;
END$$