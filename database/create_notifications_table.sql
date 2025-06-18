-- Table for application notifications
CREATE TABLE IF NOT EXISTS public.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  text text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);
