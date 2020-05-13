require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe '#show' do
    include_context "taxonomy and taxon by root and child setup"
    include_context "product by root and child setup"

    subject { response }

    context 'ルーティングの:taxon_idに対応するSpree::Taxonオブジェクトが親ノードの時' do
      before do
        get :show, params: { taxon_id: taxon_root.id }
      end

      it { should have_http_status 200 }

      it { should render_template :show }

      it '@taxonは、id属性がparams[:taxon_id]に対応したSpree::Taxonモデルオブジェクトである' do
        expect(assigns(:taxon)).to eq taxon_root
      end

      it '@productsは、@taxon自身と全ての子ノードに属する、Spree::Productモデルのコレクションである' do
        expect(assigns(:products)).to eq taxon_root.reload.all_products
      end

      it '@taxonomyiesは、全てのSpree::Taxonomyモデルのコレクションである' do
        expect(assigns(:taxonomies)).to eq Spree::Taxonomy.all
      end
    end

    context 'ルーティングの:taxon_idに対応するSpree::Taxonオブジェクトが葉ノードの時' do
      before do
        get :show, params: { taxon_id: taxon_child.id }
      end

      it { should have_http_status 200 }

      it { should render_template :show }

      it '@taxonは、id属性がparams[:taxon_id]に対応したSpree::Taxonモデルオブジェクトである' do
        expect(assigns(:taxon)).to eq taxon_child
      end

      it '@productsは、@taxonに属する全てのSpree::Productモデルのコレクションである' do
        expect(assigns(:products)).to eq taxon_child.all_products
      end

      it '@taxonomyiesは、全てのSpree::Taxonomyモデルのコレクションである' do
        expect(assigns(:taxonomies)).to eq Spree::Taxonomy.all
      end
    end
  end
end
