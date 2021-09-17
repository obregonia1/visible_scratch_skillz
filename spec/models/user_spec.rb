# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'メールアドレス、パスワードが有効である' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'メールアドレスが無い場合無効である' do
    user = FactoryBot.build(:user, email: '')
    expect(user).to_not be_valid
  end

  it 'メールアドレスが重複する場合は無効である' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.build(:user, email: user1.email)
    expect(user2).to_not be_valid
  end

  it 'ユーザー名がない場合でも有効である' do
    user = FactoryBot.build(:user, username: nil)
    expect(user).to be_valid
  end

  it 'ユーザー名がない場合はname_or_emailはメールアドレスを返す' do
    user = FactoryBot.build(:user, username: '')
    expect(user.name_or_email).to eq user.email
  end
end
