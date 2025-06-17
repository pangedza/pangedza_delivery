-- Ensure users table has gender column
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS gender text;
