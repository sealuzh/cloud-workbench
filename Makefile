.PHONY: install run migrate setup stop_spring test guard drop_db

install:
	bin/bundle install

migrate:
	bin/rake db:migrate

setup: migrate
	bin/rake user:create_default

run:
	bin/rails server

stop_spring:
	bin/spring stop

test:
	bin/rspec

guard:
	bin/guard

drop_db:
	bin/rake db:drop
