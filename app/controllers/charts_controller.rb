# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :set_chart, only: %i[show update destroy]

  def index
    @charts = Chart.order(created_at: :desc).page params[:page]
  end

  def show; end

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
    params.require(:chart).permit(:title, :chart_code).merge(user_id: current_user.id)
  end

  def image_data_url
    params.require(:chart).permit(:image)[:image]
  end
end
