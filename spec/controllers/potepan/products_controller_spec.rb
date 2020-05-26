require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe '#show' do
    let(:taxon)   { create(:taxon) }
    let(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

    subject { response }

    context 'レスポンス' do
      before do
        get :show, params: { product_id: product.id }
      end

      it { is_expected.to have_http_status 200 }

      it { is_expected.to render_template :show }
    end

    context '@product' do
      before do
        get :show, params: { product_id: product.id }
      end

      it 'id属性がparams[:product_id]に対応したSpree::Productモデルオブジェクトである' do
        expect(assigns(:product)).to eq product
      end
    end

    context '@relation_products' do
      context '関連商品のランダム性' do
        let!(:taxon)   { create(:taxon) }
        let!(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

        let(:first_relation_products) { assigns(:relation_products) }
        let(:second_relation_products) { assigns(:relation_products) }

        before do
          4.times { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }
          get :show, params: { product_id: product.id }
          first_relation_products
          get :show, params: { product_id: product.id }
          second_relation_products
        end

        subject(:relation_products) { assigns(:relation_products) }

        it '関連商品の中から取得する商品はランダムであること' do
          expect(first_relation_products).to_not eq second_relation_products
        end
      end

      context '関連商品の表示内容' do
        let!(:taxon)   { create(:taxon) }
        let!(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

        subject(:relation_products) { assigns(:relation_products) }

        context 'Spree::Productの合計個数が1個の時' do
          before do
            get :show, params: { product_id: product.id }
          end

          it '@relation_productsは空である' do
            is_expected.to be_empty
          end
        end

        context 'Spree::Productの合計個数が4個の時' do
          before do
            3.times { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }
            get :show, params: { product_id: product.id }
          end

          it '@relation_productsは@productを含んでいないこと' do
            is_expected.to_not include(assigns(:product))
          end

          it '@relation_productsの商品は重複していないこと' do
            is_expected.to eq relation_products.uniq
          end

          it '@relation_productsの個数は3である' do
            expect(relation_products.size).to eq 3
          end
        end

        context 'Spree::Productの合計個数が5個の時' do
          before do
            4.times { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }
            get :show, params: { product_id: product.id }
          end

          it '@relation_productsは@productを含んでいないこと' do
            is_expected.to_not include(assigns(:product))
          end

          it '@relation_productsの商品は重複していないこと' do
            is_expected.to eq relation_products.uniq
          end

          it '@relation_productsの個数は4である' do
            expect(relation_products.size).to eq 4
          end
        end

        context 'Spree::Productの合計個数が6個の時' do
          before do
            5.times { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }
            get :show, params: { product_id: product.id }
          end

          it '@relation_productsは@productを含んでいないこと' do
            is_expected.to_not include(assigns(:product))
          end

          it '@relation_productsの商品は重複していないこと' do
            is_expected.to eq relation_products.uniq
          end

          it '@relation_productsの個数は4である' do
            expect(relation_products.size).to eq 4
          end
        end
      end

      context '関連商品の対象' do
        let!(:taxon) { create(:taxon) }
        let!(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

        subject(:relation_products) { assigns(:relation_products) }

        context '@productが所属しているTaxonが0個の時' do
          let(:first_relation_products) { assigns(:relation_products) }
          let(:second_relation_products) { assigns(:relation_products) }

          before do
            product.taxons.delete_all
            4.times { create(:product) }
            get :show, params: { product_id: product.id }
            first_relation_products
            get :show, params: { product_id: product.id }
            second_relation_products
          end

          it '@relation_productsはランダムな商品である' do
            expect(first_relation_products.map(&:id)).to_not eq second_relation_products.map(&:id)
          end
        end

        context '@productが所属しているTaxonが1個の時' do
          let(:product_attributes1)  { attributes_for(:product, shipping_category_id: 1) }
          let(:product_attributes2)  { attributes_for(:product, shipping_category_id: 1) }
          let(:product_attributes3)  { attributes_for(:product, shipping_category_id: 1) }
          let(:product_attributes4)  { attributes_for(:product, shipping_category_id: 1) }
          let(:product_attributes5)  { attributes_for(:product, shipping_category_id: 1) }

          context 'Taxonが親ノードの時' do
            let!(:child_taxon)          { taxon.children.create(attributes_for(:taxon)) }
            let!(:other_taxon)          { create(:taxon) }
            let!(:taxon_other_product1) { taxon.products.create(product_attributes1) }
            let!(:taxon_other_product2) { taxon.products.create(product_attributes2) }
            let!(:child_taxon_product1) { child_taxon.products.create(product_attributes3) }
            let!(:child_taxon_product2) { child_taxon.products.create(product_attributes4) }
            let!(:other_taxon_product)  { other_taxon.products.create(product_attributes5) }

            before do
              2.times { create(:product) }
              get :show, params: { product_id: product.id }
            end

            it '親ノードとその子孫ノードに属する商品であること' do
              is_expected.to_not include other_taxon_product
              is_expected.to     include taxon_other_product1
              is_expected.to     include taxon_other_product2
              is_expected.to     include child_taxon_product1
              is_expected.to     include child_taxon_product2
            end
          end
        end
      end
    end
  end
end
