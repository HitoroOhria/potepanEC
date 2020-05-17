class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = @taxon.all_products.includes(:variant_images, master: :default_price)
    @taxonomies = Spree::Taxonomy.all.includes(:root)
    @option_values_size = option_values('tshirt-size')
    @option_values_color = option_values('tshirt-color')
  end

  private

  def option_values(option_type_name)
    Spree::OptionType.includes(:option_values).find_by(name: option_type_name).option_values
  end
end
