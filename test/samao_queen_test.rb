require 'test_helper'

class SamaoQueenTest < Minitest::Test
  def test_queue_push_pop
    queue = Samao::Queen.new
    queue << 1
    assert 1 == queue.pop
  end
end
