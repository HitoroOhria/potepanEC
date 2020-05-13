require 'rails_helper'

RSpec.describe "helpers/potepan/categories_helper.rb", type: :helper do
  describe 'take_option_values(option_type_name)' do
    let(:option_type) { create(:option_type, name: 'Brand') }

    before do
      2.times { option_type.option_values.create(attributes_for(:option_value)) }
    end

    it '引数にSpree::OptionTypeのname属性をStringで渡すと、該当するSpree::OptionTypteモデルの.option_valuesを返す' do
      expect(option_values('Brand')).to eq option_type.option_values
    end
  end
end
