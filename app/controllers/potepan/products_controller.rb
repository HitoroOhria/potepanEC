class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:product_id])
    @relation_products = @product.relation_products
                                 .includes(master: %i[default_price images])
                                 .limit(RELATION_PRODUCTS_COUNT)
  end
end
