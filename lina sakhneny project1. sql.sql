use master
GO
create database sales 
GO
use sales
GO

CREATE TABLE SpecialOfferProducts
(
SpecialOrfferID Int identity (1,1) not null,
ProductID INT not null,
ModifiedDate datetime default getdate () not null,
Constraint sop_SpecialOrfferID_ProductID_pk primary key (ProductID, SpecialOrfferID)
)

insert into SpecialOfferProducts
values (1,default  ),(2,default ),(3,default ), (4,default ), (5,default ), 
(6,default ),(7, default),(8, default),(9, default),(10, default)




CREATE TABLE CreditCard
(
CreditCardID INT Primary Key NOT NULL,
CardType nvarchar(50) not null,
CardNumber nvarchar(25) not null,
ExpMonth tinyint not null,
ExpYear smallint not null,
ModifiedDate datetime default getdate () not null,
constraint credit_ExpMonth_ck check (ExpMonth>=1 and ExpMonth <=12),
constraint credit_CardNumber_uq unique (CardNumber)
)

INSERT INTO creditcard
values (1,'VISA','14538367', 9 , 2026, '2024-07-29 09:44:09.600' ), 
(2,'VISA','14643367', 1 , 2027, default )


INSERT INTO CreditCard
VALUES (3,'VISA','14643387', 1 , 2027, default ),
(4,'MasterCard','12343857', 3 , 2029, '2024-07-28 09:44:09.600' ),
(5,'VISA','1464367', 5 , 2028, default ),
(6,'MasterCard','347533368', 6 , 2029, '2024-06-14 00:00:00.600' ),
(7,'VISA','14698767', 7 , 2029, default),
(8,'americanexpress','14123467', 3 , 2027, default ),
(9,'americanexpress','14646577', 10 , 2030, default ),
(10,'americanexpress','14243567', 12 , 2027, default )



create table Address
(
AddressID int primary key identity (1,1) not null,
AddressLine1 nvarchar(60) not null,
Addressline2 nvarchar(60),
City nvarchar(30) not null,
StateProvinceID int not null,
PostalCode nvarchar(15) not null,
ModifiedDate datetime default getdate () not null,
constraint adr_AddressLine1_Ck check (len(AddressLine1)>1),
constraint adr_City_Ck check (len(city)>1),
constraint adr_Postalcode_ck check (len(postalcode)>=5)
)


insert into Address
values 
('agron 55', null, 'haifa', 1, '11111', default),
('hillel 5', null, 'haifa', 2, '21111', default),
('rochild 20', null, 'Tel-aviv', 1, '11112', default),
('alenbi 16', null, 'haifa', 3, '11111', default),
('alenbi 16', null, 'Tel-aviv', 2, '55555', default),
('agron 55', null, 'jerusalem', 1, '33333', default),
('alenbi', null, 'jerusalem', 1, '33331', default),
('agron 16', null, 'haifa', 4, '33332', default),
('hillel 5', null, 'jerusalem', 1, '11311', default),
('agron 55', null, 'Tel-aviv', 3, '33332', default)



create table ShipMethod
(
ShipMethodID int primary KEY identity (1,1)  not null,
Name nvarchar(50) not null,
ShipBase money not null,
ShipRate money not null,
ModifiedDate datetime default getdate () not null,
constraint shipM_Name_Ck check (len(name)>1),
constraint shipM_shipBase_ck check (shipbase>=0),
constraint shipM_ShipRate_ck check (ShipRate>=0)
)
Alter table ShipMethod
add constraint ShipM_shipRate_df default 0 for shiprate


INSERT INTO ShipMethod
VALUES
('express', 20, default, '2024-07-29 09:44:09.600' ),
('united', 20, default, default ),
('shippers', 0, 15, default ),
('speedy', 0, default, '2024-01-27 01:43:09.500' ),
('package', 20, 20, '2024-07-29 09:44:09.600' ),
('HAAT', 0, 50, '2024-07-29 09:44:09.600' ),
('WOLT', 20, 5, '2024-07-29 09:44:09.600' ),
('TEN', 0, 10, default),
('BEES', 20, default, default ),
('BIRD', 20, default, default )



