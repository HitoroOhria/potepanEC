class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    if taxon_id_is_taxonomy?
      @products = Spree::Taxon.new.products
      Spree::Taxon.includes(:products).where(taxonomy_id: @taxon.taxonomy.id).each do |taxon|
        @products.push(taxon.products)
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
