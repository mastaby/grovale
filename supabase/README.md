# Supabase setup

1. Create a Supabase project.
2. Open SQL Editor and run `schema.sql`.
3. Enable email authentication (and Google or phone auth later).
4. Copy the project URL and anon key into the app configuration.
5. Deploy `functions/send-order-confirmation` and set `RESEND_API_KEY` plus `ORDER_EMAIL_FROM` secrets.

The schema supports one common cart and checkout flow with four order types:
`individual`, `hotel_guest`, `hotel_essentials`, and `restaurant_supplies`.
