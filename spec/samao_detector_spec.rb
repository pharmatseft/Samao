require "spec_helper"

describe Samao::Detector do
  before(:all) do
    @detector = Samao::Detector.new do |detector|
      detector.base_url 'https://github.com'
      detector.from '/Lax?tab=repositories'

      detector.match :next, 'div.pagination a.next_page'

      detector.add_item 'div#user-repositories-list li a[itemprop="name codeRepository"]' do |item|
        item.set_url :url, item.raw[:item]['href']
        item.set :success, true
      end

    end.run
  end

  it 'is instance of Samao::Detector' do
    expect(@detector.class).to eq(Samao::Detector)
  end

  it 'can find next page' do
    expect(@detector.pages.size).to be > 1
  end

  it 'can find items' do
    expect(@detector.items.size).to be >= 0
  end
end
