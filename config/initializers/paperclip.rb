Spree::Image.attachment_definitions[:attachment][:url]  = "stylishcoffee-#{Rails.env}.s3.amazonaws.com"
Spree::Image.attachment_definitions[:attachment][:path] = '/spree/products/:id/:style/:basename.:extension'
