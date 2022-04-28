create schema unitMilitary;
use unitMilitary;

create table Unit(
	Uname char(45) not null,
    NameCommander char(35) not null,
    numOfSoldiers int not null,
    primary key(Uname))
    engine = InnoDB;
    
create table Base(
	Nbase char(35) not null,
	Location char(35) not null,
	Uname char(45) not null,
    primary key(Nbase),
    foreign key(Uname) references Unit(Uname))
    engine = InnoDB;
    
 create table Weapon(
	typeWeapon char(35) not null,
	catalogNumber int not null,
    primary key(catalogNumber))
    engine = InnoDB;
    
create table Soldier(
	IDnumber int not null,
    Cname char(35),
    weaponCatalogNum int not null,
	SRank char(35) not null,
    Nbase char(35) not null,
    IDCommander int, 
    primary key(IDnumber),
	foreign key(Nbase) references Base(Nbase),
    foreign key(weaponCatalogNum) references Weapon(catalogNumber),
    foreign key(IDCommander) references Soldier(IDnumber))
	engine = InnoDB;
    
    
create table Vehicle(
	Vnumber int not null,
	respoCommId int not null,
    primary key(Vnumber),
    foreign key(respoCommId) references Soldier(IDnumber))
    engine = InnoDB;

create table combatVehicle(
	typeVehicle char(35) not null,
    Vnumber int not null,
    Nbase char(35) not null,
    primary key(Vnumber),
    foreign key(Nbase) references Base(Nbase),
    foreign key(Vnumber) references Vehicle(Vnumber))
    engine = InnoDB;
    
create table regularVehicle(
	topSpeed float not null,
	Vnumber int not null,
    Nbase char(35) not null,
    Vtype char(35),
	primary key(Vnumber),
    foreign key(Nbase) references Base(Nbase),
    foreign key(Vnumber) references Vehicle(Vnumber))
    engine = InnoDB;
    
create table Supplier(
	Sname char(35) not null,
	supplierType char(35) not null,
    primary key(Sname))
    engine = InnoDB;

create table Reservation(
    supplyDate date not null,
    destinationBase char(35) not null,
	reservationId int not null,
    primary key(reservationId),
    foreign key(destinationBase) references Base(Nbase))
    engine = InnoDB;
    
create table combatOperation(
	operationName char(35) not null,
	exitHour int not null,
	commIDnumber int not null,
    CO_status char(35),
    primary key(operationName),
	foreign key(commIDnumber) references Soldier(IDnumber))
	engine = InnoDB;
     
create table Soldier_combatOperation(
	operationName char(35) not null,
	IDnumber int not null,
    roll char(35) not null,
    primary key(operationName, IDnumber),
    foreign key(operationName) references combatOperation(operationName),
    foreign key(IDnumber) references Soldier(IDnumber))
    engine = InnoDB;
    
create table Supplier_Reservation(
	reservationId int not null,
	Sname char(35) not null,
    primary key(reservationId, Sname),
    foreign key(reservationId) references Reservation(reservationId),
    foreign key(Sname) references Supplier(Sname))
    engine = InnoDB;
    
create table Base_Vehicle(
	Nbase char(35) not null,
	Vnumber int not null,
	primary key(Nbase, Vnumber),
    foreign key(Nbase) references Base(Nbase),
    foreign key(Vnumber) references Vehicle(Vnumber))
    engine = InnoDB;
    
create table Base_Weapon(
	Nbase char(35) not null,
	catalogNumber int not null,
    primary key(catalogNumber, Nbase),
    foreign key(catalogNumber) references Weapon(catalogNumber),
    foreign key(Nbase) references Base(Nbase))
    engine = InnoDB;
    
create table Base_Supplier(
	Nbase char(35) not null,
    Sname char(45) not null,
	primary key(Sname, Nbase),
    foreign key(Sname) references Supplier(Sname),
    foreign key(Nbase) references Base(Nbase))
    engine = InnoDB;
    
create table CO_log(
	operationName char(35) ,
	old_exitHour int ,
    new_exitHour int,
	commIDnumber int ,
    command_ts timestamp,
	command varchar(10))
    engine = InnoDB;
    
    
