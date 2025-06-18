-- Enable Row-Level Security for public reads
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public select" ON categories
FOR SELECT USING (true);

ALTER TABLE dishes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public select" ON dishes
FOR SELECT USING (true);

-- Reviews table: restrict inserts to the review author
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow insert if user is owner" ON reviews
FOR INSERT TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow select for all" ON reviews
FOR SELECT TO public
USING (true);
