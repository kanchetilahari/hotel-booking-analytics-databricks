
CREATE OR REFRESH MATERIALIZED VIEW
hospitality_catalog.bookings.silver_bookings_clean
AS
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(booking_id)
            ORDER BY loaded_at DESC
        ) AS rn
    FROM hospitality_catalog.bookings.bronze_hotel_bookings
),
deduped AS (
    SELECT *
    FROM ranked
    WHERE rn = 1
)
SELECT
    TRIM(booking_id) AS booking_id,
    TRIM(guest_id) AS guest_id,
    booking_date,
    check_in_date,
    check_out_date,
    COALESCE(
        nights,
        DATEDIFF(check_out_date, check_in_date)
    ) AS nights,
    INITCAP(TRIM(hotel_name)) AS hotel_name,
    COALESCE(INITCAP(TRIM(city)), 'Unknown') AS city,
    INITCAP(TRIM(region)) AS region,
    INITCAP(TRIM(room_type)) AS room_type,
    INITCAP(TRIM(booking_channel)) AS booking_channel,
    guests,
    room_rate,
    COALESCE(
        total_amount,
        COALESCE(
            nights,
            DATEDIFF(check_out_date, check_in_date)
        ) * room_rate
    ) AS total_amount,
    discount_amount,
    INITCAP(TRIM(meal_plan)) AS meal_plan,
    INITCAP(TRIM(payment_method)) AS payment_method,
    INITCAP(TRIM(payment_status)) AS payment_status,
    INITCAP(TRIM(booking_status)) AS booking_status,
    guest_rating,
    _rescued_data,
    source_file,
    loaded_at
FROM deduped
WHERE
    booking_date IS NOT NULL
    AND check_in_date IS NOT NULL
    AND check_out_date IS NOT NULL
    AND check_out_date > check_in_date
    AND (room_rate IS NULL OR room_rate >= 0);
CREATE OR REFRESH MATERIALIZED VIEW
hospitality_catalog.bookings.silver_bookings_rejected
AS
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(booking_id)
            ORDER BY loaded_at DESC
        ) AS rn
    FROM hospitality_catalog.bookings.bronze_hotel_bookings
),
deduped AS (
    SELECT *
    FROM ranked
    WHERE rn = 1
)
SELECT *,
    CONCAT_WS(' | ',
        CASE WHEN booking_date IS NULL
            THEN 'Missing booking date' END,
        CASE WHEN check_in_date IS NULL
            THEN 'Missing check-in date' END,
        CASE WHEN check_out_date IS NULL
            THEN 'Missing check-out date' END,
        CASE WHEN check_in_date IS NOT NULL
              AND check_out_date IS NOT NULL
              AND check_out_date <= check_in_date
            THEN 'Invalid check-in/check-out dates' END,
        CASE WHEN room_rate < 0
            THEN 'Negative room rate' END
    ) AS reject_reason
FROM deduped
WHERE
    booking_date IS NULL
    OR check_in_date IS NULL
    OR check_out_date IS NULL
    OR check_out_date <= check_in_date
    OR room_rate < 0;
