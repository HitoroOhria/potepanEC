class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    if taxon_id_is_taxonomy?
      @products = Spree::Taxon.products.first
      @taxon.taxonomy.taxons.each do |taxon|
        @products.append(taxon.products)
      end
    else
      @products = @taxon.products
    end
  end

  private

    def taxon_id_is_taxonomy?
      Spree::Taxonomy.find_by(name: @taxon.name)
    end
end