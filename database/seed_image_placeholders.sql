-- Placeholder images for dishes without image_url
UPDATE dishes
SET image_url = 'https://via.placeholder.com/512x300.png?text=%D0%91%D0%BB%D1%8E%D0%B4%D0%BE'
WHERE image_url IS NULL;
