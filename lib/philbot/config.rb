require 'yaml'

module Philbot
  class Config
    def self.root
      @@root
    end

    def self.root= value
      @@root = value
    end

    def initialize yaml_file
      @yaml_file = yaml_file

      y = YAML.load File.open yaml_file
      @options = y
    end

    def [] key
      @options[key]
    end
  end
end