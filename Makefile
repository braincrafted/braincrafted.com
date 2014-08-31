CHECK          	= \033[32m✔\033[39m
DEV_URL		   	= http:\/\/braincrafted.com.dev
PROD_URL		= http:\/\/braincrafted.com

define OPEN_SCRIPT
tell application "Safari"
    set reloaded to false
    set reloadURL to "__OPEN_URL__"

    repeat with x from 1 to number of windows
        repeat with y from 1 to number of tabs in window x
            set tabURL to URL of tab y of window x
            if tabURL starts with reloadURL then
                set URL of tab y of window x to tabURL
                set reloaded to true
                set current tab of window x to (tab y of window x)
            end if
        end repeat
    end repeat

    if reloaded is false then
        tell front window
            set current tab to (make new tab with properties {URL:reloadURL})
        end tell
    end if

end tell
endef

# Required because by default $OPEN_SCRIPT is interpretated as a command
export OPEN_SCRIPT

watch:
	@echo "Watching for changes..."
	@bundle exec guard

build-and-run: build run-dev

build: build-css build-js build-jekyll

build-css: build-compass
	@echo "Minifiying CSS...                       \c"
	@cat css-dev/github.css css/braincrafted.css > css/braincrafted.tmp.css
	@ycssmin css/braincrafted.tmp.css > css/braincrafted.min.css
	@rm css/braincrafted.css css/braincrafted.tmp.css
	@echo "${CHECK} Done"

build-compass:
	@echo "Compiling Sass...                       \c"
	@compass compile -q ${SASS_MASTER}
	@echo "${CHECK} Done"

build-jekyll:
	@echo "Compiling website...                    \c"
	@jekyll build > /dev/null
	@echo "${CHECK} Done"

build-js:
	@echo "Compiling and minifying JavaScript...   \c"
	@cat js-dev/picturefill.js js-dev/highlight.pack.js js-dev/braincrafted.js > js/braincrafted.tmp.js
	@uglifyjs js/braincrafted.tmp.js > js/braincrafted.min.js
	@rm js/braincrafted.tmp.js
	@echo "${CHECK} Done"

clean: clean-compass clean-jekyll clean-js

clean-jekyll:
	@echo "Cleaning generated website...           \c"
	@rm -rf _site/*
	@echo "${CHECK} Done"

clean-compass:
	@echo "Cleaning generated CSS files...         \c"
	@rm -f css/*
	@echo "${CHECK} Done"

clean-js:
	@echo "Cleaning generated JS files...          \c"
	@rm -rf js/*.min.js
	@echo "${CHECK} Done"

deploy: clean build
	@echo "Deploying website to server...          \c"
	@rsync -avq --delete-after build/ han:/var/www/braincrafted.com
	@echo "${CHECK} Done"

run-dev:
	@echo "Open site in development environment... \c"
	@echo "$$OPEN_SCRIPT" | sed "s/__OPEN_URL__/${DEV_URL}/" | osascript
	@echo "${CHECK} Done"

run:
	@echo "Open site in production environment...  \c"
	@echo "$$OPEN_SCRIPT" | sed "s/__OPEN_URL__/${PROD_URL}/" | osascript
	@echo "${CHECK} Done"

.PHONY: build build-css build-compass build-jekyll build-js clean clean-jekyll clean-compass clean-js deploy
