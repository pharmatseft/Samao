module Samao
  class Detector
    include Matchable

    def initialize(params={})
      matchable

      @current_url = @base_url = @from = nil
      @pages = []
      @items = []

      yield self if block_given?

      self
    end

    # return Detector self
    def run
      while @from and @from.run.success? and @current_doc = @from.doc
        # find items in current_page
        if found = @current_doc.css(@selector[:item]) and found.size >= 1
          @items += found.map do |raw_item|
            item = Item.new(base_url: @current_url, raw_item:raw_item) do |item|
              @on[:item].call(item) if @on[:item]
            end.run

            if @detail_key
              detail = Detail.new(item: item, url: item.prop(@detail_key)) do |detail|
                @on[:detail].call(detail) if @on[:detail]
              end.run
            end

            item.prop
          end
        end

        # find next page[s] in current page
        if @selector[:next] and next_url = @current_doc.at_css(@selector[:next]) and next_url = URI.join(@current_url, next_url['href'])
          @on[:next].call(next_url) if @on[:next]
          from next_url
        else
          stop
        end
      end

      self
    end

    def add_detail(detail_key=:url, &block)
      @detail_key = detail_key
      @on[:detail] = block if block
    end

    def add_item(selector, &block)
      match(:item, selector, &block)
    end

    # set front page
    def from(url)
      if prev_url = @current_url || @base_url
        url = URI.join(prev_url, url)
      end
      url = URI(url) if ! url.is_a? URI

      @from = Catcher.new(url:url, base_url:@current_url)
      @pages << url
      @current_url = url

      self
    end

    # set base url
    def base_url(url)
      @base_url = url

      self
    end

    # get pages
    def pages
      @pages
    end

    # get items
    def items
      @items
    end

  private
    def stop
      @from = nil

      self
    end
  end
end
