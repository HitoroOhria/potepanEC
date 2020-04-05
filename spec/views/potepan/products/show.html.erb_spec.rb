require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:product) { FactoryBot.create(:spree_product) }

  it '正常なビューを返す' do
    visit potepan_product_path(product.id)

    expect(page).to have_title "#{product.name} | BIGBAG store"
    expect(page).to have_content product.name
    expect(page).to have_content product.price.round
    expect(page).to have_content product.description
  end
end
