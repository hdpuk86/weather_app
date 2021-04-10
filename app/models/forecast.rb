class Forecast < ApplicationRecord
  ACCEPTED_COUNTRIES = ['UK'].freeze
  before_validation :perform_forecast, on: :create

  validates :postcode, presence: true
  validates_with UkPostcodeValidator
  validates :max_temp, numericality: true
  validates :country, inclusion: { in: ACCEPTED_COUNTRIES, message: 'is not accepted' }

  def heat_rating
    ratings = HeatRating.where('? BETWEEN min_temp AND max_temp', self.max_temp)
    return unless ratings.present?

    ratings.first.name
  end

  private

  def perform_forecast
    forecast_data = WeatherServices::Forecaster.new(self.postcode).perform
    error_message = forecast_data.dig('error', 'message')
    self.errors.add(:service, error_message) if error_message.present?

    self.country = forecast_data.dig('location', 'country') || ''
    forecastday = forecast_data.dig('forecast', 'forecastday') || [{}]
    self.max_temp = forecastday.first.dig('day', 'maxtemp_c')
  end
end
