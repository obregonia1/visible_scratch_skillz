# frozen_string_literal: true

require 'application_system_test_case'

class ChartsTest < ApplicationSystemTestCase
  setup do
    @chart = charts(:one)
  end

  test 'visiting the index' do
    visit charts_url
    assert_selector 'h1', text: 'Charts'
  end

  test 'creating a Chart' do
    visit charts_url
    click_on 'New Chart'

    fill_in 'Chart code', with: @chart.chart_code
    fill_in 'Title', with: @chart.title
    click_on 'Create Chart'

    assert_text 'Chart was successfully created'
    click_on 'Back'
  end

  test 'updating a Chart' do
    visit charts_url
    click_on 'Edit', match: :first

    fill_in 'Chart code', with: @chart.chart_code
    fill_in 'Title', with: @chart.title
    click_on 'Update Chart'

    assert_text 'Chart was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Chart' do
    visit charts_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Chart was successfully destroyed'
  end
end
