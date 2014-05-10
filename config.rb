###
# Blog settings
###

Time.zone = "Europe/Amsterdam"

ignore "wercker.yml"
ignore "bower_components/*"

activate :blog do |blog|
  # blog.prefix = "blog"
  # blog.permalink = ":year/:month/:day/:title.html"
  # blog.sources = ":year-:month-:day-:title.html"
  # blog.taglink = "tags/:tag.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  # blog.default_extension = ".markdown"

  blog.layout = "article"
  blog.sources = "articles/:year-:month-:day-:title.html"
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.paginate = true
  blog.per_page = 2
  blog.page_link = "page/:num"
end

page "/feed.xml", :layout => false
page "/404.html", :layout => false

###
# Compass
###

compass_config do |config|
  # Require any additional compass plugins here.
  config.add_import_path "bower_components/foundation/scss"

  # Set this to the root of your project when deployed:
  config.http_path = "/"
  config.css_dir = "stylesheets"
  config.sass_dir = "stylesheets"
  config.images_dir = "images"
  config.javascripts_dir = "javascripts"

  # You can select your preferred output style here (can be overridden via the command line):
  # output_style = :expanded or :nested or :compact or :compressed

  # To enable relative paths to assets via compass helper functions. Uncomment:
  # relative_assets = true

  # To disable debugging comments that display the original location of your selectors. Uncomment:
  # line_comments = false


  # If you prefer the indented syntax, you might want to regenerate this
  # project again passing --syntax sass, or you can uncomment this:
  # preferred_syntax = :sass
  # and then run:
  # sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass

end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Add syntax support
activate :syntax, line_numbers: true

# Add disqus
activate :disqus do |d|
  d.shortname = "higherlearningtheblog"
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end
helpers do

  def locals_for(page, key)
    page && page.metadata[:locals][key]
  end

  def pagination_links

    if locals_for(current_page, 'num_pages') == 1
      return nil
    end

    prev_link = pagination_item('&lsaquo;', locals_for(current_page, 'prev_page').try(:url))
    next_link = pagination_item('&rsaquo;', locals_for(current_page, 'next_page').try(:url))

    items = []

    # Add the current page
    page = current_page

    # Add the prior pages
    i = 0
    while page = locals_for(page, 'prev_page')
      if (i < 2)
        items.unshift pagination_item_for(page)
        i += 1
      end
      first_page = page
    end
    first_link = pagination_item('&laquo;', first_page.try(:url))

    # Add all subsequent pages
    page = current_page
    items.push pagination_item_for(current_page)

    i = 0
    while page = locals_for(page, 'next_page')
      if (i < 2)
        items.push pagination_item_for(page)
        i += 1
      end
      last_page = page
    end
    last_link = pagination_item('&raquo;', last_page.try(:url))

    # Combine the items with the prev/next links
    items = [first_link, prev_link, items, next_link, last_link].flatten

    content_tag(:ul, items.join, :class => 'pagination')
  end

  def pagination_item_for(page)
    link_title = page.metadata[:locals]['page_number']
    pagination_item(link_title, page.url)
  end

  def pagination_item(link_title, link_path, options = {})
    if link_path == current_page.url
      options[:class] = "current"
    elsif link_path
    else
      options[:class] = "unavailable"
    end

    content = link_to(link_title, link_path)
    content_tag(:li, content, options)
  end
end

###
# Gem
###
require 'slim'
Slim::Engine.set_default_options pretty: true, sort_attrs: false

# Add bower's directory to sprockets asset path
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_path, "/Content/images/"

  #activate :gzip
  activate :minify_html
end
