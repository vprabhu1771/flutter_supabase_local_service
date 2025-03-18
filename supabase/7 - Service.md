```sql
CREATE TABLE services (
    id BIGSERIAL PRIMARY KEY,
    freelancer_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    duration INTEGER NOT NULL CHECK (duration > 0), -- Service duration in minutes
    availability JSONB NOT NULL, -- Available time slots

    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),

    FOREIGN KEY (freelancer_id) REFERENCES freelancer(id) ON DELETE CASCADE
);
```

```sql
INSERT INTO services (freelancer_id, name, description, price, duration, availability) VALUES
((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Wall Painting')),
 'Wall Painting Service', 'Professional wall painting with high-quality materials.', 1500.00, 120, '{"monday":["10:00-12:00","14:00-16:00"],"friday":["12:00-14:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Lighting Installation')),
 'Lighting Installation', 'Expert electrical lighting installation.', 1200.00, 90, '{"tuesday":["09:00-11:00"],"thursday":["13:00-15:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Pipe Installation')),
 'Pipe Installation Service', 'Professional pipe fitting and leak-proof installation.', 1800.00, 60, '{"wednesday":["10:00-12:00"],"saturday":["14:00-16:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Wedding Photography')),
 'Wedding Photography', 'Capture your beautiful moments with our professional photography.', 5000.00, 240, '{"saturday":["09:00-13:00"],"sunday":["14:00-18:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Furniture Making')),
 'Custom Furniture Making', 'Handcrafted furniture designed to match your home.', 2500.00, 180, '{"monday":["09:00-12:00"],"wednesday":["14:00-17:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Hardware Repair')),
 'Computer Hardware Repair', 'Fixing and upgrading your computer hardware.', 1000.00, 90, '{"tuesday":["10:00-12:00"],"thursday":["15:00-17:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Termite Control')),
 'Termite Control Service', 'Protect your home from termites with our safe treatment.', 2000.00, 120, '{"friday":["10:00-12:00"],"sunday":["14:00-16:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'AC Repair')),
 'AC Repair Service', 'Get your air conditioner fixed and working efficiently.', 2200.00, 60, '{"monday":["08:00-10:00"],"saturday":["12:00-14:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Home Cleaning')),
 'Home Deep Cleaning', 'Full home deep cleaning for a fresh environment.', 1500.00, 180, '{"sunday":["09:00-12:00"],"wednesday":["14:00-17:00"]}'),

((SELECT id FROM freelancer WHERE sub_category_id = (SELECT id FROM sub_categories WHERE name = 'Wedding Planning')),
 'Wedding Planning Service', 'End-to-end wedding planning for your special day.', 10000.00, 300, '{"monday":["10:00-12:00"],"friday":["14:00-18:00"]}');
```