require "spec_helper"

describe Samao::Item do
  before(:all) do
    @detector = Samao::Detector.new do |detector|
      detector.base_url 'https://github.com'
      detector.from '/Lax?tab=repositories'

      detector.find_item 'div#user-repositories-list li' do |item|
        item.find :url, 'a[itemprop="name codeRepository"]' do |value|
          [:set_url, :url, value.first['href']]
        end

        item.find :title, 'a[itemprop="name codeRepository"]' do |value|
          value.first.text.strip
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
