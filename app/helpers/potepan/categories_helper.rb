module Potepan::CategoriesHelper
  def option_values(option_type_name)
    Spree::OptionType.includes(:option_values).find_by(name: option_type_name).option_values
  end

  def product_includes_table_where(products)
    Spree::Product.includes(master: %i[images default_price]).where(id: products.pluck(:id))
  end

  def image_product_url(product)
    product.images.empty? ? Spree::Image.new.url(:product) : product.images.first.url(:product)
  end
end
