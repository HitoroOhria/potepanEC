require 'rails_helper'

RSpec.describe "Potepan::Products#show layout", type: :feature do
  let!(:product)         { create(:product) }
  let!(:variant)         { product.master }
  let!(:product_image1)  { create(:image, viewable: variant) }
  let!(:product_image2)  { create(:image, viewable: variant) }

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

    it { is_expected.to have_css("img#large_image_#{product_image1.id}") }

    it { is_expected.to have_css("img#large_image_#{product_image2.id}") }

    it { is_expected.to have_css("img#small_image_#{product_image1.id}") }

    it { is_expected.to have_css("img#small_image_#{product_image2.id}") }

    it { is_expected.to have_link('一覧ページへ戻る', href: product_to_category_path(product)) }
  end
end
