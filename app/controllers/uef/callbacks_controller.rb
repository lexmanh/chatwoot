class UEF::CallbacksController < OauthCallbackController
  include UEFConcern

  def find_channel_by_email
    # find by imap_login first, and then by email
    # this ensures the legacy users can migrate correctly even if inbox email address doesn't match
    imap_channel = Channel::Email.find_by(imap_login: users_data['email'], account: account)
    return imap_channel if imap_channel

    Channel::Email.find_by(email: users_data['email'], account: account)
  end

  private

  def provider_name
    'uef'
  end

  # using AWS SES
  def imap_address
    'imap.uef.edu.vn'
  end

  def oauth_client
    # from UEFConcern
    uef_client
  end
end
