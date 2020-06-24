require 'rails_helper'

RSpec.describe "helpers/potepan/products_helper.rb", type: :helper do
  describe '#product_to_category_path(product)' do
    context 'productに関連するSpree::Taxonが1つ以上あるとき' do
      let(:taxon)   { create(:taxon) }
      let(:product) { create(:product, taxon_ids: taxon.id) }

      it '最初のSpree::Taxonのidに対応した"/potepan/categories/:taxon_id"を返す' do
        expect(product_to_category_path(product)).to eq "/potepan/categories/#{taxon.id}"
      end
    end

    context 'productに関連するSpree::Taxonがないとき' do
      let(:product_non_taxon) { create(:product) }

      it '"/potepan/categories/1"を返す' do
        expect(product_to_category_path(product_non_taxon)).to eq '/potepan/categories/1'
      end
    end
  end
end
