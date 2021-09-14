# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "vss#{n}@example.com" }
    password { 'password' }
    username { 'Alice' }
  end
end
