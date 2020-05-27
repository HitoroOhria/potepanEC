class Potepan::ProductsController < ApplicationController
  RELATION_PRODUCTS_COUNT = 4

  def show
    @product = Spree::Product.find(params[:product_id])
    @relation_products = @product.relation_products[0...RELATION_PRODUCTS_COUNT]
  end
end
