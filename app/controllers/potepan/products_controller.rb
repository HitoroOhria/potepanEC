class Potepan::ProductsController < ApplicationController
  RELATION_PRODUCTS_COUNT = 4

  def show
    @product = Spree::Product.find(params[:product_id])
    @relation_products = @product.relation_products
                                 .includes(master: %i[default_price images])
                                 .limit(RELATION_PRODUCTS_COUNT)
  end
end
