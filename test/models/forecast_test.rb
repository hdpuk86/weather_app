require "test_helper"

class ForecastTest < ActiveSupport::TestCase
  def setup
    @postcode = 'gl1 1ga'
  end

  def test_can_create
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: @postcode,
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 200, body: JSON.generate(response_data('UK', 10.4)))

    assert Forecast.create(postcode: @postcode)
  end

  def test_country_must_be_in_accepted_countries_list
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: @postcode,
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 200, body: JSON.generate(response_data('AUS', 10.4)))

    invalid_country = Forecast.new(postcode: @postcode)
    assert_not invalid_country.save
    assert_equal 'Country is not accepted', invalid_country.errors.full_messages.first
  end

  def test_max_temp_must_be_present
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: @postcode,
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 200, body: JSON.generate(response_data('UK', nil)))

    no_max_temp = Forecast.new(postcode: @postcode)
    assert_not no_max_temp.save
    assert_equal 'Max temp is not a number', no_max_temp.errors.full_messages.first
  end

  def test_max_temp_must_be_numeric
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: @postcode,
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 200, body: JSON.generate(response_data('UK', 'invalid')))

    no_max_temp = Forecast.new(postcode: @postcode, max_temp: 'max_temp')
    assert_not no_max_temp.save
    assert_equal 'Max temp is not a number', no_max_temp.errors.full_messages.first
  end

  def test_postcode_must_be_present
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: '',
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 200, body: JSON.generate(response_data('UK', 10.4)))

    no_postcode = Forecast.new
    assert_not no_postcode.save
    assert_equal 'Postcode can\'t be blank', no_postcode.errors.full_messages.first
  end

  def test_UK_postcode_format_is_validated
    stub_request(:get, 'http://api.weatherapi.com/v1/forecast.json')
      .with(query: {
        q: '1111',
        days: '0',
        key: WEATHER_API_KEY
      })
      .to_return(status: 200, body: JSON.generate(response_data('UK', 10.4)))

    invalid = Forecast.new(postcode: '1111')
    invalid.save
    assert_equal 'Postcode must be in a valid UK format', invalid.errors.full_messages.first
  end

  private

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

  def error_data
    {
      error: {
        code: '1010',
        message: 'Something went wrong'
      }
    }
  end
end
