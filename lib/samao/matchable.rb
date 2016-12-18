module Samao
  module Matchable
    def matchable?
      true
    end

    def matchable
      @selector = {}
      @on = {}
    end

    def match(name, selector, &block)
      @selector[name] = selector

      @on[name] = block if block

      self
    end

  end
end
