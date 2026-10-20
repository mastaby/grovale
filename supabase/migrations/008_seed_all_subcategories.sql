-- Seed the subcategories used by the customer catalog and admin product form.
insert into public.subcategories (category_id, name, slug)
select c.id, v.name, v.slug
from public.categories c
join (values
  ('Atta, Rice & Dal','Atta & flour','atta-flour'),('Atta, Rice & Dal','Rice','rice'),('Atta, Rice & Dal','Dal & pulses','dal-pulses'),
  ('Oil, Ghee & Masala','Cooking oil','cooking-oil'),('Oil, Ghee & Masala','Ghee','ghee'),('Oil, Ghee & Masala','Spices & masala','spices-masala'),
  ('Dairy, Bread & Eggs','Milk & dairy','milk-dairy'),('Dairy, Bread & Eggs','Bread','bread'),('Dairy, Bread & Eggs','Eggs','eggs'),
  ('Bakery & Biscuits','Cakes & pastries','cakes-pastries'),('Bakery & Biscuits','Biscuits','biscuits'),('Bakery & Biscuits','Snacks','snacks'),
  ('Bath & Body','Bath essentials','bath-essentials'),('Bath & Body','Soaps','soaps'),('Bath & Body','Body care','body-care'),
  ('Hair','Shampoo','shampoo'),('Hair','Conditioner','conditioner'),('Hair','Hair styling','hair-styling'),
  ('Skin & Face','Face care','face-care'),('Skin & Face','Moisturizers','moisturizers'),('Skin & Face','Sunscreen','sunscreen'),
  ('Beauty & Cosmetics','Makeup','makeup'),('Beauty & Cosmetics','Fragrances','fragrances'),('Beauty & Cosmetics','Beauty tools','beauty-tools'),
  ('Feminine Hygiene','Sanitary care','sanitary-care'),('Feminine Hygiene','Intimate care','intimate-care'),
  ('Baby Care','Baby food','baby-food'),('Baby Care','Diapers','diapers'),('Baby Care','Baby toiletries','baby-toiletries'),
  ('Health & Pharma','Medicines','medicines'),('Health & Pharma','First aid','first-aid'),('Health & Pharma','Wellness','wellness'),
  ('Sexual Wellness','Contraception','contraception'),('Sexual Wellness','Personal care','personal-care'),
  ('Dry Fruits & Cereals','Dry fruits','dry-fruits'),('Dry Fruits & Cereals','Cereals','cereals'),('Dry Fruits & Cereals','Seeds','seeds'),
  ('Chicken, Meat & Fish','Chicken','chicken'),('Chicken, Meat & Fish','Meat','meat'),('Chicken, Meat & Fish','Fish','fish'),
  ('Kitchenware & Appliances','Cookware','cookware'),('Kitchenware & Appliances','Kitchen tools','kitchen-tools'),('Kitchenware & Appliances','Small appliances','small-appliances'),
  ('Electronics','Mobile accessories','mobile-accessories'),('Electronics','Home electronics','home-electronics'),('Electronics','Batteries','batteries'),
  ('Stationery & Games','Stationery','stationery'),('Stationery & Games','Board games','board-games'),('Stationery & Games','Kids activities','kids-activities'),
  ('Hotel Essentials','Guest supplies','guest-supplies'),('Hotel Essentials','Housekeeping','housekeeping'),('Hotel Essentials','Room essentials','room-essentials'),
  ('Restaurant Supplies','Kitchen supplies','kitchen-supplies'),('Restaurant Supplies','Packaging','packaging'),('Restaurant Supplies','Cleaning supplies','cleaning-supplies')
) v(category_name,name,slug) on c.name=v.category_name
on conflict (category_id, slug) do update set name=excluded.name;
