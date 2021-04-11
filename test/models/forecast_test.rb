require "test_helper"

class ForecastTest < ActiveSupport::TestCase
  def setup
    @postcode = 'gl1 1ga'
  end

  def test_can_create
    stub_forcaster_api!(country: 'UK', max_temp: 10.4, postcode: @postcode)

    assert Forecast.create(postcode: @postcode)
  end

  def test_country_must_be_in_accepted_countries_list
    stub_forcaster_api!(country: 'AUS', max_temp:  10.4, postcode: @postcode)

    invalid_country = Forecast.new(postcode: @postcode)
    assert_not invalid_country.save
    assert_equal 'Postcode country is not accepted', invalid_country.errors.full_messages.first
  end

  def test_postcode_must_be_present
    stub_forcaster_api!(country: 'UK', max_temp: 10.4, postcode: '')

    no_postcode = Forecast.new
    assert_not no_postcode.save
    assert_equal 'Postcode can\'t be blank', no_postcode.errors.full_messages.first
  end

  def test_UK_postcode_format_is_validated
    stub_forcaster_api!(country: 'UK', max_temp: 10.4, postcode: '1111')

    invalid = Forecast.new(postcode: '1111')
    invalid.save
    assert_equal 'Postcode must be in a valid UK format', invalid.errors.full_messages.first
  end

  def test_has_service_error_message_if_service_fails
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: @postcode,
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 400, body: JSON.generate(error: {
        code: '1010',
        message: 'something went wrong'
      }))

    forecast = Forecast.create(postcode: @postcode)

    assert_not forecast.save
    assert_equal 'Service error: something went wrong', forecast.errors.full_messages.first
  end

  def test_heat_rating__cold
    expected_heat_rating = heat_ratings(:cold)
    stub_forcaster_api!(country: 'UK', max_temp: expected_heat_rating.max_temp - 1, postcode: @postcode)

    forecast = Forecast.create(postcode: @postcode)

    assert_equal expected_heat_rating.name, forecast.heat_rating
  end

  def test_heat_rating__warm
    expected_heat_rating = heat_ratings(:warm)
    stub_forcaster_api!(country: 'UK', max_temp: expected_heat_rating.max_temp - 1, postcode: @postcode)

    forecast = Forecast.create(postcode: @postcode)

    assert_equal expected_heat_rating.name, forecast.heat_rating
  end

  def test_heat_rating__hot
    expected_heat_rating = heat_ratings(:hot)
    stub_forcaster_api!(country: 'UK', max_temp: expected_heat_rating.max_temp - 1, postcode: @postcode)

    forecast = Forecast.create(postcode: @postcode)

    assert_equal expected_heat_rating.name, forecast.heat_rating
  end

  private

  def stub_forcaster_api!(country:, max_temp:, postcode:)
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: postcode,
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 200, body: JSON.generate(response_data(country, max_temp)))
  end

  def response_data(country, temp)
    {
      location: {
        country: country
      },
      forecast: {
        forecastday: [{
          day: {
            maxtemp_c: temp
          }
        }]
      }
    }
  end
end
