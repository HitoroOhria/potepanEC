class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    if taxon_id_is_taxonomy?
      @products = Spree::Taxon.new.products
      @taxon.taxonomy.taxons.each do |taxon|
        @products.append(taxon.products)
      end
    else
      @products = @category.products
    end
  end

  private

    def taxon_id_is_taxonomy?
      params[:id].to_i <= Spree::Taxonomy.count
    end
end