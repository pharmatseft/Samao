require 'test_helper'

class SamaoAnalyzerTest < Minitest::Test
  def test_analyzer
    anlz = Samao::Analyzer.new
    content = title = nil

    anlz.run({'id' => 1, 'type' => 'Analyzer', 'url' => 'https://www.bing.com', 'content' => '<html></html>'}) do |new_task|
      title = new_task['title']
      content = new_task['content']
    end

    assert title == 'TITLE'
    assert content == 'CONTENT'
  end
end
