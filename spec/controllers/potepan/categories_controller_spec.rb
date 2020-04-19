require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe '#show' do
    let(:taxonomy)  { create(:taxonomy) }
    let(:taxon1)    { taxonomy.root }
    let(:taxon2)    { create(:taxon, taxonomy: taxonomy) }
    let!(:product1) { taxon1.products.create(attributes_for(:product, shipping_category_id: 1)) }
    let!(:product2) { taxon2.products.create(attributes_for(:product, shipping_category_id: 1)) }

    subject { response }

    context 'ルーティングの:taxon_idのモデルオブジェクトが親ノードの時' do
      before do
        get :show, params: { taxon_id: taxon1.id }
      end

      it { should have_http_status 200 }

      it { should render_template :show }

      it '@taxonは、id属性がparams[:taxon_id]に対応したSpree::Taxonomyモデルオブジェクトである' do
        expect(assigns(:taxon)).to eq taxon1
      end

      it '@productsは、@taxon変数に関連するSpree::Taxonomyモデルの、関連する全てのSpree::Productモデルのコレクションである' do
        expect(assigns(:products)).to eq taxon1.products.push(taxon2.products)
      end
    end

    context 'ルーティングの:taxon_idのモデルオブジェクトが葉ノードの時' do
      before do
        get :show, params: { taxon_id: taxon2.id }
      end

      it { should have_http_status 200 }

      it { should render_template :show }

      it '@taxonは、id属性がparams[:taxon_id]に対応したSpree::Taxonモデルオブジェクトである' do
        expect(assigns(:taxon)).to eq taxon2
      end

      it '@productsは、@taxon変数に関連する全てのSpree::Productモデルのコレクションである' do
        expect(assigns(:products)).to eq taxon2.products
      end
    end
  end
end
