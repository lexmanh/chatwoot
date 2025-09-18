# OmniAuth configuration
# Sets the full host URL for callbacks and proper redirect handling
OmniAuth.config.full_host = ENV.fetch('FRONTEND_URL', 'http://localhost:3000')

Rails.application.config.middleware.use OmniAuth::Builder do
  # Google OAuth2
  provider :google_oauth2,
           ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil),
           ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil),
           {
             provider_ignores_state: true
           }

  # UEF ID OAuth2
  provider :uefid,
           ENV.fetch('UEF_SSO_CLIENT_ID', nil),
           ENV.fetch('UEF_SSO_CLIENT_SECRET', nil),
           client_options: {
             # any other options such as site, authorize_url, token_url can be configured here
           }
end
