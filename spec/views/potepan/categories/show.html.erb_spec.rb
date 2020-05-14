require 'rails_helper'

RSpec.describe "potepan/categories/show.html.erb", type: :view do
  let!(:taxonomy)    { create(:taxonomy) }
  let!(:taxon_root)  { taxonomy.root }
  let!(:taxon_child) {
    taxon_root.children.create(attributes_for(:taxon, taxonomy_id: taxonomy.id))
  }
  let!(:product_by_taxon_root) {
    taxon_root.products.create(attributes_for(:product, shipping_category_id: 1))
  }
  let!(:product_by_taxon_child) {
    taxon_child.products.create(attributes_for(:product, shipping_category_id: 1))
  }

  let!(:option_type_size)       { create(:option_type,  name: 'tshirt-size') }
  let!(:option_type_color)      { create(:option_type,  name: 'tshirt-color') }
  let!(:size_option_value)      { create(:option_value, option_type: option_type_size) }
  let!(:color_option_value)     { create(:option_value, option_type: option_type_color) }

  before do
    visit potepan_category_path(taxon_root.id)
  end

  subject { page }

  feature 'GET potepan/categories/:taxon_id' do
    it { should have_title full_title(taxon_root.name) }

    context 'カテゴリーパネルの「商品カテゴリー」のレイアウト' do
      it { should have_css('.panel-heading', text: '商品カテゴリー') }
      it { should have_css('a',              text: taxon_root.taxonomy.name, visible: false) }
      it {
        should have_css('a', text: taxon_root.name, visible: false)
        should have_css('a', text: taxon_child.name, visible: false)
      }
    end

    context 'カテゴリーパネルの「色から探す」のレイアウト' do
      it { should have_css('.panel-heading',  text: '色から探す') }
      it { should have_css('a',               text: color_option_value.name) }
    end

    context 'カテゴリーパネルの「サイズから探す」のレイアウト' do
      it { should have_css('.panel-heading',  text: 'サイズから探す') }
      it { should have_css('a',               text: size_option_value.name) }
    end

    context 'プロダクト一覧表示のレイアウト' do
      context 'ルーティングの:taxon_idのモデルオブジェクトが親ノードの時' do
        let(:taxonomy_products_count) {
          taxonomy.taxons.inject(0) { |product_counter, taxon| product_counter + taxon.products.count }
        }

        it { should have_css('.productBox', count: taxonomy_products_count) }
        it {
          should have_link(product_by_taxon_root.name,
                           href: potepan_product_path(product_by_taxon_root.id))
          should have_link(product_by_taxon_child.name,
                           href: potepan_product_path(product_by_taxon_child.id))
        }
        it {
          should have_css('h3', text: product_price(product_by_taxon_root))
          should have_css('h3', text: product_price(product_by_taxon_child))
        }
      end

      context 'ルーティングの:taxon_idのモデルオブジェクトが葉ノードの時' do
        before do
          visit potepan_category_path(taxon_child.id)
        end

        it { should have_css('.productBox', count: taxon_child.products.count) }
        it {
          should have_link(product_by_taxon_child.name,
                           href: potepan_product_path(product_by_taxon_child.id))
        }
        it { should have_css('h3', text: product_price(product_by_taxon_child)) }
      end
    end
  end
end
