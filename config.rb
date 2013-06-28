activate :sprockets
activate :jasmine

set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'
set :source,     'src'

configure :build do
  activate :minify_css
  activate :minify_javascript
end
