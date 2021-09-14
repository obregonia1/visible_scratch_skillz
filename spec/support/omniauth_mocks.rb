# frozen_string_literal: true

module OmniauthMocks
  def twitter_mock
    OmniAuth.config.mock_auth[:twitter] =
      OmniAuth::AuthHash.new({
                               provider: 'twitter',
                               uid: '123545',
                               info: {
                                 name: 'Twitter',
                                 email: 'alice@example.com'
                               }
                             })
  end
end
