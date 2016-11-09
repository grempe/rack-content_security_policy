$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
require 'rspec'
require 'rack/test'
require 'rack/content_security_policy'

SimpleCov.start do
  add_filter 'spec/'
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.order = 'random'

  conf.before(:each) do
    Rack::ContentSecurityPolicy.reset
  end
end

# monkey-patch in a method reset before each test.
module Rack
  class ContentSecurityPolicy
    def self.reset
      @directives = {}
      @report_only = false
    end
  end
end
