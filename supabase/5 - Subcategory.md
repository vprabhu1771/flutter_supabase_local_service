```sql
-- 5. subcategories table
CREATE TABLE sub_categories (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    image_path VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);
```


```sql
-- Insert with default image_path ('default_image.png' will be used)
INSERT INTO categories (name) VALUES
('Single Door Refrigeration'),
('Double Door Refrigerator');
```

```sql
INSERT INTO "public"."sub_categories" ("id", "created_at", "name", "image_path", "category_id") VALUES 
('1', '2025-02-24 12:38:36.282137+00', 'Single Door Refrigeration', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRkMR5w4-0zgiZV8lB9yxbdNE4ubqgVq0C4w&s', '12'), 
('2', '2025-02-24 12:38:50.974448+00', 'Double Door Refrigerator', 'https://d1pjg4o0tbonat.cloudfront.net/content/dam/midea-aem/in/refrigerators/multi-door-refrigerators/midea-544-l-frost-free-french-door-bottom-mount-refrigerator-glass-door-finish-mdrm648fgg22ind/gallery3.jpg/jcr:content/renditions/cq5dam.web.5000.5000.jpeg', '12');
```

```sql
INSERT INTO subcategories (category_id, name) VALUES
-- Painter
((SELECT id FROM categories WHERE name = 'Painter'), 'Wall Painting'),
((SELECT id FROM categories WHERE name = 'Painter'), 'Furniture Painting'),

-- Electrician
((SELECT id FROM categories WHERE name = 'Electrician'), 'Wiring'),
((SELECT id FROM categories WHERE name = 'Electrician'), 'Lighting Installation'),

-- Plumber
((SELECT id FROM categories WHERE name = 'Plumber'), 'Leak Repair'),
((SELECT id FROM categories WHERE name = 'Plumber'), 'Pipe Installation'),

-- Photography
((SELECT id FROM categories WHERE name = 'Photography'), 'Wedding Photography'),
((SELECT id FROM categories WHERE name = 'Photography'), 'Event Photography'),

-- Carpentry
((SELECT id FROM categories WHERE name = 'Carpentry'), 'Furniture Making'),
((SELECT id FROM categories WHERE name = 'Carpentry'), 'Wood Polishing'),

-- Computer Services
((SELECT id FROM categories WHERE name = 'Computer Services'), 'Software Installation'),
((SELECT id FROM categories WHERE name = 'Computer Services'), 'Hardware Repair'),

-- Pest Control
((SELECT id FROM categories WHERE name = 'Pest Control'), 'Termite Control'),
((SELECT id FROM categories WHERE name = 'Pest Control'), 'Rodent Control'),

-- Gardening
((SELECT id FROM categories WHERE name = 'Gardening'), 'Lawn Mowing'),
((SELECT id FROM categories WHERE name = 'Gardening'), 'Plant Maintenance'),

-- AC Service
((SELECT id FROM categories WHERE name = 'AC Service'), 'AC Repair'),
((SELECT id FROM categories WHERE name = 'AC Service'), 'AC Installation'),

-- Cleaning
((SELECT id FROM categories WHERE name = 'Cleaning'), 'Home Cleaning'),
((SELECT id FROM categories WHERE name = 'Cleaning'), 'Office Cleaning'),

-- Water Purifier
((SELECT id FROM categories WHERE name = 'Water Purifier'), 'Filter Change'),
((SELECT id FROM categories WHERE name = 'Water Purifier'), 'Water Quality Check'),

-- Refrigerator (Already exists)
((SELECT id FROM categories WHERE name = 'Refrigerator'), 'Cooling Issue Repair'),
((SELECT id FROM categories WHERE name = 'Refrigerator'), 'Gas Refill'),

-- Events
((SELECT id FROM categories WHERE name = 'Events'), 'Wedding Planning'),
((SELECT id FROM categories WHERE name = 'Events'), 'Birthday Party Planning');
```