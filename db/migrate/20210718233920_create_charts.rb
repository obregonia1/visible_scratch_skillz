# frozen_string_literal: true

class CreateCharts < ActiveRecord::Migration[6.1]
  def change
    create_table :charts do |t|
      t.string :title
      t.text :chart_code

      t.timestamps
    end
  end
end
