class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = @taxon.leaf? ? @taxon.products : @taxon.all_products
  end
end
