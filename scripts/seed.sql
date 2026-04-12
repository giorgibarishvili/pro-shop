-- =============================================================================
-- Pro Shop — Seed Data
-- =============================================================================
-- Populates: categories, product_types, products, product_categories
-- Does NOT touch: profiles, orders, order_items, cart_items (user-generated)
--
-- Run against your Supabase database:
--   psql $DATABASE_URL -f scripts/seed.sql
--
-- Safe to re-run: uses ON CONFLICT DO NOTHING on all inserts.
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. CATEGORIES (10)
-- =============================================================================
INSERT INTO categories (id, name, slug, description) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'Protein Powders',         'protein-powders',         'Build and repair muscle with high-quality protein from whey, casein, and plant-based sources.'),
  ('a0000000-0000-0000-0000-000000000002', 'Creatine',                'creatine',                'The most researched sports supplement. Boost strength, power output, and muscle hydration.'),
  ('a0000000-0000-0000-0000-000000000003', 'Pre-Workout',             'pre-workout',             'Fuel your training sessions with energy, focus, and endurance-boosting formulas.'),
  ('a0000000-0000-0000-0000-000000000004', 'BCAAs & Amino Acids',     'bcaas-amino-acids',       'Support muscle recovery and reduce soreness with essential and branched-chain amino acids.'),
  ('a0000000-0000-0000-0000-000000000005', 'Vitamins & Minerals',     'vitamins-minerals',       'Fill nutritional gaps and support overall health with essential micronutrients.'),
  ('a0000000-0000-0000-0000-000000000006', 'Weight Gainers',          'weight-gainers',          'High-calorie formulas designed to help hardgainers pack on size and mass.'),
  ('a0000000-0000-0000-0000-000000000007', 'Fat Burners',             'fat-burners',             'Thermogenic and stimulant-based formulas to support fat loss and body composition goals.'),
  ('a0000000-0000-0000-0000-000000000008', 'Energy & Endurance',      'energy-endurance',        'Sustained energy and stamina for longer, harder training sessions.'),
  ('a0000000-0000-0000-0000-000000000009', 'Recovery & Joint Support','recovery-joint-support',  'Speed up recovery and protect your joints with targeted support formulas.'),
  ('a0000000-0000-0000-0000-00000000000a', 'Snacks & Bars',           'snacks-bars',             'Convenient high-protein snacks for on-the-go nutrition between meals.')
ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- 2. PRODUCT TYPES (12)
-- =============================================================================
INSERT INTO product_types (id, name, slug, how_to_use) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'Whey Protein Powder',   'whey-protein-powder',
   'Mix 1 scoop (30-35g) with 200-300ml of cold water or milk. Shake vigorously for 15-20 seconds. Best consumed within 30 minutes post-workout or as a between-meal snack. Can also be blended into smoothies or mixed into oatmeal.'),

  ('b0000000-0000-0000-0000-000000000002', 'Casein Protein Powder', 'casein-protein-powder',
   'Mix 1 scoop (30-35g) with 250-300ml of cold water or milk. Shake well — casein is thicker than whey. Best taken before bed for sustained overnight amino acid release. Can also be used as a daytime meal replacement due to its slow digestion.'),

  ('b0000000-0000-0000-0000-000000000003', 'Creatine Monohydrate',  'creatine-monohydrate',
   'Mix 1 scoop (5g) with 250ml of water, juice, or your protein shake. Take daily for consistent results — on training days after your workout, on rest days at any time with a meal. No loading phase required. Stay well hydrated throughout the day.'),

  ('b0000000-0000-0000-0000-000000000004', 'Pre-Workout Formula',   'pre-workout-formula',
   'Mix 1 scoop with 200-250ml of cold water. Consume 20-30 minutes before training on an empty or light stomach. Start with half a scoop to assess tolerance. Do not exceed 1 serving per day. Avoid taking within 4-5 hours of sleep due to caffeine content.'),

  ('b0000000-0000-0000-0000-000000000005', 'BCAA Powder',           'bcaa-powder',
   'Mix 1 scoop (7-10g) with 300-400ml of cold water. Sip during your workout for intra-workout recovery support, or drink throughout the day to support muscle protein synthesis. Can be stacked with other supplements. Tastes best ice-cold.'),

  ('b0000000-0000-0000-0000-000000000006', 'Amino Acid Capsules',   'amino-acid-capsules',
   'Take 3-4 capsules with water, 1-2 times daily. Best taken on an empty stomach for optimal absorption — first thing in the morning or 30 minutes before training. Swallow whole; do not crush or chew.'),

  ('b0000000-0000-0000-0000-000000000007', 'Mass Gainer Powder',    'mass-gainer-powder',
   'Mix 2 scoops (150-170g) with 400-500ml of whole milk for maximum calorie intake, or water for a lighter shake. Consume 1-2 servings daily between meals or post-workout. For best results, use a blender. Can be split into smaller servings if the volume is too much at once.'),

  ('b0000000-0000-0000-0000-000000000008', 'Fat Burner Capsules',   'fat-burner-capsules',
   'Take 2 capsules in the morning with breakfast and 1 capsule early afternoon with lunch. Do not exceed 3 capsules per day. Do not take within 5 hours of sleep. Start with 1 capsule per day for the first week to assess tolerance. Drink plenty of water throughout the day.'),

  ('b0000000-0000-0000-0000-000000000009', 'Multivitamin Tablets',  'multivitamin-tablets',
   'Take 1-2 tablets daily with a meal and a full glass of water. Best taken with breakfast for consistent daily use. Do not exceed the recommended dose. Store in a cool, dry place away from direct sunlight.'),

  ('b0000000-0000-0000-0000-00000000000a', 'Protein Bar',           'protein-bar',
   'Consume 1 bar as a between-meal snack, post-workout recovery fuel, or on-the-go protein boost. No preparation needed — just unwrap and eat. Best stored at room temperature. For a softer texture, microwave for 10-15 seconds.'),

  ('b0000000-0000-0000-0000-00000000000b', 'Electrolyte Powder',    'electrolyte-powder',
   'Mix 1 scoop with 400-500ml of cold water. Drink during exercise to replace minerals lost through sweat, or first thing in the morning to rehydrate. Can be consumed multiple times daily as needed. Best served ice-cold.'),

  ('b0000000-0000-0000-0000-00000000000c', 'Joint Support Capsules','joint-support-capsules',
   'Take 2-3 capsules daily with a meal. Allow 4-8 weeks of consistent use for full effect — joint support compounds build up gradually. Best taken with food containing some fat for better absorption. Do not exceed the recommended dose.')
ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- 3. PRODUCTS (50)
-- =============================================================================

