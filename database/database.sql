CREATE TABLE `time` (
  `TimeID` int NOT NULL,
  `year` year DEFAULT NULL,
  `month` tinyint DEFAULT NULL,
  `day` tinyint DEFAULT NULL,
  PRIMARY KEY (`TimeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `customer` (
  `CustomerID` int NOT NULL,
  `CustomerDB_ID` varchar(10) DEFAULT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Segment` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `item_sales` (
  `ProductID` int DEFAULT NULL,
  `OrderDateID` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Profit` decimal(15,2) DEFAULT NULL,
  `Sales` decimal(15,2) DEFAULT NULL,
  KEY `fk_is_ProductID_idx` (`ProductID`),
  KEY `fk_is_OrderDateID_idx_is` (`OrderDateID`),
  CONSTRAINT `fk_is_OrderDateID` FOREIGN KEY (`OrderDateID`) REFERENCES `time` (`TimeID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_is_ProductID` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `location` (
  `LocationID` int NOT NULL,
  `Country` varchar(45) DEFAULT NULL,
  `City` varchar(45) DEFAULT NULL,
  `State` varchar(45) DEFAULT NULL,
  `PostalCode` varchar(10) DEFAULT NULL,
  `Region` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`LocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `product` (
  `ProductID` int NOT NULL,
  `ProductDB_ID` varchar(20) DEFAULT NULL,
  `Category` varchar(20) DEFAULT NULL,
  `Subcategory` varchar(20) DEFAULT NULL,
  `Name` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sales_per_item` (
  `CustomerID` int DEFAULT NULL,
  `ProductID` int DEFAULT NULL,
  `OrderDateID` int DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  `OrderID` varchar(45) DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Profit` decimal(15,2) DEFAULT NULL,
  `Discount` decimal(15,2) DEFAULT NULL,
  `Sales` decimal(15,2) DEFAULT NULL,
  KEY `fk_spi_CustomerID_idx` (`CustomerID`),
  KEY `fk_spi_ProductID_idx` (`ProductID`),
  KEY `fk_spi_OrderDateID_idx` (`OrderDateID`),
  KEY `fk_spi_LocationID_idx` (`LocationID`),
  CONSTRAINT `fk_spi_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_spi_LocationID` FOREIGN KEY (`LocationID`) REFERENCES `location` (`LocationID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_spi_OrderDateID` FOREIGN KEY (`OrderDateID`) REFERENCES `time` (`TimeID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_spi_ProductID` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sales_per_order` (
  `CustomerID` int DEFAULT NULL,
  `OrderDateID` int DEFAULT NULL,
  `ShipDateID` int DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  `OrderID` varchar(45) DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Profit` decimal(15,2) DEFAULT NULL,
  `Sales` decimal(15,2) DEFAULT NULL,
  `Discount` decimal(15,2) DEFAULT NULL,
  KEY `fk_spo_CustomerID_idx` (`CustomerID`),
  KEY `fk_spo_OrderDateID_idx` (`OrderDateID`),
  KEY `fk_spo_ShipDateID_idx` (`ShipDateID`),
  KEY `fk_spo_LocationID_idx` (`LocationID`),
  CONSTRAINT `fk_spo_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_spo_LocationID` FOREIGN KEY (`LocationID`) REFERENCES `location` (`LocationID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_spo_OrderDateID` FOREIGN KEY (`OrderDateID`) REFERENCES `time` (`TimeID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_spo_ShipDateID` FOREIGN KEY (`ShipDateID`) REFERENCES `time` (`TimeID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
