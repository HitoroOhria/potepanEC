module Potepan::ProductsHelper
  def render_carousel_image(product, image_style: :large)
    images = product.images
    if images.present?
      render partial: 'potepan/shared/image',
             collection: images,
             locals: { image_style: image_style }
    else
      render partial: 'potepan/shared/image',
             locals: {
               image: Spree::Image.new,
               image_counter: 0,
               image_style: image_style
             }
    end
  end

  def product_to_category_path(product)
    product.taxons.present? ? potepan_category_path(product.taxons.first.id) : potepan_category_path(1)
  end
end
