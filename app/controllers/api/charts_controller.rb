# frozen_string_literal: true

class Api::ChartsController < Api::BaseController
  def show
    @chart = Chart.find(params[:id])
  end
end
