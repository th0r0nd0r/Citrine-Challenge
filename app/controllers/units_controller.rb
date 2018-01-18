class UnitsController < ApplicationController
  def show
    units = params[:units]
    @units = Unit.convert(units)
    render :show
  end

  def unit_params
    params.require(:unit).permit(:units)
  end
end
