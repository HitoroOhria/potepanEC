class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = @taxon.all_products.includes(master: :default_price)
    @taxonomies = Spree::Taxonomy.all.includes(:root)
  end
end
