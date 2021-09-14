require 'rails_helper'

RSpec.describe ImageBlob, type: :model do
  before do
    image = "#{Rails.root}/spec/fixtures/files/baby.png"
    @encoded_image = Base64.encode64(image)
    mime_type = 'image/png'
    @image_data_url = "data:#{mime_type};base64,#{@encoded_image}"
  end

  let!(:image_blob) { ImageBlob.new(@image_data_url) }

  it 'mime_typeの返り値が正常' do
    expect(image_blob.mime_type).to eq 'image/png'
  end

  it 'to_ioの返り値がStringIOクラスになっている' do
    expect(image_blob.to_io.class).to eq StringIO
  end

  it 'contentの戻り値が正常' do
    expect(image_blob.send(:content)).to eq @encoded_image
  end
end
