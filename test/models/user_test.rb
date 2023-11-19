# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email should return email when user has not name' do
    user = User.new(email: 'foo@example.com', name: '')
    assert_equal 'foo@example.com', user.name_or_email
  end

  test '#name_or_email should return name when user has name' do
    user = User.new(email: 'foo@example.com', name: 'Foo Bar')
    assert_equal 'Foo Bar', user.name_or_email
  end
end
