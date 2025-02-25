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
INSERT INTO categories (name, image_path) VALUES
('Carpentry', 'carpentry.png'),
('Gardening', 'gardening.png'),
('Pest Control', 'pest_control.png'),
('Home Appliances Repair', 'appliances_repair.png');
```