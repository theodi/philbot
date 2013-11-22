require 'resque'
require 'listen'
require 'fog'

require 'philbot/version'
require 'philbot/config'
require 'philbot/workers/uploader'
require 'philbot/workers/destroyer'
require 'philbot/providers/rackspace'

module Philbot
  def self.run watchdir
    Philbot::Config.root = File.expand_path(watchdir)

    @@listener = Listen.to watchdir do |modified, added, removed|
      unless added.empty?
        Resque.enqueue Philbot::Workers::Uploader, mapit(added, watchdir)
      end

      unless modified.empty?
        Resque.enqueue Philbot::Workers::Uploader, mapit(modified, watchdir)
      end

      unless removed.empty?
        Resque.enqueue Philbot::Workers::Destroyer, mapit(removed, watchdir)
      end
    end
    @@listener.start
  end

  def self.mapit list, parentdir
    list.map { |i| i.gsub('%s/' % parentdir, '')}
  end

  def self.work
    worker = Resque::Worker.new '*'
    worker.work 5
  end

  def self.stop
    #  @@listener.stop
  end
end
