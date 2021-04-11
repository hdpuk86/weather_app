class Forecast < ApplicationRecord
  ACCEPTED_COUNTRIES = ['UK'].freeze

  validates :postcode, presence: true
  validates_with UkPostcodeValidator
  before_create :perform_forecast

  def heat_rating
    ratings = HeatRating.where('? BETWEEN min_temp AND max_temp', self.max_temp)
    return unless ratings.present?

    ratings.first.name
  end

  private

  def perform_forecast
    begin
      forecast_data = WeatherServices::Forecaster.new(self.postcode).perform
      self.country = forecast_data.dig('location', 'country') || ''
      validate_country!

      forecastday = forecast_data.dig('forecast', 'forecastday') || [{}]
      self.max_temp = forecastday.first.dig('day', 'maxtemp_c')
    rescue WeatherServicesError => e
      self.errors.add(:service, "error: #{e}")
      throw(:abort)
    end
  end

  def validate_country!
    unless ACCEPTED_COUNTRIES.include?(self.country)
      self.errors.add(:postcode, "country is not accepted")
      throw(:abort)
    end
  end
end
