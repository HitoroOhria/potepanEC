require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe '#show' do
    let(:taxon)   { create(:taxon) }
    let(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

    before do
      get :show, params: { product_id: product.id }
    end

    subject { response }

    describe 'レスポンス' do
      it { is_expected.to have_http_status 200 }

      it { is_expected.to render_template :show }
    end

    describe '@product' do
      it 'id属性がparams[:product_id]に対応したSpree::Productモデルオブジェクトである' do
        expect(assigns(:product)).to eq product
      end
    end

    describe '@relation_products' do
      context '@productが所属しているカテゴリーがないとき' do
        let!(:taxon)   { create(:taxon) }
        let!(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

        before do
          product.taxons.delete_all
          get :show, params: { product_id: product.id }
        end

        subject(:relation_products) { assigns(:relation_products) }

        it '@relation_productsは空である' do
          is_expected.to be_empty
        end
      end

      context '@productが所属しているカテゴリーがあるとき' do
        let(:product_attributes1)  { attributes_for(:product, shipping_category_id: 1) }
        let(:product_attributes2)  { attributes_for(:product, shipping_category_id: 1) }
        let(:product_attributes3)  { attributes_for(:product, shipping_category_id: 1) }
        let(:product_attributes4)  { attributes_for(:product, shipping_category_id: 1) }
        let(:product_attributes5)  { attributes_for(:product, shipping_category_id: 1) }

        context 'カテゴリーが親ノードの時' do
          let!(:parent_taxon)          { create(:taxon) }
          let!(:child_taxon)           { parent_taxon.children.create(attributes_for(:taxon)) }
          let!(:parent_taxon_product1) { parent_taxon.products.create(product_attributes1) }
          let!(:parent_taxon_product2) { parent_taxon.products.create(product_attributes2) }
          let!(:child_taxon_product)   { child_taxon.products.create(product_attributes3) }
          let!(:another_taxon_product) { create(:product) }

          before do
            get :show, params: { product_id: parent_taxon_product1.id }
          end

          subject(:relation_products) { assigns(:relation_products) }

          it '@relation_productsの商品は重複していないこと' do
            is_expected.to eq relation_products.uniq
          end

          it '@relation_productsは@productを含んでいないこと' do
            is_expected.to_not include parent_taxon_product1
          end

          it '@relation_productsの商品は他のノードの商品を含んでいないこと' do
            is_expected.to_not include another_taxon_product
          end

          it '@relation_productsの商品は親ノードの商品を含んでいること' do
            is_expected.to include parent_taxon_product2
          end

          it '@relation_productsの商品は子ノードの商品を含んでいること' do
            is_expected.to include child_taxon_product
          end
        end

        context 'カテゴリーが中間ノードの時' do
          let!(:parent_taxon)          { create(:taxon) }
          let!(:middle_taxon)          { parent_taxon.children.create(attributes_for(:taxon)) }
          let!(:leaf_taxon)            { middle_taxon.children.create(attributes_for(:taxon)) }
          let!(:parent_taxon_product)  { parent_taxon.products.create(product_attributes1) }
          let!(:middle_taxon_product1) { middle_taxon.products.create(product_attributes2) }
          let!(:middle_taxon_product2) { middle_taxon.products.create(product_attributes3) }
          let!(:leaf_taxon_product)    { leaf_taxon.products.create(product_attributes4) }

          before do
            get :show, params: { product_id: middle_taxon_product1.id }
          end

          subject(:relation_products) { assigns(:relation_products) }

          it '@relation_productsの商品は重複していないこと' do
            is_expected.to eq relation_products.uniq
          end

          it '@relation_productsは@productを含んでいないこと' do
            is_expected.to_not include middle_taxon_product1
          end

          it '@relation_productsの商品は親ノードの商品を含んでいないこと' do
            is_expected.to_not include parent_taxon_product
          end

          it '@relation_productsの商品は中間ノードの商品を含んでいること' do
            is_expected.to include middle_taxon_product2
          end

          it '@relation_productsの商品は葉ノードの商品を含んでいること' do
            is_expected.to include leaf_taxon_product
          end
        end

        context 'カテゴリーが葉ノードの時' do
          let!(:parent_taxon)         { create(:taxon) }
          let!(:child_taxon)          { parent_taxon.children.create(attributes_for(:taxon)) }
          let!(:parent_taxon_product) { parent_taxon.products.create(product_attributes1) }
          let!(:child_taxon_product1) { child_taxon.products.create(product_attributes2) }
          let!(:child_taxon_product2) { child_taxon.products.create(product_attributes3) }

          before do
            get :show, params: { product_id: child_taxon_product1.id }
          end

          subject(:relation_products) { assigns(:relation_products) }

          it '@relation_productsの商品は重複していないこと' do
            is_expected.to eq relation_products.uniq
          end

          it '@relation_productsは@productを含んでいないこと' do
            is_expected.to_not include child_taxon_product1
          end

          it '@relation_productsの商品は親ノードの商品を含んでいないこと' do
            is_expected.to_not include parent_taxon_product
          end

          it '@relation_productsの商品は葉ノードの商品を含んでいること' do
            is_expected.to include child_taxon_product2
          end
        end
      end
    end
  end
end
