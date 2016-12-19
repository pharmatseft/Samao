module Samao
  class Catcher
    require 'open-uri'
    require 'nokogiri'

    # accpet url
    # return Catcher self
    def initialize(params)
      @url = params[:url]
      @code = 0

      @headers = {}
      @headers["Referer"] = params[:base_url].to_s if params[:base_url]
      @headers["User-Agent"] = "Samao/%s; Ruby/%s" % [Samao::VERSION, RUBY_VERSION]

      self
    end

    # return Catcher self
    def run
      begin

        open(@url, @headers) do |f|
          begin
            @doc = Nokogiri::HTML(f)
            @code = 200
          rescue
            @code = 500
          end
        end
      rescue
        @code = 400
      end

      self
    end

    # catcher task is success or not
    def success?
      @code == 200
    end

    # catcher task result with code and doc
    def result
      code:@code, doc:@doc
    end

    # catcher task result doc
    def doc
      @doc
    end

    # catcher task result code
    def code
      @code
    end
  end
end
