class AddUserIdToChart < ActiveRecord::Migration[6.1]
  def change
    add_reference :charts, :user, null: false, foreign_key: true
  end
end
