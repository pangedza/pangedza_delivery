-- Table for About screen data
CREATE TABLE IF NOT EXISTS public.about_info (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  phone text,
  address text,
  work_hours jsonb
);
