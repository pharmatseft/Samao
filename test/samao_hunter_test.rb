require 'test_helper'

class SamaoHunterTest < Minitest::Test
  def test_hunter
    hunter = Samao::Hunter.new
    new_task = nil
    new_type = 'Paginator'

    hunter.run({'id' => 1, 'type' => 'Hunter', 'next_type' => new_type, 'url' => 'https://www.bing.com'}) do |n|
      new_task = n
    end

    assert new_type == new_task['type']
  end
end