-- ---------- PROTEIN POWDERS (10) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000001',
   'Gold Standard 100% Whey', 'gold-standard-100-whey', 'Optimum Nutrition',
   'The world''s best-selling whey protein powder for over 20 years. Gold Standard delivers 24g of premium whey protein with only 1g of sugar per serving. Made with whey protein isolate as the primary ingredient for fast absorption and muscle recovery. Over 20 delicious flavors — trusted by athletes worldwide.',
   'b0000000-0000-0000-0000-000000000001',
   54.99, NULL, 120, true),

  ('c0000000-0000-0000-0000-000000000002',
   'Impact Whey Protein', 'impact-whey-protein', 'Myprotein',
   'Europe''s #1 online sports nutrition brand brings you an affordable, high-quality whey protein with 21g of protein per serving. Made from premium grass-fed milk and available in over 40 flavors. Batch-tested for banned substances — Informed Sport certified.',
   'b0000000-0000-0000-0000-000000000001',
   29.99, 24.99, 200, false),

  ('c0000000-0000-0000-0000-000000000003',
   'Nitro-Tech 100% Whey Gold', 'nitro-tech-100-whey-gold', 'MuscleTech',
   'Built on 20+ years of research, Nitro-Tech Whey Gold delivers 24g of ultra-premium whey peptides and isolate. Enhanced with added BCAAs and creatine for superior muscle recovery. Formulated using a multi-phase filtration process for maximum purity and taste.',
   'b0000000-0000-0000-0000-000000000001',
   49.99, 42.99, 85, true),

  ('c0000000-0000-0000-0000-000000000004',
   'ISO100 Hydrolyzed Whey', 'iso100-hydrolyzed-whey', 'Dymatize',
   'The gold standard of hydrolyzed whey protein isolate. ISO100 delivers 25g of protein with zero fat, less than 1g of sugar, and no lactose. Pre-digested for lightning-fast absorption — hits your muscles faster than any standard whey. Award-winning chocolate peanut butter flavor.',
   'b0000000-0000-0000-0000-000000000001',
   64.99, NULL, 65, true),

  ('c0000000-0000-0000-0000-000000000005',
   'R1 Protein WPI', 'r1-protein-wpi', 'Rule One',
   'Rule One takes a no-nonsense approach to protein: 25g of whey protein isolate per serving with minimal filler. No amino spiking, no proprietary blends — just transparently dosed, fast-absorbing protein. Naturally flavored options available.',
   'b0000000-0000-0000-0000-000000000001',
   44.99, NULL, 95, false),

  ('c0000000-0000-0000-0000-000000000006',
   'Syntha-6 Edge', 'syntha-6-edge', 'BSN',
   'The lean version of BSN''s legendary Syntha-6 protein blend. Edge delivers 24g of premium multi-source protein with only 2g of sugar. A sustained-release formula combining fast, medium, and slow-digesting proteins for all-day muscle fuel. Award-winning taste that mixes into a milkshake-like texture.',
   'b0000000-0000-0000-0000-000000000001',
   39.99, 34.99, 70, false),

  ('c0000000-0000-0000-0000-000000000007',
   'Proton Whey Isolate', 'proton-whey-isolate', 'Kaged',
   'Kaged''s micro-filtered whey protein isolate is sourced from hormone-free cows and cold-processed to preserve bioactive fractions. 25g of protein per serving with added ProHydrolase enzyme for improved digestion and absorption. Third-party tested for purity.',
   'b0000000-0000-0000-0000-000000000001',
   49.99, NULL, 55, false),

  ('c0000000-0000-0000-0000-000000000008',
   'Gold Standard Casein', 'gold-standard-casein', 'Optimum Nutrition',
   'Slow-digesting micellar casein for overnight muscle recovery. Gold Standard Casein delivers 24g of sustained-release protein that forms a gel in your stomach, providing a steady amino acid stream for up to 7 hours. The perfect bedtime protein.',
   'b0000000-0000-0000-0000-000000000002',
   52.99, NULL, 45, false),

  ('c0000000-0000-0000-0000-000000000009',
   'Combat 100% Whey', 'combat-100-whey', 'MusclePharm',
   'Battle-tested protein designed for serious athletes. Combat Whey delivers 25g of fast-absorbing whey protein isolate and concentrate with naturally occurring BCAAs and glutamine. Sport-certified and banned substance tested — trusted in the ring and on the field.',
   'b0000000-0000-0000-0000-000000000001',
   34.99, 29.99, 110, false),

  ('c0000000-0000-0000-0000-00000000000a',
   'Plant Protein+', 'plant-protein-plus', 'Vega',
   'A complete plant-based protein blend of pea, sunflower seed, and pumpkin seed protein delivering 30g of multi-source protein per serving. Smooth texture with no gritty aftertaste — a common problem Vega solved with their proprietary blending process. Certified vegan, non-GMO, and gluten-free.',
   'b0000000-0000-0000-0000-000000000001',
   42.99, NULL, 80, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- CREATINE (5) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000101',
   'Micronised Creatine Monohydrate', 'micronised-creatine-monohydrate', 'Optimum Nutrition',
   'The industry standard creatine — unflavored, pure creatine monohydrate micronised to 200 mesh for better mixability. Creapure sourced from Germany for pharmaceutical-grade purity. 5g per serving, 60 servings per container. No fillers, no extras — just creatine that works.',
   'b0000000-0000-0000-0000-000000000003',
   19.99, NULL, 180, true),

  ('c0000000-0000-0000-0000-000000000102',
   'Platinum 100% Creatine', 'platinum-100-creatine', 'MuscleTech',
   'Ultra-pure HPLC-tested creatine monohydrate delivering 5g per serving. MuscleTech''s flagship creatine is backed by clinical research showing significant increases in strength and muscle size in just 14 days of use. 80 servings per container — best value per serving.',
   'b0000000-0000-0000-0000-000000000003',
   17.99, 14.99, 150, false),

  ('c0000000-0000-0000-0000-000000000103',
   'Creatine HCl', 'creatine-hcl', 'Kaged',
   'Patented creatine hydrochloride requiring only 750mg per serving — a fraction of traditional monohydrate doses. Superior solubility means no loading phase, no bloating, and no stomach discomfort. For athletes who want creatine''s benefits without the water retention.',
   'b0000000-0000-0000-0000-000000000003',
   29.99, NULL, 90, false),

  ('c0000000-0000-0000-0000-000000000104',
   'Cell-Tech Creatine', 'cell-tech-creatine', 'MuscleTech',
   'Not just creatine — Cell-Tech is a complete creatine transport system. Combines 5g creatine with a precise ratio of carbs and alpha-lipoic acid to spike insulin and drive more creatine into muscle cells. Clinically shown to increase creatine uptake by 40% versus creatine alone.',
   'b0000000-0000-0000-0000-000000000003',
   39.99, 34.99, 60, false),

  ('c0000000-0000-0000-0000-000000000105',
   'Pure Creatine', 'pure-creatine', 'Myprotein',
   'Straight-to-the-point creatine monohydrate at an unbeatable price. Third-party batch tested and Informed Sport certified. 250 servings per bag — months of supply in a single purchase. Unflavored for easy stacking with any shake.',
   'b0000000-0000-0000-0000-000000000003',
   14.99, NULL, 220, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- PRE-WORKOUT (6) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000201',
   'C4 Original', 'c4-original', 'Cellucor',
   'America''s #1 selling pre-workout for over a decade. C4 Original delivers explosive energy, heightened focus, and a signature beta-alanine tingle to get you locked in from the first rep. 150mg caffeine — enough to fire you up without the jitters. Available in 16 flavors.',
   'b0000000-0000-0000-0000-000000000004',
   29.99, NULL, 130, true),

  ('c0000000-0000-0000-0000-000000000202',
   'Gold Standard Pre-Workout', 'gold-standard-pre-workout', 'Optimum Nutrition',
   'The same trusted quality behind the world''s best whey, now in pre-workout form. Gold Standard Pre delivers 175mg of natural caffeine alongside 3g of creatine monohydrate and 1.5g of beta-alanine. Fully transparent label — every dose is listed, no proprietary blends.',
   'b0000000-0000-0000-0000-000000000004',
   34.99, 29.99, 75, false),

  ('c0000000-0000-0000-0000-000000000203',
   'Total War', 'total-war-pre-workout', 'Redcon1',
   'Built for the hardest training sessions. Total War packs 320mg of caffeine, 6g of citrulline malate, and 3.2g of beta-alanine into every scoop — all transparently dosed. Warning: this is a high-stim formula designed for experienced pre-workout users. Not for the faint-hearted.',
   'b0000000-0000-0000-0000-000000000004',
   44.99, NULL, 55, false),

  ('c0000000-0000-0000-0000-000000000204',
   'Beyond Raw LIT', 'beyond-raw-lit', 'Beyond Raw',
   'GNC''s flagship pre-workout formula featuring clinically dosed ingredients at fully transparent amounts. 250mg of caffeine paired with 3.2g beta-alanine, 1.5g nitric oxide blend, and NeuroFactor for enhanced cognitive focus. The perfect middle ground between mild and high-stim.',
   'b0000000-0000-0000-0000-000000000004',
   37.99, NULL, 65, false),

  ('c0000000-0000-0000-0000-000000000205',
   'Pre JYM', 'pre-jym', 'JYM Supplement Science',
   'Created by PhD exercise physiologist Jim Stoppani, Pre JYM is the science-first pre-workout. Every single ingredient is clinically dosed and backed by peer-reviewed research — 6g citrulline malate, 2g creatine HCl, 6g BCAAs, 300mg caffeine. Zero proprietary blends. Zero shortcuts.',
   'b0000000-0000-0000-0000-000000000004',
   49.99, 44.99, 40, false),

  ('c0000000-0000-0000-0000-000000000206',
   'Vapor X5 Next Gen', 'vapor-x5-next-gen', 'MuscleTech',
   'MuscleTech''s most advanced pre-workout combines a dual-source caffeine blend (275mg) with a neurosensory complex for razor-sharp focus that lasts the entire session. Added betaine anhydrous and hawthorn berry extract for enhanced muscular endurance and pumps.',
   'b0000000-0000-0000-0000-000000000004',
   32.99, NULL, 90, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- BCAAs & AMINO ACIDS (5) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000301',
   'Xtend Original BCAA', 'xtend-original-bcaa', 'Scivation',
   'The original intra-workout BCAA — trusted by athletes for over 10 years. Xtend delivers 7g of BCAAs in the research-backed 2:1:1 ratio plus added electrolytes and citrulline for hydration and endurance. Zero sugar, zero calories. Over 20 refreshing flavors.',
   'b0000000-0000-0000-0000-000000000005',
   27.99, 22.99, 140, true),

  ('c0000000-0000-0000-0000-000000000302',
   'BCAA 5000 Powder', 'bcaa-5000-powder', 'Optimum Nutrition',
   'Clean, unflavored BCAA powder for easy stacking with any drink. 5g of branched-chain amino acids in every serving with the scientifically validated 2:1:1 ratio. Instantized for quick mixing — no clumping, no grit. A versatile building block for any supplement stack.',
   'b0000000-0000-0000-0000-000000000005',
   24.99, NULL, 100, false),

  ('c0000000-0000-0000-0000-000000000303',
   'Amino X', 'amino-x', 'BSN',
   'A next-gen amino acid formula that goes beyond BCAAs. Amino X delivers 10g of aminos per serving including BCAAs, citrulline, taurine, and alanine for recovery, endurance, and hydration. Effervescent formula that mixes into a light, refreshing drink — perfect for sipping all day.',
   'b0000000-0000-0000-0000-000000000005',
   25.99, NULL, 85, false),

  ('c0000000-0000-0000-0000-000000000304',
   'Essential Amino 9', 'essential-amino-9', 'Rule One',
   'All 9 essential amino acids in clinically studied doses. Rule One took the research on EAA supplementation seriously — 7.5g of EAAs per serving, including 3.5g of BCAAs, for complete muscle protein synthesis support. Goes beyond the standard BCAA formula to give your body everything it needs.',
   'b0000000-0000-0000-0000-000000000006',
   32.99, NULL, 65, false),

  ('c0000000-0000-0000-0000-000000000305',
   'Alpha Amino EAA', 'alpha-amino-eaa', 'Cellucor',
   'Cellucor''s complete amino acid formula with 14 aminos including all EAAs and BCAAs, plus a hydration blend with raw coconut water concentrate and electrolytes. Designed to be your all-day sipping drink — supports recovery, hydration, and performance. Amazing tropical flavors.',
   'b0000000-0000-0000-0000-000000000005',
   29.99, 24.99, 75, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- VITAMINS & MINERALS (6) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000401',
   'Opti-Men Multivitamin', 'opti-men-multivitamin', 'Optimum Nutrition',
   'A comprehensive multivitamin designed specifically for active men. Opti-Men packs 75+ ingredients across 4 targeted blends: amino, phyto, enzyme, and viri men''s blend. Covers vitamin D, B-complex, zinc, and magnesium at doses tailored for athletes — not generic RDA amounts.',
   'b0000000-0000-0000-0000-000000000009',
   22.99, NULL, 110, false),

  ('c0000000-0000-0000-0000-000000000402',
   'Opti-Women Multivitamin', 'opti-women-multivitamin', 'Optimum Nutrition',
   'The counterpart to Opti-Men — formulated for the unique nutritional needs of active women. Higher iron, calcium, and folic acid doses, plus a botanical blend with soy isoflavones, dong quai, and uva ursi. 23 vitamins and minerals in a once-daily dose.',
   'b0000000-0000-0000-0000-000000000009',
   21.99, NULL, 95, false),

  ('c0000000-0000-0000-0000-000000000403',
   'Vitamin D3 5000 IU', 'vitamin-d3-5000-iu', 'NOW Foods',
   'High-potency vitamin D3 for athletes who train indoors or live in low-sunlight regions. Each softgel delivers 5000 IU of cholecalciferol — the most bioavailable form of vitamin D. Supports bone density, immune function, and testosterone production. Small softgel, easy to swallow.',
   'b0000000-0000-0000-0000-000000000009',
   12.99, NULL, 200, false),

  ('c0000000-0000-0000-0000-000000000404',
   'ZMA Recovery', 'zma-recovery', 'Optimum Nutrition',
   'The classic zinc-magnesium-B6 stack for deeper sleep and faster recovery. ZMA is one of the most studied nighttime supplements — research shows it supports anabolic hormone levels, muscle recovery, and sleep quality. Take on an empty stomach before bed for best absorption.',
   'b0000000-0000-0000-0000-000000000009',
   18.99, 14.99, 120, false),

  ('c0000000-0000-0000-0000-000000000405',
   'Zinc Picolinate 50mg', 'zinc-picolinate-50mg', 'NOW Foods',
   'Zinc picolinate — the most absorbable form of supplemental zinc. Supports immune health, protein synthesis, and testosterone maintenance. Ideal for athletes losing zinc through sweat. One small capsule per day covers your needs.',
   'b0000000-0000-0000-0000-000000000009',
   9.99, NULL, 170, false),

  ('c0000000-0000-0000-0000-000000000406',
   'Magnesium Glycinate 400mg', 'magnesium-glycinate-400mg', 'NOW Foods',
   'Chelated magnesium glycinate for superior absorption without the digestive issues common with cheaper magnesium forms. 400mg per serving supports muscle relaxation, sleep quality, and over 300 enzymatic reactions in the body. The go-to magnesium for athletes and lifters.',
   'b0000000-0000-0000-0000-000000000009',
   14.99, NULL, 155, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- WEIGHT GAINERS (4) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000501',
   'Serious Mass', 'serious-mass', 'Optimum Nutrition',
   'The ultimate mass gainer for hardgainers who struggle to eat enough. Serious Mass delivers a staggering 1,250 calories and 50g of protein per serving from a blend of whey, casein, and egg proteins. Added creatine, glutamine, and 25 vitamins and minerals. When food isn''t enough, this is your answer.',
   'b0000000-0000-0000-0000-000000000007',
   49.99, NULL, 50, false),

  ('c0000000-0000-0000-0000-000000000502',
   'Mass-Tech Extreme 2000', 'mass-tech-extreme-2000', 'MuscleTech',
   'Engineered for maximum calorie delivery — 2,000 calories per full serving with 80g of multi-phase protein. Mass-Tech uses a combination of fast, medium, and slow-digesting proteins plus complex carbs from oat flour for sustained energy release. The most scientifically advanced mass gainer on the market.',
   'b0000000-0000-0000-0000-000000000007',
   59.99, 49.99, 35, false),

  ('c0000000-0000-0000-0000-000000000503',
   'True Mass 1200', 'true-mass-1200', 'BSN',
   'BSN''s ultra-premium mass gainer with 1,220 calories and 50g of multi-source protein. What sets True Mass apart is the fat source — healthy fats from MCTs, flax, and sunflower — not just sugar and maltodextrin. A cleaner approach to mass gaining.',
   'b0000000-0000-0000-0000-000000000007',
   54.99, NULL, 40, false),

  ('c0000000-0000-0000-0000-000000000504',
   'Real Gains', 'real-gains', 'Universal Nutrition',
   'Old-school mass gainer from a brand that''s been feeding bodybuilders since 1977. Real Gains delivers 602 calories and 52g of protein per serving — a realistic, no-bloat approach to gaining size. Uses complex carbs from oat fiber and flax for steady energy, not sugar spikes.',
   'b0000000-0000-0000-0000-000000000007',
   44.99, 39.99, 55, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- FAT BURNERS (4) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000601',
   'Hydroxycut Hardcore Elite', 'hydroxycut-hardcore-elite', 'MuscleTech',
   'America''s #1 selling weight loss supplement brand. Hydroxycut Hardcore Elite delivers a potent thermogenic matrix with 270mg of caffeine anhydrous, green coffee extract, and coleus forskohlii for enhanced metabolic rate. Key ingredient (C. canephora robusta) shown to help subjects lose 10.95 lbs in 60 days.',
   'b0000000-0000-0000-0000-000000000008',
   29.99, NULL, 85, false),

  ('c0000000-0000-0000-0000-000000000602',
   'L-Carnitine 3000', 'l-carnitine-3000', 'Optimum Nutrition',
   'Stimulant-free fat metabolism support. L-Carnitine transports fatty acids to mitochondria where they''re burned for energy — helping your body use fat as fuel during exercise. 3000mg per serving in liquid form for fast absorption. Stack with your pre-workout or take on its own before cardio.',
   'b0000000-0000-0000-0000-000000000008',
   21.99, 17.99, 100, false),

  ('c0000000-0000-0000-0000-000000000603',
   'Super HD Thermogenic', 'super-hd-thermogenic', 'Cellucor',
   'Cellucor''s flagship fat burner combines a nootropic energy blend with thermogenic ingredients for focus and fat loss. 160mg of caffeine — moderate enough to stack with other stimulant products. Added capsimax (concentrated capsaicin) to raise core body temperature and boost calorie burn.',
   'b0000000-0000-0000-0000-000000000008',
   34.99, NULL, 70, false),

  ('c0000000-0000-0000-0000-000000000604',
   'Trans4orm Thermogenic', 'trans4orm-thermogenic', 'Evlution Nutrition',
   'A clean, transparent thermogenic with no proprietary blends. Trans4orm delivers 175mg caffeine, green tea extract, coleus forskohlii, and acetyl L-carnitine in clinically studied doses. Mild enough for stim-sensitive users yet effective enough for seasoned athletes. Great entry-level fat burner.',
   'b0000000-0000-0000-0000-000000000008',
   24.99, 19.99, 95, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- ENERGY & ENDURANCE (5) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000701',
   'Essential Amino Energy', 'essential-amino-energy', 'Optimum Nutrition',
   'Part amino acid supplement, part energy drink — Amino Energy is the ultimate all-day productivity and training companion. 100mg of natural caffeine from green tea and coffee bean paired with 5g of amino acids. Use 1 scoop for a morning pick-me-up, 2 scoops for a pre-workout boost.',
   'b0000000-0000-0000-0000-000000000005',
   24.99, NULL, 160, true),

  ('c0000000-0000-0000-0000-000000000702',
   'Beta-Alanine Powder', 'beta-alanine-powder', 'NOW Foods',
   'Pure beta-alanine for buffering lactic acid and extending high-intensity performance. Clinically shown to increase muscular endurance when dosed at 3.2g daily. Unflavored and easy to stack — add to your pre-workout or drink of choice. The tingle means it''s working.',
   'b0000000-0000-0000-0000-000000000005',
   16.99, NULL, 130, false),

  ('c0000000-0000-0000-0000-000000000703',
   'Citrulline Malate 2:1', 'citrulline-malate', 'Myprotein',
   'Pure L-citrulline malate in the clinically studied 2:1 ratio for maximum nitric oxide production and muscle pumps. 6g per serving enhances blood flow to working muscles, improving nutrient delivery and waste removal. Unflavored for clean stacking.',
   'b0000000-0000-0000-0000-000000000005',
   19.99, 16.99, 110, false),

  ('c0000000-0000-0000-0000-000000000704',
   'Hydra-Charge Electrolytes', 'hydra-charge-electrolytes', 'Kaged',
   'A complete electrolyte and hydration formula with 5 key electrolytes, coconut water concentrate, and spectra antioxidant blend. Zero sugar, zero calories, amazing flavors. Designed to replace what you lose through sweat without the junk found in commercial sports drinks.',
   'b0000000-0000-0000-0000-00000000000b',
   24.99, NULL, 90, false),

  ('c0000000-0000-0000-0000-000000000705',
   'Peak ATP', 'peak-atp', 'MuscleTech',
   'Patented oral ATP supplement clinically shown to increase total strength, power output, and lean body mass. Peak ATP works by increasing extracellular ATP levels — the energy currency your muscles run on. 400mg per serving. Stack with creatine for compounded strength gains.',
   'b0000000-0000-0000-0000-000000000006',
   39.99, 34.99, 45, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- RECOVERY & JOINT SUPPORT (5) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000801',
   'Glutamine Powder', 'glutamine-powder', 'Optimum Nutrition',
   'Pure L-glutamine — the most abundant amino acid in muscle tissue and the one most depleted by intense training. 5g per serving supports gut health, immune function, and muscle recovery. Unflavored and micronized for instant mixing with any liquid.',
   'b0000000-0000-0000-0000-000000000005',
   19.99, NULL, 120, false),

  ('c0000000-0000-0000-0000-000000000802',
   'Fish Oil 1000mg Softgels', 'fish-oil-1000mg', 'Optimum Nutrition',
   'Enteric-coated fish oil softgels for joint support, heart health, and anti-inflammatory benefits without the fishy aftertaste. Each softgel delivers 300mg of combined EPA and DHA omega-3 fatty acids. Molecularly distilled to remove heavy metals and impurities.',
   'b0000000-0000-0000-0000-00000000000c',
   14.99, NULL, 140, false),

  ('c0000000-0000-0000-0000-000000000803',
   'Glucosamine & Chondroitin MSM', 'glucosamine-chondroitin-msm', 'NOW Foods',
   'The triple-action joint support stack trusted by athletes and aging lifters alike. Glucosamine rebuilds cartilage, chondroitin improves joint cushioning, and MSM reduces inflammation. Clinically studied doses in every serving. Results build over 4-8 weeks of consistent use.',
   'b0000000-0000-0000-0000-00000000000c',
   24.99, 19.99, 85, false),

  ('c0000000-0000-0000-0000-000000000804',
   'R1 Collagen Peptides', 'r1-collagen-peptides', 'Rule One',
   'Hydrolyzed bovine collagen peptides sourced from grass-fed, pasture-raised cattle. 10g of type I and III collagen per serving supports joints, tendons, ligaments, skin, and hair. Dissolves clear in hot or cold liquids — add to coffee, shakes, or water without affecting taste.',
   'b0000000-0000-0000-0000-00000000000c',
   29.99, NULL, 70, false),

  ('c0000000-0000-0000-0000-000000000805',
   'Tart Cherry Extract', 'tart-cherry-extract', 'NOW Foods',
   'Concentrated Montmorency tart cherry extract — nature''s recovery supplement. Rich in anthocyanins with potent anti-inflammatory and antioxidant properties. Research shows tart cherry accelerates recovery from intense exercise and supports healthy sleep. 1000mg per serving.',
   'b0000000-0000-0000-0000-00000000000c',
   18.99, NULL, 100, false)
