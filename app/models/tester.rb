class Tester < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates_presence_of :subject_id, :user_id, :is_public
end
