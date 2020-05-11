module Potepan::ApplicationHelper
  def product_price(product)
    product_prices = product.prices
    if (jpy_price = find_currency(product_prices, 'JPY'))
      number_to_currency(jpy_price.amount, format: '%n%u', unit: jpy_price.currency, precision: 0)
    elsif (usd_price = find_currency(product_prices, 'USD'))
      number_to_currency(usd_price.amount, format: '%n%u', unit: usd_price.currency)
    else
      product_first_price = product_prices.first
      number_to_currency(product_first_price.amount, format: '%n%u', unit: product_first_price.currency)
    end
  end

  def find_currency(product_prices, currency)
    product_prices.find { |price| price.currency == currency }
  end
end
