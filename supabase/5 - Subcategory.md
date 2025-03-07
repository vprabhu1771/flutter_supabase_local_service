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
INSERT INTO "public"."sub_categories" ("id", "created_at", "name", "image_path", "category_id") VALUES 
('1', '2025-02-24 12:38:36.282137+00', 'Single Door Refrigeration', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRkMR5w4-0zgiZV8lB9yxbdNE4ubqgVq0C4w&s', '12'), 
('2', '2025-02-24 12:38:50.974448+00', 'Double Door Refrigerator', 'https://d1pjg4o0tbonat.cloudfront.net/content/dam/midea-aem/in/refrigerators/multi-door-refrigerators/midea-544-l-frost-free-french-door-bottom-mount-refrigerator-glass-door-finish-mdrm648fgg22ind/gallery3.jpg/jcr:content/renditions/cq5dam.web.5000.5000.jpeg', '12');
```
