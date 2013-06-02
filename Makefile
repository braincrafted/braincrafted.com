CHECK          = \033[32m✔\033[39m

watch:
	@fswatch ./_posts:./_layouts:./sass:./js "make build"

build-and-run: build run

build: build-css build-js build-jekyll

build-css: build-compass
	@echo "Minifiying CSS...                     \c"
	@cat css-dev/github.css css/braincrafted.css > css/braincrafted.tmp.css
	@ycssmin css/braincrafted.tmp.css > css/braincrafted.min.css
	@rm css/braincrafted.css css/braincrafted.tmp.css
	@echo "${CHECK} Done"

build-compass:
	@echo "Compiling Sass...                     \c"
	@compass compile -q ${SASS_MASTER}
	@echo "${CHECK} Done"

build-jekyll:
	@echo "Compiling website...                  \c"
	@jekyll > /dev/null
	@echo "${CHECK} Done"

build-js:
	@echo "Compiling and minifying JavaScript... \c"
	@cat js-dev/picturefill.js js-dev/highlight.pack.js js-dev/braincrafted.js > js/braincrafted.tmp.js
	@uglifyjs js/braincrafted.tmp.js > js/braincrafted.min.js
	@rm js/braincrafted.tmp.js
	@echo "${CHECK} Done"

clean: clean-compass clean-jekyll clean-js

clean-jekyll:
	@echo "Cleaning generated website...         \c"
	@rm -rf _site/*
	@echo "${CHECK} Done"

clean-compass:
	@echo "Cleaning generated CSS files...       \c"
	@rm -f css/*
	@echo "${CHECK} Done"

clean-js:
	@echo "Cleaning generated JS files...        \c"
	@rm -rf js/*.min.js
	@echo "${CHECK} Done"

deploy: clean build
	@echo "Deploying website to server...        \c"
	@rsync -avq --delete-after _site/ han:/var/www/braincrafted.com
	@echo "${CHECK} Done"

run:
	@open http://braincrafted.com.dev

.PHONY: build build-css build-compass build-jekyll build-js clean clean-jekyll clean-compass clean-js deploy
