class UsersController < ApplicationController
  def show
    @charts = current_user.charts
  end
end
