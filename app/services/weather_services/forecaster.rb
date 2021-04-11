module WeatherServices
  class Forecaster
    def initialize(postcode, days = 0)
      @postcode = postcode
      @days = days
    end

    def perform
      response = HTTParty.get('http://api.weatherapi.com/v1/forecast.json', {
        query: {
          key: WEATHER_API_KEY,
          q: postcode,
          days: days
        }
      })
      if response.success?
        JSON.parse(response.body)
      else
        error_message = JSON.parse(response.body).dig('error', 'message')
        Rails.logger.error("WeatherServices::Forecaster - Response Code: #{response.code}, Error: #{error_message}")
        raise WeatherServicesError.new(error_message)
      end
    end

    private

    attr_reader :postcode, :days
  end
end
