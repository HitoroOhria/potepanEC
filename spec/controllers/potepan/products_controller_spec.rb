require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  let(:taxon)   { create(:taxon) }
  let(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

  before do
    get :show, params: { product_id: product.id }
  end

  subject { response }

  describe '#show' do
    it { is_expected.to have_http_status 200 }

    it { is_expected.to render_template :show }

    it '@product変数は、id属性がparams[:product_id]に対応したSpree::Productモデルオブジェクトである' do
      expect(assigns(:product)).to eq product
    end
  end
end
