module Potepan::ProductsHelper
  def render_carousel_image(product, carousel_type: :large)
    images = product.images
    if images.present?
      render partial: 'potepan/shared/image',
             collection: images,
             locals: { carousel_type: carousel_type }
    else
      render partial: 'potepan/shared/image',
             locals: {
               image: Spree::Image.new,
               image_counter: 0,
               carousel_type: carousel_type
             }
    end
  end

  def product_to_category_path(product)
    product.taxons.present? ? potepan_category_path(product.taxons.first.id) : potepan_category_path(1)
  end
end
