module UEFIDConcern
  extend ActiveSupport::Concern

  def uef_id_client
    app_id = GlobalConfigService.load('UEF_ID_OAUTH_CLIENT_ID', nil)
    app_secret = GlobalConfigService.load('UEF_ID_OAUTH_CLIENT_SECRET', nil)
    app_realm = GlobalConfigService.load('UEF_ID_OAUTH_REALM', nil)

    ::OAuth2::Client.new(app_id, app_secret, {
                           site: 'https://sso.uef.edu.vn',
                           authorize_url: "https://sso.uef.edu.vn/realms/#{app_realm}/protocol/openid-connect/auth",
                           token_url: "https://sso.uef.edu.vn/realms/#{app_realm}/protocol/openid-connect/token"
                         })
  end

  private

  def scope
    'email profile openid'
  end
end
