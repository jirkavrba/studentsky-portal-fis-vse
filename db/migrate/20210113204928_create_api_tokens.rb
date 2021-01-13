class CreateApiTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :api_tokens do |t|
      t.string :name, null: true
      t.string :value, unique: true
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
