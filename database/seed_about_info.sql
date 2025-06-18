-- Seed data for about screen
INSERT INTO public.about_info (id, phone, address, work_hours)
VALUES (
  '00000000-0000-0000-0000-000000000100',
  '+7 993 315 12 12',
  'г. Новороссийск, ул. Коммунистическая, д. 51',
  '["ежедневно 09:00 – 22:59"]'::jsonb
)
ON CONFLICT (id) DO NOTHING;
