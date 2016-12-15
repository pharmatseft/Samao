module Samao
  class Base
    def push(type, payload={})
      payload['type'] = type

      @queue << payload
    end

    def push_fetcher(type, payload={})
      payload['next_type'] ||= type

      push 'Fetcher', payload
    end
  end
end
