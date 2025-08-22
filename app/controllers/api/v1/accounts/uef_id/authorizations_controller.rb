class Api::V1::Accounts::UEF::AuthorizationsController < Api::V1::Accounts::OauthAuthorizationController
  include UEFIDConcern

  def create
    redirect_url = uef_id_client.auth_code.authorize_url(
      {
        redirect_uri: "#{base_url}/uef_id/callback",
        scope: scope,
        response_type: 'code',
        prompt: 'consent', # the oauth flow does not return a refresh token, this is supposed to fix it
        access_type: 'offline', # the default is 'online'
        state: state,
        client_id: GlobalConfigService.load('UEF_ID_OAUTH_CLIENT_ID', nil)
      }
    )

    if redirect_url
      render json: { success: true, url: redirect_url }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
end
