class Tester < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates_presence_of :subject_id, :user_id, :questions, :is_public
  validates :questions, json: { schema: "#{Rails.root}/app/models/schemas/tester_questions.json" }

  scope :visible_by, -> (user) { Tester.where(user_id: user.id).or(Tester.where(is_public: true)) }
end
