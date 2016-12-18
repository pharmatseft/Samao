module Samao
  class Detail
    include Matchable

    def initialize(params={})
      matchable

      @item = params[:item]
      @url = params[:url]
      @base_url = params[:base_url]
      @catcher = Catcher.new(url:@url, base_url: @base_url)

      yield self if block_given?

      self
    end

    def run
      if @catcher and @catcher.run.success? and doc = @catcher.doc
        @selector.each do |name, sel|
          @item.set_raw name, doc.css(sel)
          @on[name].call @item if @on[name]
        end
      end

      self
    end

  end
end
