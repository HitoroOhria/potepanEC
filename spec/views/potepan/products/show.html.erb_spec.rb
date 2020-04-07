require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:product) { FactoryBot.create(:spree_product) }
  before '/potepan/products/1にGETリクエストを送付' do
    visit potepan_product_path(product.id)
  end

  describe 'products/show.html.erbを表示' do
    it 'タイトルに@productのname属性が表示されている' do
      expect(page).to have_title "#{product.name} | BIGBAG store"
    end

    it 'ボディに@productのname属性が表示されている' do
      expect(page).to have_content product.name
    end

    it 'ボディに@productのprice属性が表示されている' do
      expect(page).to have_content product.price.round
    end

    it 'ボディに@productのdescription属性が表示されている' do
      expect(page).to have_content product.description
    end
  end
end
