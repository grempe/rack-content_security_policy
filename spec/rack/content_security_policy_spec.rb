require 'spec_helper'

describe Rack::ContentSecurityPolicy do
  let(:app) do
    [200, { 'Content-Type' => 'text/html; charset=utf-8' }, %w(ok)]
  end

  describe 'configuring' do
    context 'report_only' do
      context 'with a block' do
        it 'sets report_only attribute to false by default' do
          Rack::ContentSecurityPolicy.configure { |csp|  }
          expect(Rack::ContentSecurityPolicy.report_only).to be false
        end

        it 'can be set to true' do
          Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = true }
          expect(Rack::ContentSecurityPolicy.report_only).to be true
        end

        it 'can be set to false' do
          Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = false }
          expect(Rack::ContentSecurityPolicy.report_only).to be false
        end

        it 'raises an exception if set to non-boolean' do
          expect do
            Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = 'true' }
          end.to raise_error(ParamContractError)
        end

        it 'raises an exception if set to nil' do
          expect do
            Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = nil }
          end.to raise_error(ParamContractError)
        end
      end

      context 'with a hash' do
        it 'sets report_only attribute to false by default' do
          csp = Rack::ContentSecurityPolicy.new(app, directives: { 'default-src' => "'self'" })
          expect(csp.report_only).to be false
        end

        it 'can be set to true' do
          csp = Rack::ContentSecurityPolicy.new(app, report_only: true, directives: { 'default-src' => "'self'" })
          expect(csp.report_only).to be true
        end

        it 'can be set to false' do
          csp = Rack::ContentSecurityPolicy.new(app, report_only: false, directives: { 'default-src' => "'self'" })
          expect(csp.report_only).to be false
        end

        it 'raises an exception if set to non-boolean' do
          expect do
            Rack::ContentSecurityPolicy.new(app, report_only: 'true', directives: { 'default-src' => "'self'" })
          end.to raise_error(ParamContractError)
        end

        it 'raises an exception if set to nil' do
          expect do
            Rack::ContentSecurityPolicy.new(app, report_only: nil, directives: { 'default-src' => "'self'" })
          end.to raise_error(ParamContractError)
        end
      end

      context 'with a block and a hash' do
        it 'sets true if block is true and hash is false' do
          Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = true }
          csp = Rack::ContentSecurityPolicy.new(app, report_only: false, directives: { 'default-src' => "'self'" })
          expect(csp.report_only).to be true
        end

        it 'sets true if block is false and hash is true' do
          Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = false }
          csp = Rack::ContentSecurityPolicy.new(app, report_only: true, directives: { 'default-src' => "'self'" })
          expect(csp.report_only).to be true
        end

        it 'sets false if block is false and hash is false' do
          Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = false }
          csp = Rack::ContentSecurityPolicy.new(app, report_only: false, directives: { 'default-src' => "'self'" })
          expect(csp.report_only).to be false
        end

        it 'sets true if block is true and hash is true' do
          Rack::ContentSecurityPolicy.configure { |csp| csp.report_only = true }
          csp = Rack::ContentSecurityPolicy.new(app, report_only: true, directives: { 'default-src' => "'self'" })
          expect(csp.report_only).to be true
        end
      end
    end

    context 'directives' do
      context 'with block' do
        it 'calls block for self' do
          expect(Rack::ContentSecurityPolicy).to receive(:configure).and_yield(Rack::ContentSecurityPolicy)
          Rack::ContentSecurityPolicy.configure { |csp| csp['default-src'] = '*' }
        end

        it 'sets directives' do
          Rack::ContentSecurityPolicy.configure { |csp| csp['default-src'] = '*' }
          expect(Rack::ContentSecurityPolicy.directives).to eq('default-src' => '*')
        end

        it 'appends directives' do
          Rack::ContentSecurityPolicy.configure { |csp| csp['default-src'] = '*' }
          Rack::ContentSecurityPolicy.configure { |csp| csp['script-src']  = '*' }
          expect(Rack::ContentSecurityPolicy.directives).to eq('default-src' => '*', 'script-src' => '*')
        end

        it 'raises an exception if directives key has invalid uppercase chars' do
          expect do
            Rack::ContentSecurityPolicy.configure { |csp| csp['Default-Src']  = "'self'" }
          end.to raise_error(ParamContractError)
        end

        it 'raises an exception if directives key has invalid chars' do
          expect do
            # * is not a valid char
            Rack::ContentSecurityPolicy.configure { |csp| csp['default-src-*']  = "'self'" }
          end.to raise_error(ParamContractError)
        end

        it 'raises an exception if directives are not set' do
          Rack::ContentSecurityPolicy.configure { |csp| }
          expect do
            Rack::ContentSecurityPolicy.new(app)
          end.to raise_error(ArgumentError, 'no directives provided')
        end
      end

      context 'with hash' do
        it 'sets directives' do
          csp = Rack::ContentSecurityPolicy.new(app, directives: { 'default-src' => "'self'" })
          expect(csp.directives).to eq('default-src' => "'self'")
        end

        it 'raises an exception if directives key has invalid uppercase chars' do
          expect do
            Rack::ContentSecurityPolicy.new(app, directives: { 'Default-Src' => "'self'" })
          end.to raise_error(ParamContractError)
        end

        it 'raises an exception if directives key has invalid chars' do
          expect do
            Rack::ContentSecurityPolicy.new(app, directives: { 'default-src-*' => "'self'" })
          end.to raise_error(ParamContractError)
        end

        it 'raises an exception if directives set to nil' do
          expect do
            Rack::ContentSecurityPolicy.new(app, directives: nil)
          end.to raise_error(ParamContractError)
        end
      end

      context 'with both block and hash' do
        it 'sets combined directives' do
          Rack::ContentSecurityPolicy.configure { |csp| csp['default-src'] = "'self'" }
          csp = Rack::ContentSecurityPolicy.new(app, directives: { 'script-src' => "'self'" })
          expect(csp.directives).to eq('default-src' => "'self'", 'script-src' => "'self'")
        end
      end

      context 'with no-arg directives' do
        it 'sets directives' do
          csp = Rack::ContentSecurityPolicy.new(app, directives: { 'default-src' => '*', 'block-all-mixed-content' => true, 'disown-opener' => true, 'upgrade-insecure-requests' => true })
          expect(csp.directives).to eq("default-src"=>"*", "block-all-mixed-content"=>true, "disown-opener"=>true, "upgrade-insecure-requests"=>true)
        end
      end
    end
  end
end
