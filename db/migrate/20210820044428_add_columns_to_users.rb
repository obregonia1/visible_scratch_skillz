# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :users, :provider
      t.string :users, :uid
      t.string :users, :username
    end
  end
end
