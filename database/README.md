# Database Patches

This folder contains SQL snippets for the Supabase database.

`patch_orders_table.sql` ensures the `orders` table has the required columns and constraints used by the application. It now adds optional `user_name` and `user_phone` fields along with
`items`, `user_id` and `created_at` columns if they are missing.

Run the script on your Supabase instance or integrate it into your migration workflow.
