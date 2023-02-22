-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- begin attached script 'script'
DROP DATABASE IF EXISTS littlelemondb;
-- end attached script 'script'
-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Customers` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` INT NOT NULL,
  `Email` VARCHAR(255) NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `FullName_UNIQUE` (`FullName` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Bookings` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `BookingDate` DATE NOT NULL,
  `TableNumber` INT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_Bookings_Customers_idx` (`CustomerID` ASC) VISIBLE,
  UNIQUE INDEX `CustomerID_UNIQUE` (`CustomerID` ASC, `BookingDate` ASC) INVISIBLE,
  UNIQUE INDEX `BookingDate_UNIQUE` (`BookingDate` ASC, `TableNumber` ASC) INVISIBLE,
  CONSTRAINT `fk_Bookings_Customers`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`CustomerID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Menus` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menus` (
  `MenuID` INT NOT NULL AUTO_INCREMENT,
  `MenuName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MenuID`),
  UNIQUE INDEX `MenuName_UNIQUE` (`MenuName` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Staff` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `StaffID` INT NOT NULL AUTO_INCREMENT,
  `StaffName` VARCHAR(255) NOT NULL,
  `StaffRole` VARCHAR(255) NULL,
  `Salary` INT NULL,
  PRIMARY KEY (`StaffID`),
  UNIQUE INDEX `StaffName_UNIQUE` (`StaffName` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`Orders` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `OrderDate` DATE NOT NULL,
  `CustomerID` INT NOT NULL,
  `MenuID` INT NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL(10,2) NOT NULL,
  `StaffID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_Orders_Menu_idx` (`MenuID` ASC) VISIBLE,
  INDEX `fk_Orders_Customers_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_Orders_Staff_idx` (`StaffID` ASC) INVISIBLE,
  CONSTRAINT `fk_Orders_Menu`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemonDB`.`Menus` (`MenuID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Orders_Customers`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Staff`
    FOREIGN KEY (`StaffID`)
    REFERENCES `LittleLemonDB`.`Staff` (`StaffID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`DeliveryStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`DeliveryStatus` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`DeliveryStatus` (
  `DeliveryID` INT NOT NULL AUTO_INCREMENT,
  `DeliveryDate` DATE NULL,
  `DeliveryStatus` TINYINT NOT NULL DEFAULT 0,
  `OrderID` INT NULL,
  PRIMARY KEY (`DeliveryID`),
  INDEX `fk_DeliveryStatus_Orders_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `fk_DeliveryStatus_Orders`
    FOREIGN KEY (`OrderID`)
    REFERENCES `LittleLemonDB`.`Orders` (`OrderID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`MenuItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`MenuItems` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MenuItems` (
  `MenuItemID` INT NOT NULL AUTO_INCREMENT,
  `Starters` VARCHAR(255) NULL,
  `Courses` VARCHAR(255) NULL,
  `Drinks` VARCHAR(255) NULL,
  `Desserts` VARCHAR(255) NULL,
  `MenuID` INT NOT NULL,
  PRIMARY KEY (`MenuItemID`),
  INDEX `fk_MenuItems_Menus_idx` (`MenuID` ASC) VISIBLE,
  CONSTRAINT `fk_MenuItems_Menus`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemonDB`.`Menus` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Placeholder table for view `LittleLemonDB`.`OrdersView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrdersView` (`OrderID` INT, `Quantity` INT, `TotalCost` INT);

-- -----------------------------------------------------
-- procedure CancelOrder
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `LittleLemonDB`.`CancelOrder`;

DELIMITER $$
USE `LittleLemonDB`$$
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

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

USE `LittleLemonDB`;
DROP procedure IF EXISTS `LittleLemonDB`.`GetMaxQuantity`;

DELIMITER $$
USE `LittleLemonDB`$$
CREATE PROCEDURE GetMaxQuantity ()
BEGIN
SELECT Quantity as `Max Quantity in Order` FROM Orders
ORDER BY Quantity DESC
LIMIT 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `LittleLemonDB`.`OrdersView`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`OrdersView`;
DROP VIEW IF EXISTS `LittleLemonDB`.`OrdersView` ;
USE `LittleLemonDB`;
CREATE  OR REPLACE VIEW `OrdersView` AS
SELECT OrderID, Quantity, TotalCost
FROM Orders
WHERE Quantity > 2;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
-- begin attached script 'script1'
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
	("2022-10-10", 5, 1),
	("2023-11-12", 3, 3),
	("2023-10-11", 2, 2),
  ("2022-10-13", 2, 1);

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
	("2023-02-20",0,9);
    
-- end attached script 'script1'
