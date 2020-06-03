require 'rails_helper'

RSpec.describe Spree::Product, type: :model do
  let(:viewable_type)         { [:viewable_type, 'Spree::Variant'] }

  let(:product)               { create(:product) }
  let(:master_variant)        { product.master }
  let(:master_variant_image1) { create(:image, [[:viewable_id, master_variant.id], viewable_type].to_h) }
  let(:master_variant_image2) { create(:image, [[:viewable_id, master_variant.id], viewable_type].to_h) }
  let(:other_variant)         { create(:variant, product: product) }
  let(:other_variant_image1)  { create(:image, [[:viewable_id, other_variant.id], viewable_type].to_h) }
  let(:other_variant_image2)  { create(:image, [[:viewable_id, other_variant.id], viewable_type].to_h) }

  describe '#main_image' do
    subject { product.main_image }

    context 'product.imagesに画像があるとき' do
      before do
        master_variant_image1
        master_variant_image2
      end

      it 'product.imagesの1番目の画像を返すこと' do
        is_expected.to eq master_variant_image1
      end
    end

    context 'product.imagesに画像がなく、product.variant_imagesに画像があるとき' do
      before do
        master_variant
        other_variant_image1
        other_variant_image2
      end

      it 'product.variant_imagesの1番目の画像を返すこと' do
        is_expected.to eq other_variant_image1
      end
    end

    context 'product.imagesにも、product.variant_imagesにも画像がないとき' do
      before do
        master_variant
        other_variant
      end

      it 'Spree::Images.newを返すこと' do
        expect(product.main_image.attributes).to eq Spree::Image.new.attributes
      end
    end
  end

  describe '#show_images' do
    subject { product.show_images }

    context 'product.imagesに画像があるとき' do
      before do
        master_variant_image1
        master_variant_image2
      end

      it 'product.imagesを返すこと' do
        is_expected.to eq product.images
      end
    end

    context 'product.imagesに画像がなく、product.variant_imagesに画像があるとき' do
      before do
        master_variant
        other_variant_image1
        other_variant_image2
      end

      it 'product.variant_imagesを返すこと' do
        is_expected.to eq product.variant_images
      end
    end

    context 'product.imagesにも、product.variant_imagesにも画像がないとき' do
      before do
        master_variant
        other_variant
      end

      subject(:show_images) { product.show_images }

      it '返すコレクションの個数は1であること' do
        expect(show_images.size).to eq 1
      end

      it '返すコレクションの1個目のオブジェクトは、Spree::Imageクラスのオブジェクトであること' do
        expect(show_images.first.class).to eq Spree::Image
      end

      it '返すコレクションの1個目のオブジェクトは、DBに保存されていないインスタンスであること' do
        expect(show_images.first.new_record?).to eq true
      end
    end
  end

  describe '#relation_products' do
    let(:product_attributes1) { attributes_for(:product, shipping_category_id: 1) }
    let(:product_attributes2) { attributes_for(:product, shipping_category_id: 1) }
    let(:product_attributes3) { attributes_for(:product, shipping_category_id: 1) }
    let(:product_attributes4) { attributes_for(:product, shipping_category_id: 1) }
    let(:product_attributes5) { attributes_for(:product, shipping_category_id: 1) }

    before do
      create(:product) # レシーバが所属するカテゴリー以外の商品は含まないことをテスト
    end

    context 'レシーバが所属するカテゴリーがない場合' do
      let!(:product) { create(:product) }

      it 'コレクションを返すこと' do
        expect(product.relation_products.class).to eq Spree::Product.where(name: 'hoge').class
      end
    end

    context 'レシーバが所属するカテゴリーに、レシーバ以外の商品がない時' do
      let!(:product) { create(:product) }

      before do
        product.taxons.create(attributes_for(:taxon))
      end

      subject { product.relation_products }

      it '空のコレクションを返すこと' do
        is_expected.to eq []
      end
    end

    context 'レシーバの所属するカテゴリーが親ノードの時' do
      let!(:parent_taxon)          { create(:taxon) }
      let!(:child_taxon)           { parent_taxon.children.create(attributes_for(:taxon)) }
      let!(:parent_taxon_product1) { parent_taxon.products.create(product_attributes1) }
      let!(:parent_taxon_product2) { parent_taxon.products.create(product_attributes2) }
      let!(:child_taxon_product)   { child_taxon.products.create(product_attributes3) }

      subject { parent_taxon_product1.relation_products }

      it '所属するカテゴリーとその子孫ノードのproductsを返すこと' do
        is_expected.to eq [parent_taxon_product2, child_taxon_product]
      end
    end

    context 'レシーバの所属するカテゴリーが中間ノードの時' do
      let!(:parent_taxon)          { create(:taxon) }
      let!(:middle_taxon)          { parent_taxon.children.create(attributes_for(:taxon)) }
      let!(:leaf_taxon)            { middle_taxon.children.create(attributes_for(:taxon)) }
      let!(:parent_taxon_product)  { parent_taxon.products.create(product_attributes1) }
      let!(:middle_taxon_product1) { middle_taxon.products.create(product_attributes2) }
      let!(:middle_taxon_product2) { middle_taxon.products.create(product_attributes3) }
      let!(:leaf_taxon_product)    { leaf_taxon.products.create(product_attributes4) }

      before do
        create(:product)
      end

      subject { middle_taxon_product1.relation_products }

      it '所属するカテゴリーとその子孫ノードのproductsを返すこと' do
        is_expected.to eq [middle_taxon_product2, leaf_taxon_product]
      end
    end

    context 'レシーバの所属するカテゴリーが葉ノードの時' do
      let!(:parent_taxon)         { create(:taxon) }
      let!(:child_taxon)          { parent_taxon.children.create(attributes_for(:taxon)) }
      let!(:parent_taxon_product) { parent_taxon.products.create(product_attributes1) }
      let!(:child_taxon_product1) { child_taxon.products.create(product_attributes2) }
      let!(:child_taxon_product2) { child_taxon.products.create(product_attributes3) }

      subject { child_taxon_product1.relation_products }

      it '所属するカテゴリーのみのproductsを返すこと' do
        is_expected.to eq [child_taxon_product2]
      end
    end
  end
end
