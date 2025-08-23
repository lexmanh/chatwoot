Rails.application.config.middleware.use OmniAuth::Builder do
  # Google OAuth2
  provider :google_oauth2, ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil), ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil), {
    provider_ignores_state: true
  }

  # UEF SSO (based on Keycloak)
  provider :keycloak_openid, ENV.fetch('UEF_SSO_CLIENT_ID', nil), ENV.fetch('UEF_SSO_CLIENT_SECRET', nil),
           client_options: { site: ENV.fetch('UEF_SSO_URL', nil), realm: ENV.fetch('UEF_SSO_REALM', nil),  base_url: '' },
           name: 'keycloak'
end
