insert into pkbc_region(
        region_name
) select distinct region from pkbc_awesome_inc_orders ;

insert into pkbc_country(
        country_name   
) select distinct 
		a.Country
 from  pkbc_awesome_inc_orders a; 
 
insert into pkbc_state(
        state_name
) select distinct 
		a.state
 from pkbc_awesome_inc_orders a;

insert into pkbc_city(
        city_name
) select distinct 
		a.City 
 from pkbc_awesome_inc_orders a ; 
 
insert into pkbc_customer(
        cust_id     ,
        cust_name   ,
        segment     ,
        email		,
        `password`	
) select distinct `Customer ID`, `Customer Name`, 
	CASE WHEN `Segment` = 'Consumer'  THEN 1
		WHEN `Segment` = 'Corporate'  THEN 2
		WHEN `Segment` = 'Home Office'  THEN 3
        ELSE 0 
	END `Segment Code`,
    CONCAT(`Customer ID`, '@gmail.com'),
    CONCAT('pass_', `Customer ID`)
	from pkbc_awesome_inc_orders;

  
insert into pkbc_address(
	city_id      ,        
	region_id    ,
    postal_code  ,
	state_id     ,
	cust_id      ,
	 country_id    
)  select distinct
	city_id      ,  
	region_id     , 
	`Postal Code`   , 
	state_id    	,
	cust_id     ,
	country_id  
from pkbc_awesome_inc_orders a
	inner join pkbc_city b on a.City = b.city_name
    inner join pkbc_region c on a.Region = c.region_name
    inner join pkbc_state d on a.State = d.state_name
    inner join pkbc_customer e on a.`Customer ID` = e.cust_id
    inner join pkbc_country f on a.Country = f.country_name;
    

 insert into pkbc_category(
        category_name       ,
        sub_category_name   
) select distinct	
		Category,
        `Sub-Category`
 from pkbc_awesome_inc_orders;
 
insert into pkbc_product(
        product_id   ,
        product_name ,
        market       ,
        category_id 
)  select distinct
	`Product ID`,
    `Product Name`,
    case when Market = 'USCA'  then 1
		when Market = 'Asia Pacific'  then 2
		when Market = 'Europe'  then 3
		when Market = 'Africa'  then 4
		when Market = 'LATAM'  then 5
        else 0
	end as Market ,
    (
		select category_id from pkbc_category b where a.Category = b.category_name and a.`Sub-Category` = b.sub_category_name
    ) as category_id
 from pkbc_awesome_inc_orders a  ;
 
 
 insert into pkbc_orders(
        order_id   	,
        order_date  ,
        is_returned 
) select distinct 
        `Order ID`   	,
		STR_TO_DATE(`Order Date`, '%m/%d/%Y')   ,
        'N' as is_returned 
	from pkbc_awesome_inc_orders a ;


insert into pkbc_ord_prod(
		quantity    	,
		discount        ,
		shipping_cost   ,
		profit          ,
		sales           ,
		order_id        ,
		product_id      ,
		market          ,
		addr_id         ,
		cust_id    	    ,
		ship_mode       ,
		ship_date   
		
) select 
		CASE WHEN quantity is NULL or quantity='' then 0  
			WHEN substring(quantity , 1, 1) = '$' THEN CAST( substring(quantity , 2) AS DECIMAL) 
            WHEN quantity REGEXP '^[0-9]+$' then quantity 
			ELSE 0
        END as quantity ,
		CASE WHEN a.discount is NULL or a.discount = ''  then 0 
			WHEN a.discount REGEXP '^[0-9]+$' then a.discount 
			else 0
		END as discount,
		CASE WHEN a.`Shipping Cost` is NULL or a.`Shipping Cost` = '' then 0 
			 WHEN substring(a.`Shipping Cost` , 1, 1) = '$' THEN CAST( substring(a.`Shipping Cost` , 2) AS DECIMAL) 
			 WHEN substring(a.`Shipping Cost` , 1, 2) = '-$' THEN CAST( substring(a.`Shipping Cost` , 3) AS DECIMAL)
             WHEN a.`Shipping Cost` REGEXP '^[0-9]+$' then a.`Shipping Cost`
             ELSE 0
        END as `Shipping Cost` ,
		CASE WHEN Profit is NULL or Profit = '' then 0  
			WHEN substring(Profit , 1, 1) = '$' THEN CAST( substring(Profit , 2) AS DECIMAL) 
			 WHEN substring(Profit , 1, 2) = '-$' THEN CAST( substring(Profit , 3) AS DECIMAL)
             WHEN Profit REGEXP '^[0-9]+$' then Profit
             ELSE 0
        END as profit   ,
        CASE WHEN Sales is NULL or Sales = '' then 0 
			WHEN Sales REGEXP '^[0-9]+$' then Sales
			ELSE 0 
		END as sales,
		a.`Order ID`as order_id ,
		a.`Product ID` as product_id ,
		case when Market = 'USCA'  then 1
			when Market = 'Asia Pacific'  then 2
			when Market = 'Europe'  then 3
			when Market = 'Africa'  then 4
			when Market = 'LATAM'  then 5
			else 0
		end as market ,
		(
			select addr_id from pkbc_address b
				where b.city_id in (select c.city_id from pkbc_city c where a.City = c.city_name) 
                and	  b.region_id in (select d.region_id from pkbc_region d where a.Region = d.region_name )
                and	  b.state_id in (select e.state_id from pkbc_state e where a.State = e.state_name )
                and   b.cust_id in (select f.cust_id from pkbc_customer f where a.`Customer ID` = f.cust_id )
                and   b.country_id  in (select g.country_id from pkbc_country g where a.Country = g.country_name )
                and   b.postal_code = a.`Postal Code`
        ) as addr_id ,
		a.`Customer ID` ,
		case when `Ship Mode` = 'First Class' then 1  
			 when `Ship Mode` = 'Second Class' then 2 
			 when `Ship Mode` = 'Same Day' then 3
			 when `Ship Mode` = 'Standard Class' then 4
             else 0
        end as ship_mode,
		STR_TO_DATE(`Ship Date`, '%m/%d/%Y')  as ship_date
 from pkbc_awesome_inc_orders  a ;


update pkbc_orders a set is_returned = true 
where a.order_id in ( select `Order ID` from pkbc_awesome_inc_returns);
