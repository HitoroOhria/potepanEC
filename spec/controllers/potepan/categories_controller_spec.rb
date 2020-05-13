require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe '#show' do
    let!(:taxonomy)    { create(:taxonomy) }
    let!(:taxon_root)  { taxonomy.root }
    let!(:taxon_child) { taxon_root.children.create(attributes_for(:taxon, taxonomy_id: taxonomy.id)) }
    let!(:product_by_taxon_root) { taxon_root.products.create(attributes_for(:product, shipping_category_id: 1)) }
    let!(:product_by_taxon_child) { taxon_child.products.create(attributes_for(:product, shipping_category_id: 1)) }

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
