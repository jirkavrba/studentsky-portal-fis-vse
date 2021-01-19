class AddPasswordResetTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_reset_token, :string, null: true
  end
end
