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
    expect(true).to eq(@catcher.success?)
    expect(@catcher.code).to eq(200)
  end

  it "get gem name as title" do
    title = @catcher.doc.css("h1.page__heading a")
    expect(title.length).to eq(1)
    title = title.first.content
    expect(title).to eq(@gemname)
  end

  it "get gem version as subtitle" do
    version = @catcher.doc.css("h1.page__heading i.page__subheading")
    expect(version.length).to eq(1)
    version = version.first.content
    expect(version).to eq(@gemver)
  end
end
