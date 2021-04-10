class ForecastsController < ApplicationController
  def index
    @forecasts = Forecast.all
  end

  def new
    @forecast = Forecast.new
  end

  def create
    @forecast = Forecast.new(forecast_params)

    if @forecast.save
      redirect_to forecasts_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def forecast_params
    params.require(:forecast).permit(:postcode)
  end
end
