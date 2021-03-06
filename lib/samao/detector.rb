module Samao
  class Detector
    include Matchable

    def initialize(params={})
      matchable

      @current_url = @baseurl = @from = @max_page = nil
      @pages = []
      @items = []

      @queue_of_items = Queue.new

      @semaphore = Queue.new
      @max_concurrent = params[:max_concurrent] || 5
      @max_concurrent.times { @semaphore.push(1) }

      yield self if block_given?

      self
    end

    # return Detector self
    def run
      threads = []
      while @from
        break unless @from.run.success?
        @current_doc = @from.doc

        # find items in current_page
        if found = @current_doc.css(@selector[:item]) and found.size >= 1
          found.each do |raw_item|
            threads << Thread.new do
              @semaphore.pop
              # puts "#{Time.now} #{@semaphore.size} available tokens. #{@semaphore.num_waiting} threads waiting."

              begin
                item = Item.new(baseurl: @current_url, raw_item:raw_item) do |item|
                  @on[:item].call(item) if @on[:item]
                end.run

                if @detail_key
                  detail = Detail.new(item: item, url: item.prop(@detail_key)) do |detail|
                    @on[:detail].call(detail) if @on[:detail]
                  end.run
                end

                @queue_of_items.push item.prop
              rescue => e
                p e
              ensure
                @semaphore.push(1)
              end
            end # end Thread
          end # end found.each loop
        end # end if found

        # find next page[s] in current page
        if @max_page and @pages.size >= @max_page
          stop
        elsif @selector[:next] and next_url = @current_doc.at_css(@selector[:next]) and next_url = URI.join(@current_url, next_url['href'])
          @on[:next].call(next_url) if @on[:next]
          from next_url
        else
          stop
        end
      end # end while @from

      threads.each(&:join)

      threads.size.times do
        item = @queue_of_items.pop
        @items << item
      end

      self
    end

    def add_detail(detail_key=:url, &block)
      @detail_key = detail_key
      @on[:detail] = block if block
    end

    def find_item(selector, &block)
      find(:item, selector, &block)
    end

    # set front page
    def from(url)
      if prev_url = @current_url || @baseurl
        url = URI.join(prev_url, url)
      end
      url = URI(url) if ! url.is_a? URI

      @from = Catcher.new(url:url, baseurl:@current_url)
      @pages << url
      @current_url = url

      self
    end

    # set base url
    def baseurl(url)
      @baseurl = url

      self
    end

    # set max page
    def max_page(max)
      @max_page = max

      self
    end

    # set max concurrent level
    def max_concurrent(max)
      @max_concurrent = max

      self
    end
    alias :concurrent :max_concurrent

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
