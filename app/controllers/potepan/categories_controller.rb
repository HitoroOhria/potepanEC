class Potepan::CategoriesController < ApplicationController
  def show
    @category = Spree::Taxonomy.find(params[:id])
  end
end
