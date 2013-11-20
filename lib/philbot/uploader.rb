module Philbot
  class Uploader
    @queue = :default

    def self.perform filename
      puts "Uploading %s" % filename
    end
  end
end