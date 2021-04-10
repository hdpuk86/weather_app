class HeatRatingsController < ApplicationController
  before_action :set_heat_rating

  def edit
  end

  def update
    if @heat_rating.update(heat_rating_params)
      redirect_to edit_heat_rating_url(@heat_rating)
    else
      render :edit
    end
  end

  private

  def set_heat_rating
    @heat_rating = HeatRating.find(params[:id])
  end

  def heat_rating_params
    params.require(:heat_rating).permit(:min_temp, :max_temp, :name)
  end
end
