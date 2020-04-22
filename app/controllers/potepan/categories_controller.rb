class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = @taxon.all_products
    @taxonomies = Spree::Taxonomy.includes(:taxons).all
  end
end
