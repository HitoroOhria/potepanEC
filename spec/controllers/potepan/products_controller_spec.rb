require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  let(:product) { FactoryBot.create(:spree_product) }
  before 'showアクションを起動' do
    get :show, params: { id: product.id }
  end

  describe '#show' do
    it '@product変数はSpree::Productクラスのインスタンス変数である' do
      expect(assigns(:product)).to eq product
    end

    it 'products/show.html.erbがレンダリングされる' do
      expect(response).to render_template :show
    end

    it 'ビューのレンダリングに成功する' do
      expect(response).to be_successful
    end
  end
end
