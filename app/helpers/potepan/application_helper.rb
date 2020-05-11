module Potepan::ApplicationHelper
  def product_price(product)
    product_price = product.master.default_price
    case product_price.currency
    when 'JPY'
      number_to_currency(product_price.amount, format: '%n%u',
                                               unit: product_price.currency,
                                               precision: 0)
    else
      number_to_currency(product_price.amount, format: '%n%u',
                                               unit: product_price.currency)
    end
  end
end
