# frozen_string_literal: true

class Subject < ApplicationRecord
  has_many :testers

  validates_presence_of :name, :code
  validates_uniqueness_of :code, scope: :id
end
