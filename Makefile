.PHONY: install outdated run migrate setup stop_spring test guard drop_db prod_setup prod_run

install:
	bin/bundle install

outdated:
	bin/bundle outdated

migrate:
	bin/rake db:create
	bin/rake db:migrate

setup: migrate
	bin/rake user:create_default

run:
	bin/rails server

worker:
	bin/rake jobs:work

foreman:
	bin/foreman start

stop_spring:
	bin/spring stop

test:
	bin/rspec

guard:
	bin/guard

drop_db:
	bin/rake db:drop

# Production commands for development
# NOTICE: This custom rake task (`lib/tasks/db.rake`) uses
# 				the `postgres` user to create another PostgreSQL role/user
prod_create_db_user: RAILS_ENV=production
prod_create_db_user:
	bin/rake db:create_user

prod_setup: RAILS_ENV=production
prod_setup:
	bin/rake db:setup
	bin/rake user:create

prod_run:
prod_run: RAILS_ENV=production
prod_run: RAILS_SERVE_STATIC_FILES=true
prod_run: RAILS_LOG_TO_STDOUT=true
prod_run:
	bin/rake assets:precompile
	bin/rails server
