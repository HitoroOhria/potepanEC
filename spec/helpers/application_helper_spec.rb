require 'rails_helper'

RSpec.describe "helpers/application_helper.rb", type: :helper do
  describe 'full_title(page_title)' do
    context '引数がStringの時' do
      it 'ベースタイトルと結合した文字列を返す' do
        expect(full_title('bags')).to eq 'bags | BIGBAG store'
      end
    end

    context '引数がIntegerの時' do
      it 'ベースタイトルと結合した文字列を返す' do
        expect(full_title(123)).to eq '123 | BIGBAG store'
      end
    end

    context '引数が空文字の時' do
      it 'ベースタイトルのみの文字列を返す' do
        expect(full_title('')).to eq 'BIGBAG store'
      end
    end

    context '引数がnilの時' do
      it 'ベースタイトルのみの文字列を返す' do
        expect(full_title(nil)).to eq 'BIGBAG store'
      end
    end
  end
end
