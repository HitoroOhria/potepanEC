require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe '#show' do
    context ':taxon_idがTaxonomyの場合' do
      let!(:taxon_by_taxonomy)      { create(:taxon) }
      let!(:anothre_taxon_products) {
        taxon_by_taxonomy.taxonomy.taxons.create(attributes_for(:taxon)).products.create(attributes_for(:product))
      }
      before do
        taxon_by_taxonomy.products.create(attributes_for(:product))
        get :show, params: { id: taxon_by_taxonomy.id }
      end

      context 'インスタンス変数のスペック'  do
        it '@taxon変数は、id属性がparams[:id]に対応したSpree::Taxonモデルオブジェクトである' do
          expect(assigns(:taxon)).to eq taxon_by_taxonomy
        end

        it '@products変数は、@taxon変数に関連するSpree::Taxonomyモデルの、関連する全てのSpree::Productモデルのコレクションである' do
          products = Spree::Taxon.new.products
          expect(assigns(:products)).to eq taxon_by_taxonomy.products.append(anothre_taxon_products)
        end
      end

      context 'レスポンスのスペック' do
        it 'HTTPレスポンスステータスコードが200である' do
          expect(response).to have_http_status(200)
        end

        it 'レスポンスののテンプレートがcategories/show.html.erbである' do
          expect(response).to render_template :show
        end
      end
    end

    context ':taxon_idがTaxonの場合' do
      let(:taxon)             { create(:taxon).taxonomy.taxons.create(attributes_for(:taxon)) }
      before do
        2.times { taxon.products.create(attributes_for(:product)) }
        get :show, params: {id: taxon.id}
      end

      context 'インスタンス変数のスペック'  do
        it '@taxon変数は、id属性がparams[:id]に対応したSpree::Taxonモデルオブジェクトである' do
          expect(assigns(:taxon)).to eq Spree::Taxon.find(taxon.id)
        end

        it '@products変数は、@taxon変数に関連する全てのSpree::Productモデルのコレクションである' do
          expect(assigns(:products)).to eq taxon.all_products
        end
      end

      context 'レスポンスのスペック' do
        it 'HTTPレスポンスステータスコードが200である' do
          expect(response).to have_http_status(200)
        end

        it 'レスポンスののテンプレートがcategories/show.html.erbである' do
          expect(response).to render_template :show
        end
      end
    end
  end
end