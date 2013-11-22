require 'fog/rackspace/models/storage/files'

module Philbot
  module Workers
    class Uploader
      @queue = :default

      def self.perform filenames
        dir = Philbot::Providers::Rackspace.new.dir
        filenames.each do |filename|
          dir.files.create :key => filename, :body => File.open(File.join(Philbot::Config.root, filename))
        end
      end
    end
  end
end