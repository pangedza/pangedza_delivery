-- Tables for dish modifiers
CREATE TABLE IF NOT EXISTS public.modifiers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text,
  price numeric DEFAULT 0,
  group_name text
);

CREATE TABLE IF NOT EXISTS public.dish_modifiers (
  dish_id uuid REFERENCES dishes(id),
  modifier_id uuid REFERENCES modifiers(id)
);
