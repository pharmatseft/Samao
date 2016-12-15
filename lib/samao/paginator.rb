module Samao
  class Paginator < Base
    attr_accessor :next_f, :item_f

    def initialize
    end

    def run(task)
      # task: {url, content}
      # parse content
      #task['content'] = '<html></html>'
      # if next_: yield next_, nil
      # for item_ in items: yield nil, item_
      new_task = task

      new_task['type'] = 'Fetcher'

      [@next_f, @item_f, @item_f].each do |e|
        if e == 'next'
          yield new_task.merge('next_f' => e)
        else
          yield new_task.merge('item_f' => e)
        end
      end
    end
  end
end
