require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:product) { FactoryBot.create(:spree_product) }
  before do
    visit potepan_product_path(product.id)
  end

  describe 'products/show.html.erbを表示' do
    it 'titleがfull_title(@product.name)と一致する' do
      expect(page.title).to eq full_title(product.name)
    end

    it 'bodyに@productのname属性が表示されている' do
      expect(page).to have_content product.name
    end

    it 'bodyに@productのprice属性が表示されている' do
      expect(page).to have_content product.price.round
    end

    it 'bodyに@productのdescription属性が表示されている' do
      expect(page).to have_content product.description
    end
  end
end
