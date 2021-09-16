# frozen_string_literal: true

FactoryBot.define do
  factory :chart do
    title { 'Baby' }
    chart_code {
      <<~CODE
        [{"trick":"baby","pattern":"forward","beatLength":6,"beatPosition":0},
        {"trick":"baby","pattern":"backward","beatLength":6,"beatPosition":6},
        {"trick":"baby","pattern":"forward","beatLength":6,"beatPosition":12},
        {"trick":"baby","pattern":"backward","beatLength":6,"beatPosition":18}]
      CODE
    }
    after(:create) do |chart|
      title_image = chart.title.downcase.sub /_\d/, ''
      chart.image.attach(io: File.open("spec/fixtures/files/#{title_image}.png"), filename: "#{title_image}.png", content_type: 'image/png')
    end
    association :user
  end
end
