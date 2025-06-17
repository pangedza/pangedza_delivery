-- Seed Закуски category and a sample dish
INSERT INTO categories (id, name, sort_order)
VALUES ('45585233-0322-4581-a467-ae84b317e71f', 'Закуски', 0)
ON CONFLICT (name) DO NOTHING;

INSERT INTO dishes (id, name, description, price, weight, category_id, image_url)
VALUES (
  '60746ac6-76ec-49f2-8c38-755ff086c1dd',
  'Картофель фри',
  'Хрустящий картофель фри, обжаренный до золотистой корочки. Подаётся с соусом по выбору.',
  199,
  '150 г',
  '45585233-0322-4581-a467-ae84b317e71f',
  'https://via.placeholder.com/512x300.png?text=Картофель+фри'
)
ON CONFLICT (id) DO NOTHING;
