require "philbot/version"
require "resque"

module Philbot
  def self.run watchdir
    @@listener = Listen.to watchdir  do |modified, added, removed|
      puts "modified absolute path: #{modified}"
      puts "added absolute path: #{added}"
      puts "removed absolute path: #{removed}"
    end
    @@listener.start
    # sleep
  end

  def self.stop
  #  @@listener.stop
  end
end
