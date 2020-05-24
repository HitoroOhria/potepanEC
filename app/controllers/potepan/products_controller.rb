class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:product_id])
  end
end
