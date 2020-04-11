Spree::Image.attachment_definitions[:attachment] = {
  styles:          { mini: '48x48>', small: '400x400>', product: '680x680>', large: '1200x1200>' },
  default_style:   :product,
  default_url:     'noimages/:style.png',
  url:             '/spree/products/:id/:style/:basename.:extension',
  path:            ':rails_root/app/assets/images/spree/products/:id/:style/:basename.:extension',
  convert_options: { all: '-strip -auto-orient -colorspace sRGB' }
}
