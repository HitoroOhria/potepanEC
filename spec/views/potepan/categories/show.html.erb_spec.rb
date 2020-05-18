require 'rails_helper'

RSpec.describe "potepan/categories/show.html.erb", type: :view do
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

      it { is_expected.to have_css('a', text: taxon_root.taxonomy.name, visible: false) }

      it { is_expected.to have_css('a', text: taxon_root.name,  visible: false) }

      it { is_expected.to have_css('a', text: taxon_child.name, visible: false) }
    end

    context 'カテゴリーパネルの「色から探す」のレイアウト' do
      it { is_expected.to have_css('.panel-heading', text: '色から探す') }

      it { is_expected.to have_css('a', text: option_value_color.name) }
    end

    context 'カテゴリーパネルの「サイズから探す」のレイアウト' do
      it { is_expected.to have_css('.panel-heading', text: 'サイズから探す') }

      it { is_expected.to have_css('a', text: option_value_size.name) }
    end

    context 'プロダクト一覧表示のレイアウト' do
      let(:root_product_path) { potepan_product_path(taxon_root_product.id) }
      let(:child_product_path) { potepan_product_path(taxon_child_product.id) }

      let!(:taxon_root_product)  {
        taxon_root.products.create(attributes_for(:product, shipping_category_id: 1))
      }
      let!(:taxon_child_product) {
        taxon_child.products.create(attributes_for(:product, shipping_category_id: 1))
      }
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
