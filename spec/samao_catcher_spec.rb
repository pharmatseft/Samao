require "spec_helper"

describe Samao::Catcher do
  before(:all) do
    @gemname = 'Samao-Null-Spec'
    @gemver = '0.0.1'

    @catcher = Samao::Catcher.new(url: "https://rubygems.org/gems/#{@gemname}").run
  end

  it 'is instance of Samao::Catcher' do
    expect(@catcher.class).to eq(Samao::Catcher)
  end

  it "get result success" do
    expect(@catcher.success?).to be true
    expect(@catcher.code).to eq(200)
  end

  it "get gem name as title" do
    title = @catcher.doc.at_css("h1.page__heading a").content
    expect(title).to eq(@gemname)
  end

  it "get gem version as subtitle" do
    version = @catcher.doc.at_css("h1.page__heading i.page__subheading").content
    expect(version).to eq(@gemver)
  end
end
