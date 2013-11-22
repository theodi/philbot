module Philbot
  module Providers
    class Rackspace
      def dir
        config = Philbot::Config.instance

        rackspace = Fog::Storage.new(
            {
                provider:           config['provider'],
                rackspace_username: config['rackspace_username'],
                rackspace_api_key:  config['rackspace_api_key'],
                rackspace_region:   config['region'].to_sym
            }
        )

        container = rackspace.directories.get config['container']

        container
      end
    end
  end
end