-- Add WOK category and ensure correct sort order

-- Ensure Комбо has sort_order=0
UPDATE categories SET sort_order = 0
WHERE name = 'Комбо' AND (sort_order IS NULL OR sort_order <> 0);

-- Insert WOK category if missing
INSERT INTO categories (name, sort_order)
SELECT 'WOK', 1
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'WOK');

-- Rename existing "Собери лапшу сам" category to WOK if present
UPDATE categories SET name = 'WOK', sort_order = 1
WHERE name = 'Собери лапшу сам';
