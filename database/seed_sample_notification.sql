-- Example notification entry
INSERT INTO public.notifications (id, title, text)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Дарим ВОК',
  'При заказе от 1000 рублей — подарок!'
)
ON CONFLICT (id) DO NOTHING;
