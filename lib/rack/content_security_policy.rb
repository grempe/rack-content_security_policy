require 'contracts'
require 'rack/content_security_policy/contracts'

module Rack
  class ContentSecurityPolicy
    include Contracts::Core
    include Contracts::Builtin

    CSP_HEADER = 'Content-Security-Policy'.freeze
    CSP_REPORT_ONLY_HEADER = 'Content-Security-Policy-Report-Only'.freeze
    NO_ARG_DIRECTIVES = ['block-all-mixed-content',
                         'disown-opener',
                         'upgrade-insecure-requests'].freeze

    Contract Any, KeywordArgs[directives: Optional[Directives], report_only: Optional[Bool]] => Any
    def initialize(app, directives: {}, report_only: false)
      @app = app

      class_dirs = Rack::ContentSecurityPolicy.directives
      if directives.empty? && class_dirs.empty?
        raise ArgumentError, 'no directives provided'
      end
      @directives = class_dirs.merge(directives)

      class_report_only = Rack::ContentSecurityPolicy.report_only
      @report_only = report_only || class_report_only ? true : false
    end

    Contract None => Bool
    def report_only
      @report_only
    end

    Contract None => Directives
    def directives
      @directives
    end

    Contract Hash => RackResponse
    def call(env)
      dup._call(env)
    end

    Contract Hash => RackResponse
    def _call(env)
      status, headers, response = @app.call(env)

      directives = @directives.sort.map do |d|
        if NO_ARG_DIRECTIVES.include?(d[0])
          d[0]
        else
          "#{d[0]} #{d[1]}"
        end
      end.join('; ')

      csp_hdr = @report_only ? CSP_REPORT_ONLY_HEADER : CSP_HEADER
      headers[csp_hdr] = directives

      [status, headers, response]
    end

    ################################
    # CLASS METHODS
    ################################

    Contract Bool => Bool
    def self.report_only=(ro)
      @report_only = ro
    end

    Contract None => Bool
    def self.report_only
      @report_only
    end

    Contract None => Directives
    def self.directives
      @directives
    end

    Contract Proc => Or[String, Bool, nil]
    def self.configure
      @directives ||= {}
      yield(self)
    end

    Contract DirectiveKey, DirectiveVal => Or[String, Bool]
    def self.[]=(name, value)
      @directives[name] = value
    end
  end
end
