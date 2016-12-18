require "spec_helper"

describe Samao::Item do
  before(:all) do
    @detector = Samao::Detector.new do |detector|
      detector.base_url 'https://github.com'
      detector.from '/Lax?tab=repositories'

      detector.add_item 'div#user-repositories-list li' do |item|
        item.match :url, 'a[itemprop="name codeRepository"]' do |item|
          item.set_url :url, item.raw(:url).first['href']
        end

        item.match :title, 'a[itemprop="name codeRepository"]' do |item|
          item.set :title, item.raw(:title).first.text.strip
        end
      end

    end.run
  end

  it 'can find items' do
    expect(@detector.items.size).to be > 0
  end

  it 'can find item title' do
    expect(@detector.items.first).to have_key(:title)
  end

  it 'can find item url' do
    expect(@detector.items.last).to have_key(:url)
  end
end
