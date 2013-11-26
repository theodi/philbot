require 'yaml'
require 'singleton'

module Philbot
  class Config
    include Singleton

    def self.root
      @@root
    end

    def self.root= value
      @@root = value
    end

    def configure yaml_file = 'conf/philbot.yaml'
      @yaml_file = yaml_file

      y = YAML.load File.open yaml_file
#      puts ">>> CONFIGURING WITH %s <<<" % y
      @options = y
    end

    def [] key
      @options[key]
    end
  end
end