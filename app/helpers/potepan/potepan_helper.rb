module Potepan::PotepanHelper
  def product_price(product)
    if (jpy_price = product.prices.find { |price| price.currency == 'JPY' })
      number_to_currency(jpy_price.amount, format: '%n%u', unit: 'JPY', precision: 0)
    else
      number_to_currency(product.price * 107.75, format: '%n%u', unit: 'JPY', precision: 0)
    end
  end
end
