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
