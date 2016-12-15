module Samao
  class Analyzer < Base
    attr_accessor :title, :content

    def initialize
    end

    def run(task)
      # task: {url, content}
      new_task = task
      new_task.delete 'type'

      new_task['title'] = 'TITLE'
      new_task['content'] = 'CONTENT'

      yield new_task
    end
  end
end
