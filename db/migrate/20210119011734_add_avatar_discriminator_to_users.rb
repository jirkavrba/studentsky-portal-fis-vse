# frozen_string_literal: true

class AddAvatarDiscriminatorToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :avatar_discriminator, :string, default: ''
  end
end
