Spree::Product.class_eval do
  def main_image
    images.first || variant_images.first || Spree::Image.new
  end

  def show_images
    images.presence || variant_images.presence || (images.new && images)
  end
end
