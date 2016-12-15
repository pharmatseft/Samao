require "samao/version"

require 'samao/queen'
require 'samao/base'
require 'samao/hunter'
require 'samao/paginator'
require 'samao/analyzer'

module Samao
  class Builder
    attr_accessor :queue, :hunter, :paginator, :analyzer

    def self.build
      smb = Samao::Builder.new
      yield smb

      smb
    end

    def initialize(concurrency=5)
      @queue ||= Queen.new
      @hunter ||= Hunter.new

      @semaphore = Queue.new
      concurrency.times { @semaphore.push(1) }
    end

    def run
      # push frontpage

      conf = { Hunter: @hunter, Paginator: @paginator, Analyzer: @analyzer }
      while task = @queue.pop do
        tp = task['type'].to_sym
        runner = conf[tp]

        @semaphore.pop
        runner.run task do |new_task|
        end
        @semaphore.push(1)
      end
    end
  end
end

# Samao::Builder.build do |s|
#   s.paginator 'frontpage' => 'http://_/index.html', 'next_f' => '', 'item_f' => ''
#   s.analyzer 'title' => '', 'content' => '', 'author' => ''
# end
