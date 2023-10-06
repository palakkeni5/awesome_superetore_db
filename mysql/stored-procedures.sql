use awesome_inc;

drop procedure if exists USP_UpsertCustomer;
delimiter $$
create procedure USP_UpsertCustomer
(
	in cust_name VARCHAR(100), in segment int, in email varchar(30), in `password` varchar(100)
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
    
