require 'resque'
require 'listen'
require 'fog'

require 'philbot/version'
require 'philbot/config'
require 'philbot/workers/uploader'
require 'philbot/workers/destroyer'
require 'philbot/providers/rackspace'

module Philbot
  @@conffile = nil
  @@confdir = nil

  def self.configure yaml = 'conf/philbot.yaml'
    @@conffile = yaml
    @@confdir  = File.dirname yaml
    Philbot::Config.instance.configure yaml
  end

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

#    @@conflistener = Listen.to confdir do |m, a, r|
#      unless m.empty?
#        self.configure @@conffile
#      end
#    end

#   @@conflistener.start
  end

  def self.mapit list, parentdir
    pd = parentdir.gsub(/\/$/, '')
    list.delete_if { |i| File.basename(i)[0] == '.' }
    list.map { |i| i.gsub('%s/' % pd, '') }
  end

  def self.work
    worker = Resque::Worker.new '*'
    worker.work 5
  end
end
