require 'fog/rackspace/models/storage/files'

module Philbot
  class Uploader
    @queue = :default

    def self.perform filename
#     puts "Uploading %s" % filename
     rackspace = Fog::Storage.new(
          {
              provider:           'Rackspace',
              rackspace_username: 'raxdemotheodi', #ENV['RACKSPACE_USERNAME'],
              rackspace_api_key:  'qwerty', #ENV['RACKSPACE_API_KEY'],
              rackspace_region:   :lon #ENV['RACKSPACE_REGION'].to_sym
          }
      )

      dir = rackspace.directories.get ENV['RACKSPACE_DB_CONTAINER']
      dir.files.create :key => filename, :body => File.open(tarpath)
    end
  end
end