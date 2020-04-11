require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  let(:product) { create(:product) }
  before do
    get :show, params: { id: product.id }
  end

  describe '#show' do
    it '@product変数は、id属性がparams[:id]に対応したSpree::Productモデルオブジェクトである' do
      expect(assigns(:product)).to eq Spree::Product.find(product.id)
    end

    it 'HTTPレスポンスステータスコードが200である' do
      expect(response).to have_http_status(200)
    end

    it 'レスポンスののテンプレートがproducts/show.html.erbである' do
      expect(response).to render_template :show
    end
  end
end
