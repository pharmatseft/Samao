require "spec_helper"

describe Samao::Detail do
  before(:all) do
    @detector = Samao::Detector.new do |detector|
      detector.base_url 'https://github.com'
      detector.from '/Lax?tab=repositories'

      detector.add_item 'div#user-repositories-list li' do |item|
        item.match :url, 'a[itemprop="name codeRepository"]' do |item|
          item.set_url :url, item.raw(:url).first['href']
        end
      end

      detector.add_detail :url do |detail|
        detail.match :name, 'h1.public strong[itemprop="name"] a' do |item|
          item.set :name, item.raw(:name).first.text.strip
        end
        detail.match :author, 'h1.public .author a' do |item|
          item.set :author, item.raw(:author).first.text.strip
        end
      end
    end.run
  end

  it 'can find items' do
    expect(@detector.items.size).to be >= 0
  end

  it 'can find item name' do
    expect(@detector.items.first).to have_key(:name)
  end

  it 'can find item author' do
    expect(@detector.items.last).to have_key(:author)
  end
end