delimiter $
CREATE TRIGGER CO_ins_trg AFTER INSERT ON combatOperation
FOR EACH ROW
BEGIN
INSERT INTO  CO_log VALUES(new.operationName, null, new.exitHour, new.commIDnumber, now(), 'insert');
END$

delimiter ;

delimiter $
CREATE TRIGGER CO_updHour_trg AFTER UPDATE ON combatOperation
FOR EACH ROW
BEGIN
INSERT INTO  CO_log VALUES(new.operationName, old.exitHour, new.exitHour, new.commIDnumber, now(), 'update');
END$

delimiter ;

delimiter $
CREATE TRIGGER CO_del_trg AFTER DELETE ON combatOperation
FOR EACH ROW
BEGIN
INSERT INTO  CO_log VALUES(old.operationName, null, old.exitHour, old.commIDnumber, now(), 'delete');
END$

delimiter ;

insert into Unit values
('Air-force', 'Norkin',1000),
('Navy', 'Barel',800);

insert into Base values
('Tel-Nof', 'Gedera', 'Air-force'),
('Shayetet', 'Karkur', 'Navy');

insert into Weapon values
('M-16', 001),
('Negev', 002),
('M-16', 003),
('Negev', 004),
('M-16', 005),
('M-16', 006),
('M-16', 007),
('M-16', 008),
('Mag', 009),
('Mag', 010),
('Mag', 011);

insert into Soldier values
(501, "shay", 001, 'Officer', 'Tel-Nof', null),
(502, "daniel", 008, 'Officer', 'Shayetet', null),
(505, "niv" ,003, 'Officer', 'Tel-Nof', 501),
(503, "shalom", 004, 'Sargent', 'Tel-Nof', 501),
(504, "elad", 005, 'Sargent', 'Shayetet', 502),
(508, "Itay", 006, 'Sargent', 'Shayetet', 502),
(506, "David", 007, 'Sargent', 'Tel-Nof', 501),
(509, "Shalom", 002, 'Sargent', 'Shayetet', 501),
(510, "Michael", 011, 'Sargent', 'Tel-Nof', 502),
(511, "Doron", 010, 'Sargent', 'Shayetet', 502),
(512, "Matan", 009, 'Sargent', 'Shayetet', 501);

insert into Vehicle values
(12345, 501),
(45678, 502), 
(14667, 501),
(14668, 502),
(56473, 502),
(13579, 501),
(24680, 502),
(68042, 502),
(20406, 501),
(15657, 501);

insert into combatVehicle values
('Tank', 12345, 'Tel-Nof'),
('Namer', 45678, 'Shayetet'),
('Namer', 13579, 'Shayetet'),
('Tank', 24680, 'Shayetet'),
('Tank', 68042, 'Shayetet');

insert into regularVehicle values
(100, 14667, 'Tel-Nof', "BMW"),
(170, 14668, 'Shayetet', "BMW"),
(110, 56473, 'Shayetet', "renault"),
(150, 20406, 'Tel-Nof', "Mitsubishi"),
(120, 15657, 'Tel-Nof', "Toyota");

insert into Supplier values
('Teva', 'medical'), 
('Tnuva', 'food');

insert into Reservation values
('2019-03-09', 'Tel-Nof', 6001),
('2020-04-09', 'Shayetet', 6002);

insert into combatOperation values
('Amud-Anan', 7,  501, "succes"),
('Zuk-Eithan', 18,  502, "failed"),
('Shomer-homot', 12,  501, "succes"),
('lebanon', 23,  501, "failed"),
('galil', 3,  502, "succes");

update combatOperation 
set exitHour = 2
where combatOperation.operationName = "Amud-Anan";

insert into Soldier_combatOperation values
('Amud-Anan', 504, "Negevist"), 
('Amud-Anan', 503, "Magist"), 
('Zuk-Eithan', 504, "Kashar"),
('Zuk-Eithan', 503, "Medic"),
('Amud-Anan', 508, "Kashar"),
('Zuk-Eithan', 511, "Magist"),
('Zuk-Eithan', 509, "Negevist"),
('Zuk-Eithan', 506, "Kashar"),
('lebanon', 506, "Kashar"),
('lebanon', 511, "Magist"),
('lebanon', 508, "Kashar"),
('galil', 505, "Medic"),
('galil', 503, "Negevist"),
('galil', 508, "Kashar"),
('galil', 509, "Kashar"),
('galil', 511, "Magist"),
('Shomer-homot', 503, "Negevist"),
('Shomer-homot', 506, "Kashar"),
('Shomer-homot', 508, "Kashar"),
('Shomer-homot', 509, "Kashar"),
('Shomer-homot', 510, "Magist");

