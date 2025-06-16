-- Seed category and dishes for "Build your own noodles" now named "WOK"
INSERT INTO categories (name, sort_order)
VALUES ('WOK', 1)
ON CONFLICT (name) DO NOTHING;

WITH cat AS (
  SELECT id FROM categories WHERE name='WOK'
), dishes_data AS (
  SELECT 'Курица' AS name, 0 AS price, 'https://via.placeholder.com/512x300.png?text=Курица' AS image_url UNION ALL
  SELECT 'Креветка', 0, 'https://via.placeholder.com/512x300.png?text=Креветка' UNION ALL
  SELECT 'Свинина', 0, 'https://via.placeholder.com/512x300.png?text=Свинина' UNION ALL
  SELECT 'Овощи', 0, 'https://via.placeholder.com/512x300.png?text=Овощи'
)
INSERT INTO dishes (name, price, image_url, category_id)
SELECT d.name, d.price, d.image_url, cat.id FROM dishes_data d, cat
ON CONFLICT (name) DO NOTHING;
