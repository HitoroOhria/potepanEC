require 'rails_helper'

RSpec.describe "helpers/potepan/application_helper.rb", type: :helper do
  let(:product) { create(:product, price: 100) }

  describe 'product_price(product)' do
    subject { product_price(product) }

    context 'product.pricesに、currency属性が"JPY"のpriceがある時' do
      let(:product) { create(:product) }
      let(:variant) { create(:variant, product: product) }

      before do
        variant.prices.create(attributes_for(:price, amount: 1980, currency: 'JPY'))
      end

      it { should eq '1,980JPY' }
    end

    context 'product.pricesに、currency属性が"JPY"のpriceがない時' do
      it { should eq '10,775JPY' }
    end
  end
end
