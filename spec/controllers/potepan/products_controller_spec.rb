require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe '#show' do
    let(:taxon)   { create(:taxon) }
    let(:product) { create(:product, taxon_ids: taxon.id) }

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
      before do
        create_list(:product, 5, taxon_ids: taxon.id)
        get :show, params: { product_id: product.id }
      end

      it '商品の個数は4であること' do
        expect(assigns(:relation_products).count).to eq 4
      end
    end
  end
end
