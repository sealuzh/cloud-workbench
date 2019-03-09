# Development

## Requirements

* [Ruby (2.5.1)](https://www.ruby-lang.org/en/downloads/) for development and deployment with Bundler
  * [Mac Ruby installation tutorial](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)
  * [Windows Ruby installer](http://rubyinstaller.org/)
  * Install bundler:

  ```bash
  gem install bundler
  ```

## Install Dependencies

```bash
bin/bundle install
```

## Run Migrations

```bash
bin/rake db:migrate
bin/rake user:create_default
```

## Start Server

```bash
bin/rails s
open http://localhost:3000
# Login with password `demo`
```

## Start Worker

```bash
bin/rake jobs:work
```

## Start Server and Worker

```bash
bin/foreman start
```

## Run Tests

Run all tests:

```bash
bin/rspec
```

## Continuously Run Tests

[Guard](https://github.com/guard/guard) automatically
runs your tests whenever a file is modified:

```bash
bin/guard
```

* Type `all` to run all tests.
* Type `exit` to leave guard.
* Install the [Livereload](http://livereload.com/extensions/)
  browser extension to automatically reload the browser page.

Automatically reloads a page on asset modification via the following browser plugin:

## Setup Production Environment Locally

* Requirement: Setup local PostgreSQL

```bash
# Via Make
# NOTICE: `prod_create_db_user` uses the `postgres` DB to create a new CWB PostgreSQL user (called cloud)
make prod_create_db_user prod_setup

# Manually
export RAILS_ENV=production
bin/rake db:setup
bin/rake user:create
```

## Run in Production Mode Locally

```bash
# Via Make
make prod_run

# Manually
export RAILS_ENV=production
export RAILS_SERVE_STATIC_FILES=true
export RAILS_LOG_TO_STDOUT=true
export PORT=3000
bin/rake assets:precompile
bin/foreman start -f Procfile_production
```

## Run Linter

```bash
make lint
```

## Tips & Tricks

* The Rails application preloader [Spring](https://github.com/rails/spring)
  automatically speeds up your development.
* Tests can be [tagged](https://www.relishapp.com/rspec/rspec-core/v/3-4/docs/command-line/tag-option)
  (e.g., useful for [slow tests](http://engineering.sharethrough.com/blog/2013/08/10/greater-test-control-with-rspecs-tag-filters/))

## Local Integration Testing Environment

* CWB can be locally installed into 2 [Virtualbox](https://www.virtualbox.org/wiki/Downloads) VMs.
  Follow the [Installation](https://github.com/sealuzh/cwb-chef-repo#installation) steps
  using the template from `install/virtualbox/Vagrantfile`

* Notice that cloud VMs cannot communicate with the local machines unless
  both VMs (chef-server and cwb-server) have public hostnames.

* The Vagrant plugin [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier)
  can speed up development by serving as a cache for apt, gems, etc.

    ```bash
    vagrant plugin install vagrant-cachier
    ```

## Conventions

### Commit Messages

1. Capitalize the subject line (e.g., Fix ... instead of fix ...)
2. Use imperative verbs in the subject line (e.g., Fix instead of Fixed)
3. Use the body to motivate the change (i.e., what?, why?, how?) when appropriate. Example:

    ```none
    Fix HTTP status codes for errors

    Problem: Errors (i.e., 404, 422, 500) returned 200 by mistake
    Solution: Return the right error code by calling the right helper method
    ```

Common prefixes are: Fix, Add, Update, Remove, Improve

### Branching Strategy

This project uses short-lived features branches typically prefixed with:

* `feature/` introducing new functionality
* `fix/` fixing an issue
* `support/` supporting changes related to documentation, deployment, or testing

Feature branches are merged into master via Github pull request after a successful build.
Minor changes (e.g., README updates) can be committed directly into master (Hint: `[skip-ci]` skips the CI build for minor commits).

### Release / Deployment Strategy

This project follows a [continous delivery](https://continuousdelivery.com/) deployment model and therefore does not use the notion of releases.
Checkout the [cwb client library](https://github.com/sealuzh/cwb) for a publicly released [Ruby gem](https://rubygems.org/gems/cwb).
