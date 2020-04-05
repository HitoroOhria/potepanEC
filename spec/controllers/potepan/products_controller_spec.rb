require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  let!(:product) { FactoryBot.create(:spree_product) }

  it '#show' do
    get :show, params: { id: product.id }
    expect(response).to be_success
    expect(response).to have_http_status 200
  end
end
