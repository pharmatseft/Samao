module Samao
  class Item
    include Matchable

    def initialize(params={})
      matchable

      @prop = {}   # usefull properties
      @raw = {}    # nodes go here.

      @base_url = params[:base_url]
      set_raw :item, params[:raw_item] if params[:raw_item]

      yield self if block_given?

      self
    end

    def extract
      @selector.each do |name, sel|
        found(name, @raw[:item].css(sel))
      end

      self
    end
    alias :run :extract

    def set(name, value)
      @prop[name] = value
    end

    def set_url(name, value)
      value = URI.join @base_url, value if @base_url
      set(name, value.to_s)
    end

    def prop(name=nil)
      if name
        return @prop[name]
      else
        return @prop
      end
    end

    def set_raw(name, value)
      @raw[name] = value
    end

    def raw(name=nil)
      if name
        return @raw[name]
      else
        return @raw
      end
    end
  end
end
