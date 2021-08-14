class Chart < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def attach_blob(image_params)
    image_extension = to_extension(image_params)
    contents = image_params.sub %r/data:image\/.{3,},/, ''
    decoded_data = Base64.decode64(contents)
    filename = Time.zone.now.to_s + '.' + image_extension
    io = StringIO.new(decoded_data)
    image.attach(io: io, filename: filename, content_type: to_mime_type(image_params))
  end

  private

  def to_extension(image_params)
    content_type = to_mime_type(image_params)
    content_type[%r/\b(?!.*\/).*/]
  end

  def to_mime_type(image_params)
    image_params[%r/(image\/[a-z]{3,4})/]
  end
end
