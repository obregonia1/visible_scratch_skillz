# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chart, type: :model do
  it 'タイトルの文字数が有効である' do
    user = create(:user)
    chart = build(:chart)
    chart.user = user
    expect(chart).to be_valid
  end

  it 'タイトルの文字数が無効である' do
    user = create(:user)
    chart = build(:chart, title: 'a' * 51)
    chart.user = user
    expect(chart).to_not be_valid
  end
end
