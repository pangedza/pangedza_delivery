-- Seed a default modifier for every dish
INSERT INTO modifiers (name, price, group_name)
VALUES ('Соус чили', 20, 'Соусы')
ON CONFLICT (name, price, group_name) DO NOTHING;

WITH mod AS (
  SELECT id FROM modifiers WHERE name='Соус чили'
)
INSERT INTO dish_modifiers (dish_id, modifier_id)
SELECT d.id, mod.id FROM dishes d, mod
ON CONFLICT DO NOTHING;
