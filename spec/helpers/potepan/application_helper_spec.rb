require 'rails_helper'

RSpec.describe "helpers/potepan/application_helper.rb", type: :helper do
  let(:product) { create(:product) }
  let(:variant) { create(:variant, product: product) }

  describe 'product_price(product)' do
    subject { product_price(product) }

    context 'product.master.defaul_priceの、currency属性が"JPY"の時' do
      before do
        product.master.default_price.update_attributes(amount: rand(500_000), currency: 'JPY')
      end

      it '"○○○JPY"のように、数字の後に"JPY"を付けた文字列を返す' do
        should match(/\d+JPY/)
      end

      context 'product.master.defaul_priceの、amount属性の数値が4桁未満の時' do
        before do
          product.master.default_price.update_attributes(amount: rand(999), currency: 'JPY')
        end

        it '"◯◯◯"のように、数字部分にカンマを含まない' do
          should_not include(',')
        end
      end

      context 'product.master.defaul_priceの、amount属性の数値が4桁以上の時' do
        before do
          product.master.default_price.update_attributes(amount: rand(1000..500_000), currency: 'JPY')
        end

        it '"◯◯,◯◯◯"のように、数字部分を3桁毎にカンマで区切った文字列を返す' do
          should match(/\d+,\d{3}/)
        end
      end
    end

    context 'product.master.defaul_priceの、currency属性が"JPY"以外の時' do
      before do
        product.master.default_price.update_attributes(amount: rand(500_000), currency: 'USD')
      end

      it '"○○◯CURRENCY"のように、数字の後にcurrency属性の値を追加した文字列を返す' do
        should match(/\d+USD/)
      end

      context 'product.master.defaul_priceの、amount属性の数値が4桁未満の時' do
        before do
          product.master.default_price.update_attributes(amount: rand(999), currency: 'JPY')
        end

        it '"◯◯◯"のように、数字部分にカンマを含まない' do
          should_not include(',')
        end
      end

      context 'product.master.defaul_priceの、amount属性の数値が4桁以上の時' do
        before do
          product.master.default_price.update_attributes(amount: rand(1000..500_000), currency: 'JPY')
        end

        it '"◯◯,◯◯◯"のように、数字部分を3桁毎にカンマで区切った文字列を返す' do
          should match(/\d+,\d{3}/)
        end
      end
    end
  end
end
