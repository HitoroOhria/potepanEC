require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe '#show' do
    let(:taxonomy)             { create(:taxonomy) }
    let(:taxon_root)           { taxonomy.root }
    let(:taxon_child)          { create(:taxon, parent: taxon_root) }
    let!(:taxon_root_product)  { create(:product, taxon_ids: taxon_root.id) }
    let!(:taxon_child_product) { create(:product, taxon_ids: taxon_child.id) }

    let(:option_type_size)    { create(:option_type,  name: 'tshirt-size') }
    let(:option_type_color)   { create(:option_type,  name: 'tshirt-color') }
    let!(:option_value_size)  { create(:option_value, option_type: option_type_size) }
    let!(:option_value_color) { create(:option_value, option_type: option_type_color) }

    subject { response }

    context 'ルーティングの:taxon_idに対応するSpree::Taxonオブジェクトが親ノードの時' do
      before do
        get :show, params: { taxon_id: taxon_root.id }
      end

      it { is_expected.to have_http_status 200 }

      it { is_expected.to render_template :show }

      it '@taxonは、id属性がparams[:taxon_id]に対応したSpree::Taxonモデルオブジェクトである' do
        expect(assigns(:taxon)).to eq taxon_root
      end

      it '@productsは、@taxon自身と全ての子ノードに属する、Spree::Productモデルのコレクションである' do
        expect(assigns(:products)).to eq taxon_root.reload.all_products
      end

      it '@taxonomyiesは、全てのSpree::Taxonomyモデルのコレクションである' do
        expect(assigns(:taxonomies)).to eq Spree::Taxonomy.all
      end

      it '@option_values_sizeは、name属性が"tshirt-size"のSpree::OptionTypeの.option_valuesである' do
        expect(assigns(:option_values_size)).to eq option_type_size.option_values
      end

      it '@option_values_colorは、name属性が"tshirt-color"のSpree::OptionTypeの.option_valuesである' do
        expect(assigns(:option_values_color)).to eq option_type_color.option_values
      end
    end

    context 'ルーティングの:taxon_idに対応するSpree::Taxonオブジェクトが葉ノードの時' do
      before do
        get :show, params: { taxon_id: taxon_child.id }
      end

      it { is_expected.to have_http_status 200 }

      it { is_expected.to render_template :show }

      it '@taxonは、id属性がparams[:taxon_id]に対応したSpree::Taxonモデルオブジェクトである' do
        expect(assigns(:taxon)).to eq taxon_child
      end

      it '@productsは、@taxonに属する全てのSpree::Productモデルのコレクションである' do
        expect(assigns(:products)).to eq taxon_child.all_products
      end

      it '@taxonomyiesは、全てのSpree::Taxonomyモデルのコレクションである' do
        expect(assigns(:taxonomies)).to eq Spree::Taxonomy.all
      end

      it '@option_values_sizeは、name属性が"tshirt-size"のSpree::OptionTypeの.option_valuesである' do
        expect(assigns(:option_values_size)).to eq option_type_size.option_values
      end

      it '@option_values_colorは、name属性が"tshirt-color"のSpree::OptionTypeの.option_valuesである' do
        expect(assigns(:option_values_color)).to eq option_type_color.option_values
      end
    end
  end
end
