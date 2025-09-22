module UefConcern
  extend ActiveSupport::Concern

  def uef_client
    app_id = GlobalConfigService.load('UEF_SSO_CLIENT_ID', nil)
    app_secret = GlobalConfigService.load('UEF_SSO_CLIENT_SECRET', nil)

    ::OAuth2::Client.new(app_id, app_secret, {
                           site: 'https://sso.uef.edu.vn  ',
                           authorize_url: '/realms/university/protocol/openid-connect/auth',
                           token_url: '/realms/university/protocol/openid-connect/token'
                         })
  end

  private

  def scope
    'email profile openid'
  end
end
