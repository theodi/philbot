require 'fog/rackspace/models/storage/files'

module Philbot
  module Workers
    class Destroyer
      @queue = :default

      def self.perform filenames
        dir = Philbot::Providers::Rackspace.new.dir
        filenames.each do |filename|
          dir.files.destroy filename
        end
      end
    end
  end
end