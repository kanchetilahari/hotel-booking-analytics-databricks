-- 1: Hotel Revenue

CREATE OR REFRESH MATERIALIZED VIEW
hospitality_catalog.bookings.gold_hotel_revenue
AS
SELECT
    hotel_name,
    city,
    COUNT(DISTINCT booking_id) AS total_bookings,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_booking_amount,
    AVG(room_rate) AS average_room_rate,
    AVG(guest_rating) AS average_guest_rating
FROM hospitality_catalog.bookings.silver_bookings_clean
GROUP BY hotel_name, city;

-- 2: City Performance

CREATE OR REFRESH MATERIALIZED VIEW
hospitality_catalog.bookings.gold_city_performance
AS
SELECT
    city,
    region,
    COUNT(DISTINCT booking_id) AS total_bookings,
    SUM(total_amount) AS total_revenue,
    SUM(guests) AS total_guests,
    AVG(guest_rating) AS average_rating,
    SUM(
        CASE
            WHEN LOWER(booking_status) = 'cancelled'
            THEN 1 ELSE 0
        END
    ) AS cancelled_bookings
FROM hospitality_catalog.bookings.silver_bookings_clean
GROUP BY city, region;

-- 3: Booking Trends

CREATE OR REFRESH MATERIALIZED VIEW
hospitality_catalog.bookings.gold_booking_trends
AS
SELECT
    DATE_TRUNC('MONTH', booking_date) AS booking_month,
    COUNT(DISTINCT booking_id) AS total_bookings,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_booking_amount,
    SUM(guests) AS total_guests
FROM hospitality_catalog.bookings.silver_bookings_clean
GROUP BY DATE_TRUNC('MONTH', booking_date);

-- 4: Payment Analysis

CREATE OR REFRESH MATERIALIZED VIEW
hospitality_catalog.bookings.gold_payment_analysis
AS
SELECT
    payment_method,
    payment_status,
    COUNT(DISTINCT booking_id) AS total_bookings,
    SUM(total_amount) AS total_amount,
    AVG(total_amount) AS average_amount
FROM hospitality_catalog.bookings.silver_bookings_clean
GROUP BY payment_method, payment_status;
