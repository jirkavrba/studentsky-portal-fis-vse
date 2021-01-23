class AddQuestionsToTesters < ActiveRecord::Migration[6.1]
  def change
    add_column :testers, :questions, :json, null: true
  end
end
