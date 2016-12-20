# Samao

Samao is a simple and easy to use web-crawlar written in ruby.

[![Build Status](https://travis-ci.org/Lax/Samao.svg?branch=master)](https://travis-ci.org/Lax/Samao)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'samao'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install samao

## Usage

    #!/usr/bin/env ruby
    require 'samao'

    # create samao detector
    samao = Samao::Detector.new

    # set base url and start page
    samao.baseurl 'https://github.com'
    samao.from '/Lax?tab=repositories'
    # the following line have the same effect
    #samao.from  'https://github.com/Lax?tab=repositories'

    # tell samao how to find the next page
    samao.find :next, 'div.pagination a.next_page'
    samao.max_page 1

    # tell samao how to find items.
    # further more, set the data from matched HTML node/element.
    samao.find_item 'div#user-repositories-list li a[itemprop="name codeRepository"]' do |item|
      item.set_url :url, item.raw(:item)['href']
      item.set :title, item.raw(:item).text.strip
    end

    samao.find_item 'div#user-repositories-list li' do |item|
      item.find(:url, 'a[itemprop="name codeRepository"]') {|value| [:set_url, :url, value.first['href']] }
      item.find(:title, 'a[itemprop="name codeRepository"]') {|value| [:set, value.first.text.strip] }
    end

    # if it need to open content page for more information
    # default key is :url
    samao.add_detail :url do |detail|
    #samao.add_detail do |detail|
      detail.find(:author, 'h1.public .author a') {|value| value.first.text.strip }
    end

    # run the detector
    samao.run

    # read items
    p samao.items
    ## [{:url=>"https://github.com/Lax/awesome", :title=>"awesome", :author=>"Lax"}, {:url=>"https://github.com/Lax/lax.github.com", :title=>"lax.github.com", :author=>"Lax"}, ..]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Lax/Samao. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
