require 'spec_helper'

describe Rack::ContentSecurityPolicy do
  context 'middleware' do
    before(:each) do
      Rack::ContentSecurityPolicy.configure do |csp|
        csp.report_only = false
        csp['default-src'] = '*'
        csp['script-src'] = "'self'"
        csp['img-src'] = '*.google.com'
        csp['block-all-mixed-content'] = true
        csp['disown-opener'] = true
        csp['upgrade-insecure-requests'] = true
      end
    end

    context 'with text/html response header' do
      let(:app) do
        Rack::Builder.app do
          use Rack::ContentSecurityPolicy
          run lambda { |env| [200, { 'Content-Type' => 'text/html; charset=utf-8' }, %w(ok)] }
        end
      end

      it 'responds with Content-Security-Policy response header' do
        get('/')
        expect(last_response.headers['Content-Security-Policy'])
          .to eq("block-all-mixed-content; default-src *; disown-opener; img-src *.google.com; script-src 'self'; upgrade-insecure-requests")
      end

      it 'responds with Content-Security-Policy-Report-Only response header' do
        Rack::ContentSecurityPolicy.report_only = true
        get('/')
        expect(last_response.headers['Content-Security-Policy-Report-Only'])
          .to eq("block-all-mixed-content; default-src *; disown-opener; img-src *.google.com; script-src 'self'; upgrade-insecure-requests")
      end
    end
  end
end
