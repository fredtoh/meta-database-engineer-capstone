INSERT INTO customers (FullName, ContactNumber)
VALUES 
	("Customer 1", 1234567),
    ("Customer 2", 1234568),
    ("Customer 3", 1234569),
    ("Customer 4", 9123456),
    ("Customer 5", 8123456),
    ("Customer 6", 7123456),
    ("Customer 7", 6123456),
    ("Customer 8", 5123456),
    ("Customer 9", 4123456),
    ("Customer 10", 3123456);
    
INSERT INTO staff (StaffName, StaffRole, Salary)
VALUES
	("Waiter 1", "Waiter", 40000),
    ("Waiter 2", "Waiter", 45000),
    ("Waiter 3", "Waiter", 46500);

INSERT INTO menus (MenuName)
VALUES
	("Set Lunch"),
    ("Set Dinner"),
    ("House Special"),
    ("New York Special");

INSERT INTO menuitems (Starters, Courses, Drinks, Desserts, MenuID)
VALUES
	("Edamame", "Chicken teriyaki", "Soda", "Orange slice", 1),
	("House salad", "Pesto with chicken", "Soda", "Fruit salad", 2),
	("Caesar salad", "Prime rib", "Red wine", "Tiramisu", 3),
	("Cobb salad", "New York steak", "Champagne", "New York cheesecake slice", 4);

INSERT INTO bookings (BookingDate, TableNumber, CustomerID)
VALUES 
	("2023-02-01", 1, 1),
	("2023-02-10", 1, 2),
	("2023-02-10", 2, 4),
	("2023-02-11", 1, 5),
	("2023-02-11", 3, 1),
    ("2023-04-01", 2, 2);

INSERT INTO orders (OrderDate, CustomerID, MenuID, Quantity, TotalCost, StaffID)
VALUES 
	("2023-02-01", 1, 1, 2, 29.00, 1),
	("2023-02-02", 2, 1, 1, 14.50, 1),
	("2023-02-11", 2, 2, 1, 18.50, 2),
	("2023-02-11", 3, 3, 1, 35.00, 1),
	("2023-02-12", 4, 2, 2, 37.00, 3),
	("2023-02-14", 4, 4, 3, 210.00, 1),
	("2023-02-14", 5, 3, 2, 70.00, 2),
	("2023-02-17", 6, 3, 5, 175.00, 1),
	("2023-02-17", 2, 1, 10, 145.00, 3),
    ("2023-02-20", 3, 3, 2, 70.00, 3);

INSERT INTO deliverystatus (DeliveryDate, DeliveryStatus, OrderID)
VALUES
	("2023-02-02",1,1),
	("2023-02-02",1,2),
	("2023-02-11",1,3),
	("2023-02-11",1,4),
	("2023-02-12",1,5),
	("2023-02-14",1,6),
	("2023-02-15",1,7),
	("2023-02-17",1,8),
	("2023-02-18",0,9),
	("2023-02-20",0,10);
    