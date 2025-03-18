```sql
-- 2. users table
CREATE TABLE users (
    id UUID PRIMARY KEY,  -- Ensure id is the primary key
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
-- Drop existing trigger and function
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS handle_new_user();

-- Create a new function
CREATE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name, phone)
  VALUES (
    NEW.id, 
    NEW.email, 
    (NEW.raw_user_meta_data->>'name'),  -- Extract name from user_metadata JSONB
    (NEW.raw_user_meta_data->>'phone')  -- Extract phone number from user_metadata JSONB
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;  -- Ensures the function runs with the necessary permissions

-- Create the trigger
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION handle_new_user();
```

```sql
INSERT INTO users (id, name, email, phone, created_at, updated_at)
VALUES
(gen_random_uuid(), 'Arun Kumar', 'arunkumar.tn@example.com', '+91 9876543210', NOW(), NOW()),
(gen_random_uuid(), 'Priya Dharshini', 'priyadh.tn@example.com', '+91 9867543211', NOW(), NOW()),
(gen_random_uuid(), 'Vignesh R', 'vignesh.r.tn@example.com', '+91 9956321478', NOW(), NOW()),
(gen_random_uuid(), 'Swetha Raj', 'swetha.raj@example.com', '+91 9845236987', NOW(), NOW()),
(gen_random_uuid(), 'Karthik S', 'karthik.s@example.com', '+91 9887456321', NOW(), NOW()),
(gen_random_uuid(), 'Lakshmi Narayanan', 'lakshmi.n.tn@example.com', '+91 9786543212', NOW(), NOW()),
(gen_random_uuid(), 'Deepak Kumar', 'deepak.kumar@example.com', '+91 9874123658', NOW(), NOW()),
(gen_random_uuid(), 'Meena V', 'meena.v@example.com', '+91 9923658741', NOW(), NOW()),
(gen_random_uuid(), 'Rajeshwaran P', 'rajesh.p@example.com', '+91 9845632147', NOW(), NOW()),
(gen_random_uuid(), 'Harini B', 'harini.b@example.com', '+91 9764123589', NOW(), NOW());
```