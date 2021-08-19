# frozen_string_literal: true

module UsersHelper
  def to_embed(url, title)
    "<img src='#{url}' alt='#{title}'>"
  end
end
