module Samao
  class Detail
    include Matchable

    def initialize(params={})
      matchable

      @item = params[:item]
      @url = params[:url]
      @baseurl = params[:baseurl]
      @catcher = Catcher.new(url:@url, baseurl: @baseurl)

      yield self if block_given?

      self
    end

    def run
      if @catcher and @catcher.run.success? and doc = @catcher.doc
        @selector.each do |name, sel|
          found(name, doc.css(sel), @item)
        end
      end

      self
    end

  end
end
