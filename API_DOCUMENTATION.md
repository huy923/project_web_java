# Hotel Management System - REST API Documentation

## Base URL
```
http://localhost:8080/my-web-app/api
```

## Authentication
All endpoints require an active session. Include session cookies with requests.

---

## 1. Booking API
**Base Path:** `/api/bookings` or `/api/booking/{id}`

### GET - Get All Bookings
```
GET /api/bookings
```
**Response:**
```json
{
  "success": true,
  "timestamp": 1234567890,
  "data": [
    {
      "booking_id": 1,
      "guest_id": 1,
      "room_id": 1,
      "check_in_date": "2024-01-15",
      "check_out_date": "2024-01-20",
      "total_amount": 500.00,
      "status": "checked_in",
      "adults": 2,
      "children": 1,
      "first_name": "John",
      "last_name": "Doe",
      "phone": "1234567890",
      "room_number": "101"
    }
  ]
}
```

### GET - Get Booking by ID
```
GET /api/booking/{id}
```

### PUT - Update Booking
```
PUT /api/booking/{id}
Content-Type: application/json

{
  "status": "checked_out"
}
```
Or update details:
```json
{
  "check_in_date": "2024-01-15",
  "check_out_date": "2024-01-20",
  "adults": 2,
  "children": 1
}
```

### DELETE - Delete Booking (Mark as Cancelled)
```
DELETE /api/booking/{id}
```

---

## 2. Guest API
**Base Path:** `/api/guests` or `/api/guest/{id}`

### GET - Get All Guests
```
GET /api/guests
```

### GET - Get Guest by ID
```
GET /api/guest/{id}
```

### POST - Create Guest
```
POST /api/guests
Content-Type: application/json

{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "phone": "1234567890",
  "id_number": "123456789",
  "nationality": "USA"
}
```

### PUT - Update Guest
```
PUT /api/guest/{id}
Content-Type: application/json

{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "phone": "1234567890",
  "id_number": "123456789",
  "nationality": "USA"
}
```

### DELETE - Delete Guest
```
DELETE /api/guest/{id}
```

---

## 3. Room API
**Base Path:** `/api/rooms` or `/api/room/{id}`

### GET - Get All Rooms
```
GET /api/rooms
```

### GET - Get Room by ID
```
GET /api/room/{id}
```

### POST - Create Room
```
POST /api/rooms
Content-Type: application/json

{
  "room_number": "101",
  "room_type_id": 1,
  "floor_number": 1
}
```

### PUT - Update Room Status
```
PUT /api/room/{id}
Content-Type: application/json

{
  "status": "available"
}
```
Valid statuses: `available`, `occupied`, `maintenance`

### DELETE - Delete Room
```
DELETE /api/room/{id}
```

---

## 4. Payment API
**Base Path:** `/api/payments` or `/api/payment/{id}`

### GET - Get All Payments
```
GET /api/payments
```

### GET - Get Payment by ID
```
GET /api/payment/{id}
```

### POST - Create Payment
```
POST /api/payments
Content-Type: application/json

{
  "booking_id": 1,
  "amount": 500.00,
  "payment_type": "credit_card",
  "transaction_id": "TXN123456",
  "processed_by": 1,
  "notes": "Payment received"
}
```

### PUT - Update Payment Status
```
PUT /api/payment/{id}
Content-Type: application/json

{
  "payment_status": "completed"
}
```
Valid statuses: `pending`, `completed`, `failed`, `refunded`

---

## 5. Service API
**Base Path:** `/api/services` or `/api/service/{id}`

### GET - Get All Services
```
GET /api/services
```

### GET - Get Services by Category
```
GET /api/services?category=room_service
```

### GET - Get Service by ID
```
GET /api/service/{id}
```

### POST - Create Service
```
POST /api/services
Content-Type: application/json

{
  "service_name": "Room Cleaning",
  "description": "Professional room cleaning service",
  "price": 50.00,
  "category": "room_service"
}
```

### PUT - Update Service
```
PUT /api/service/{id}
Content-Type: application/json

{
  "service_name": "Room Cleaning",
  "description": "Professional room cleaning service",
  "price": 50.00,
  "category": "room_service"
}
```

### DELETE - Delete Service
```
DELETE /api/service/{id}
```

---

## 6. Maintenance API
**Base Path:** `/api/maintenance` or `/api/maintenance/{id}`

### GET - Get All Maintenance Records
```
GET /api/maintenance
```

### GET - Get Maintenance by Status
```
GET /api/maintenance?status=reported
```

### GET - Get Maintenance by Room
```
GET /api/maintenance?room_id=1
```

### GET - Get Maintenance by ID
```
GET /api/maintenance/{id}
```

### POST - Create Maintenance Record
```
POST /api/maintenance
Content-Type: application/json

{
  "room_id": 1,
  "issue_description": "Air conditioner not working",
  "reported_by": 1,
  "priority": "high"
}
```

