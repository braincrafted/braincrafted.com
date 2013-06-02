notification :growl

guard :shell do
    # When layout or posts are modified, only rebuild jekyll
    watch /^(_(layouts|posts)\/)?[a-zA-Z0-9\-_]*\.(md|htm|html)/ do |m|
        `make build-jekyll`
        n "Rebuilt Jekyll"
    end

    # When JavaScript is modified, build JS and Jekyll
    watch /^js-dev\/.*\.js/ do |m|
        `make build-js build-jekyll`
        n "Rebuilt JavaScript and Jekyll"
    end

    # When Sass is modified, build CSS and Jekyll
    watch /^sass\/(.*)\.s[ac]ss/ do |m|
        `make build-css build-jekyll`
        n "Rebuilt CSS and Jekyll"
    end

end
