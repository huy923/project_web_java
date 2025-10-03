-- =====================================================
-- Recent Activities Query for Hotel Management System
-- =====================================================
-- This query fetches recent activities for the dashboard
-- including check-ins, check-outs, bookings, and maintenance
-- =====================================================

-- Query to get recent activities (last 10 activities)
-- This combines different types of activities into a unified result set

SELECT 
    'checkin' as activity_type,
    CONCAT('Check-in Phòng ', r.room_number) as description,
    CONCAT(g.first_name, ' ', g.last_name) as guest_name,
    DATE_FORMAT(b.updated_at, '%H:%i') as activity_time,
    r.room_number,
    b.updated_at as activity_date
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
JOIN guests g ON b.guest_id = g.guest_id
WHERE b.status = 'checked_in' 
    AND b.updated_at >= DATE_SUB(NOW(), INTERVAL 7 DAYS)
    AND b.status != 'confirmed'  -- Only actual check-ins, not just confirmations

UNION ALL

SELECT 
    'checkout' as activity_type,
    CONCAT('Check-out Phòng ', r.room_number) as description,
    CONCAT(g.first_name, ' ', g.last_name) as guest_name,
    DATE_FORMAT(b.updated_at, '%H:%i') as activity_time,
    r.room_number,
    b.updated_at as activity_date
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
JOIN guests g ON b.guest_id = g.guest_id
WHERE b.status = 'checked_out' 
    AND b.updated_at >= DATE_SUB(NOW(), INTERVAL 7 DAYS)

UNION ALL

SELECT 
    'booking' as activity_type,
    CONCAT('Đặt phòng ', r.room_number) as description,
    CONCAT(g.first_name, ' ', g.last_name) as guest_name,
    DATE_FORMAT(b.created_at, '%H:%i') as activity_time,
    r.room_number,
    b.created_at as activity_date
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
JOIN guests g ON b.guest_id = g.guest_id
WHERE b.status = 'confirmed' 
    AND b.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAYS)

UNION ALL

SELECT 
    'maintenance' as activity_type,
    CONCAT('Bảo trì Phòng ', r.room_number) as description,
    CONCAT('Nhân viên kỹ thuật') as guest_name,
    DATE_FORMAT(mr.created_at, '%H:%i') as activity_time,
    r.room_number,
    mr.created_at as activity_date
FROM maintenance_records mr
JOIN rooms r ON mr.room_id = r.room_id
WHERE mr.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAYS)
    AND mr.status IN ('reported', 'in_progress')

ORDER BY activity_date DESC
LIMIT 10;

-- =====================================================
-- Alternative simpler query for recent bookings only
-- =====================================================

-- If you prefer to show only recent booking activities:
/*
SELECT 
    CASE 
        WHEN b.status = 'checked_in' THEN 'checkin'
        WHEN b.status = 'checked_out' THEN 'checkout'
        WHEN b.status = 'confirmed' THEN 'booking'
        ELSE 'booking'
    END as activity_type,
    CASE 
        WHEN b.status = 'checked_in' THEN CONCAT('Check-in Phòng ', r.room_number)
        WHEN b.status = 'checked_out' THEN CONCAT('Check-out Phòng ', r.room_number)
        WHEN b.status = 'confirmed' THEN CONCAT('Đặt phòng ', r.room_number)
        ELSE CONCAT('Cập nhật Phòng ', r.room_number)
    END as description,
    CONCAT(g.first_name, ' ', g.last_name) as guest_name,
    DATE_FORMAT(COALESCE(b.updated_at, b.created_at), '%H:%i') as activity_time,
    r.room_number,
    COALESCE(b.updated_at, b.created_at) as activity_date
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
JOIN guests g ON b.guest_id = g.guest_id
WHERE (b.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAYS) 
    OR b.updated_at >= DATE_SUB(NOW(), INTERVAL 7 DAYS))
ORDER BY activity_date DESC
LIMIT 10;
*/

-- =====================================================
-- Query for Java backend implementation
-- =====================================================
-- This is the recommended query structure for the Java backend
-- The result should be mapped to a Map<String, Object> with these keys:
-- - activity_type: String ("checkin", "checkout", "booking", "maintenance")
-- - description: String (display text)
-- - guest_name: String (guest name or "Nhân viên kỹ thuật" for maintenance)
-- - activity_time: String (formatted time like "10:30")
-- - room_number: String (room number)

-- Example Java code structure:
/*
List<Map<String, Object>> recentActivities = new ArrayList<>();

// Execute the SQL query above
// For each row in the result set:
Map<String, Object> activity = new HashMap<>();
activity.put("activity_type", rs.getString("activity_type"));
activity.put("description", rs.getString("description"));
activity.put("guest_name", rs.getString("guest_name"));
activity.put("activity_time", rs.getString("activity_time"));
activity.put("room_number", rs.getString("room_number"));
recentActivities.add(activity);

// Set in request attribute
request.setAttribute("recentActivities", recentActivities);
*/