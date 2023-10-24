use awesome_inc;

drop procedure if exists USP_UpsertCustomer;
delimiter $$
create procedure USP_UpsertCustomer
(
	in cust_name VARCHAR(100), 
    in segment int, 
    in email varchar(30), 
    in `password` varchar(100)
)
begin
declare cust_id VARCHAR(20);
set cust_id = left(uuid(), 20);
insert into pkbc_customer (cust_id, cust_name, segment, email, `password`)
values (cust_id, cust_name, segment, email, `password`);
select cust_id;
end$$

delimiter ;

drop procedure if exists USP_GetCustomerById;
delimiter $$
create procedure USP_GetCustomerById(
	in cust_id VARCHAR(20)
)
begin
select * from pkbc_customer a where a.cust_id = cust_id limit 1;
end$$

delimiter ;

drop procedure if exists USP_GetCustomerByEmail;
delimiter $$
create procedure USP_GetCustomerByEmail(
	in email VARCHAR(30)
)
begin
select * from pkbc_customer a where a.email = email limit 1;
end$$

delimiter ;

drop procedure if exists USP_GetAllCountries;
delimiter $$
create procedure USP_GetAllCountries()
begin
select country_id, country_name from pkbc_country;
end$$

delimiter ;

drop procedure if exists USP_GetAllStatesByCountry;
delimiter $$
create procedure USP_GetAllStatesByCountry(
	in country_id int
)
begin
select s.state_id, s.state_name from pkbc_state s where s.country_id = country_id;
end$$

delimiter ;

drop procedure if exists USP_GetAllCitiesByState;
delimiter $$
create procedure USP_GetAllCitiesByState(
	in state_id int
)
begin
select c.city_id, c.city_name from pkbc_city c where c.state_id = state_id;
end$$

delimiter ;

drop procedure if exists USP_GetAllRegions;
delimiter $$
create procedure USP_GetAllRegions()
begin
select region_id, region_name from pkbc_region;
end$$

delimiter ;

drop procedure if exists USP_UpsertAddress;
delimiter $$
create procedure USP_UpsertAddress(
	in city_id int,
    in country_id int,
    in region_id int,
    in postal_code VARCHAR(10),
    in cust_id VARCHAR(20)
)
begin
insert into pkbc_address (city_id, country_id, region_id, postal_code, cust_id)
values (city_id, country_id, region_id, postal_code, cust_id);
select addr_id, city_id, country_id, region_id, postal_code, cust_id from pkbc_address where addr_id = last_insert_id();
end$$

delimiter ;

drop procedure if exists USP_GetAddressByCustomer;
delimiter $$
create procedure USP_GetAddressByCustomer(
	in cust_id VARCHAR(20)
)
begin
select a.addr_id, a.city_id, a.country_id, a.region_id, a.postal_code, s.state_id
from pkbc_address a 
left join pkbc_city c on a.city_id = c.city_id
left join pkbc_state s on s.state_id = c.state_id
where a.cust_id = cust_id;
end$$

delimiter ;

drop procedure if exists USP_UpdateAddress;
delimiter $$
create procedure USP_UpdateAddress(
	in addr_id int,
	in city_id int,
    in country_id int,
    in region_id int,
    in postal_code VARCHAR(10)
)
begin
update pkbc_address a
set 
a.city_id = city_id,
a.country_id = country_id,
a.region_id = region_id,
a.postal_code = postal_code
where a.addr_id = addr_id;
select a.addr_id, a.city_id, a.country_id, a.region_id, a.postal_code, a.cust_id from pkbc_address a where a.addr_id = addr_id;
end$$

delimiter ;



    
