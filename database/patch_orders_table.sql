-- Ensure orders table has required columns
ALTER TABLE IF EXISTS public.orders
  ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES users(id) NOT NULL;

ALTER TABLE IF EXISTS public.orders
  ADD COLUMN IF NOT EXISTS user_name text;

ALTER TABLE IF EXISTS public.orders
  ADD COLUMN IF NOT EXISTS user_phone text;

ALTER TABLE IF EXISTS public.orders
  ADD COLUMN IF NOT EXISTS items jsonb NOT NULL;

ALTER TABLE IF EXISTS public.orders
  ADD COLUMN IF NOT EXISTS created_at timestamp with time zone NOT NULL DEFAULT now();

-- Adjust column types if they differ
ALTER TABLE public.orders
  ALTER COLUMN user_id TYPE uuid USING user_id::uuid,
  ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE public.orders
  ALTER COLUMN items TYPE jsonb USING items::jsonb,
  ALTER COLUMN items SET NOT NULL;

-- Ensure foreign key constraint exists
ALTER TABLE public.orders
  ADD CONSTRAINT IF NOT EXISTS orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);
