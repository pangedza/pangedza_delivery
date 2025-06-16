-- Tables for dish modifiers
CREATE TABLE IF NOT EXISTS public.modifiers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  price numeric DEFAULT 0,
  group_name text,
  created_at timestamp DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.dish_modifiers (
  dish_id uuid REFERENCES dishes(id) ON DELETE CASCADE,
  modifier_id uuid REFERENCES modifiers(id) ON DELETE CASCADE,
  PRIMARY KEY (dish_id, modifier_id)
);
