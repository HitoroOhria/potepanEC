require 'rails_helper'

RSpec.describe "helpers/potepan/application_helper.rb", type: :helper do
  let(:product) { create(:product) }
  let(:variant) { create(:variant, product: product) }

  describe 'product_price(product)' do
    subject { product_price(product) }

    context 'product.pricesに、currency属性が"JPY"のpriceがある時' do
      before do
        product.prices.first.update_attributes(amount: 1980, currency: 'JPY')
      end

      it { should eq '1,980JPY' }
    end

    context 'product.pricesに、currency属性が"JPY"のpriceがなく、currency属性が"USD"のpriceがある時' do
      before do
        product.prices.first.update_attributes(amount: 1075.99, currency: 'USD')
      end

      it { should eq '1,075.99USD' }
    end

    context 'product.pricesに、priceのcurrency属性が"JPY"も"USD"もない時' do
      before do
        product.prices.first.update_attributes(amount: 2057.99, currency: 'EUR')
        product.prices.create(attributes_for(:price, amount: 37.45, currency: 'ARI'))
      end

      it { should eq '2057..99EUR' }
    end
  end

  describe 'find_currency(product_prices, currency)' do
    context '引数 :currency に指定した通貨単位が、product.pricesのcurrency属性の中にあるとき' do
      let(:price_usd)  { product.prices.find_by(currency: 'USD') }
      let!(:price_eur) { variant.prices.create(attributes_for(:price, currency: 'EUR')) }

      it '引数 currency に"USD"を指定すると、product.pricesの中から、currency属性が"USD"のpriceを返すこと' do
        expect(find_currency(product.prices, 'USD')).to eq price_usd
      end

      it '引数 currency に"EUR"を指定すると、product.pricesの中から、currency属性が"EUR"のpriceを返すこと' do
        expect(find_currency(product.prices, 'EUR')).to eq price_eur
      end
    end

    context '引数 currency に指定した通貨単位が、product.pricesのcurrency属性の中にないとき' do
      it 'nilを返すこと' do
        expect(find_currency(product.prices, 'HOG')).to eq nil
      end
    end
  end
end