insert into Supplier_Reservation values
(6001, 'Teva'),
(6002, 'Tnuva');

insert into Base_Vehicle values
('Tel-Nof', 12345),
('Tel-Nof', 14667),
('Tel-Nof', 20406),
('Tel-Nof', 15657),
('Shayetet', 45678),
('Shayetet', 13579),
('Shayetet', 24680),
('Shayetet', 68042),
('Shayetet', 14668),
('Shayetet', 56473);

insert into Base_Weapon values
('Tel-Nof', 001),
('Tel-Nof', 002),
('Shayetet', 003),
('Shayetet', 004),
('Tel-Nof', 005),
('Tel-Nof', 006),
('Shayetet', 007),
('Shayetet', 008),
('Tel-Nof', 009),
('Tel-Nof', 010),
('Shayetet', 011);

insert into Base_Supplier values
('Tel-Nof', 'Tnuva'),
('Tel-Nof', 'Teva'),
('Shayetet', 'Tnuva'),
('Shayetet', 'Teva');

update combatVehicle 
set typeVehicle = 'Nagmash'
where combatVehicle.Vnumber = 12345;

update Supplier 
set supplierType = 'dairy', Sname = 'Tnuva' 
where Supplier.Sname = 'Tnuva';

insert into Supplier values
('Tara', 'milk'),
('Kimberly', 'Toilet');

delete from Supplier where Supplier.Sname = 'Tara';

insert into Base values
('Zikim', 'Gaza', 'Air-force');

delete from Base where Base.Nbase = 'Zikim';
delete from soldier_combatoperation where soldier_combatoperation.roll = 'Medic'
and soldier_combatoperation.IDnumber = 505;

select vehicle.Vnumber, combatvehicle.typeVehicle 
from vehicle, combatvehicle
where combatvehicle.Vnumber = vehicle.Vnumber
group by combatvehicle.typeVehicle;

select count(vehicle.Vnumber) as count_Vehicle
from vehicle
where vehicle.Vnumber = (select combatvehicle.Vnumber from combatvehicle 
where combatvehicle.typeVehicle = 'Nagmash');

select combatvehicle.Vnumber from combatvehicle 
where combatvehicle.typeVehicle = 'Tank';

select  count(vehicle.Vnumber) as Pcount, combatvehicle.typeVehicle
from vehicle, combatVehicle
where vehicle.respoCommId = 501;

select combatOperation.operationName
from combatOperation 
where combatOperation.operationName = (select soldier_combatoperation.operationName
from soldier_combatoperation where soldier_combatoperation.roll = (select soldier_combatoperation.roll
from soldier_combatoperation where soldier_combatoperation.roll = 'Medic'));

select  typeWeapon, count(Weapon.catalogNumber) as count_Weapons 
from Weapon
group by Weapon.typeWeapon;

select * 
from Reservation 
where destinationBase = 'Tel-Nof'
order by Reservation.supplyDate;

select distinct Soldier_combatOperation.operationName, Soldier.IDnumber, 
Soldier.Cname as name, Soldier_combatOperation.roll as roll 
from Soldier_combatOperation, Soldier
where Soldier.IDnumber = Soldier_combatOperation.IDnumber and
Soldier_combatOperation.operationName = 'galil'
order by operationName;

select Supplier.Sname, Reservation.supplyDate 
from Supplier inner join Reservation
on Supplier.Sname = "Tnuva" 
order by Reservation.supplyDate desc;

select Uname, numOfSoldiers from Unit
where numOfSoldiers > (select min(numOfSoldiers) from Unit); 

select regularvehicle.Vtype from regularvehicle
where regularvehicle.Nbase = (select Nbase from base
where base.Nbase = (select base_vehicle.Nbase from base_vehicle
where base_vehicle.Vnumber = 14667));