create table CurrencyRate
(
CurrencyRateID int primary key identity (1,1) not null,
CurrencyRateDate datetime default getdate() not null,
FromCurrencyCode nchar(3) not null,
ToCurrencyCode nchar(3) not null,
AverageRate money not null,
EndofDayRate money not null,
ModifiedDate datetime default getdate () not null

)
 

 create table SalesOrderDetails
 (
 SalesOrderID INT IDENTITY (1,1) not null,
 SalesOrderDetailID int not null,
 CarrierTrackingNumber nvarchar(25),
 OrderQTY  smallint not null,
 ProductID int not null,
 SpecialOfferID int not null,
 UnitPrice money not null,
 UnitPriceDiscount money default 0 not null,
 ModifiedDate datetime default getdate () not null,
 constraint SOD_SalesOrderID_SalesOrderDetailID_pk primary key (SalesOrderID, SalesOrderDetailID),
 constraint sod_unitprice_ck check (unitprice >=0),
 constraint sod_OrderQTY_ck check ( OrderQTY >0),
 constraint sod_UnitPriceDiscount_ck check (UnitPriceDiscount >=0 and UnitPriceDiscount <=1 ),
 constraint sod_productID_FK foreign key (productID,SpecialOfferID) references SpecialOfferProducts(productID,SpecialOrfferID)
)



create table SalesTerriotory
(
TerritoryID int primary key IDENTITY (1,1) not null,
Name nvarchar(50) not null,
CountryRegionCode nvarchar(3) not null,
[Group] nvarchar(50) not null,
SalesYTD money not null,
SalesLastYear money not null,
CostYTD money not null, 
CostLastYear money not null,
ModifiedDate datetime default getdate () not null,
constraint ST_Name_ck check (len(name)>1)
)



Create Table SalesPerson
(
BusinessEntityID int primary key IDENTITY (1,1) not null,
TerritoryID int,
SalesQuota money,
Bonus money default 0 not null,
CommissionPct smallmoney default 0 not null,
SalesYTD money not null,
SalesLastYear money not null,
ModifiedDate datetime default getdate () not null
constraint SP_TerritoryID_FK foreign key (TerritoryID) references SalesTerriotory (TerritoryID)
)



Create table customer 
(
CustomerID int PRIMARY KEY identity (1,1) NOT NULL,
personID INT,
StoreID int,
TerritoryID int,
AccountNumber int not null,
ModifiedDate datetime default getdate () not null
constraint Cust_AccountNumber_uq unique (AccountNumber),
constraint Cust_AccountNumber_ck check (len(AccountNumber)>0),
constraint cust_TerritoryID_FK foreign key (TerritoryID) references SalesTerriotory (TerritoryID)
)



create table SalesOrderHeader
(
SalesOrderId int primary key not null,
RevisionNumber Tinyint not null,
OrderDate datetime not null, 
DueDate datetime not null,
ShipDate datetime ,
Status tinyint not null,
SalesOrderNumber int not null,
customerID int not null,
SalesPersonID int,
TerritoryID int,
BillToAddressID int not null,
ShipToAddressID int not null,
ShipMethodID INT NOT NULL,
CreditCardID int ,
CreditCardApprovalCode varchar(15),
CurrencyRateID int,
SubTotal Money not null,
TaxAmt money default 0 not null,
Freight money default 0 not null,
constraint SOH_customerID_FK foreign key (CustomerID) references customer(CustomerID),
constraint SOH_TerritoryID_FK foreign key (TerritoryID) references SalesTerriotory (TerritoryID),
constraint soh_SalesPersonID_FK foreign key (SalesPersonID) references SalesPerson (BusinessEntityID),
constraint soh_CreditCardID_FK foreign key (CreditCardID) references CreditCard (CreditCardID),
constraint soh_ShipToAddressID_FK foreign key (ShipToAddressID) references Address (AddressID),
constraint soh_BillToAddressID_FK foreign key (BillToAddressID) references Address (AddressID),
constraint soh_ShipMethodID_FK foreign key (ShipMethodID) references ShipMethod (ShipMethodID),
constraint soh_CurrencyRateID_FK foreign key (CurrencyRateID) references CurrencyRate (CurrencyRateID)
)

