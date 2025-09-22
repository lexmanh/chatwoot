class Uef::CallbacksController < OauthCallbackController
  include UefConcern

  private

  def provider_name
    'uef'
  end

  def oauth_client
    # from UefConcern
    uef_client
  end
end
