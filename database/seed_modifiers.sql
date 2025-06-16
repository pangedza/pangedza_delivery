-- Seed example modifiers
INSERT INTO modifiers (name, price, group_name)
VALUES
  ('Лапша удон', 0, 'Лапша'),
  ('Лапша рисовая', 0, 'Лапша'),
  ('Соус чили', 20, 'Соусы'),
  ('Сырный соус', 25, 'Соусы')
ON CONFLICT (name, price, group_name) DO NOTHING;

WITH mod AS (
  SELECT id FROM modifiers ORDER BY created_at LIMIT 1
)
INSERT INTO dish_modifiers (dish_id, modifier_id)
SELECT d.id, mod.id FROM dishes d, mod
ON CONFLICT DO NOTHING;
