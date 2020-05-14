require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:product)               { create(:product) }

  before do
    product.taxons.create(attributes_for(:taxon))
    visit potepan_product_path(product.id)
  end

  subject { page }

  describe 'GET potepan/products/:product_id' do
    it { is_expected.to have_title(full_title(product.name)) }

    it { is_expected.to have_css('h2', text: product.name) }

    it { is_expected.to have_css('h3', text: product_price(product)) }

    it { is_expected.to have_css('p',  text: product.description) }
  end
end
