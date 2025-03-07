```sql
-- 4. categories table
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    image_path VARCHAR(100) DEFAULT 'default_image.png',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
-- 2. Create a function to update the updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

```sql
-- 3. Create a trigger to call the function before an update
CREATE TRIGGER trigger_update_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
```

```sql
-- Insert with default image_path ('default_image.png' will be used)
INSERT INTO categories (name) VALUES
('Cleaning Services'),
('Plumbing'),
('Electrical'),
('Painting');
```

```sql
-- Insert with custom image_path
INSERT INTO "public"."categories" ("id", "created_at", "name", "image_path") VALUES 
('1', '2025-02-24 11:41:04.282503+00', 'Painter', 'https://static.vecteezy.com/system/resources/thumbnails/006/137/360/small_2x/painter-paint-the-wall-free-vector.jpg'), 
('2', '2025-02-24 11:41:21.012703+00', 'Electrician', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkfzjwHX_XSZ_3JUaSxRDQ4hLN3AvyDbr3bg&s'), 
('3', '2025-02-24 11:41:29.527716+00', 'Plumber', 'https://www.plumbingbyjake.com/wp-content/uploads/2015/11/VIGILANT-plumber-fixing-a-sink-shutterstock_132523334-e1448389230378.jpg'), 
('4', '2025-02-24 11:41:37.906956+00', 'Photography', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfxPedWjxkXJc2auRUiKEWahf_7ONYV_JkFQ&s'), 
('5', '2025-02-24 11:41:50.804588+00', 'Carpentry', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJyFCVxE3teH2aaMkvYg2RC1nNRfQai38yhg&s'), 
('6', '2025-02-24 11:41:58.599328+00', 'Computer Services', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbwIhGVdbhQ-HTWlM_98gW1CmlaVYf6tFa6A&s'), 
('7', '2025-02-24 11:42:05.545676+00', 'Pest Control', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxOZJAllvNwnfUWdRGTHr6Kyn2vBvO7bDqeA&s'), 
('8', '2025-02-24 11:42:13.708055+00', 'Gardening', 'https://cdn.shopify.com/s/files/1/2318/5061/files/Gardening_with_Family.jpg?v=1575880787'), 
('9', '2025-02-24 11:42:23.063072+00', 'AC Service', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgbnmqjKx24Js5v-9ap5kZ__aQdA_T7Tn-9Q&s'), 
('10', '2025-02-24 11:42:32.089422+00', 'Cleaning', 'https://cdn.prod.website-files.com/60ff934f6ded2d17563ab9dd/61392d693cf1ac14070ad5b8_starting-a-cleaning-business.jpeg'), 
('11', '2025-02-24 11:42:42.082048+00', 'Water Purifier', 'https://media.croma.com/image/upload/v1722273758/Croma%20Assets/Small%20Appliances/Water%20Purifier/Images/212088_1_npiebr.png'), 
('12', '2025-02-24 11:42:48.599015+00', 'Refrigerator', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFWiZE1zfkUU1vp-yQomAu54gNxHBkQnhI1Q&s'), 
('13', '2025-02-24 11:42:57.111164+00', 'Events', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnigmW4DjBg-tJbax-HKtG3Glf94QNXm0k3w&s');
```