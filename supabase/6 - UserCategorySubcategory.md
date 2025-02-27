```sql
-- 6. user_category_subcategory (pivot table)
CREATE TABLE user_category_subcategory (
    user_id UUID NOT NULL,
    category_id BIGINT NOT NULL,
    sub_category_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, category_id, sub_category_id),
    CONSTRAINT fk_ucsu_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_ucsu_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    CONSTRAINT fk_ucsu_sub_category FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE
);
```