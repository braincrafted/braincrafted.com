CHECK          = \033[32m✔\033[39m
SASS_MASTER    = sass/master.scss
CSS_MASTER     = css/master.css
MIN_CSS_MASTER = css/master.min.css

build: build-css build-js build-jekyll

build-css: build-compass
	@echo "Minifiying CSS...                     \c"
	@ycssmin ${CSS_MASTER} > ${MIN_CSS_MASTER}
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
	@@uglifyjs js/picturefill.js > js/braincrafted.min.js
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

.PHONY: build build-css build-compass build-jekyll build-js clean clean-jekyll clean-compass clean-js deploy
