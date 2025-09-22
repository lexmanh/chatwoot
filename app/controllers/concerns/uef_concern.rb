# UEF Integration
# This module provides methods to interact with the UEF OAuth2 client.
module UefConcern
  extend ActiveSupport::Concern

  included do
    helper_method :uef_client
  end

  def uef_client
    @uef_client ||= OAuth2::Client.new(
      ENV.fetch('UEF_SSO_CLIENT_ID', nil),
      ENV.fetch('UEF_SSO_CLIENT_SECRET', nil),
      site: ENV.fetch('UEF_SSO_SITE', 'https://sso.uef.edu.vn'),
      authorize_url: '/realms/university/protocol/openid-connect/auth',
      token_url: '/realms/university/protocol/openid-connect/token'
    )
  end
end
