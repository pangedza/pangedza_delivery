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

SQL patches for the database can be found in the [`database`](database) directory.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
