#!/usr/bin/env ruby
require 'samao'
require 'yaml'

# create samao detector
samao = Samao::Detector.new

# set max concurrent level
samao.concurrent 3

# set base url and start page
samao.baseurl 'https://www.expireddomains.net'
samao.from '/deleted-io-domains/?start=0&fwhois=22'

# tell samao how to find the next page
samao.find :next, 'div.expiredio div.listing div.pagescode.page_top div.right a.next'

# tell samao how to find items.
# further more, set the data from matched HTML node/element.
samao.find_item 'div.expiredio div.listing table td.field_domain > a:first' do |item|
  item.set :domain, item.raw(:item).text.strip
end

# run the detector
samao.run

# read items
puts samao.items.sort {|x, y| x[:domain].downcase <=> y[:domain].downcase }.to_yaml
## [{:url=>"https://github.com/Lax/awesome", :title=>"awesome", :author=>"Lax"}, {:url=>"https://github.com/Lax/lax.github.com", :title=>"lax.github.com", :author=>"Lax"}, ..]
