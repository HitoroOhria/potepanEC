# Taxonomyを作成する
categories = Spree::Taxonomy.create!(name: 'Categories')
brand = Spree::Taxonomy.create!(name: 'Brand')

# Taxonを作成する
categories_taxons = [ 'Bags', 'Mags', 'Shirts', 'T-Shirts' ]
categories_taxons.each { |taxon| categories.taxons.create!(name: taxon) }
brand_taxons = [ 'Ruby', 'Nginx', 'Rials', 'Unicorn' ]
brand_taxons.each { |taxon| brand.taxons.create!(name: taxon) }

# OptionTypeとOptionValueを作成する
color = Spree::OptionType.create!(name: 'color',   presentation: 'color variant' )
color.option_values.create!(name: 'ブラック', presentation: '漆黒')
color.option_values.create!(name: 'ホワイト', presentation: '純白')
color.option_values.create!(name: 'レッド',   presentation: '業火')
color.option_values.create!(name: 'ブルー',   presentation: '群青')

size = Spree::OptionType.create!(name: 'size', presentation: 'size varinat' )
size.option_values.create!(name: 'S',    presentation: 'スモール')
size.option_values.create!(name: 'M',    presentation: 'ミディアム')
size.option_values.create!(name: 'L',    presentation: 'ラージ')
size.option_values.create!(name: 'XL',   presentation: 'デカイラージ')

# Taxonと関連したProductを作成し、Variantを作成する
Spree::Taxon.all.each do |taxon|
  rand(1..5).times do
    product = taxon.products.create!(name: Faker::Food.fruits,
                          slug: Faker::Lorem.words(number: 4),
                          price: rand(1..2000),
                          description: Faker::Lorem.sentence,
                          shipping_category_id: 1)
    rand(1..3).times do
      product.variants.create!(weight: rand(1..500) , height: rand(1..500), width: rand(1..500), depth: rand(1..500))
      product.variants.each do |variant|
        option_values_variant = variant.option_values_variants.create!
        option_values_variant.update_attribute(:option_value_id, rand(1..Spree::OptionValue.count))
      end
    end
  end
end

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
