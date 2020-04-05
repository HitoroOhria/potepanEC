require 'rails_helper'

RSpec.describe "helpers/application_helper.rb", type: :view do
  describe 'full_title' do
    it "文字列を引数に取ると、サイト名と結合した文字列を返す" do
      expect(full_title('bags')).to eq 'bags | BIGBAG store'
    end
    it "数字を引数に取ると、サイト名と結合した文字列を返す" do
      expect(full_title(123)).to eq '123 | BIGBAG store'
    end
    it "nilを引数に取ると、サイト名のみの文字列を返す" do
      expect(full_title(nil)).to eq 'BIGBAG store'
    end
    it "空白文字を引数に取ると、サイト名のみの文字列を返す" do
      expect(full_title('')).to eq 'BIGBAG store'
    end
  end
end
