module Potepan::PotepanHelper
  def product_price(product)
    number_to_currency(product.price, format: '%n%u', unit: 'JPY', precision: 0)
  end
end
