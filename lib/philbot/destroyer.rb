module Philbot
  class Destroyer
    @queue = :default

    def self.perform filenames
      puts 'Destroying %s' % filenames.inspect
    end
  end
end