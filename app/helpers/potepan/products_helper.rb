module Potepan::ProductsHelper
  def render_carousel_image(product, carousel_type: :large)
    if product.images.present?
      render product.images,
             carousel_type: carousel_type
    else
      render 'potepan/spree/images/image',
             carousel_type: carousel_type,
             image_counter: 0, image: Spree::Image.new
    end
  end

  def product_to_category_path(product)
    product.taxons.present? ? potepan_category_path(product.taxons.first.id)
                            : potepan_category_path(1)
  end
end
