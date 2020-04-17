class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    if @taxon.leaf?
      @products = @taxon.products
    else
      @products = Spree::Taxon.new.products
      Spree::Taxon.includes(:products).where(name: @taxon.self_and_descendants.pluck(:name)).each do |taxon|
        @products.push(taxon.products)
      end
    end
  end
end
