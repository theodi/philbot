require 'resque'
require 'listen'
require 'fog'

require 'philbot/version'
require 'philbot/config'
require 'philbot/workers/uploader'
require 'philbot/workers/destroyer'
require 'philbot/providers/rackspace'
require 'philbot/monitors/share_monitor'

module Philbot
  @@conffile = nil
  @@confdir = nil

  def self.configure yaml = 'conf/philbot.yaml'
    @@conffile = yaml
    @@confdir  = File.dirname yaml
    Philbot::Config.instance.configure yaml
  end
end
