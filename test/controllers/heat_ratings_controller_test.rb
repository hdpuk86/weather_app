require "test_helper"

class HeatRatingsControllerTest < ActionDispatch::IntegrationTest
  def test_should_get_edit
    get edit_heat_rating_url(heat_ratings(:cold))
    assert_response :success
  end

  def test_should_update
    heat_rating = HeatRating.create!(name: 'editme', min_temp: 0, max_temp: 10)
    patch heat_rating_url(heat_rating), params: { heat_rating: {
        min_temp: -20,
        max_temp: 20
      }
    }

    heat_rating.reload

    assert_redirected_to edit_heat_rating_url(heat_rating)
    assert_equal -20, heat_rating.min_temp
    assert_equal 20, heat_rating.max_temp
  end
end
