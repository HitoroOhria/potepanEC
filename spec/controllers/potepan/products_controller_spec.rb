require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  let!(:product) { FactoryBot.create(:spree_product) }

  it '#show' do
    get :show, params: { id: product.id }
    expect(response).to render_template :show
    expect(assigns(:product)).to eq product
    expect(response).to be_success
  end
end
