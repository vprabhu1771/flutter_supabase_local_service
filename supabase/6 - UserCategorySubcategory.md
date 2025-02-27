```sql
-- 6. user_category_subcategory (pivot table)
CREATE TABLE user_category_subcategory (
    user_id UUID NOT NULL,
    category_id BIGINT NOT NULL,
    subcategory_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, category_id, subcategory_id),
    CONSTRAINT fk_ucsu_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_ucsu_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_ucsu_subcategory FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE SET NULL
);
```