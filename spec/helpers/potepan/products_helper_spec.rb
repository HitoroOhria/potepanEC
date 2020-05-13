require 'rails_helper'

RSpec.describe "helpers/potepan/products_helper.rb", type: :helper do
  describe '#product_to_category_path(product)' do
    context 'productに関連するSpree::Taxonが1つ以上あるとき' do
      let(:taxon)   { create(:taxon) }
      let(:product) { taxon.products.create(attributes_for(:product, shipping_category_id: 1)) }

      subject { product_to_category_path(product) }

      it '最初のSpree::Taxonのidに対応した"/potepan/categories/:taxon_id"を返す' do
        should eq "/potepan/categories/#{taxon.id}"
      end
    end

    context 'productに関連するSpree::Taxonがないとき' do
      let(:product_non_taxon) { create(:product) }

      subject { product_to_category_path(product_non_taxon) }

      it '"/potepan/categories/1"を返す' do
        should eq '/potepan/categories/1'
      end
    end
  end
end
