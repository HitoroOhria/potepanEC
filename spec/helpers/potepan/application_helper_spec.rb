require 'rails_helper'

RSpec.describe "helpers/potepan/application_helper.rb", type: :helper do
  let(:product) { create(:product) }
  let(:variant) { product.master }

  describe '#product_price(product)' do
    before do
      variant.default_price.update_attributes(amount: rand(500_000), currency: 'USD')
    end

    subject { product_price(product) }

    it '"$◯◯◯"のように、数字の前に価格記号を付けた文字列を返す' do
      is_expected.to match(/\$\d+/)
    end

    context 'product.master.defaul_priceの、amount属性の数値が4桁未満の時' do
      before do
        product.master.default_price.update_attributes(amount: rand(999))
      end

      it '"◯◯◯"のように、数字部分にカンマを含まない' do
        is_expected.to_not include(',')
      end
    end

    context 'product.master.defaul_priceの、amount属性の数値が4桁以上の時' do
      before do
        product.master.default_price.update_attributes(amount: rand(1000..500_000))
      end

      it '"◯◯,◯◯◯"のように、数字部分を3桁毎にカンマで区切った文字列を返す' do
        is_expected.to match(/\d{1,3},\d{3}/)
      end
    end
  end
end
