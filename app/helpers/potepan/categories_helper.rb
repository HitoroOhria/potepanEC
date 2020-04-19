module Potepan::CategoriesHelper
  def option_values(option_type_name)
    Spree::OptionType.includes(:option_values).find_by(name: option_type_name).option_values
  end
end
