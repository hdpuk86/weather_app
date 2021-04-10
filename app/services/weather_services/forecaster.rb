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
      JSON.parse(response.body)
    end

    private

    attr_reader :postcode, :days
  end
end
