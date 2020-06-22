require 'rails_helper'

RSpec.describe "Potepan::Categories#show layout", type: :feature do
  let(:taxon_attr) { attributes_for(:taxon, name: 'Bag', taxonomy_id: taxonomy.id) }

  let!(:taxonomy)    { create(:taxonomy, name: 'Category') }
  let!(:taxon_root)  { taxonomy.root }
  let!(:taxon_child) { create(:taxon, parent: taxon_root) }

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

    describe 'カテゴリーパネルの「商品カテゴリー」のレイアウト' do
      it { is_expected.to have_css('.panel-heading', text: '商品カテゴリー') }

      it { is_expected.to have_link(taxonomy.name) }

      it { is_expected.to have_link("#{taxon_child.name} (#{taxon_child.products.count})") }
    end

    describe 'カテゴリーパネルの「色から探す」のレイアウト' do
      before do
        rand(3).times { option_value_color.variants.create(attributes_for(:variant)) }
        visit potepan_category_path(taxon_root.id)
      end

      it { is_expected.to have_css('.panel-heading', text: '色から探す') }

      it '「色から探す」パネルの中に、カラー名のリンクがあること' do
        expect(find('.panel-heading', text: '色から探す').ancestor('.panel')).to \
          have_css('a', text: option_value_color.name)
      end

      it 'カラー名のリンクのテキスト部分に、span要素でvariantsの個数が表示されていること' do
        expect(find('a', text: option_value_color.name)).to \
          have_css('span', text: "(#{option_value_color.variants.count})")
      end
    end

    describe 'カテゴリーパネルの「サイズから探す」のレイアウト' do
      before do
        rand(3).times { option_value_size.variants.create(attributes_for(:variant)) }
        visit potepan_category_path(taxon_root.id)
      end

      it { is_expected.to have_css('.panel-heading', text: 'サイズから探す') }

      it '「サイズから探す」パネルの中に、ザイズ名のリンクがあること' do
        expect(find('.panel-heading', text: 'サイズから探す').ancestor('.panel')).to \
          have_css('a', text: option_value_size.name)
      end

      it 'サイズ名のリンクのテキスト部分に、span要素でvariantsの個数が表示されていること' do
        expect(find('a', text: option_value_size.name)).to \
          have_css('span', text: "(#{option_value_size.variants.count})")
      end
    end

    describe 'プロダクト一覧表示のレイアウト' do
      let(:root_product_path)    { potepan_product_path(taxon_root_product.id) }
      let(:child_product_path)   { potepan_product_path(taxon_child_product.id) }

      let!(:taxon_root_product)  { create(:product, taxon_ids: taxon_root.id) }
      let!(:taxon_child_product) { create(:product, taxon_ids: taxon_child.id) }
      let!(:root_product_image)  { create(:image, viewable: taxon_root_product.master) }
      let!(:child_product_image) { create(:image, viewable: taxon_child_product.master) }

      subject { page }

      context 'ルーティングの:taxon_idのモデルオブジェクトが親ノードの時' do
        before do
          visit potepan_category_path(taxon_root.id)
        end

        it { is_expected.to have_css('.productBox', count: 2) }

        it { is_expected.to have_css("img#product_image_#{root_product_image.id}") }

        it { is_expected.to have_css("img#product_image_#{child_product_image.id}") }

        it { is_expected.to have_css('h5', text: taxon_root_product.name) }

        it { is_expected.to have_css('h5', text: taxon_child_product.name) }

        it { is_expected.to have_css('h3', text: product_price(taxon_root_product)) }

        it { is_expected.to have_css('h3', text: product_price(taxon_child_product)) }

        it '親ノードTaxonの商品の画像にリンクが貼られていること' do
          expect(find_link('', href: root_product_path)).to \
            have_css("img#product_image_#{root_product_image.id}")
        end

        it '葉ノードTaxonの商品の画像にリンクが貼られていること' do
          expect(find_link('', href: child_product_path)).to \
            have_css("img#product_image_#{child_product_image.id}")
        end

        it { is_expected.to have_link(taxon_root_product.name, href: root_product_path) }

        it { is_expected.to have_link(taxon_child_product.name, href: child_product_path) }

        it { is_expected.to have_link(product_price(taxon_root_product), href: root_product_path) }

        it { is_expected.to have_link(product_price(taxon_child_product), href: child_product_path) }
      end

      describe 'ルーティングの:taxon_idのモデルオブジェクトが葉ノードの時' do
        before do
          visit potepan_category_path(taxon_child.id)
        end

        it { is_expected.to have_css('.productBox', count: 1) }

        it { is_expected.to have_css("img#product_image_#{child_product_image.id}") }

        it { is_expected.to have_css('h5', text: taxon_child_product.name) }

        it { is_expected.to have_css('h3', text: product_price(taxon_child_product)) }

        it '葉ノードTaxonの商品の画像にリンクが貼られていること' do
          expect(find_link('', href: child_product_path)).to \
            have_css("img#product_image_#{child_product_image.id}")
        end

        it { is_expected.to have_link(taxon_child_product.name, href: child_product_path) }

        it { is_expected.to have_link(product_price(taxon_child_product), href: child_product_path) }
      end
    end
  end
end
