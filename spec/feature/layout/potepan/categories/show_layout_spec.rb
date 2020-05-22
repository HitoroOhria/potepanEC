require 'rails_helper'

RSpec.describe "Potepan::Categories#show layout", type: :feature do
  let(:taxon_attr) { attributes_for(:taxon, name: 'Bag', taxonomy_id: taxonomy.id) }

  let!(:taxonomy)    { create(:taxonomy, name: 'Category') }
  let!(:taxon_root)  { taxonomy.root }
  let!(:taxon_child) { taxon_root.children.create(taxon_attr) }

  let!(:option_type_size)   { create(:option_type,  name: 'tshirt-size') }
  let!(:option_type_color)  { create(:option_type,  name: 'tshirt-color') }
  let!(:option_value_size)  { create(:option_value, option_type: option_type_size) }
  let!(:option_value_color) { create(:option_value, option_type: option_type_color) }

  before do
    visit potepan_category_path(taxon_root.id)
  end

  subject { page }

  feature 'GET potepan/categories/:taxon_id' do
    it { is_expected.to have_title full_title(taxon_root.name) }

    context 'カテゴリーパネルの「商品カテゴリー」のレイアウト' do
      it { is_expected.to have_css('.panel-heading', text: '商品カテゴリー') }

      context 'collapseのレイアウト' do
        it { is_expected.to have_link(taxonomy.name) }

        it { is_expected.to_not have_link(taxon_child.name, visible: true) }

        context 'collapseのリンクをクリックしたとき' do
        before do
          visit potepan_category_path(taxon_root.id)
          click_link taxonomy.name
        end

        it { is_expected.to have_link("#{taxon_child.name} (#{taxon_child.products.count})") }
        end
      end
    end

    context 'カテゴリーパネルの「色から探す」のレイアウト' do
      it { is_expected.to have_css('.panel-heading', text: '色から探す') }

      it { is_expected.to have_link("#{option_value_color.name} (#{option_type_color.products.count})") }

      it { is_expected.to have_css('span' , text: "(#{option_type_color.products.count})") }
    end

    context 'カテゴリーパネルの「サイズから探す」のレイアウト' do
      it { is_expected.to have_css('.panel-heading', text: 'サイズから探す') }

      it { is_expected.to have_link(option_value_size.name) }

      it { is_expected.to have_css('span' , text: "(#{option_type_size.products.count})") }
    end

    context 'プロダクト一覧表示のレイアウト' do
      let(:product_attributes_1) { attributes_for(:product, name: 'Product1', shipping_category_id: 1) }
      let(:product_attributes_2) { attributes_for(:product, name: 'Product2', shipping_category_id: 1) }
      let(:root_product_path)    { potepan_product_path(taxon_root_product.id) }
      let(:child_product_path)   { potepan_product_path(taxon_child_product.id) }

      let!(:taxon_root_product)  { taxon_root.products.create(product_attributes_1) }
      let!(:taxon_child_product) { taxon_child.products.create(product_attributes_2) }
      let!(:root_product_image)  { create(:image, viewable: taxon_root_product.master) }
      let!(:child_product_image) { create(:image, viewable: taxon_child_product.master) }

      subject { page }

      context 'ルーティングの:taxon_idのモデルオブジェクトが親ノードの時' do
        before do
          visit potepan_category_path(taxon_root.id)
        end

        it { is_expected.to have_css('.productBox', count: 2) }

        it { is_expected.to have_css('img', id: "product_image_#{root_product_image.id}") }

        it { is_expected.to have_css('img', id: "product_image_#{child_product_image.id}") }

        it { is_expected.to have_css('h5', text: taxon_root_product.name) }

        it { is_expected.to have_css('h5', text: taxon_child_product.name) }

        it { is_expected.to have_css('h3', text: product_price(taxon_root_product)) }

        it { is_expected.to have_css('h3', text: product_price(taxon_child_product)) }

        it { is_expected.to have_link(taxon_root_product.name, href: root_product_path) }

        it { is_expected.to have_link(taxon_child_product.name, href: child_product_path) }

        it { is_expected.to have_link(product_price(taxon_root_product), href: root_product_path) }

        it { is_expected.to have_link(product_price(taxon_child_product), href: child_product_path) }
      end

      context 'ルーティングの:taxon_idのモデルオブジェクトが葉ノードの時' do
        before do
          visit potepan_category_path(taxon_child.id)
        end

        it { is_expected.to have_css('.productBox', count: 1) }

        it { is_expected.to have_css('img', id: "product_image_#{child_product_image.id}") }

        it { is_expected.to have_css('h5', text: taxon_child_product.name) }

        it { is_expected.to have_css('h3', text: product_price(taxon_child_product)) }

        it { is_expected.to have_link(taxon_child_product.name, href: child_product_path) }

        it { is_expected.to have_link(product_price(taxon_child_product), href: child_product_path) }
      end
    end
  end
end
