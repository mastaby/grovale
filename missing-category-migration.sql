begin;

create temporary table missing_catalog (category_name text, subcategory_name text);

insert into missing_catalog values
('Frozen Foods','Frozen snacks'),('Frozen Foods','Frozen vegetables'),('Frozen Foods','Frozen meals'),
('Chips & Namkeen','Potato chips'),('Chips & Namkeen','Namkeen'),('Chips & Namkeen','Popcorn'),
('Sweets & Chocolates','Indian sweets'),('Sweets & Chocolates','Chocolates'),('Sweets & Chocolates','Candies'),
('Drinks & Juices','Soft drinks'),('Drinks & Juices','Juices'),('Drinks & Juices','Water'),
('Tea, Coffee & Milk Drinks','Tea'),('Tea, Coffee & Milk Drinks','Coffee'),('Tea, Coffee & Milk Drinks','Milk drinks'),
('Instant Food','Noodles'),('Instant Food','Ready meals'),('Instant Food','Soups'),
('Sauces & Spreads','Ketchup'),('Sauces & Spreads','Spreads'),('Sauces & Spreads','Pickles'),
('Paan Corner','Paan'),('Paan Corner','Mouth fresheners'),('Paan Corner','Paan accessories'),
('Ice Creams & More','Ice creams'),('Ice Creams & More','Kulfi'),('Ice Creams & More','Frozen desserts'),
('Oral Care','Toothpaste'),('Oral Care','Toothbrushes'),('Oral Care','Mouthwash'),
('Men’s Grooming','Shaving'),('Men’s Grooming','Deodorants'),('Men’s Grooming','Beard care'),
('Fragrances','Perfumes'),('Fragrances','Body sprays'),('Fragrances','Attars'),
('Home & Lifestyle','Storage'),('Home & Lifestyle','Decor'),('Home & Lifestyle','Home utility'),
('Cleaners & Repellents','Cleaners'),('Cleaners & Repellents','Repellents'),('Cleaners & Repellents','Disinfectants'),
('Print Store','Notebook'),('Print Store','Photo print'),('Print Store','Canvas'),
('E-Gift Cards','Shopping vouchers'),('E-Gift Cards','Food vouchers'),('E-Gift Cards','Entertainment vouchers'),
('Festival Gifts','Gift hampers'),('Festival Gifts','Festival decorations'),('Festival Gifts','Greeting cards'),
('Laundry','Detergent'),('Laundry','Fabric care'),('Laundry','Laundry tools'),
('Mobile Accessories','Chargers'),('Mobile Accessories','Power banks'),('Mobile Accessories','Headphones'),
('Travel Essentials','Luggage'),('Travel Essentials','Travel bags'),('Travel Essentials','Travel accessories');

insert into public.categories (name, slug)
select distinct category_name, lower(regexp_replace(category_name, '[^a-zA-Z0-9]+', '-', 'g'))
from missing_catalog m
where not exists (select 1 from public.categories c where lower(c.name)=lower(m.category_name));

insert into public.subcategories (name, category_id, slug)
select distinct
  m.subcategory_name,
  c.id,
  lower(regexp_replace(m.subcategory_name, '[^a-zA-Z0-9]+', '-', 'g'))
from missing_catalog m
join public.categories c on lower(c.name)=lower(m.category_name)
where not exists (select 1 from public.subcategories s where s.category_id=c.id and lower(s.name)=lower(m.subcategory_name));

drop table missing_catalog;
commit;
