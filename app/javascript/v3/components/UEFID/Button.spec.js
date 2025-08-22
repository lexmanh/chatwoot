import { shallowMount } from '@vue/test-utils';
import UEFIDOAuthButton from './Button.vue';

function getWrapper(showSeparator) {
  return shallowMount(UEFIDOAuthButton, {
    propsData: { showSeparator: showSeparator },
    mocks: { $t: text => text },
  });
}

describe('UEFIDOAuthButton.vue', () => {
  beforeEach(() => {
    window.chatwootConfig = {
      uefIdOAuthClientId: 'clientId',
      uefIdOAuthCallbackUrl: 'http://localhost:3000/test-callback',
    };
  });

  afterEach(() => {
    window.chatwootConfig = {};
  });

  it('renders the OR separator if showSeparator is true', () => {
    const wrapper = getWrapper(true);
    expect(wrapper.findComponent({ ref: 'divider' }).exists()).toBe(true);
  });

  it('does not render the OR separator if showSeparator is false', () => {
    const wrapper = getWrapper(false);
    expect(wrapper.findComponent({ ref: 'divider' }).exists()).toBe(false);
  });

  it('generates the correct UEF ID Auth URL', () => {
    const wrapper = getWrapper();
    const uefIdAuthUrl = new URL(wrapper.vm.getGoogleAuthUrl());
    const params = uefIdAuthUrl.searchParams;
    expect(uefIdAuthUrl.origin).toBe('https://sso.uef.edu.vn');
    expect(uefIdAuthUrl.pathname).toBe('/o/oauth2/auth/oauthchooseaccount');
    expect(params.get('client_id')).toBe('clientId');
    expect(params.get('redirect_uri')).toBe(
      'http://localhost:3000/test-callback'
    );
    expect(params.get('response_type')).toBe('code');
    expect(params.get('scope')).toBe('email profile');

    expect(wrapper.findComponent({ ref: 'divider' }).exists()).toBe(true);
  });
});
