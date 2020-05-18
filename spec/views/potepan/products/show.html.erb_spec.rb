require 'rails_helper'

RSpec.describe "products/show.html.erb", type: :view do
  let(:viewable_type) { [:viewable_type, 'Spree::Variant'] }

  let!(:product)         { create(:product) }
  let!(:product_variant) { product.master }
  let!(:product_image1)  { create(:image, [[:viewable_id, product_variant.id], viewable_type].to_h) }
  let!(:product_image2)  { create(:image, [[:viewable_id, product_variant.id], viewable_type].to_h) }

  before do
    product.taxons.create(attributes_for(:taxon))
    visit potepan_product_path(product.id)
  end

  subject { page }

  feature 'GET potepan/products/:product_id' do
    it { is_expected.to have_title(full_title(product.name)) }

    it { is_expected.to have_css('h2', text: product.name) }

    it { is_expected.to have_css('h3', text: product_price(product)) }

    it { is_expected.to have_css('p',  text: product.description) }

    it { is_expected.to have_css('img', id: "large_image_#{product_image1.id}") }

    it { is_expected.to have_css('img', id: "large_image_#{product_image2.id}") }

    it { is_expected.to have_css('img', id: "small_image_#{product_image1.id}") }

    it { is_expected.to have_css('img', id: "small_image_#{product_image2.id}") }
  end
end
