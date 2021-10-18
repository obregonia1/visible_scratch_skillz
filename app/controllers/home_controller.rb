# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to current_user
  end

  def privacy_policy; end

  def tos; end
end
