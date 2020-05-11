module Potepan::ProductsHelper
  def product_to_category_path(product)
    product.taxons.present? ? potepan_category_path(product.taxons.first.id) : potepan_category_path(1)
  end
end
