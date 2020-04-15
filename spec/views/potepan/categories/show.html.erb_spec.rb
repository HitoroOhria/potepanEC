require 'rails_helper'

RSpec.describe "potepan/categories/show.html.erb", type: :view do
  feature 'GET potepan/categories/:taxon_id' do
    let(:taxonomy)  { create(:taxonomy) }
    let(:taxon1)    { taxonomy.taxons.create(attributes_for(:taxon)) }
    let(:taxon2)    { taxonomy.taxons.create(attributes_for(:taxon)) }
    let!(:product1) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }
    let!(:product2) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }
    let!(:option_type_size)   { create(:option_type, name: 'size') }
    let!(:option_type_color)  { create(:option_type, name: 'color') }
    let!(:size_option_value)  { create(:option_value, option_type: option_type_size) }
    let!(:color_option_value) { create(:option_value, option_type: option_type_color) }

    before do
      visit potepan_category_path(taxon1.id)
    end

    subject { page }

    context 'ページタイトル' do
      it { should have_title full_title(taxon1.name) }
    end

    context 'カテゴリーパネル' do
      context '商品カテゴリー' do
        it { should have_css('.panel-heading', text: '商品カテゴリー') }
        it { should have_css('a',              text: taxon1.taxonomy.name, visible: false) }
        it {
          should have_css('a', text: taxon1.name, visible: false)
          should have_css('a', text: taxon2.name, visible: false)
        }
      end

      context '色から探す' do
        it { should have_css('.panel-heading',  text: '色から探す') }
        it { should have_css('a',               text: color_option_value.name) }
      end

      context 'サイズから探す' do
        it { should have_css('.panel-heading',  text: 'サイズから探す') }
        it { should have_css('a',               text: size_option_value.name) }
      end
    end

    context 'プロダクト一覧' do
      context ':taxon_idがTaxonomyの場合' do
        let(:taxonomy_products_count) {
          taxonomy.taxons.inject(0) { |product_counter, taxon| product_counter + taxon.products.count }
        }

        before do
          visit potepan_category_path(Spree::Taxon.find_by(name: taxonomy.name).id)
        end

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

      context ':taxon_idがTaxonの場合' do
        it { should have_css('.productBox', count: taxon1.products.count) }
        it { should have_link(product1.name, href: potepan_product_path(product1.id)) }
        it { should have_css('h3', text: "#{product1.price.round}円") }
      end
    end
  end
end
