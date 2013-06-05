# Notification via Growl when files change
notification :growl

# Ignore the following diretories and files
ignore %r{^_site/}, %r{/Guardfile/}, %r{/config.rb/}, %r{/code/}, %r{/css(-dev)?/}, %r{/js/}

guard :shell do

    # When HTML and Markdown files are modified run Jekyll
    watch(/^.*\.(md|htm|html|xml)/) do |m|
        `make build-jekyll run-dev`
        n "Built HTML for braincrafted.com"
        m[0]
    end

    # When JavaScript is modified build JS and Jekyll
    watch(/^js-dev\/.*\.js/) do |m|
        `make build-js build-jekyll run-dev`
        n "Built HTML and JavaScript for braincrafted.com"
        m[0]
    end

    # When Sass is modified build CSS and Jekyll
    watch(/^sass\/(.*)\.s[ac]ss/) do |m|
        `make build-css build-jekyll run-dev`
        n "Built HTML and CSS for braincrafted.com"
        m[0]
    end

end
