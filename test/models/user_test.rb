# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email should return email when user has not name' do
    user = User.new(email: 'alice@example.com', name: '')
    assert_equal 'alice@example.com', user.name_or_email
  end

  test '#name_or_email should return name when user has name' do
    user = User.new(email: 'alice@example.com', name: 'Alice')
    assert_equal 'Alice', user.name_or_email
  end
end
