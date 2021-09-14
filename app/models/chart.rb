# frozen_string_literal: true

class Chart < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, length: { maximum: 50 }
  validates :title, presence: true

  def attach_blob(image_data_url)
    image_blob = ImageBlob.new(image_data_url)
    image.attach(
      io: image_blob.to_io,
      filename: Time.zone.now,
      content_type: image_blob.mime_type
    )
  end
end
