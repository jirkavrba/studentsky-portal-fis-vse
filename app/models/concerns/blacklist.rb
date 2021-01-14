# frozen_string_literal: true

module Blacklist
  def blacklist
    @blacklist ||= File.readlines(Rails.root.join('lib', 'blacklist.txt')).map(&:strip)
  end
end
