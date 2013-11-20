require 'fog/rackspace/models/storage/files'

module Philbot
  class Uploader
    @queue = :default

    def self.perform filenames
      rackspace = Fog::Storage.new(
          {
              provider:           'Rackspace',
              rackspace_username: 'fake_username', #ENV['RACKSPACE_USERNAME'],
              rackspace_api_key:  'api_key_of_fake', #ENV['RACKSPACE_API_KEY'],
              rackspace_region:   :lon #ENV['RACKSPACE_REGION'].to_sym
          }
      )

      dir = rackspace.directories.get 'fake_bucket' # ENV['RACKSPACE_DB_CONTAINER']
      filenames.each do |filename|
        dir.files.create :key => filename, :body => File.open(File.join(Philbot::Config.root, filename))
      end
    end
  end
end