# frozen_string_literal: true

class AddIsPublicToCharts < ActiveRecord::Migration[6.1]
  def change
    add_column :charts, :is_public, :boolean
  end
end
