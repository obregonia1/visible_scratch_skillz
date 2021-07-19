require "test_helper"

class ChartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chart = charts(:one)
  end

  test "should get index" do
    get charts_url
    assert_response :success
  end

  test "should get new" do
    get new_chart_url
    assert_response :success
  end

  test "should create chart" do
    assert_difference('Chart.count') do
      post charts_url, params: { chart: { chart_code: @chart.chart_code, title: @chart.title } }
    end

    assert_redirected_to chart_url(Chart.last)
  end

  test "should show chart" do
    get chart_url(@chart)
    assert_response :success
  end

  test "should get edit" do
    get edit_chart_url(@chart)
    assert_response :success
  end

  test "should update chart" do
    patch chart_url(@chart), params: { chart: { chart_code: @chart.chart_code, title: @chart.title } }
    assert_redirected_to chart_url(@chart)
  end

  test "should destroy chart" do
    assert_difference('Chart.count', -1) do
      delete chart_url(@chart)
    end

    assert_redirected_to charts_url
  end
end
