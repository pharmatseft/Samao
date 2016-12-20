require "spec_helper"

describe Samao::Detail do
  before(:all) do
    @detector = Samao::Detector.new do |detector|
      detector.base_url 'https://github.com'
      detector.from '/Lax?tab=repositories'

      detector.find_item 'div#user-repositories-list li' do |item|
        item.find :url, 'a[itemprop="name codeRepository"]' do |value|
          [:set_url, value.first['href']]
        end
      end

      detector.add_detail :url do |detail|
        detail.find :name, 'h1.public strong[itemprop="name"] a' do |value|
          value.first.text.strip
        end
        detail.find :author, 'h1.public .author a' do |value|
          value.first.text.strip
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
