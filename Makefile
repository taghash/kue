REPORTER = spec

all:    build css

build:
	@./node_modules/coffee-script/bin/coffee \
    -c \
    -o lib src

css:
	@./node_modules/.bin/node-sass \
    lib/http/public/stylesheets/main.scss \
    lib/http/public/stylesheets/main.css

test-tdd:
	@./node_modules/.bin/mocha \
    --reporter $(REPORTER) \
		--require should \
		--require sinon \
    --ui tdd \
    test/tdd/*.js

test-bdd:
	@./node_modules/.bin/mocha \
    --reporter $(REPORTER) \
    --require should \
    --ui bdd \
    test/*.js

test-bdd-coffee:
	@./node_modules/.bin/mocha \
    --compilers coffee:coffee-script \
    --reporter $(REPORTER) \
    --require should \
    --require coffee-script/register \
    --ui bdd \
    test/*.coffee


test-all:   test-tdd test-bdd test-bdd-coffee

.PHONY: test-all
