###
# Blog settings
###

Time.zone = "Europe/Amsterdam"

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

  blog.layout = "article.html.haml"
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

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

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

    haml_tag(:ul, items.join, :class => 'pager')
  end

  def pagination_item_for(page)
    link_title = page.metadata[:locals]['page_number']
    pagination_item(link_title, page.url)
  end

  def pagination_item(link_title, link_path, options = {})
    if link_path == current_page.url
      content = content_tag(:span, link_title)
      options[:class] = "active"
    elsif link_path
      content = link_to(link_title, link_path)
    else
      content = content_tag(:span, link_title)
      options[:class] = "disabled"
    end

    content_tag(:li, content, options)
  end
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
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  
  # Or use a different image path
  # set :http_path, "/Content/images/"

  activate :gzip
  activate :minify_html
end

activate :deploy do |deploy|
  deploy.method = :rsync
  # host and path *must* be set
  deploy.host = "higherlearning.eu"
  deploy.path = "/srv/www/higherlearning/html"
  # user is optional (no default)
  deploy.user = "higherlearning"
  # port is optional (default is 22)
  deploy.port  = 22222
  # clean is optional (default is false)
  deploy.clean = true
  deploy.build_before = true
end

activate :asset_hash
activate :sprockets

#Use haml
set :haml, { :ugly => true, :format => :html5 }
