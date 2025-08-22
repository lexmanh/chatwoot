require 'rails_helper'

RSpec.describe 'DeviseOverrides::OmniauthCallbacksController', type: :request do
  let(:account_builder) { double }
  let(:user_double) { object_double(:user) }
  let(:email_validation_service) { instance_double(Account::SignUpEmailValidationService) }

  def set_omniauth_config(provider, for_email = 'test@example.com')
    OmniAuth.config.test_mode = true
    auth_hash = OmniAuth::AuthHash.new(
      provider: provider,
      uid: provider == 'google_oauth2' ? '123545' : 'keycloak-123545',
      info: {
        name: 'test',
        email: for_email,
        image: provider == 'google_oauth2' ? 'https://example.com/image.jpg' : nil
      }
    )
    OmniAuth.config.mock_auth[provider.to_sym] = auth_hash
  end

  before do
    allow(Account::SignUpEmailValidationService).to receive(:new).and_return(email_validation_service)
    allow(GlobalConfigService).to receive(:load).with('UEF_ID_OAUTH_CLIENT_ID', nil).and_return('chatwoot-client')
    allow(GlobalConfigService).to receive(:load).with('UEF_ID_OAUTH_CLIENT_SECRET', nil).and_return('keycloak-secret')
    allow(GlobalConfigService).to receive(:load).with('UEF_ID_OAUTH_REALM', nil).and_return('uef_id')
    allow(GlobalConfigService).to receive(:load).with('KEYCLOAK_URL', 'https://sso.uef.edu.vn').and_return('https://sso.uef.edu.vn')
  end

  describe '#omniauth_success' do
    before do
      GlobalConfig.clear_cache
    end

    %w[google_oauth2 uef_id].each do |provider|
      describe "for #{provider}" do
        it 'allows signup' do
          with_modified_env ENABLE_ACCOUNT_SIGNUP: 'true', FRONTEND_URL: 'http://www.example.com' do
            set_omniauth_config(provider, 'test_not_preset@example.com')
            allow(AccountBuilder).to receive(:new).and_return(account_builder)
            allow(account_builder).to receive(:perform).and_return(user_double)
            allow(Avatar::AvatarFromUrlJob).to receive(:perform_later).and_return(true) if provider == 'google_oauth2'
            allow(email_validation_service).to receive(:perform).and_return(true)

            get "/omniauth/#{provider}/callback"

            expect(response).to redirect_to("http://www.example.com/auth/#{provider}/callback")
            follow_redirect!

            expect(AccountBuilder).to have_received(:new).with({
                                                                 account_name: 'example',
                                                                 user_full_name: 'test',
                                                                 email: 'test_not_preset@example.com',
                                                                 locale: I18n.locale,
                                                                 confirmed: nil
                                                               })
            expect(account_builder).to have_received(:perform)
          end
        end

        it 'blocks personal accounts signup' do
          with_modified_env ENABLE_ACCOUNT_SIGNUP: 'true', FRONTEND_URL: 'http://www.example.com' do
            set_omniauth_config(provider, 'personal@gmail.com')
            allow(email_validation_service).to receive(:perform).and_raise(
              CustomExceptions::Account::InvalidEmail.new({ valid: false, disposable: nil })
            )

            get "/omniauth/#{provider}/callback"

            expect(response).to redirect_to("http://www.example.com/auth/#{provider}/callback")
            follow_redirect!

            expect(response).to redirect_to(%r{/app/login\?error=business-account-only$})
          end
        end

        it 'blocks personal accounts signup with different Gmail case variations' do
          with_modified_env ENABLE_ACCOUNT_SIGNUP: 'true', FRONTEND_URL: 'http://www.example.com' do
            ['personal@Gmail.com', 'personal@GMAIL.com', 'personal@Gmail.COM'].each do |email|
              set_omniauth_config(provider, email)
              allow(email_validation_service).to receive(:perform).and_raise(
                CustomExceptions::Account::InvalidEmail.new({ valid: false, disposable: nil })
              )

              get "/omniauth/#{provider}/callback"

              expect(response).to redirect_to("http://www.example.com/auth/#{provider}/callback")
              follow_redirect!

              expect(response).to redirect_to(%r{/app/login\?error=business-account-only$})
            end
          end
        end

        it 'blocks signup if ENV disabled' do
          with_modified_env ENABLE_ACCOUNT_SIGNUP: 'false', FRONTEND_URL: 'http://www.example.com' do
            set_omniauth_config(provider, 'does-not-exist-for-sure@example.com')
            allow(email_validation_service).to receive(:perform).and_return(true)

            get "/omniauth/#{provider}/callback"

            expect(response).to redirect_to("http://www.example.com/auth/#{provider}/callback")
            follow_redirect!

            expect(response).to redirect_to(%r{/app/login\?error=no-account-found$})
          end
        end

        it 'allows login' do
          with_modified_env FRONTEND_URL: 'http://www.example.com' do
            create(:user, email: 'test@example.com')
            set_omniauth_config(provider, 'test@example.com')

            get "/omniauth/#{provider}/callback"
            expect(response).to redirect_to("http://www.example.com/auth/#{provider}/callback")

            follow_redirect!
            expect(response).to redirect_to(%r{/app/login\?email=.+&sso_auth_token=.+$})

            follow_redirect!
            expect(response).to have_http_status(:ok)
          end
        end

        it 'allows personal account login' do
          with_modified_env FRONTEND_URL: 'http://www.example.com' do
            create(:user, email: 'personal-existing@gmail.com')
            set_omniauth_config(provider, 'personal-existing@gmail.com')

            get "/omniauth/#{provider}/callback"
            expect(response).to redirect_to("http://www.example.com/auth/#{provider}/callback")

            follow_redirect!
            expect(response).to redirect_to(%r{/app/login\?email=.+&sso_auth_token=.+$})

            follow_redirect!
            expect(response).to have_http_status(:ok)
          end
        end
      end
    end
  end
end
