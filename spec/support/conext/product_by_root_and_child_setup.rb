# このshared_contextを使用する時は、事前に include_context "taxonomy and taxon by root and child setup" を呼び出すこと

RSpec.shared_context "product by root and child setup" do
  let!(:product_by_taxon_root) {
    taxon_root.products.create(
      attributes_for(:product, shipping_category_id: 1)
    )
  }
  let!(:product_by_taxon_child) {
    taxon_child.products.create(
      attributes_for(:product, shipping_category_id: 1)
    )
  }
end
