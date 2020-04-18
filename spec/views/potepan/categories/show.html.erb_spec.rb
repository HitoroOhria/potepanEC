require 'rails_helper'

RSpec.describe "potepan/categories/show.html.erb", type: :view do
  let(:taxonomy)  { create(:taxonomy) }
  let(:taxon1)    { taxonomy.root }
  let(:taxon2)    { taxon1.children.create(attributes_for(:taxon, taxonomy_id: taxonomy.id)) }
  let!(:product1) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }
  let!(:product2) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }
  let!(:option_type_size)   { create(:option_type,  name: 'tshirt-size') }
  let!(:option_type_color)  { create(:option_type,  name: 'tshirt-color') }
  let!(:size_option_value)  { create(:option_value, option_type: option_type_size) }
  let!(:color_option_value) { create(:option_value, option_type: option_type_color) }

  before do
    visit potepan_category_path(taxon1.id)
  end

  subject { page }

  feature 'GET potepan/categories/:taxon_id' do
    it { should have_title full_title(taxon1.name) }

    context 'カテゴリーパネルの「商品カテゴリー」のレイアウトは、' do
      it { should have_css('.panel-heading', text: '商品カテゴリー') }
      it { should have_css('a',              text: taxon1.taxonomy.name, visible: false) }
      it {
        should have_css('a', text: taxon1.name, visible: false)
        should have_css('a', text: taxon2.name, visible: false)
      }
    end

    context 'カテゴリーパネルの「色から探す」のレイアウトは' do
      it { should have_css('.panel-heading',  text: '色から探す') }
      it { should have_css('a',               text: color_option_value.name) }
    end

    context 'カテゴリーパネルの「サイズから探す」のレイアウトは' do
      it { should have_css('.panel-heading',  text: 'サイズから探す') }
      it { should have_css('a',               text: size_option_value.name) }
    end

    context 'プロダクト一覧表示のレイアウトは' do
      context 'ルーティングの:taxon_idのモデルオブジェクトが親ノードの時' do
        let(:taxonomy_products_count) {
          taxonomy.taxons.inject(0) { |product_counter, taxon| product_counter + taxon.products.count }
        }

        it { should have_css('.productBox', count: taxonomy_products_count) }
        it {
          should have_link(product1.name, href: potepan_product_path(product1.id))
          should have_link(product2.name, href: potepan_product_path(product2.id))
        }
        it {
          should have_css('h3', text: "#{product1.price.round}円")
          should have_css('h3', text: "#{product2.price.round}円")
        }
      end

      context 'ルーティングの:taxon_idのモデルオブジェクトが葉ノードの時' do
        before do
          visit potepan_category_path(taxon2.id)
        end

        it { should have_css('.productBox', count: taxon2.products.count) }
        it { should have_link(product2.name, href: potepan_product_path(product2.id)) }
        it { should have_css('h3', text: "#{product2.price.round}円") }
      end
    end
  end
end
