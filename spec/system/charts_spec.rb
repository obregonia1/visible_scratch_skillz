# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Chart', type: :system do
  context 'ログイン無しで作成' do
    background { visit new_chart_path }

    scenario 'Saveボタンの非表示' do
      expect(page).to_not have_content('Save')
    end

    scenario '画像エクスポートボタンをクリック' do
      fill_in 'Title', with: 'Baby'
      first('.vss-export').click
      expect(find_by_id('img').visible?).to be_truthy
    end
  end

  context 'ログインユーザー' do
    background do
      visit new_user_session_path
      user = create(:user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      within '.actions' do
        click_button 'Log in'
      end
      visit new_chart_path
    end

    scenario 'Saveボタンが表示されている' do
      expect(page).to have_content('Save')
    end

    scenario 'Titleが空文字の場合保存できない' do
      first(:css, '.vss-save').click
      expect(page).to have_content("Title is too short")
    end

    scenario 'Chartの保存成功' do
      fill_in 'Title', with: 'Baby'
      first(:css, '.vss-save').click
      expect(page).to have_content('Saved!')
    end

    context 'Chart保存後' do
      background do
        fill_in 'Title', with: 'Baby'
        first(:css, '.vss-save').click
      end

      scenario 'Chartの編集、更新の成功' do
        within '.chart-title' do
          click_on 'Baby'
        end
        within '.vss-chart-edit' do
          first(:css, '.edit').click
        end
        fill_in('Title', with: 'Chirp', fill_options: { clear: :backspace })
        first(:css, '.vss-save').click
        expect(page).to have_content('Chirp')
      end

      scenario 'Chartの削除成功', js: true do
        within '.chart-title' do
          click_on 'Baby'
        end
        within '.vss-chart-edit' do
          click_on 'Delete'
        end
        page.accept_confirm
        expect(page).to have_content('Deleted!')
      end
    end
  end

  context '非ログインユーザー' do
    scenario 'chart詳細ページにアクセス' do
      chart = create(:chart)
      visit chart_path(chart)
      expect(page).to have_content('Requested page required login.')
    end
  end
end
