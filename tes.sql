String sql = """
    SELECT b.booking_id, b.guest_id, b.room_id, b.check_in_date, b.check_out_date,
           b.total_amount, b.status, b.adults, b.children, b.notes, b.created_at,
           g.first_name, g.last_name, g.phone, g.email, g.id_number,
           r.room_number, rt.type_name, rt.base_price
    FROM bookings b
    JOIN guests g ON b.guest_id = g.guest_id
    JOIN rooms r ON b.room_id = r.room_id
    JOIN room_types rt ON r.room_type_id = rt.room_type_id
    ORDER BY b.created_at DESC
    """;
