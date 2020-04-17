Spree::Image.attachment_definitions[:attachment] = {
  url:         "stylishcoffee-#{Rails.env}.s3.amazonaws.com",
  default_url: '/spree/products/noimage/:style.png',
  path:        '/spree/products/:id/:style/:basename.:extension'
}