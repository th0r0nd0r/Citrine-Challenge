class UnitsController < ApplicationController
  def si
    units = params[:units]
    @units = Unit.convert(units)
    if @units
      render json: @units
    else
      render json: ["Invalid Query"], status: 422
    end
  end

  def unit_params
    params.require(:unit).permit(:units)
  end
end
