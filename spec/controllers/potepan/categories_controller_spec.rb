require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  describe '#show' do
    context ':taxon_idがTaxonomyの場合' do
      let(:taxon) { create(:taxon) }
      let!(:anothre_taxon_products) {
        taxon.taxonomy.taxons.create(attributes_for(:taxon))
             .products.create(attributes_for(:product, shipping_category_id: 1))
      }
      before do
        taxon.products.create(attributes_for(:product, shipping_category_id: 1))
        get :show, params: { taxon_id: taxon.id }
      end

      context 'インスタンス変数' do
        it '@taxon変数は、id属性がparams[:taxon_id]に対応したSpree::Taxonomyモデルオブジェクトである' do
          expect(assigns(:taxon)).to eq taxon
        end

        it '@products変数は、@taxon変数に関連するSpree::Taxonomyモデルの、関連する全てのSpree::Productモデルのコレクションである' do
          expect(assigns(:products)).to eq taxon.products.push(anothre_taxon_products)
        end
      end

      context 'レスポンス' do
        it 'HTTPレスポンスステータスコードが200である' do
          expect(response).to have_http_status(200)
        end

        it 'レスポンスのテンプレートがcategories/show.html.erbである' do
          expect(response).to render_template :show
        end
      end
    end

    context ':taxon_idがTaxonの場合' do
      let(:taxon) { create(:taxon).taxonomy.taxons.create(attributes_for(:taxon)) }
      before do
        2.times { taxon.products.create(attributes_for(:product)) }
        get :show, params: { taxon_id: taxon.id }
      end

      context 'インスタンス変数' do
        it '@taxon変数は、id属性がparams[:taxon_id]に対応したSpree::Taxonモデルオブジェクトである' do
          expect(assigns(:taxon)).to eq Spree::Taxon.find(taxon.id)
        end

        it '@products変数は、@taxon変数に関連する全てのSpree::Productモデルのコレクションである' do
          expect(assigns(:products)).to eq taxon.all_products
        end
      end

      context 'レスポンス' do
        it 'HTTPレスポンスステータスコードが200である' do
          expect(response).to have_http_status(200)
        end

        it 'レスポンスのテンプレートがcategories/show.html.erbである' do
          expect(response).to render_template :show
        end
      end
    end
  end
end
