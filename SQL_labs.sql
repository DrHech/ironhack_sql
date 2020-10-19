USE sakila;

-- LAB 1

-- LAB 2

-- LAB 3
select count(distinct(last_name)) from sakila.actor;

select distinct language_id from sakila.language;

select title, length from sakila.film where release_year = 2006
order by length desc
limit 10;

select rental_date, DATEDIFF(days,left(min(rental_date),6), left(max(rental_date),6)) AS Date_Diff from  rental;

select*from rental;
SELECT DATEDIFF(month,max(return_date), min(rental_date)) as operating_in_days, min(rental_date) as first_rental, max(return_date) as last_return from rental;

select*from rental;

-- select count(rental_id) from rental where ( "2006-02-14" - INTERVAL 30 DAY) <= rental_date;
-- select count(rental_id) from rental where ( "2006-02-14" - INTERVAL 30 DAY) <= rental_date;
-- I did this: SELECT * from rental where DATE_FORMAT(rental_date, '%M') = (SELECT DATE_FORMAT(CONVERT(MAX(rental_date),date), '%M') from rental);

-- 6)
select*, date_format(rental_date, "%m") as rental_month, date_format(rental_date, "%w") as rental_weekday from rental
limit 20;

-- 7)
select*,
case
	when date_format(rental_date, "%w") between 1 and 5 then "weekday"
	Else "week-end"
end as day_type
from rental;

-- 8)
select*from rental order by rental_date desc;
select*from rental where rental_date between "2006-01-15" and "2006-02-15";


-- Lab 4

select rating from film;

select release_year from film;

select*from film where title like ("%ARMAGEDDON%");

select*from film where title like ("%APOLLO%");

select*from film where title regexp("APOLLO$");

select*from film where title like "DATE %" or title like "% DATE";
-- select*from film where title regexp ("DATE | DATE");
-- select*from film where title regexp('[[:<:]]DATE[[:>:]]');

select*from film order by length(title) desc limit 10;

select*from film order by length desc limit 10;

select count(special_features) from film where special_features like "%behind the scenes%";

select*from film order by release_year, title;


-- Lab 5

alter table sakila.staff drop picture;
select*from sakila.staff;

insert into sakila.staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update)  
values (3, 'Tammy', 'Sanders', 5, 'Tammy.Sanders@sakilastaff.com',2,1,'Tam', '', current_date());

show fields from rental;
insert into rental values 
(16050,curdate(),5000,15,"",2,current_date()) ;


select*from rental
order by rental_id desc;

drop table if exists films_2020;

CREATE TABLE films_2020
(`title` varchar(128) NOT NULL,
`description` varchar(5000) NOT NULL,
`release_year` int(5) NOT NULL,
`language_id`int(5) NOT NULL,
`rental_rate` int(5) NULL,
`length` int(5) NOT NULL,
`rating` varchar(10) NULL,
`special_features` varchar(5000) NULL);

select*from films_2020;


show fields from film;

-- Lab 6

show variables like 'local_infile';
set global local_infile = 1;



load data infile 'Users/mac/Desktop/Workspace/films_2020.csv' into table film fields terminated by ',';

select*from sakila.film;

SHOW VARIABLES LIKE "secure_file_priv";

select*from films_2020;

select*from store;










-- Lab 7

select distinct last_name from sakila.actor;
select last_name, count(last_name) as "appearances" from sakila.actor
group by last_name
having appearances = 1
order by appearances;

select last_name, count(last_name) as "appearances" from sakila.actor
group by last_name
having appearances > 1
order by appearances;

select *from rental;
select staff_id, count(rental_id) as "rental_numbers" from sakila.rental
group by staff_id;

select*from sakila.film;
show fields from film;
select rating, count(film_id) as "number_of_films" from sakila.film
group by rating
order by number_of_films desc;


select rating, round(avg(length),2) as "mean_length" from sakila.film
group by rating;

select rating, round(avg(length),2) as "mean_length" from sakila.film
group by rating
having mean_length > 120;


select*from sakila.film;
select title, rating, original_language_id, avg(length) over(partition by rating) as "mean_length" from sakila.film;


-- 9)

select*from sakila.film;
select rental_id, inventory_id, date;





-- Lab 8

 select*from film;
 
-- rank films by length

select film_id, title, rating, length, dense_rank() over (order by length desc) as 'rank' from film;

-- rank films by length whithin the rating category

select film_id, title, length, dense_rank() over (partition by rating order by length desc) as 'rank' from film;

-- rank languages by the number of films (as original language)


select name, count(film_id) as number_of_films, rank() over (order by count(film_id) desc) as ranking from film
inner join language on film.language_id = language.language_id
group by name;


-- rank categories by the number of films.


select*from film;

select name, count(film_id) as number_of_films, rank() over (order by count(film_id) desc) as ranking from category
left join film_category on film_category.category_id = category.category_id
group by name;


-- which actor has appeared in the most films



-- most active customer



-- most rented film






-- Lab 9
select*from customer;

select customer_id, city from customer
left join address on address.address_id = customer.address_id
left join city on city.city_id = address.city_id;

select customer.first_name, customer.last_name,category.name, count(film.film_id), dense_rank() over (partition by customer.first_name, customer.last_name order by count(film.film_id)) as number_of_films from customer
inner join address on address.address_id = customer.address_id
inner join city on city.city_id = address.city_id
inner join store on store.store_id = customer.store_id
inner join inventory on inventory.store_id = store.store_id
inner join film on film.film_id = inventory.film_id
inner join film_category on film_category.film_id = film.film_id
inner join category on category.category_id = film_category.category_id
group by customer.first_name, customer.last_name, category.name;



select name, count(film.film_id) as number_of_films, rank() over (order by count(film.film_id) desc) as "rank" from category
inner join film_category on film_category.category_id = category.category_id
inner join film on film.film_id = film_category.film_id
group by name;

select first_name, last_name, count(rental_id) as number_of_rents from customer
inner join rental on rental.customer_id = customer.customer_id
group by first_name, last_name;


select sum(payment.amount) as total_money_spent from customer
inner join payment on payment.customer_id = customer.customer_id
group by first_name, last_name;

select * from customer
inner join payment on payment.customer_id = customer.customer_id
inner join rental on rental.customer_id = customer.customer_id
inner join address on address.address_id = customer.address_id
inner join city on city.city_id = address.city_id;












select*from rental;
select count(rental_id) from rental
where rental_date between "2005-05-15" and "2005-05-30";





select first_name, last_name,