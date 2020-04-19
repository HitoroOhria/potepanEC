require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:taxon1)         { create(:taxon) }
  let(:taxon1_product) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }

  before { visit potepan_product_path(taxon1_product.id) }

  subject { page }

  describe 'GET potepan/products/:product_id' do
    it 'titleがfull_title(@product.name)と一致する' do
      expect(page.title).to eq full_title(taxon1_product.name)
    end

    it 'bodyに@productのname属性が表示されている' do
      expect(page).to have_content taxon1_product.name
    end

    it 'bodyに@productのprice属性が表示されている' do
      expect(page).to have_content taxon1_product.price.round
    end

    it 'bodyに@productのdescription属性が表示されている' do
      expect(page).to have_content taxon1_product.description
    end

    context '商品の所属するカテゴリーが1つの時'do
      let!(:taxon1_other_product1) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }
      let!(:taxon1_other_product2) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }

      before { visit potepan_product_path(taxon1_product.id) }

      context 'そのカテゴリーに所属する商品の個数が3個の場合' do
        it '関連商品は、自身の商品を表示しない' do
          should_not have_css('h5', text: taxon1_product.name)
        end

        it '関連商品は、自身を除いた2個の商品を表示する' do
          should have_css('.productBox', text: taxon1_other_product1.name)
          should have_css('.productBox', text: taxon1_other_product2.name)
        end
      end

      context 'そのカテゴリーに所属する商品の個数が5個の場合' do
        let!(:taxon1_other_product3) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }
        let!(:taxon1_other_product4) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }

        before { visit potepan_product_path(taxon1_product.id) }

        it '関連商品は、自身の商品を表示しない' do
          should_not have_css('h5', text: taxon1_product.name)
        end

        it '関連商品は、自身の商品を除いた4個を表示する' do
          should have_css('.productBox', text: taxon1_other_product1.name)
          should have_css('.productBox', text: taxon1_other_product2.name)
          should have_css('.productBox', text: taxon1_other_product3.name)
          should have_css('.productBox', text: taxon1_other_product4.name)
        end
      end
    end

    context '商品の所属するカテゴリーが2つの時'do
      let!(:taxon2) { taxon1_product.taxons.create(attributes_for(:taxon)) }
      let!(:taxon1_other_product1) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }
      let!(:taxon2_other_product2) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }

      before { visit potepan_product_path(taxon1_product.id) }

      context '2つのカテゴリーに所属する商品の合計個数が3個の場合' do
        it '関連商品は、自身の商品を表示しない' do
          should_not have_css('h5', text: taxon1_product.name)
        end

        it '関連商品は、自身を除いた2個の商品を表示する' do
          should have_css('.productBox', text: taxon1_other_product1.name)
          should have_css('.productBox', text: taxon2_other_product2.name)
        end
      end

      context '2つのカテゴリーに所属する商品の合計個数が5個の場合' do
        let!(:taxon2_other_product3) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }
        let!(:taxon2_other_product4) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }

        before { visit potepan_product_path(taxon1_product.id) }

        it '関連商品は、自身の商品を表示しない' do
          should_not have_css('h5', text: taxon1_product.name)
        end

        it '関連商品は、自身の商品を除いた4個を表示する' do
          should have_css('.productBox', text: taxon1_other_product1.name)
          should have_css('.productBox', text: taxon2_other_product2.name)
          should have_css('.productBox', text: taxon2_other_product3.name)
          should have_css('.productBox', text: taxon2_other_product4.name)
        end
      end
    end

    context '商品の所属するカテゴリーが2つで、2つ目のカテゴリーが子カテゴリーを一つ持つ(ネストしている)時'do
      context '3つのカテゴリーの商品の合計個数が4個の場合' do
        let!(:taxon2) { taxon1_product.taxons.create(attributes_for(:taxon, taxonomy_id: taxon1.taxonomy.id)) }
        let!(:taxon3) { taxon2.children.create(attributes_for(:taxon, taxonomy_id: taxon2.taxonomy.id)) }
        let!(:taxon1_other_product1) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }
        let!(:taxon2_other_product2) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }
        let!(:taxon3_other_product3) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }

        before { visit potepan_product_path(taxon1_product.id) }

        it '関連商品は、自身の商品を表示しない' do
          should_not have_css('h5', text: taxon1_product.name)
        end

        it '関連商品は、子カテゴリーの商品も含め、3個の商品を表示する' do
          should have_css('.productBox', text: taxon1_other_product1.name)
          should have_css('.productBox', text: taxon2_other_product2.name)
          should have_css('.productBox', text: taxon3_other_product3.name)
        end
      end
    end
  end
end
