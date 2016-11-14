# Rack::ContentSecurityPolicy

[![Build Status](https://travis-ci.org/grempe/rack-content_security_policy.svg?branch=master)](https://travis-ci.org/grempe/rack-content_security_policy)
[![Code Climate](https://codeclimate.com/github/grempe/rack-content_security_policy/badges/gpa.svg)](https://codeclimate.com/github/grempe/rack-content_security_policy)

## WARNING

This is pre-release software. It is pretty well tested but has not yet
been used in production. Your feedback is requested.

## About

`Rack::ContentSecurityPolicy` is a Rack middleware that makes it easy for your
Rack based application (Sinatra, Rails) to serve an `Content-Security-Policy` or
`Content-Security-Policy-Report-Only` header.

This middleware was inspired by the [p0deje/content-security-policy](https://github.com/p0deje/content-security-policy)
middleware and borrows quite a bit of code from that gem. This gem also makes
extensive use of the [contracts](https://egonschiele.github.io/contracts.ruby/)
gem to enforce strict type checking and validation on all inputs and outputs.
It is designed to fail-fast on errors.

It provides full support for Content Security Policy Level 1/2/3 directives.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'rack-content_security_policy', '~> 0.1'
```

And then execute:

```
$ bundle install
```

Or install it directly with:

```
$ gem install rack-content_security_policy
```

## Usage

This middleware can be configured with a block or a hash of config options. It
accepts two primary configuration options:

* `report_only` : boolean `true` or `false`. Returns a `Content-Security-Policy-Report-Only` header instead of `Content-Security-Policy` when `true`. Defaults to true.
* `directives` : A collection of valid CSP directives provided as key/value pairs. The key must be a lowercase String and must be comprised of the characters [a-z] and the `-`. The value must also be a String but is not limited to remain flexible as the CSP standards evolve. You can use conditional statements within the configuration block to set values dynamically at startup time. Defaults to an empty config that you must configure. An empty config will raise an exception.

Note that certain CSP directives, such as `upgrade-insecure-requests`, do not
take any arguments. For those, just set the value to `true`.

Learn more about the Content Security Policy at the following sites:

* W3C CSP Level 1 (deprecated) : [https://www.w3.org/TR/CSP1/](https://www.w3.org/TR/CSP1/)
* W3C CSP Level 2 (current) : [https://www.w3.org/TR/CSP2/](https://www.w3.org/TR/CSP2/)
* W3C CSP Level 3 (draft) : [https://www.w3.org/TR/CSP3/](https://www.w3.org/TR/CSP3/)
* [https://developer.mozilla.org/en-US/docs/Web/Security/CSP](https://developer.mozilla.org/en-US/docs/Web/Security/CSP)
* [http://caniuse.com/#search=ContentSecurityPolicy](http://caniuse.com/#search=ContentSecurityPolicy)
* [http://content-security-policy.com/](http://content-security-policy.com/)
* [https://securityheaders.io](https://securityheaders.io)
* [https://scotthelme.co.uk/csp-cheat-sheet/](https://scotthelme.co.uk/csp-cheat-sheet/)
* [http://www.html5rocks.com/en/tutorials/security/content-security-policy/](http://www.html5rocks.com/en/tutorials/security/content-security-policy/)
* [https://hacks.mozilla.org/2016/02/implementing-content-security-policy/](https://hacks.mozilla.org/2016/02/implementing-content-security-policy/)

### Block Configuration Example

``` ruby
require 'rack/content_security_policy'

Rack::ContentSecurityPolicy.configure do |d|
  d.report_only = false
  d['default-src'] = "'none'"
  d['script-src']  = "'self'"
  d['upgrade-insecure-requests'] = true
end

use Rack::ContentSecurityPolicy
```

### Hash Configuration Example

``` ruby
require 'rack/content_security_policy'

use Rack::ContentSecurityPolicy, report_only: true, directives: { 'default-src' => "'self'" }
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then,
run `bundle exec rake` to run the specs.

To install this gem onto your local machine, run `bundle exec rake install`.

### Installation Security : Signed Ruby Gem

This gem is cryptographically signed. To be sure the gem you install hasn’t
been tampered with you can install it using the following method:

Add my public key (if you haven’t already) as a trusted certificate

```
# Caveat: Gem certificates are trusted globally, such that adding a
# cert.pem for one gem automatically trusts all gems signed by that cert.
gem cert --add <(curl -Ls https://raw.github.com/grempe/rack-content_security_policy/master/certs/gem-public_cert_grempe_2026.pem)
```

To install, it is possible to specify either `HighSecurity` or `MediumSecurity`
mode. Since this gem depends on one or more gems that are not cryptographically
signed you will likely need to use `MediumSecurity`. You should receive a warning
if any signed gem does not match its signature.

```
# All signed dependent gems must be verified.
gem install rack-content_security_policy -P MediumSecurity
```

You can [learn more about security and signed Ruby Gems](http://guides.rubygems.org/security/).

### Installation Security : Signed Git Commits

Most, if not all, of the commits and tags to this repository are
signed with my PGP/GPG code signing key. I have uploaded my code signing public
keys to GitHub and you can now verify those signatures with the GitHub UI.
See [this list of commits](https://github.com/grempe/rack-content_security_policy/commits/master)
and look for the `Verified` tag next to each commit. You can click on that tag
for additional information.

You can also clone the repository and verify the signatures locally using your
own GnuPG installation. You can find my certificates and read about how to conduct
this verification at [https://www.rempe.us/keys/](https://www.rempe.us/keys/).

### Contributing

Bug reports and pull requests are welcome on GitHub
at [https://github.com/grempe/rack-content_security_policy](https://github.com/grempe/rack-content_security_policy). This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Legal

### Copyright

Copyright (c) 2016 Glenn Rempe <[glenn@rempe.us](mailto:glenn@rempe.us)> ([https://www.rempe.us/](https://www.rempe.us/))

Some portions Copyright (c) 2009-2012 Alexey Rodionov

### License

The gem is available as open source under the terms of
the [MIT License](http://opensource.org/licenses/MIT).

### Warranty

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
either express or implied. See the LICENSE.txt file for the
specific language governing permissions and limitations under
the License.

## Thank You!

Thanks to Alexey Rodionov ([@p0deje](https://github.com/p0deje)) for
his well written original implementation of CSP.
