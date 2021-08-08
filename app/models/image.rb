class Image < ApplicationRecord
  belongs_to :chart, optional: true

  has_one_attached :image
end
