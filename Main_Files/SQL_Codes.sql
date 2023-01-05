create database oyo;
use oyo;

create table oyo_hotels
(
	booking_id int not null primary key,
    customer_id int,
    status text,
    check_in date,
    check_out date,
    no_of_rooms int,
    hotel_id int,
    amount float,
    discount float,
    date_of_booking date,
    constraint hotelid_fk foreign key (hotel_id) references city_hotels(Hotel_id)
);
select * from oyo_hotels;

create table city_hotels
(
	Hotel_id int not null primary key,
    City varchar(50)
);
select * from city_hotels;

# No. of cities - 10
select count(distinct(city)) 'No of Cities' from city_hotels;

# No. of hotels - 357
select count(distinct(hotel_id)) 'No of Hotels' from city_hotels;

# No. of Hotels in each city
select city, count(hotel_id) 'No of Hotels'
from city_hotels
group by city
order by count(city) desc;

# Finding avg room rate in each city
select c.city, avg(o.amount-o.discount) 'Avg Room Rate'
from oyo_hotels o, city_hotels c
where o.hotel_id = c.hotel_id
group by c.city
order by avg(o.amount) desc;

# Finding the avg room prices in cities
# To find this, we need to calculate the rate and also the nights stayed
alter table oyo_hotels add column rate float;
update oyo_hotels set rate = (amount + discount);

alter table oyo_hotels modify column check_in date;
alter table oyo_hotels modify column check_out date;
alter table oyo_hotels modify column date_of_booking date;

alter table oyo_hotels add column no_of_nights int;
update oyo_hotels set no_of_nights = datediff(check_out,check_in);

alter table oyo_hotels add column price float;
update oyo_hotels set price = round(if(no_of_rooms = 1, (rate/no_of_nights), (rate/no_of_nights)/no_of_rooms),2);

select c.city, round(avg(o.price),2) 'Avg Room Price'
from oyo_hotels o, city_hotels c
where o.hotel_id = c.hotel_id
group by c.city
order by avg(o.price) desc;

# Cancellation Rate
select c.city, count(o.status) 'Cancellation Rate'
from oyo_hotels o, city_hotels c
where o.hotel_id = c.hotel_id
and o.status = 'Cancelled'
group by c.city;

# Bokings by Month
select c.city, count(c.city) 'Bookings_per_Month', monthname(date_of_booking) 'Month'
from oyo_hotels o, city_hotels c
where o.hotel_id = c.hotel_id
group by city, monthname(date_of_booking)
order by c.city, month(date_of_booking);

# Bokings by Month with Check-In dates in those months
select c.city, count(c.city) 'Bookings_per_Month', monthname(date_of_booking) 'Month'
from oyo_hotels o, city_hotels c
where o.hotel_id = c.hotel_id
and month(check_in) = month(date_of_booking)
group by city, monthname(date_of_booking)
order by c.city, month(date_of_booking);

# Nature of Booking
select count(*) 'Bookings', datediff(check_in, date_of_booking) 'Date_Difference'
from oyo_hotels
group by 2
order by 2;