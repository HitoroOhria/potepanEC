Spree::Product.class_eval do
  def main_image
    images.first || variant_images.first || Spree::Image.new
  end

  def show_images
    images.presence || variant_images.presence || (images.new && images)
  end

  def relation_products
    return all_other_products if a_few_products?

    if taxons.present?
      invalid_or_products(taxons) || refill_products(taxons)
    else
      random_products
    end
  end

  private

  def a_few_products?
    Potepan::ProductsController::RELATION_PRODUCTS_COUNT + 1 >= Spree::Product.count
  end

  def all_other_products
    Spree::Product.count == 1 ? [] : Spree::Product.find(*Spree::Product.all.map(&:id).to_a - [id])
  end

  def invalid_or_products(taxons)
    product_ids = taxons.flat_map { |taxon| taxon.all_products.pluck(:id) }
    distinct_products = Spree::Product.find(*product_ids.uniq - [id])
    Potepan::ProductsController::RELATION_PRODUCTS_COUNT <= distinct_products.count && distinct_products
  end

  def refill_products(taxons)
    instance_taxons = Spree::Product.new.taxons << taxons
    other_taxon_ids = Spree::Taxon.all.map(&:id).to_a - instance_taxons.pluck(:id)
    added_taxons = instance_taxons << Spree::Taxon.find(other_taxon_ids.sample)
    invalid_or_products(added_taxons) || refill_products(added_taxons)
  end

  def random_products
    product_ids = []
    Potepan::ProductsController::RELATION_PRODUCTS_COUNT.times do
      product_ids << other_random_number(product_ids)
    end
    Spree::Product.find(*product_ids)
  end

  def other_random_number(array)
    random_number = (Spree::Product.all.map(:id) - [id]).sample
    array.include?(random_number) ? other_random_number(array) : random_number
  end
end
