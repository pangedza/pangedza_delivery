-- Creates the categories and dishes tables used in the application.
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text UNIQUE NOT NULL,
  sort_order integer DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dishes (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  weight text,
  price integer NOT NULL,
  description text,
  image_url text,
  category_id uuid REFERENCES categories(id)
);