### PUT - Update Maintenance Record
```
PUT /api/maintenance/{id}
Content-Type: application/json

{
  "status": "in_progress"
}
```
Or assign and complete:
```json
{
  "assigned_to": 2,
  "actual_cost": 150.00
}
```

### DELETE - Delete Maintenance Record
```
DELETE /api/maintenance/{id}
```

---

## 7. Inventory API
**Base Path:** `/api/inventory` or `/api/inventory/{id}`

### GET - Get All Inventory Items
```
GET /api/inventory
```

### GET - Get Inventory by Category
```
GET /api/inventory?category=linens
```

### GET - Get Low Stock Items
```
GET /api/inventory?low_stock=true
```

### GET - Get Inventory Item by ID
```
GET /api/inventory/{id}
```

### POST - Create Inventory Item
```
POST /api/inventory
Content-Type: application/json

{
  "item_name": "Bed Sheets",
  "category": "linens",
  "current_stock": 100,
  "minimum_stock": 20,
  "unit_price": 15.00,
  "supplier": "Supplier Inc"
}
```

### PUT - Update Inventory Stock
```
PUT /api/inventory/{id}
Content-Type: application/json

{
  "current_stock": 150
}
```
Or add/remove stock:
```json
{
  "add_quantity": 50
}
```
```json
{
  "remove_quantity": 10
}
```

### DELETE - Delete Inventory Item
```
DELETE /api/inventory/{id}
```

---

## 8. Review API
**Base Path:** `/api/reviews` or `/api/review/{id}`

### GET - Get All Reviews
```
GET /api/reviews
```

### GET - Get Public Reviews Only
```
GET /api/reviews?public=true
```

### GET - Get Reviews by Rating Range
```
GET /api/reviews?min_rating=4&max_rating=5
```

### GET - Get Review by ID
```
GET /api/review/{id}
```

### POST - Create Review
```
POST /api/reviews
Content-Type: application/json

{
  "booking_id": 1,
  "guest_id": 1,
  "rating": 5,
  "review_text": "Excellent service and clean rooms!",
  "is_public": true
}
```

### PUT - Update Review
```
PUT /api/review/{id}
Content-Type: application/json

{
  "rating": 4,
  "review_text": "Good service",
  "is_public": true
}
```
Or toggle visibility:
```json
{
  "toggle_visibility": true
}
```

### DELETE - Delete Review
```
DELETE /api/review/{id}
```

---

## 9. Guest Service API
**Base Path:** `/api/guest-services` or `/api/guest-service/{id}`

### GET - Get All Guest Services
```
GET /api/guest-services
```

### GET - Get Services by Booking
```
GET /api/guest-services?booking_id=1
```

### GET - Get Services by Guest
```
GET /api/guest-services?guest_id=1
```

### GET - Get Services by Status
```
GET /api/guest-services?status=pending
```

### GET - Get Guest Service by ID
```
GET /api/guest-service/{id}
```

### POST - Add Guest Service
```
POST /api/guest-services
Content-Type: application/json

{
  "booking_id": 1,
  "service_id": 1,
  "quantity": 2
}
```

### PUT - Update Guest Service
```
PUT /api/guest-service/{id}
Content-Type: application/json

{
  "status": "delivered"
}
```
Or update quantity:
```json
{
  "quantity": 3
}
```

### DELETE - Delete Guest Service
```
DELETE /api/guest-service/{id}
```

---

## 10. Report API
**Base Path:** `/api/reports`

### GET - Generate Occupancy Report
```
GET /api/reports?type=occupancy&start_date=2024-01-01&end_date=2024-01-31
```
**Response includes:**
- total_rooms
- occupied_rooms
- available_rooms
- maintenance_rooms

### GET - Generate Revenue Report
```
GET /api/reports?type=revenue&start_date=2024-01-01&end_date=2024-01-31
```
**Response includes:**
- booking_revenue
- payment_revenue
- service_revenue
- payment_breakdown (by type)

### GET - Generate Guest Analysis Report
```
GET /api/reports?type=guest&start_date=2024-01-01&end_date=2024-01-31
```
**Response includes:**
- total_guests
- new_guests
- average_stay_days
- top_nationalities

### GET - Generate Maintenance Report
```
GET /api/reports?type=maintenance&start_date=2024-01-01&end_date=2024-01-31
```
**Response includes:**
- total_records
- status_breakdown
- priority_breakdown
- total_cost

### GET - Generate Inventory Report
```
GET /api/reports?type=inventory
```
**Response includes:**
- total_inventory_value
- total_items
- low_stock_items
- inventory_by_category

---

## Error Response Format
```json
{
  "success": false,
  "message": "Error description",
  "timestamp": 1234567890
}
```

## HTTP Status Codes
- `200 OK` - Request successful
- `400 Bad Request` - Invalid request parameters
- `401 Unauthorized` - Not authenticated
- `500 Internal Server Error` - Server error

---

## Notes
- All timestamps are in milliseconds (Unix epoch)
- Date format: `YYYY-MM-DD`
- All monetary values are in decimal format
- Session authentication is required for all endpoints
