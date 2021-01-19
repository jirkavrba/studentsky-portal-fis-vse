# frozen_string_literal: true

class DiscordServer < ApplicationRecord
  validates :priority, numericality: { greater_than: 0 }
  validates :embed_url, :invite_url, :priority, presence: true
  validates_uniqueness_of :embed_url, :invite_url, scope: :id
end
