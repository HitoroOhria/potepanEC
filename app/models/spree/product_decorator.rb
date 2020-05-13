Spree::Product.class_eval do
  def main_image
    images.first || variant_images.first || Spree::Image.new
  end

  def show_images
    check_present(images) || check_present(variant_images) || (images.new && images)
  end

  private

  def check_present(collection)
    collection.present? && collection
  end
end