ON CONFLICT (id) DO NOTHING;

-- ---------- SNACKS & BARS (5) ----------
INSERT INTO products (id, name, slug, brand, brand_description, product_type_id, price, sale_price, stock, is_featured) VALUES
  ('c0000000-0000-0000-0000-000000000901',
   'Protein Crisp Bar', 'protein-crisp-bar', 'BSN',
   'A protein bar that actually tastes like a candy bar. BSN''s Protein Crisp delivers 20g of protein in a light, crispy, multi-layered texture — not the dense, chewy brick you''re used to. Chocolate Crunch tastes like a Crunch bar with 20g of protein. Dessert that fits your macros.',
   'b0000000-0000-0000-0000-00000000000a',
   29.99, NULL, 200, false),

  ('c0000000-0000-0000-0000-000000000902',
   'ONE Bar', 'one-bar', 'ONE Brands',
   'One gram of sugar. One bar. One incredible taste. The ONE Bar delivers 20g of protein with just 1g of sugar and no sugar alcohols. Flavors like Birthday Cake and Maple Glazed Doughnut taste indulgent without the guilt. Coated in real chocolate. A guilt-free treat for any time of day.',
   'b0000000-0000-0000-0000-00000000000a',
   32.99, 27.99, 150, true),

  ('c0000000-0000-0000-0000-000000000903',
   'Quest Protein Bar', 'quest-protein-bar', 'Quest Nutrition',
   'The bar that started the high-protein bar revolution. Quest Bars pack 21g of protein with only 1g of sugar using a milk protein isolate base that stays soft. High fiber (14g) for lasting satiety. No junk — Quest pioneered the "clean protein bar" category back in 2010.',
   'b0000000-0000-0000-0000-00000000000a',
   29.99, NULL, 180, false),

  ('c0000000-0000-0000-0000-000000000904',
   'Grenade Carb Killa', 'grenade-carb-killa', 'Grenade',
   'Born in the UK, Carb Killa stormed the global market with its triple-layer construction: protein nougat base, caramel layer, and chocolate coating. 23g of protein with under 2g of sugar — engineered to satisfy candy cravings without derailing your diet. White Chocolate Cookie is legendary.',
   'b0000000-0000-0000-0000-00000000000a',
   34.99, 29.99, 120, false),

  ('c0000000-0000-0000-0000-000000000905',
   'Protein Cookie', 'protein-cookie', 'Lenny & Larrys',
   'The Complete Cookie — soft-baked, plant-based protein cookie with 16g of protein per cookie. Vegan, non-GMO, and free from soy, dairy, and eggs. Tastes like a real bakery cookie, not a protein product. Chocolate Chip and Snickerdoodle are fan favorites. One cookie is a full serving.',
   'b0000000-0000-0000-0000-00000000000a',
   24.99, NULL, 160, false)
ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- 4. PRODUCT ↔ CATEGORY LINKS
-- =============================================================================
-- Products can belong to multiple categories where it makes sense.

