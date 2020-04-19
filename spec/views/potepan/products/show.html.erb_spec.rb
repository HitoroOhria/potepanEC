require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:product) { create(:product) }
  before do
    product.taxons.create(attributes_for(:taxon))
    visit potepan_product_path(product.id)
  end

  describe 'GET potepan/products/:product_id' do
    it 'titleがfull_title(@product.name)と一致する' do
      expect(page.title).to eq full_title(product.name)
    end

    it 'bodyに@productのname属性が表示されている' do
      expect(page).to have_content product.name
    end

    it 'bodyに@productのprice属性が表示されている' do
      expect(page).to have_content product.price.round
    end

    it 'bodyに@productのdescription属性が表示されている' do
      expect(page).to have_content product.description
    end

    context '商品の所属するカテゴリーが1つの時'do
      context 'そのカテゴリーに所属する商品の個数が4個未満の場合' do
        it '関連商品に、そのカテゴリーに所属する商品を全て表示する' do

        end
      end

      context 'そのカテゴリーに所属する商品の個数が5個以上の場合' do
        it '関連商品に、そのカテゴリーに所属する商品を4個まで表示する' do

        end
      end
    end

    context '商品の所属するカテゴリーが2つの時'do
      context '２つのカテゴリーに所属する商品の合計個数が4個未満の場合' do
        it '関連商品に、2つのカテゴリーに所属する商品を全て表示する' do

        end
      end

      context '2つのカテゴリーの商品の合計個数が5個以上の場合' do
        it '関連商品に、2つのカテゴリーに所属する商品を4個まで表示する' do

        end
      end
    end

    context '商品の所属するカテゴリーが2つで、2つ目のカテゴリーが子カテゴリーを一つ持つ(ネストされている)時'do
      it '関連商品は、子カテゴリーの商品も含め、上限4個まで商品を表示する' do

      end
    end
  end
end
