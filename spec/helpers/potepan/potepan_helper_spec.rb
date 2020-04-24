require 'rails_helper'

RSpec.describe "helpers/potepan/potepan_helper.rb", type: :helper do
  let(:product) { create(:product, price: 1980) }

  describe 'product_price(product)' do
    subject { product_price(product) }

    it { should eq '1,980JPY' }
  end
end
