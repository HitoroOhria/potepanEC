Spree::Product.class_eval do
  def main_image
    images.first || variant_images.first || Spree::Image.new
  end

  def show_images
    images.presence || variant_images.presence || (images.new && images)
  end

  def relation_products
    taxons.present? ? distinct_products : []
  end

  private

  def distinct_products
    product_ids = taxons.flat_map { |taxon| taxon.all_products.pluck(:id) }
    case product_ids.count
    when 1
      []
    when 2
      [Spree::Product.find(*product_ids.uniq - [id])]
    else
      Spree::Product.find(*product_ids.uniq - [id])
    end
  end
end
