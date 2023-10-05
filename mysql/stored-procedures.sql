use awesome_inc;

drop procedure if exists USP_UpsertCustomer;
delimiter $$
create procedure USP_UpsertCustomer
(
	in cust_name VARCHAR(100), in segment int, in email varchar(30), in `password` varchar(50)
)
begin
insert into pkbc_customer (cust_id, cust_name, segment, email, `password`)
values (left(uuid(), 20), cust_name, segment, email, `password`);
end$$

delimiter ;
