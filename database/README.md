# Database Patches

This folder contains SQL snippets for the Supabase database used by the app.

Run the scripts on your Supabase instance or incorporate them into your migration workflow. The key files are:

- `create_modifiers_tables.sql` – creates `modifiers` and `dish_modifiers` tables
- `patch_dishes_table.sql` – ensures `image_url` column exists in `dishes`
- `patch_wok_category.sql` – adds the `WOK` category and sets proper ordering
- `seed_noodle_category.sql` – inserts example dishes for the `WOK` category
- `seed_modifiers.sql` – seeds example modifiers and links them to dishes
- `seed_image_placeholders.sql` – fills `dishes.image_url` with placeholder URLs if empty
- `patch_orders_table.sql` – updates `orders` with required fields
- `patch_users_table.sql` – adds a `gender` column to `users`
- `seed_snacks_category.sql` – adds the "Закуски" category with a sample dish
- `enable_rls.sql` – enables RLS and creates public SELECT policies for `categories` and `dishes` tables
