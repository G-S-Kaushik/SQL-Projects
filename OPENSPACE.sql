create database DA1;
USE DA1;
CREATE TABLE users ( id int,  created_at timestamp, fulLname varchar(3), dob_day int, 
dob_month int,dob_year int);
INSERT INTO users
(id, created_at, fulLname,dob_day, dob_month, dob_year)
VALUES
(1, '2020-08-01 02:44:00', 'X',1,1,1995),
(2, '2020-09-01 02:44:00', 'A', 2,3,2000),
(3, '2020-10-01 02:44:00', 'C', 12,10,1990),
(4, '2020-11-01 02:44:00', 'E', 4,8,2020),
(5, '2020-12-01 02:44:00', 'M', 5,6,1970);

CREATE TABLE checkouts
(id int, created_at timestamp, user_id int, order_id int);
INSERT INTO checkouts
(id, created_at, user_id, order_id)
VALUES
(1, '2020-08-01 02:14:00', 1, NULL),
(2, '2020-08-01 04:14:00', 1, 2),
(3, '2020-08-01 02:14:00',1, NULL),
(4, '2020-12-01 03:14:00', 5, 3),
(5,'2020-08-01 03:14:00', 3, NULL),
(6, '2020-08-01 03:14:00', 3, NULL),
(7,'2020-08-01 03:14:00', 4, 4);

CREATE TABLE orders
(id int, created_at timestamp, merchant_id int, user_id int, order_value int);

INSERT INTO orders
(id, created_at, merchant_id, User_id, order_value)
VALUES
(1, '2020-12-01 03:14:00', 11, 1, 500),
(2, '2020-12-01 03:20:00', 22, 4, 3000),
(3, '2020-12-01 03:20:00', 22, 5, 8000);

CREATE TABLE merchants
(id int, merchant_name varchar(5));

INSERT INTO merchants
(id, merchant_name,user_id)
VALUES
(11, 'AA'),
(22, 'BB'),
(33, 'CC'),
(44, 'DD');

select * from checkouts;
select * from merchants;
select * from orders;
select * from users;


###################

# Q1
select id , fulLname as name , created_at AS CREATED  from USERS WHERE year(curdate())-dob_year>25;

###################

# Q2
SELECT count(order_id) AS Count_of_users FROM CHECKOUTS WHERE order_id IS NOT NULL;

##################

#Q3
create table no_orders as( select u.id as user_id, u.created_at as user_created_at, ch.id as character_id, ch.created_at as character_created_at,o.id order_id, o.created_at as order_created_at
from users as u inner join checkouts as ch on (u.id = ch.user_id) inner join
orders as o on(ch.user_id=o.user_id) inner join merchants as m on (o.merchant_id=m.id) where ch.order_id is not null);

alter table no_orders add count_orders int auto_increment primary key;

select * from no_orders ;

##################################

#Q4
select user_id, `fulLname`, ch.id as checkout_id from checkouts as ch inner join users as u 
on (ch.user_id = u.id)  where USER_id NOT IN ( SELECT USER_ID FROM CHECKOUTS WHERE ORDER_ID IS NOT NULL);


#######################################

#Q5
SELECT MERCHANT_NAME , COUNT(O.ID) AS COUNT_OF_ORDER_ID FROM MERCHANTS M INNER JOIN ORDERS O ON (M.ID=O.MERCHANT_ID) WHERE M.MERCHANT_NAME="BB";

########################################

#Q6
SELECT U.* FROM USERS U LEFT JOIN ORDERS O ON (U.ID=O.USER_ID) WHERE O.ID IS NULL;

select * FROM USERS WHERE ID NOT IN (SELECT USER_ID FROM ORDERS);
########################################

#Q7
SELECT EXTRACT(MINUTE FROM O.created_at)-EXTRACT(MINUTE FROM CH.CREATED_AT) as minutes FROM checkouts ch INNER JOIN ORDERS o ON (ch.USER_ID=o.USER_ID)
 WHERE ch.USER_ID=5 AND ORDER_ID IS NOT NULL;

##############################################

#Q8
select * from merchants WHERE ID NOT IN (SELECT merchant_ID FROM ORDERS); 

##############################################

#Q9
SELECT merchant_id, merchant_name, ROUND(avg(order_value),0) as AOV FROM MERCHANTS M
 INNER JOIN ORDERS O ON (M.ID=O.MERCHANT_ID) GROUP BY MERCHANT_ID;
 
 #############################################
 
 #Q10
 SELECT U.ID AS USER_ID, COUNT(CH.USER_ID) AS CHECKOUT_COUNT, COUNT(CH.ORDER_ID) AS ORDER_COUNT ,COUNT(CH.ORDER_ID)/COUNT(CH.USER_ID) AS CONV_RATE  FROM 
 USERS as u LEFT join checkouts as ch on (u.id = ch.user_id) 
group by U.ID order by U.ID;

###############################################

#Q11.1
select distinct  CH.ID AS CHECKOUT_ID, CH.CREATED_AT,  U.ID AS USER_ID, ORDER_ID,
rank() OVER(order by ORDER_ID )  AS RANK_
FROM users as u inner join checkouts as ch on (u.id = ch.user_id)
;

###############################################

#Q11.2
SELECT date(CREATED_AT) AS CREATE_DATE, count(date(CREATED_AT)) AS COUNT_OF_ORDERS
FROM ORDERS;