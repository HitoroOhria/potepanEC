RSpec.shared_context "taxonomy and taxon by root and child setup" do
  let!(:taxonomy)    { create(:taxonomy) }
  let!(:taxon_root)  { taxonomy.root }
  let!(:taxon_child) {
    taxon_root.children.create(
      attributes_for(:taxon, taxonomy_id: taxonomy.id)
    )
  }
end
