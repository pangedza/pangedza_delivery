-- Ensure dishes table has image_url column
ALTER TABLE dishes
  ADD COLUMN IF NOT EXISTS image_url text;
