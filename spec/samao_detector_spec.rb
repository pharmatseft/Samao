require "spec_helper"

describe Samao::Detector do
  before(:all) do
    @max_page = 3
    @detector = Samao::Detector.new do |detector|
      detector.base_url 'https://github.com'
      detector.from '/Lax?tab=repositories'

      detector.find :next, 'div.pagination a.next_page'
      detector.max_page @max_page

      detector.find_item 'div#user-repositories-list li a[itemprop="name codeRepository"]' do |item|
        item.set_url :url, item.raw[:item]['href']
        item.set :success, true
      end

    end.run
  end

  it 'is instance of Samao::Detector' do
    expect(@detector.class).to eq(Samao::Detector)
  end

  it 'can find next page, limit to max_page' do
    expect(@detector.pages.size).to eq @max_page
  end

  it 'can find items' do
    expect(@detector.items.size).to be > 30 * (@max_page - 1)
  end
end
