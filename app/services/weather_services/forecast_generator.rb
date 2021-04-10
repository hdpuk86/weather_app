module WeatherServices
  class ForecastGenerator
    attr_reader :postcode
    attr_reader :days

    def initialize(postcode, days = 0)
      @postcode = postcode
      @days = days
    end

    def perform
      response = HTTParty.get('http://api.weatherapi.com/v1/forecast.json', {
        query: {
          key: WEATHER_API_KEY,
          q: self.postcode,
          days: self.days
        }
      })
      response_body = JSON.parse(response.body)

      if response.ok?
        response_body
      else
        response_body.dig('error')
      end
    end
  end
end
