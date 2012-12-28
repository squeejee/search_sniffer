# Search::Sniffer

Simple plugin to sniff inbound search terms from popular search engines

## Installation


Add this line to your application's Gemfile:

```ruby
gem 'search-sniffer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search-sniffer

## Usage

```ruby
class ApplicationController < ActionController::Base
  before_filter :sniff_referring_search
  ...
end
```

The plugin populates the @@referring_search@ object containing info that can be passed to a keyword highlighter or internal site search engine to pull related content. For an HTTP referer of @http://www.google.com/search?q=ruby+on+rails+houston&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a@@

```ruby
@referring_search.search_terms
 => "ruby rails houston"
@referring_search.raw
 => "ruby on rails houston"
@referring_search.engine
 => "google"
```

Copyright (c) 2008 Squeejee, released under the MIT license

Converted to Rails gem by Alexander Timofeev (https://github.com/ATimofeev) 2012

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request