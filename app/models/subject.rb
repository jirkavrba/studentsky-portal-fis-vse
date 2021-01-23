# frozen_string_literal: true

class Subject < ApplicationRecord
  has_many :testers

  validates :name, :code, presence: true
  validates_uniqueness_of :code, scope: :id
end
