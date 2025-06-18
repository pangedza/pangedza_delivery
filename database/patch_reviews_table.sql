-- Updates the reviews table to the latest schema
ALTER TABLE IF EXISTS public.reviews
  ALTER COLUMN id SET DEFAULT gen_random_uuid();

ALTER TABLE IF EXISTS public.reviews
  ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE IF EXISTS public.reviews
  ALTER COLUMN rating TYPE integer USING rating::integer,
  ALTER COLUMN rating DROP DEFAULT,
  ALTER COLUMN rating SET NOT NULL;

ALTER TABLE IF EXISTS public.reviews
  ADD COLUMN IF NOT EXISTS photo_url text;

ALTER TABLE IF EXISTS public.reviews
  ALTER COLUMN created_at SET DEFAULT timezone('utc', now());
