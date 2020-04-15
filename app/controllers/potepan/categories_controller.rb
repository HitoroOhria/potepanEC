class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    if @taxon.taxonomy.present?
      @products = Spree::Taxon.new.products
      @taxon.taxonomy.taxons.each do |taxon|
        @products.push(taxon.products)
      end
    else
      @products = @taxon.products
    end
  end
end
