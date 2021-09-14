# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :set_chart, only: %i[show update destroy]

  # GET /charts or /charts.json
  def index
    @charts = Chart.order(created_at: :desc).page params[:page]
  end

  # GET /charts/1 or /charts/1.json
  def show; end

  # GET /charts/new
  def new
    @chart = Chart.new
  end

  # POST /charts or /charts.json
  def create
    @chart = Chart.new(chart_params)
    @chart.attach_blob(image_data_url)

    respond_to do |format|
      if @chart.save
        format.html { redirect_to current_user, notice: 'Saved!' }
        format.json { render :show, status: :created, location: @chart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /charts/1 or /charts/1.json
  def update
    respond_to do |format|
      if @chart.update(chart_params)
        @chart.attach_blob(image_data_url)
        format.html { redirect_to current_user, notice: 'Updated!' }
        format.json { render :show, status: :ok, location: @chart }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1 or /charts/1.json
  def destroy
    @chart.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Deleted!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chart
    @chart = Chart.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def chart_params
    params.require(:chart).permit(:title, :chart_code).merge(user_id: current_user.id)
  end

  def image_data_url
    params.require(:chart).permit(:image)[:image]
  end
end
