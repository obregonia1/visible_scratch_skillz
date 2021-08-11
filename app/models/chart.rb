class Chart < ApplicationRecord
  attr_accessor :edit
  has_one :image
end
