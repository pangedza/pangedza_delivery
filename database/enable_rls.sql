-- Enable Row-Level Security for public reads
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public select" ON categories
FOR SELECT USING (true);

ALTER TABLE dishes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public select" ON dishes
FOR SELECT USING (true);
