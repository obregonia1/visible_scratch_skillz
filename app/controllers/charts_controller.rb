class ChartsController < ApplicationController
  before_action :set_chart, only: %i[ show edit update destroy ]

  # GET /charts or /charts.json
  def index
    @charts = Chart.all
  end

  # GET /charts/1 or /charts/1.json
  def show
  end

  # GET /charts/new
  def new
    @chart = Chart.new
  end

  # GET /charts/1/edit
  def edit
  end

  # POST /charts or /charts.json
  def create
    @chart = Chart.new(chart_params)

    respond_to do |format|
      if @chart.save
        format.html { redirect_to @chart, notice: "Chart was successfully created." }
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
        format.html { redirect_to @chart, notice: "Chart was successfully updated." }
        format.json { render :show, status: :ok, location: @chart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1 or /charts/1.json
  def destroy
    @chart.destroy
    respond_to do |format|
      format.html { redirect_to charts_url, notice: "Chart was successfully destroyed." }
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
      params.require(:chart).permit(:title, :chart_code, :image)
    end
end
