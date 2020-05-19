Spree::Product.class_eval do
  def main_image
    images.first || variant_images.first || Spree::Image.new
  end

  def show_images
    self_or_false(images) || self_or_false(variant_images) || (images.new && images)
  end

  private

  def self_or_false(collection)
    collection.present? && collection
  end
end