Alter table salesorderdetails
add constraint SOD_SalesOrderId_FK foreign key (SalesOrderId) REFERENCES SalesOrderHeader(SalesOrderId)






INSERT INTO CurrencyRate
values (default,'AUD', 'EUR', 5, 10000, DEFAULT ),
(default,'EUR', 'AUD', 5, 10000, DEFAULT ),
(default,'AUD', 'USD', 5, 10000, DEFAULT ),
(default,'USD', 'AUD', 5, 10000, DEFAULT ),
(default,'USD', 'EUR', 5, 10000, DEFAULT ),
(default,'EUR', 'USD', 5, 10000, DEFAULT ),
(default,'AUD', 'GBP', 5, 10000, DEFAULT ),
(default,'GBO', 'AUD', 5, 10000, DEFAULT ),
(default,'GBP', 'EUR', 5, 10000, DEFAULT ),
(default,'EUR', 'GBP', 5, 10000, DEFAULT )





INSERT INTO SalesTerriotory
VALUES('CENTER','CA2', 'QW1', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','CA3', 'QW1', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','LA2', '67', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','LA3', '67', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','LA4', '67', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','NY2', 'RT1', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','NY3', 'RT1', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','NY4', 'RT1', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','DC2', 'WE4', 3456, 1000000, 500,3000, DEFAULT ),
('CENTER','DC3', 'WE4', 3456, 1000000, 500,3000, DEFAULT )

INSERT INTO SalesPerson 
VALUES(10 ,null , default, default,10000, 1500000, default )

INSERT INTO SalesPerson 
values(1,null, default, default,10000, 1500000, default ),
(2,null, default, default,10000, 1500000, default ),
(3,null, default, default,10000, 1500000, default ),
(4,null, default, default,10000, 1500000, default ),
(5,null, default, default,10000, 1500000, default ),
(6,null, default, default,10000, 1500000, default ),
(7,null, default, default,10000, 1500000, default ),
(8,null, default, default,10000, 1500000, default ),
(9,null, default, default,10000, 1500000, default )


insert into customer
values (null,1,null,123456789, default),
(null,null,2,1111, default),
(null,null,3,2222, default),
(null,null,4,3333, default),
(null,null,5,4444, default),
(null,null,6,5555, default),
(null,null,7,6666, default),
(null,null,8,7777, default),
(null,null,9,8888, default),
(null,null,10,9999, default)


insert into SalesOrderHeader 
values 
(1,1, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,3,1,1,1,2,2,1, null,null,null,250,default,default),
(2,2, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,1,2,5,1,2,2,1, null,null,null,250,default,default),
(3,3, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,4,2,7,1,2,2,1, null,null,null,250,default,default),
(4,4, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,6,4,1,1,2,2,1, null,null,null,250,default,default),
(5,5, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,5,5,1,1,2,2,1, null,null,null,250,default,default),
(6,6, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,1,3,1,1,2,2,1, null,null,null,250,default,default),
(7,7, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,7,1,1,1,2,2,1, null,null,null,250,default,default),
(8,8, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,10,1,1,1,2,2,1, null,null,null,250,default,default),
(9,9, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,10,1,1,1,2,2,1, null,null,null,250,default,default),
(10,10, '2023-11-12 00:00:00.000', '2023-11-17 00:00:00.000', '2023-11-15 00:00:00.000', 2,3,1,1,1,2,2,1, null,null,null,250,default,default)


INSERT INTO SalesOrderDetails
VALUES
(1,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(2,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(3,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(4,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(5,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(6,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(7,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(8,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(9,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT ),
(10,null, 1, 1, 1, 45.6, DEFAULT, DEFAULT )

