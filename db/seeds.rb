Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

# Producutを作成する
Spree::Product.create!(name: 'rails tote',
                       slug: 'railstote',
                       price: 9800,
                       description: "Railsロゴ入りのトートバックです。装備すると、プログラミング力が＋３上がります。Railsチュートリアルを抜けた先のお店に並んでいます。",
                       shipping_category_id: 1)

# OprionTypeとOptionValueを作成する
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