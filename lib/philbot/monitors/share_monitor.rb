module Philbot
  module Monitors
    class ShareMonitor
      def self.run watchdir
        Philbot::Config.root = File.expand_path(watchdir)

        @@listener = Listen.to watchdir do |modified, added, removed|
          unless added.empty?
            Resque.enqueue Philbot::Workers::Uploader, mapit(added, watchdir)
          end

          unless modified.empty?
            Resque.enqueue Philbot::Workers::Uploader, mapit(modified, watchdir)
          end

          unless removed.empty?
            Resque.enqueue Philbot::Workers::Destroyer, mapit(removed, watchdir)
          end
        end
        @@listener.start
      end

      def self.mapit list, parentdir
        pd = parentdir.gsub(/\/$/, '')
        list.delete_if { |i| File.basename(i)[0] == '.' }
        list.map { |i| i.gsub('%s/' % pd, '') }
      end
    end
  end
end