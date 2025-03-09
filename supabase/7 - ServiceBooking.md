### ✅ **Service Booking System in PostgreSQL**
To implement a **service booking** system, you'll need a `service_bookings` table to store **which user booked a service from which provider** (freelancer).

---

### 📌 **1. Create `service_bookings` Table**
```sql
CREATE TABLE service_bookings (
    id BIGSERIAL PRIMARY KEY,
    customer_id UUID NOT NULL,
    freelancer_id INT NOT NULL,
    freelancer_user_id UUID NULL,
    sub_category_id BIGINT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending', -- pending, confirmed, completed, canceled
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES freelancer(id) ON DELETE CASCADE,
    FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE
);
```
---

### 📌 **2. Insert a New Booking**
```sql
INSERT INTO service_bookings (customer_id, provider_id, sub_category_id, status)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'f47ac10b-58cc-4372-a567-0e02b2c3d479', 2, 'pending');
```
**Explanation:**
- `customer_id`: The user who booked the service.
- `provider_id`: The freelancer offering the service.
- `sub_category_id`: The subcategory of the service.
- `status`: Defaults to **pending** until confirmed.

---

### 📌 **3. Fetch Bookings for a Customer**
```sql
SELECT sb.id, sb.booking_date, sb.status, u.name AS provider_name, sc.name AS service_name
FROM service_bookings sb
JOIN users u ON sb.provider_id = u.id
JOIN sub_categories sc ON sb.sub_category_id = sc.id
WHERE sb.customer_id = '550e8400-e29b-41d4-a716-446655440000';
```

---

### 📌 **4. Fetch Bookings for a Service Provider**
```sql
SELECT sb.id, sb.booking_date, sb.status, u.name AS customer_name, sc.name AS service_name
FROM service_bookings sb
JOIN users u ON sb.customer_id = u.id
JOIN sub_categories sc ON sb.sub_category_id = sc.id
WHERE sb.provider_id = 'f47ac10b-58cc-4372-a567-0e02b2c3d479';
```

---

### 📌 **5. Update Booking Status (Confirm, Complete, Cancel)**
```sql
UPDATE service_bookings 
SET status = 'confirmed' 
WHERE id = 1;
```

```sql
UPDATE service_bookings 
SET status = 'completed' 
WHERE id = 1;
```

```sql
UPDATE service_bookings 
SET status = 'cancelled' 
WHERE id = 1;
```

---

### 🎯 **Features & Benefits**
✅ **Keeps track of service bookings**  
✅ **Supports different statuses** (`pending`, `confirmed`, `completed`, `cancelled`)  
✅ **Ensures referential integrity** (`ON DELETE CASCADE`)

Would you like an API implementation for this in **Django or Laravel**? 🚀

```sql 
alter policy "Enable update for users based on email"

on "public"."service_bookings"

to public

using (

(auth.uid() = freelancer_user_id)

);
```
