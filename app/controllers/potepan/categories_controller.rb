class Potepan::CategoriesController < ApplicationController
  def show
    if category_id_is_taxonomy?
      @category = Spree::Taxonomy.find(params[:id])
      @products = Spree::Taxon.new.products
      @category.taxons.each do |taxon|
        @products.append(taxon.products)
      end
    else
      taxon_id = params[:id].to_i - Spree::Taxonomy.count
      @category = Spree::Taxon.find(taxon_id)
      @products = @category.products
    end
  end

  private

    def category_id_is_taxonomy?
      params[:id].to_i <= Spree::Taxonomy.count ? true : false
    end
end