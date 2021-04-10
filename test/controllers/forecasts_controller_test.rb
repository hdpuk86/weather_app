require "test_helper"

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  def test_should_get_new
    get new_forecast_url
    assert_response :success
  end

  def test_should_get_index
    get forecasts_url
    assert_response :success
  end
end
