# will_paginate_infinite
[![gem version](https://img.shields.io/gem/v/will_paginate_infinite.svg)](http://rubygems.org/gems/will_paginate_infinite)

Will Paginate with infinite scroll for Rails

## Instalation

Include the gem in your Gemfile:
```
gem 'will_paginate_infinite'
```
And then execute:
```
$ bundle install
```


Adds to `app/assets/stylesheets/application.scss`:
```
*= require will_paginate_infinite
```

And javascript to `app/assets/javascripts/application.js`:
```
//= require will_paginate_infinite
```


## Configuration
In your index view pagination :
```
# app/views/news/index.html.erb
<h1>News List</h1>

<div class="list-news">
  <ul>
    <% @news.each do |item| %>
      <%= render item %>
    <% end %>
  </ul>

  <%= will_paginate @news, renderer: WillPaginateInfinite::InfinitePagination %>
</div>
```
Will paginate renderer: `WillPaginateInfinite::InfinitePagination`


In content partial view:
```
# app/views/news/_news.html.erb
<li>
  <%= item.title %>
</li>
```

And in controller/action with items to be paginated:
```
# app/controllers/news_controller.rb
class NewsController < ApplicationController
  def index
    @news = News.order(:created_at).paginate(:page => params[:page], :per_page => 30)
    # ...

    respond_to do |format|
      format.html
      format.js
    end
  end
end
```

Creates a javascript version from your index view:
```
# app/views/news/index.js.erb
<%= infinite_append ".list-news ul", @news %>
```
or
```
# app/views/news/index.js.erb
<%= infinite_append ".list-news ul", { partial: "news/news", collection: @news }  %>
```

## Example
Example using will_paginate_infinite with Rails 4: https://github.com/Godoy/will_paginate_infinite_example


## Contributing

1. Fork it (https://github.com/PlanBCom/will_paginate_infinite/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.
