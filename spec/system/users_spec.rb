# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User', type: :system do
  context 'サインアップ' do
    scenario 'サインアップの成功' do
      visit '/users/sign_up'
      expect(current_path).to eq '/users/sign_up'
      fill_in 'Email', with: 'alice@example.com'
      fill_in 'Password', with: 'testtest'
      fill_in 'Password confirmation', with: 'testtest'
      within '.actions' do
        click_button 'Sign up'
      end
      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end

  scenario 'メールアドレスとパスワードでログイン' do
    user = create(:user)
    visit new_user_session_path
    expect(current_path).to eq '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within '.actions' do
      click_button 'Log in'
    end
    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'twitterログイン' do
    twitter_mock
    visit new_user_session_path
    within '.vss-devise-links' do
      click_on 'Sign in with Twitter'
    end
    visit current_path
    twitter_login_user = User.find_by(provider: 'twitter')
    expect(page).to have_content("#{twitter_login_user.username}'s Routines")
  end
end
