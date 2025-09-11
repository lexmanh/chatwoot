# OmniAuth configuration
# Sets the full host URL for callbacks and proper redirect handling
OmniAuth.config.full_host = ENV.fetch('FRONTEND_URL', 'http://localhost:3000')

Rails.application.config.middleware.use OmniAuth::Builder do
  # OmniAuth.config.allowed_request_methods = [:get]
  # # Google OAuth2
  # provider :google_oauth2,
  #          ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil),
  #          ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil),
  #          {
  #            provider_ignores_state: true
  #          }

  # UEF SSO (based on Keycloak)
  # provider :keycloak_openid,
  #          ENV.fetch('UEF_SSO_CLIENT_ID', nil),
  #          ENV.fetch('UEF_SSO_CLIENT_SECRET', nil),
  #          client_options: {
  #            site: ENV.fetch('UEF_SSO_URL', nil),
  #            realm: ENV.fetch('UEF_SSO_REALM', nil),
  #            base_url: ''
  #          },
  #          name: 'uef'

  # Using custom omniauth strategy for UEF ID
  provider :uefid,
           ENV.fetch('UEF_SSO_CLIENT_ID', nil),
           ENV.fetch('UEF_SSO_CLIENT_SECRET', nil),
           client_options: {
             site: ENV.fetch('UEF_SSO_URL', nil),
             realm: ENV.fetch('UEF_SSO_REALM', nil),
             base_url: '',
            #  redirect_uri: ENV.fetch('UEF_SSO_CALLBACK_URL', nil)
           },
           name: 'uef',
           scope: 'openid email profile',
           strategy_class: OmniAuth::Strategies::UefId,
           skip_jwt: ENV.fetch('UEF_SSO_SKIP_JWT', 'false') == 'true'

end
