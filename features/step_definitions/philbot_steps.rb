When(/^the monitor is watching "(.*?)"$/) do |directory|
  Philbot.run full_path(directory)
end

Then(/^the upload of file "(.*?)" should be queued$/) do |filename|
  Resque.should_receive(:enqueue).with(Philbot::Uploader, [full_path(filename)]).once
end

When(/^I wait for the monitor to notice$/) do
  sleep 1
end

Given(/^the file upload of "(.*?)" has been queued$/) do |filename|
  @files ||= []
  @files << full_path(filename)
  @job = Philbot::Uploader
end

Then(/^the file "(.*?)" should be uploaded$/) do |filename|
  Fog::Storage::Rackspace::Files.any_instance.should_receive(:create) do |options|
    options[:key].should == filename
    options[:body].length.should == 512
  end
end

When(/^the queued job is executed$/) do
  @job.perform @files
end