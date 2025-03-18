```sql
-- 6. user_category_subcategory (pivot table)
CREATE TABLE freelancer (
    user_id UUID NOT NULL,
    sub_category_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, sub_category_id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_category FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE
);
```
# OR

```sql
CREATE TABLE freelancer (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    sub_category_id BIGINT NOT NULL,
    total_earnings DECIMAL(10,2) DEFAULT 0.00, -- Track total earnings
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_category FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE
);
```

```sql
-- Sample freelancers with assigned jobs and amounts
INSERT INTO freelancer (user_id, sub_category_id, total_earnings) VALUES
-- Painter
('550e8400-e29b-41d4-a716-446655440000', (SELECT id FROM sub_categories WHERE name = 'Wall Painting'), 5000.00),
('550e8400-e29b-41d4-a716-446655440001', (SELECT id FROM sub_categories WHERE name = 'Furniture Painting'), 3500.00),

-- Electrician
('550e8400-e29b-41d4-a716-446655440002', (SELECT id FROM sub_categories WHERE name = 'Wiring'), 6000.00),
('550e8400-e29b-41d4-a716-446655440003', (SELECT id FROM sub_categories WHERE name = 'Lighting Installation'), 4000.00),

-- Plumber
('550e8400-e29b-41d4-a716-446655440004', (SELECT id FROM sub_categories WHERE name = 'Leak Repair'), 2500.00),
('550e8400-e29b-41d4-a716-446655440005', (SELECT id FROM sub_categories WHERE name = 'Pipe Installation'), 4500.00),

-- Photography
('550e8400-e29b-41d4-a716-446655440006', (SELECT id FROM sub_categories WHERE name = 'Wedding Photography'), 15000.00),
('550e8400-e29b-41d4-a716-446655440007', (SELECT id FROM sub_categories WHERE name = 'Event Photography'), 10000.00),

-- AC Service
('550e8400-e29b-41d4-a716-446655440008', (SELECT id FROM sub_categories WHERE name = 'AC Repair'), 5500.00),
('550e8400-e29b-41d4-a716-446655440009', (SELECT id FROM sub_categories WHERE name = 'AC Installation'), 7000.00),

-- Cleaning
('550e8400-e29b-41d4-a716-446655440010', (SELECT id FROM sub_categories WHERE name = 'Home Cleaning'), 3000.00),
('550e8400-e29b-41d4-a716-446655440011', (SELECT id FROM sub_categories WHERE name = 'Office Cleaning'), 5000.00);
```