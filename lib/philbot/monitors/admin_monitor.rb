module Philbot
  module Monitors
    class AdminMonitor
      def self.run directory
        @@listener = Listen.to directory do |modified, added, removed|
          unless modified.empty?
            puts ">>> %s <<<" % modified.inspect
            Philbot::Config.instance.configure modified[0]
          end
        end

        @@listener.start
      end
    end
  end
end