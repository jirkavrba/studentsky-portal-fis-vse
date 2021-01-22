class CreateTesters < ActiveRecord::Migration[6.1]
  def change
    create_table :testers do |t|
      t.integer :user_id
      t.integer :subject_id, null: true, default: nil
      t.string  :title, null: true
      t.boolean :is_public, default: true

      t.timestamps
    end
  end
end
