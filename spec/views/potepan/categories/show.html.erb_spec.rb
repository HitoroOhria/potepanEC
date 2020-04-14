require 'rails_helper'

RSpec.describe "potepan/categories/show.html.erb", type: :view do
  feature 'GET potepan/categories/:taxon_id' do
    # 作成するファクトリーと関連付け
    # Taxonomy
    # Taxonomy <-> Taxon1 <-> Product1 <-> Variant2
    # Taxonomy <-> Taxon2 <-> Product2
    # OptionType(color) <-> OptionValue1, OptionType(size) <-> OptionValue2
    # Product2 <-> Variant2 <-> OptionValue1
    #
    # メソッドと格納されているファクトリー
    # taxonomy = Taxonomy
    # taxon = Taxon1
    # product = product2
    # option_values = [ OptionValue1, OptionValue2 ]

    let(:taxonomy) { create(:taxonomy) }
    let(:taxon)    {
      taxonomy.taxons.create(attributes_for(:taxon))
              .products.create(attributes_for(:product, shipping_category_id: 1))
              .variants.create(attributes_for(:variant))
      taxonomy.taxons.second
    }
    let(:product) {
      create(:taxon, taxonomy: taxon.taxonomy)
        .products.create(attributes_for(:product, shipping_category_id: 1))
    }
    let(:option_values) {
      option_types_name = %w[color size]
      option_types_name.map do |option_type|
        create(:option_type, name: option_type).option_values.create(attributes_for(:option_value))
      end
    }
    before do
      product.variants.create(attributes_for(:variant))
             .option_values_variants.create(option_value_id: option_values[0].id)
      visit potepan_category_path(taxon.id)
    end

    subject { page }

    context 'カテゴリーパネル' do
      context '商品カテゴリー' do
        it { should have_css('.panel-heading', text: '商品カテゴリー') }
        it { should have_css('a',              text: taxon.taxonomy.name, visible: false) }
        it { should have_css('a',              text: "#{taxon.name} ",    visible: false) }
      end

      context '色から探す' do
        it { should have_css('.panel-heading',  text: '色から探す') }
        it { should have_css('a',               text: option_values[0].name) }
      end

      context 'サイズから探す' do
        it { should have_css('.panel-heading',  text: 'サイズから探す') }
        it { should have_css('a',               text: option_values[1].name) }
      end
    end

    context 'プロダクト一覧' do
      context ':taxon_idがTaxonomyの場合' do
        before do
          visit potepan_category_path(Spree::Taxon.find_by(name: taxonomy.name).id)
        end

        it {
          products = Spree::Taxon.new.products
          products_count = taxonomy.taxons.each { |taxon| products.push(taxon.products) } .count
          should have_css('.productBox', count: products_count)
        }
        it { should have_link(product.name), href: potepan_product_path(product.id) }
        it { should have_css('h3', text: "#{product.price.round}円") }
      end

      context ':taxon_idがTaxonの場合' do
        let(:taxon_product) { taxon.products.first }

        it { should have_css('.productBox', count: taxon.products.count) }
        it { should have_link(taxon_product.name), href: potepan_product_path(taxon_product.id) }
        it { should have_css('h3', text: "#{taxon_product.price.round}円") }
      end
    end
  end
end
