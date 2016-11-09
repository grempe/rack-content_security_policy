module Rack
  class ContentSecurityPolicy
    # Custom Contracts
    # See : https://egonschiele.github.io/contracts.ruby/

    class DirectiveKey
      def self.valid?(val)
        Contract.valid?(val, /^[[a-z]+\-?]+$/)
      end

      def self.to_s
        'A CSP directive key must be one or more lowercase ASCII (a-z) characters with optional dashes (-)'
      end
    end

    class DirectiveVal
      def self.valid?(val)
        Contract.valid?(val, Contracts::Or[String, Contracts::Bool])
      end

      def self.to_s
        'A CSP directive value must be a String or Boolean'
      end
    end

    class Directives
      def self.valid?(val)
        Contract.valid?(val, Contracts::HashOf[DirectiveKey => DirectiveVal])
      end

      def self.to_s
        'A CSP directive key/value Hash'
      end
    end

    class RackResponse
      def self.valid?(val)
        Contract.valid?(val, [Contracts::Int, Hash, Contracts::RespondTo[:each]])
      end

      def self.to_s
        'A Rack response'
      end
    end
  end
end
