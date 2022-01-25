# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :set_chart, only: %i[show update destroy]

  def show
    redirect_to root_path, alert: 'Requested page required login.' unless user_signed_in?
  end

  def new
    @chart = Chart.new
  end

  def create
    @chart = Chart.new(chart_params)
    @chart.attach_blob(image_data_url)

    if @chart.save
      redirect_to current_user, notice: 'Saved!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @chart.update(chart_params)
      @chart.attach_blob(image_data_url)
      redirect_to current_user, notice: 'Updated!'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @chart.destroy
    redirect_to current_user, notice: 'Deleted!'
  end

  private

  def set_chart
    @chart = Chart.find(params[:id])
  end

  def chart_params
    params.require(:chart).permit(:title, :chart_code, :is_public).merge(user_id: current_user.id)
  end

  def image_data_url
    params.require(:chart).permit(:image)[:image]
  end
end
