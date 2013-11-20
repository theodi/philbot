require "philbot/version"
require 'philbot/uploader'
require "resque"
require 'listen'

module Philbot
  def self.run watchdir
    @@listener = Listen.to watchdir do |modified, added, removed|
      puts "modified absolute path: #{modified}"
      puts "removed absolute path: #{removed}"
      if added
        puts "added absolute path: #{added}"
        Resque.enqueue Philbot::Uploader, added
      end
    end
    @@listener.start
  end

  def self.work
    worker = Resque::Worker.new '*'
    worker.work 5
  end

  def self.stop
    #  @@listener.stop
  end
end
