# frozen_string_literal: true

FactoryBot.define do
  factory :chart do
    title { 'Baby' }
    chart_code { '[{"trick":"baby","pattern":"forward","beatLength":6,"beatPosition":0}]' }
    association :user
  end
end
