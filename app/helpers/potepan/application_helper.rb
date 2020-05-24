module Potepan::ApplicationHelper
  def product_price(product)
    product_price = product.master.default_price
    Spree::Money.parse(product_price.amount, product_price.currency).format
  end
end
