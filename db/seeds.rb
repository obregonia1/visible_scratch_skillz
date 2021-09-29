# frozen_string_literal: true

require 'factory_bot'

2.times { FactoryBot.create(:user) }

3.times do |n|
  FactoryBot.create(:chart, title: "Baby_#{1 + n}", user: User.first)
  FactoryBot.create(
    :chart,
    title: "Chirp_#{1 + n}",
    user: User.first,
    chart_code:
      <<~CODE
        [{\"trick\":\"chirp\",\"pattern\":\"forward\",\"beatLength\":6,\"beatPosition\":0,\"faderPositions\":[6]},
        {\"trick\":\"chirp\",\"pattern\":\"backward\",\"beatLength\":6,\"beatPosition\":6,\"faderPositions\":[0]},
        {\"trick\":\"chirp\",\"pattern\":\"forward\",\"beatLength\":6,\"beatPosition\":12,\"faderPositions\":[6]},
        {\"trick\":\"chirp\",\"pattern\":\"backward\",\"beatLength\":6,\"beatPosition\":18,\"faderPositions\":[0]}]
      CODE
  )
end
