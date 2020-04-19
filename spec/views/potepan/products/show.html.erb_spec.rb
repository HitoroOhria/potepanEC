require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:taxon1)         { create(:taxon) }
  let(:taxon1_product) { taxon1.products.create(attributes_for(:product, shipping_category: 1)) }

  before do
    visit potepan_product_path(taxon1_product.id)
  end

  subject { page }

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
      let!(:taxon1_other_product1) { taxon1.products.create(attributes_for(:product, shipping_category: 1)) }
      let!(:taxon1_other_product2) { taxon1.products.create(attributes_for(:product, shipping_category: 1)) }

      context 'そのカテゴリーに所属する商品の個数が3個の場合' do
        it '関連商品には、自身の商品を表示しない' do
          should_not have_css('h5', text: taxon1_product.name)
        end

        it '関連商品に自身を除いた2個の商品を表示する' do
          should have_css('.productBox', count: taxon1.products.count)
        end
      end

      context 'そのカテゴリーに所属する商品の個数が6個の場合' do
        let!(:taxon1_other_product3) { taxon1.products.create(attributes_for(:product, shipping_category: 1)) }
        let!(:taxon1_other_product4) { taxon1.products.create(attributes_for(:product, shipping_category: 1)) }

        it '関連商品には、自身の商品を表示しない' do
          should_not have_css('h5', text: taxon1_product.name)
        end

        it '関連商品に、自身の商品を除いた4個を表示する' do
          should have_css('.productBox', count: 4)
        end
      end
    end

    context '商品の所属するカテゴリーが2つの時'do
      let!(:taxon1_other_product1) { taxon1.products.create(attributes_for(:product, shipping_category: 1)) }
      let(:taxon2) { taxon1_product.taxons.create(attribute_for(:taxon)) }
      let!(:taxon2_other_product1) { taxon2.products.create(attributes_for(:product, shipping_category: 1)) }
      let!(:taxon2_other_product2) { taxon2.products.create(attributes_for(:product, shipping_category: 1)) }


      context '２つのカテゴリーに所属する商品の合計個数が5個未満の場合' do
        it '関連商品に、2つのカテゴリーに所属する自身の商品以外の個数分、表示する' do

        end
      end

      context '2つのカテゴリーの商品の合計個数が5個以上の場合' do
        it '関連商品に、2つのカテゴリーに所属する自身の商品以外を4個表示する' do

        end
      end
    end

    context '商品の所属するカテゴリーが2つで、2つ目のカテゴリーが子カテゴリーを一つ持つ(ネストしている)時'do
      it '関連商品は、子カテゴリーの商品も含め、上限4個まで商品を表示する' do

      end
    end
  end
end
