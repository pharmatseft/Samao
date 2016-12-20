module Samao
  module Matchable
    def matchable?
      true
    end

    def matchable
      @cmd_sets = [:set, :set_url] ## target class should inplements methods as: set(name, value)
      @selector = {}
      @on = {}
    end

    def find(name, selector, &block)
      @selector[name] = selector

      @on[name] = block if block

      self
    end
    alias match find

    def found(name, value, target=self)
      cmd = :set

      if @on[name]
        value = @on[name].call value
        if value.is_a? Array and @cmd_sets.include?(value[0].to_sym)
          case value.length
          when 2
            cmd, value = value
          when 3
            cmd, name, value = value
          end
        end
        target.send cmd, name, value
      end

      target.send cmd, name, value
    end

  end
end
