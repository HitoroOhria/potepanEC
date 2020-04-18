Spree::Image.attachment_definitions[:attachment][:url]         = "stylishcoffee-#{Rails.env}.s3.amazonaws.com"
Spree::Image.attachment_definitions[:attachment][:default_url] = "/stylishcoffee-#{Rails.env}.s3-ap-northeast-1.amazonaws.com/spree/products/noimage/:style.png"
Spree::Image.attachment_definitions[:attachment][:path]        = '/spree/products/:id/:style/:basename.:extension'