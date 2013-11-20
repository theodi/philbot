module Philbot
  class Config
    def self.root
      @@root
    end

    def self.root= value
      @@root = value
    end
  end
end