# frozen_string_literal: true

class API::ChartsController < API::BaseController
  def show
    @chart = Chart.find(params[:id])
  end
end
