import { shallowMount } from '@vue/test-utils';
import UEFSsoButton from './Button.vue';

function getWrapper(showSeparator) {
  return shallowMount(UEFSsoButton, {
    propsData: { showSeparator: showSeparator },
    mocks: { $t: text => text },
  });
}

describe('UEFSsoButton.vue', () => {
  beforeEach(() => {
    window.chatwootConfig = {
      googleOAuthClientId: 'clientId',
      googleOAuthCallbackUrl: 'http://localhost:3000/test-callback',
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

  it('generates the correct UEF SSO URL', () => {
    const wrapper = getWrapper();
    const uefSsoUrl = new URL(wrapper.vm.getUEFSsoUrl());
    const params = uefSsoUrl.searchParams;
    expect(uefSsoUrl.origin).toBe('https://sso.uef.edu.vn');
    expect(uefSsoUrl.pathname).toBe('/');
    expect(params.get('client_id')).toBe('clientId');
    expect(params.get('redirect_uri')).toBe(
      'http://localhost:3000/test-callback'
    );
    expect(params.get('response_type')).toBe('code');
    expect(params.get('scope')).toBe('email profile');

    expect(wrapper.findComponent({ ref: 'divider' }).exists()).toBe(true);
  });
});
