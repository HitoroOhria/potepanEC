require 'rails_helper'

RSpec.describe "helpers/potepan/application_helper.rb", type: :helper do
  let(:product) { create(:product) }
  let(:variant) { create(:variant, product: product) }

  describe 'product_price(product)' do
    subject { product_price(product) }

    context 'product.master.defaul_priceの、currency属性が"JPY"の時' do
      before do
        product.master.default_price.update_attributes(amount: rand(500000), currency: 'JPY')
      end

      it { should match /.*\d{1,3}JPY/ }
    end

    context 'product.master.defaul_priceの、currency属性が"JPY"以外の時' do
      before do
        product.master.default_price.update_attributes(amount: rand(500000), currency: 'USD')
      end

      it { should match /.*\d{1,3}.\d{2}[A-Z]{3}/ }
    end
  end
end
