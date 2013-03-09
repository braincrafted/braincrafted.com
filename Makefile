CHECK=\033[32m✔\033[39m
SASS_MASTER    = sass/master.scss
CSS_MASTER     = css/master.css
MIN_CSS_MASTER = css/master.min.css

clean-compass:
	@echo "Cleaning generated CSS files...       \c"
	@rm -f css/*
	@echo "${CHECK} Done"

clean-jekyll:
	@echo "Cleaning generated website...         \c"
	@rm -rf _site/*
	@echo "${CHECK} Done"

clean: clean-compass clean-jekyll

build-compass:
	@echo "Compiling Sass with Compass...        \c"
	@compass compile -q ${SASS_MASTER}
	@echo "${CHECK} Done"

build-css: build-compass
	@echo "Minifiying CSS...                     \c"
	@ycssmin ${CSS_MASTER} > ${MIN_CSS_MASTER}
	@echo "${CHECK} Done"

build-jekyll:
	@echo "Compiling website with Jekyll...      \c"
	@jekyll > /dev/null
	@echo "${CHECK} Done"

build: build-css build-jekyll

deploy: clean build
	@echo "Deploying website to server...        \c"
	@rsync -avq --delete-after _site/ han:/var/www/braincrafted.com
	@echo "${CHECK} Done"

.PHONY: build clean deploy