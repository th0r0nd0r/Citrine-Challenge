class UnitsController < ApplicationController
  def show
    units = params[:units]
    Unit.convert(units)

  end

  def unit_params
    params.require(:unit).permit(:units)
  end
end
