# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @charts = @user.charts
                   .with_attached_image
                   .order(created_at: :desc)
                   .page(params[:page])
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
