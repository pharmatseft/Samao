require 'test_helper'

class SamaoPaginatorTest < Minitest::Test
  def test_paginator
    pagi = Samao::Paginator.new
    pagi.next_f = 'next' # parse
    pagi.item_f = 'item' # items

    n = nil
    i = []
    pagi.run({'id' => 1, 'type' => 'Paginator', 'url' => 'https://www.bing.com', 'content' => '<html></html>'}) do |new_task|
      if new_task['next_f']
        n = new_task['next_f']
      elsif new_task['item_f']
        i << new_task['item_f']
      end
    end

    assert n == 'next'
    assert i.size == 2
    assert i[0] == 'item'
  end
end
