# frozen_string_literal: true

class ChangeColmunToChart < ActiveRecord::Migration[6.1]
  def change
    change_column_null :charts, :title, false
  end
end
