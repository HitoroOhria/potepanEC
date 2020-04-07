module Potepan::CategoriesHelper
  def take_all_taxonomies
    Spree::Taxonomy.all
  end

  def take_taxons(taxonomy)
    Spree::Taxon.where(taxonomy_id: taxonomy.id)
  end

  def take_option_type(option_type_name)
    Spree::OptionType.find_by(name: option_type_name )
  end

  def take_option_values(option_type_name)
    option_type = Spree::OptionType.find_by(name: option_type_name )
    Spree::OptionValue.where(option_type_id: option_type.id)
  end
end
