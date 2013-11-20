require 'resque'
require 'listen'
require 'fog'

require 'philbot/version'
require 'philbot/config'
require 'philbot/uploader'

module Philbot
  def self.run watchdir
    Philbot::Config.root = File.expand_path(watchdir)

    @@listener = Listen.to watchdir do |modified, added, removed|
      if added
        Resque.enqueue Philbot::Uploader, added.map{ |i| i.gsub('%s/' % watchdir, '')}
      end
      # we want to handle the other cases, too
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