INSERT INTO product_categories (product_id, category_id) VALUES
  -- ── Protein Powders ──
  ('c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001'), -- Gold Standard Whey → Protein Powders
  ('c0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001'), -- Impact Whey → Protein Powders
  ('c0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001'), -- Nitro-Tech → Protein Powders
  ('c0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001'), -- ISO100 → Protein Powders
  ('c0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000001'), -- R1 Protein → Protein Powders
  ('c0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000001'), -- Syntha-6 Edge → Protein Powders
  ('c0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000001'), -- Proton Whey → Protein Powders
  ('c0000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000001'), -- Gold Standard Casein → Protein Powders
  ('c0000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000001'), -- Combat Whey → Protein Powders
  ('c0000000-0000-0000-0000-00000000000a', 'a0000000-0000-0000-0000-000000000001'), -- Plant Protein+ → Protein Powders
  ('c0000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000009'), -- Gold Standard Casein → Recovery (slow release)

  -- ── Creatine ──
  ('c0000000-0000-0000-0000-000000000101', 'a0000000-0000-0000-0000-000000000002'), -- ON Creatine → Creatine
  ('c0000000-0000-0000-0000-000000000102', 'a0000000-0000-0000-0000-000000000002'), -- Platinum Creatine → Creatine
  ('c0000000-0000-0000-0000-000000000103', 'a0000000-0000-0000-0000-000000000002'), -- Creatine HCl → Creatine
  ('c0000000-0000-0000-0000-000000000104', 'a0000000-0000-0000-0000-000000000002'), -- Cell-Tech → Creatine
  ('c0000000-0000-0000-0000-000000000105', 'a0000000-0000-0000-0000-000000000002'), -- Pure Creatine → Creatine
  ('c0000000-0000-0000-0000-000000000104', 'a0000000-0000-0000-0000-000000000008'), -- Cell-Tech → Energy & Endurance (carb+creatine)

  -- ── Pre-Workout ──
  ('c0000000-0000-0000-0000-000000000201', 'a0000000-0000-0000-0000-000000000003'), -- C4 → Pre-Workout
  ('c0000000-0000-0000-0000-000000000202', 'a0000000-0000-0000-0000-000000000003'), -- ON Pre → Pre-Workout
  ('c0000000-0000-0000-0000-000000000203', 'a0000000-0000-0000-0000-000000000003'), -- Total War → Pre-Workout
  ('c0000000-0000-0000-0000-000000000204', 'a0000000-0000-0000-0000-000000000003'), -- Beyond Raw LIT → Pre-Workout
  ('c0000000-0000-0000-0000-000000000205', 'a0000000-0000-0000-0000-000000000003'), -- Pre JYM → Pre-Workout
  ('c0000000-0000-0000-0000-000000000206', 'a0000000-0000-0000-0000-000000000003'), -- Vapor X5 → Pre-Workout
  ('c0000000-0000-0000-0000-000000000201', 'a0000000-0000-0000-0000-000000000008'), -- C4 → Energy & Endurance
  ('c0000000-0000-0000-0000-000000000203', 'a0000000-0000-0000-0000-000000000008'), -- Total War → Energy & Endurance

  -- ── BCAAs & Amino Acids ──
  ('c0000000-0000-0000-0000-000000000301', 'a0000000-0000-0000-0000-000000000004'), -- Xtend → BCAAs
  ('c0000000-0000-0000-0000-000000000302', 'a0000000-0000-0000-0000-000000000004'), -- BCAA 5000 → BCAAs
  ('c0000000-0000-0000-0000-000000000303', 'a0000000-0000-0000-0000-000000000004'), -- Amino X → BCAAs
  ('c0000000-0000-0000-0000-000000000304', 'a0000000-0000-0000-0000-000000000004'), -- Essential Amino 9 → BCAAs
  ('c0000000-0000-0000-0000-000000000305', 'a0000000-0000-0000-0000-000000000004'), -- Alpha Amino → BCAAs
  ('c0000000-0000-0000-0000-000000000301', 'a0000000-0000-0000-0000-000000000009'), -- Xtend → Recovery
  ('c0000000-0000-0000-0000-000000000303', 'a0000000-0000-0000-0000-000000000009'), -- Amino X → Recovery

  -- ── Vitamins & Minerals ──
  ('c0000000-0000-0000-0000-000000000401', 'a0000000-0000-0000-0000-000000000005'), -- Opti-Men → Vitamins
  ('c0000000-0000-0000-0000-000000000402', 'a0000000-0000-0000-0000-000000000005'), -- Opti-Women → Vitamins
  ('c0000000-0000-0000-0000-000000000403', 'a0000000-0000-0000-0000-000000000005'), -- Vitamin D3 → Vitamins
  ('c0000000-0000-0000-0000-000000000404', 'a0000000-0000-0000-0000-000000000005'), -- ZMA → Vitamins
  ('c0000000-0000-0000-0000-000000000405', 'a0000000-0000-0000-0000-000000000005'), -- Zinc → Vitamins
  ('c0000000-0000-0000-0000-000000000406', 'a0000000-0000-0000-0000-000000000005'), -- Magnesium → Vitamins
  ('c0000000-0000-0000-0000-000000000404', 'a0000000-0000-0000-0000-000000000009'), -- ZMA → Recovery

  -- ── Weight Gainers ──
  ('c0000000-0000-0000-0000-000000000501', 'a0000000-0000-0000-0000-000000000006'), -- Serious Mass → Weight Gainers
  ('c0000000-0000-0000-0000-000000000502', 'a0000000-0000-0000-0000-000000000006'), -- Mass-Tech → Weight Gainers
  ('c0000000-0000-0000-0000-000000000503', 'a0000000-0000-0000-0000-000000000006'), -- True Mass → Weight Gainers
  ('c0000000-0000-0000-0000-000000000504', 'a0000000-0000-0000-0000-000000000006'), -- Real Gains → Weight Gainers
  ('c0000000-0000-0000-0000-000000000501', 'a0000000-0000-0000-0000-000000000001'), -- Serious Mass → Protein Powders (50g protein)
  ('c0000000-0000-0000-0000-000000000502', 'a0000000-0000-0000-0000-000000000001'), -- Mass-Tech → Protein Powders (80g protein)

  -- ── Fat Burners ──
  ('c0000000-0000-0000-0000-000000000601', 'a0000000-0000-0000-0000-000000000007'), -- Hydroxycut → Fat Burners
  ('c0000000-0000-0000-0000-000000000602', 'a0000000-0000-0000-0000-000000000007'), -- L-Carnitine → Fat Burners
  ('c0000000-0000-0000-0000-000000000603', 'a0000000-0000-0000-0000-000000000007'), -- Super HD → Fat Burners
  ('c0000000-0000-0000-0000-000000000604', 'a0000000-0000-0000-0000-000000000007'), -- Trans4orm → Fat Burners
  ('c0000000-0000-0000-0000-000000000602', 'a0000000-0000-0000-0000-000000000008'), -- L-Carnitine → Energy & Endurance

  -- ── Energy & Endurance ──
  ('c0000000-0000-0000-0000-000000000701', 'a0000000-0000-0000-0000-000000000008'), -- Amino Energy → Energy & Endurance
  ('c0000000-0000-0000-0000-000000000702', 'a0000000-0000-0000-0000-000000000008'), -- Beta-Alanine → Energy & Endurance
  ('c0000000-0000-0000-0000-000000000703', 'a0000000-0000-0000-0000-000000000008'), -- Citrulline → Energy & Endurance
  ('c0000000-0000-0000-0000-000000000704', 'a0000000-0000-0000-0000-000000000008'), -- Hydra-Charge → Energy & Endurance
  ('c0000000-0000-0000-0000-000000000705', 'a0000000-0000-0000-0000-000000000008'), -- Peak ATP → Energy & Endurance
  ('c0000000-0000-0000-0000-000000000701', 'a0000000-0000-0000-0000-000000000004'), -- Amino Energy → BCAAs (has aminos)
  ('c0000000-0000-0000-0000-000000000702', 'a0000000-0000-0000-0000-000000000004'), -- Beta-Alanine → BCAAs (amino acid)

  -- ── Recovery & Joint Support ──
  ('c0000000-0000-0000-0000-000000000801', 'a0000000-0000-0000-0000-000000000009'), -- Glutamine → Recovery
  ('c0000000-0000-0000-0000-000000000802', 'a0000000-0000-0000-0000-000000000009'), -- Fish Oil → Recovery
  ('c0000000-0000-0000-0000-000000000803', 'a0000000-0000-0000-0000-000000000009'), -- Glucosamine → Recovery
  ('c0000000-0000-0000-0000-000000000804', 'a0000000-0000-0000-0000-000000000009'), -- Collagen → Recovery
  ('c0000000-0000-0000-0000-000000000805', 'a0000000-0000-0000-0000-000000000009'), -- Tart Cherry → Recovery
  ('c0000000-0000-0000-0000-000000000801', 'a0000000-0000-0000-0000-000000000004'), -- Glutamine → BCAAs (amino acid)
  ('c0000000-0000-0000-0000-000000000802', 'a0000000-0000-0000-0000-000000000005'), -- Fish Oil → Vitamins & Minerals

  -- ── Snacks & Bars ──
  ('c0000000-0000-0000-0000-000000000901', 'a0000000-0000-0000-0000-00000000000a'), -- Protein Crisp → Snacks & Bars
  ('c0000000-0000-0000-0000-000000000902', 'a0000000-0000-0000-0000-00000000000a'), -- ONE Bar → Snacks & Bars
  ('c0000000-0000-0000-0000-000000000903', 'a0000000-0000-0000-0000-00000000000a'), -- Quest Bar → Snacks & Bars
  ('c0000000-0000-0000-0000-000000000904', 'a0000000-0000-0000-0000-00000000000a'), -- Grenade → Snacks & Bars
  ('c0000000-0000-0000-0000-000000000905', 'a0000000-0000-0000-0000-00000000000a'), -- Protein Cookie → Snacks & Bars
  ('c0000000-0000-0000-0000-000000000901', 'a0000000-0000-0000-0000-000000000001'), -- Protein Crisp → Protein Powders (it's a protein product)
  ('c0000000-0000-0000-0000-000000000903', 'a0000000-0000-0000-0000-000000000001')  -- Quest Bar → Protein Powders
ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================================================
-- Verification queries (optional — run manually to check counts)
-- =============================================================================
-- SELECT 'categories' AS tbl, count(*) FROM categories
-- UNION ALL SELECT 'product_types', count(*) FROM product_types
-- UNION ALL SELECT 'products', count(*) FROM products
-- UNION ALL SELECT 'product_categories', count(*) FROM product_categories;
--
-- -- Products per category:
-- SELECT c.name, count(pc.product_id) AS products
-- FROM categories c
-- LEFT JOIN product_categories pc ON pc.category_id = c.id
-- GROUP BY c.name ORDER BY products DESC;
--
-- -- Featured products:
-- SELECT name, brand, price, rating FROM products WHERE is_featured = true;
--
-- -- Products on sale:
-- SELECT name, brand, price, sale_price FROM products WHERE sale_price IS NOT NULL;
