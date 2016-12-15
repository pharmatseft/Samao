module Samao
  class Hunter < Base
    def initialize
    end

    def run(task)
      # task: {url, next_type}
      # curl url
      task['type'] = task['next_type']
      task.delete 'next_type'
      task['content'] = '<html></html>'

      yield task
    end
  end
end
