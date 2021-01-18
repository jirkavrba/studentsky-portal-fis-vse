# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def sign_out
      get logout_url
    end

    def sign_in_as(name)
      user = users(name)

      post sign_in_url, params: {
        # Username is matched with the name, because it's actually stored as RipeMD160 hash
        username: user.name,
        password: name
      }
    end
  end
end
