```sql
-- 6. user_category_subcategory (pivot table)
CREATE TABLE user_subcategory (
    user_id UUID NOT NULL,
    sub_category_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, sub_category_id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_category FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE
);
```
# OR

```sql
CREATE TABLE user_subcategory (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    sub_category_id BIGINT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_category FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE
);
```