notification :growl

# Ignore the following diretories and files
ignore %r{^_site/}, /Guardfile/, /config.rb/, /code/

guard :shell do
    # When HTML and Markdown files are modified run Jekyll
    watch /^.*\.(md|htm|html)/ do |m|
        `make build-jekyll`
        n "Built HTML for braincrafted.com"
        m[0]
    end

    # When JavaScript is modified build JS and Jekyll
    watch /^js-dev\/.*\.js/ do |m|
        `make build-js build-jekyll`
        n "Built HTML and JavaScript for braincrafted.com"
        m[0]
    end

    # When Sass is modified build CSS and Jekyll
    watch /^sass\/(.*)\.s[ac]ss/ do |m|
        `make build-css build-jekyll`
        n "Built HTML and CSS for braincrafted.com"
        m[0]
    end

end
