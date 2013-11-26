require 'resque'
require 'listen'
require 'fog'

require 'philbot/version'
require 'philbot/config'
require 'philbot/workers/uploader'
require 'philbot/workers/destroyer'
require 'philbot/providers/rackspace'
require 'philbot/monitors/share_monitor'
require 'philbot/monitors/admin_monitor'

module Philbot
  def self.configure yaml = 'conf/philbot.yaml'
     Philbot::Config.instance.configure yaml
  end

  def self.run watchdir, confdir
    Philbot::Monitors::ShareMonitor.run watchdir
#    Philbot::Monitors::AdminMonitor.run confdir
  end

  def self.work
    worker = Resque::Worker.new '*'
    worker.work 5
  end
end
