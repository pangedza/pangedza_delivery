# pangedza_delivery

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

## Environment configuration

Copy `.env.example` to `.env` and fill in your Supabase and Telegram keys before running the app.

## Supabase structure

The menu is loaded entirely from Supabase. Ensure these tables are present:

- `categories` with `id`, `name` and `sort_order`
- `dishes` with fields `id`, `name`, `price`, `weight`, `description`, `image_url`, `category_id`
- `modifiers` with `id`, `name`, `price` and optional `group_name`
- `dish_modifiers` linking dishes and modifiers
- `reviews` for storing user reviews

SQL patches for the database can be found in the [`database`](database) directory.
Run `create_menu_tables.sql` first to create the `categories` and `dishes` tables,
then import data from the provided Excel file if needed.

### Automatic menu import

The project includes a helper `MenuLoader` that uploads the full menu to
Supabase. When the app starts in debug mode and the `categories` table is empty,
`MenuLoader.loadIfNeeded()` reads `assets/data/pangedza_menu_full_template (3).xlsx`
and populates both `categories` and `dishes`, linking each dish to its category.
Make sure the Excel file path is listed under `flutter.assets` in
`pubspec.yaml` (already configured in the repository).

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

### Row level security

Enable RLS on the `categories`, `dishes` and `reviews` tables so the client can read the data and authenticated users can create reviews:

```sql
\i database/enable_rls.sql
```

This script turns on row level security for all three tables. `categories` and `dishes` get public `SELECT` access, while `reviews` also restricts `INSERT` to the review author.
