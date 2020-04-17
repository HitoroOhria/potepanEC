require 'rails_helper'

RSpec.describe "helpers/potepan/categories_helper.rb", type: :helper do
  let(:option_type) { create(:option_type) }
  before do
    2.times { option_type.option_values.create(attributes_for(:option_value)) }
  end

  describe 'take_option_values(option_type_name)' do
    it '引数にSpree::OptionTypeのname属性をStringで渡すと、該当するSpree::OptionTypteモデルの.option_valuesを返す' do
      expect(option_values(option_type.name)).to eq option_type.option_values
    end
  end
end
