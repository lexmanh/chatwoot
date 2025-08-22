# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2, ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil), ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil), {
#     provider_ignores_state: true
#   }
# end

Rails.application.config.middleware.use OmniAuth::Builder do
  # Google OAuth2 Provider
  provider :google_oauth2,
           ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil),
           ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil),
           provider_ignores_state: true

  # UEF ID Provider (Keycloak)
  provider :keycloak_openid,
           ENV.fetch('UEF_ID_OAUTH_CLIENT_ID', nil),
           ENV.fetch('UEF_ID_OAUTH_CLIENT_SECRET', nil),
           provider_ignores_state: true
end

# OmniAuth.config.logger = Rails.logger
# OmniAuth.config.path_prefix = '/auth'
