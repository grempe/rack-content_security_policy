# Gem Release Process

Don't use the `bundle exec rake release` task. It is more convenient,
but it skips the process of signing the version release task.

## Run Tests

```sh
$ bundle exec rake wwtd
```

## Git Push

```sh
$ git push
```

Check for regressions in automated tests.

* [https://travis-ci.org/grempe/rack-content_security_policy](https://travis-ci.org/grempe/rack-content_security_policy)

## Bump Version Number and edit CHANGELOG.md

```sh
$ vi lib/rack/content_security_policy/version.rb
$ git add lib/rack/content_security_policy/version.rb
$ vi CHANGELOG.md
$ git add CHANGELOG.md
```

## Local Build and Install w/ Signed Gem

The `build` step should ask for PEM passphrase to sign gem. If it does
not ask it means that the signing cert is not present.

Build:

```sh
$ rake build
Enter PEM pass phrase:
rack-content_security_policy 0.1.0 built to pkg/rack-content_security_policy-0.1.0.gem
```

Install locally w/ Cert:

```sh
$ gem uninstall rack-content_security_policy
$ rbenv rehash
$ gem install pkg/rack-content_security_policy-0.1.0.gem -P MediumSecurity
Successfully installed rack-content_security_policy-0.1.0
1 gem installed
```

## Git Commit Version and CHANGELOG Changes, Tag and push to Github

```sh
$ git commit -m 'Bump version v0.1.0'
$ git tag -s v0.1.0 -m "v0.1.0" SHA1_OF_COMMIT
```

Verify last commit and last tag are GPG signed:

```
$ git tag -v v0.1.0
...
gpg: Good signature from "Glenn Rempe (Code Signing Key) <glenn@rempe.us>" [ultimate]
...
```

```
$ git log --show-signature
...
gpg: Good signature from "Glenn Rempe (Code Signing Key) <glenn@rempe.us>" [ultimate]
...
```

Push code and tags to GitHub:

```
$ git push
$ git push --tags
```

## Push gem to Rubygems.org

```sh
$ gem push pkg/rack-content_security_policy-0.1.0.gem
```

Verify Gem Push at [https://rubygems.org/gems/rack-content_security_policy](https://rubygems.org/gems/rack-content_security_policy)

## Create a GitHub Release

Specify the tag we just pushed to attach release to. Copy notes from CHANGELOG.md

[https://github.com/grempe/rack-content_security_policy/releases](https://github.com/grempe/rack-content_security_policy/releases)
