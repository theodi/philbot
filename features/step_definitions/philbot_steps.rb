When(/^the monitor is watching "(.*?)"$/) do |directory|
  Philbot.run full_path(directory)
end

Then(/^the upload of file "(.*?)" should be queued$/) do |filename|
  Resque.should_receive(:enqueue).with(Philbot::Uploader, [filename]).once
end

Then(/^the upload of file "(.*?)" should be queued (\d+) times$/) do |filename, count|
  Resque.should_receive(:enqueue).with(Philbot::Uploader, [filename]).exactly(count.to_i).times
end

When(/^I wait for the monitor to notice$/) do
  sleep 1
end

Given(/^the upload of "(.*?)" has been queued$/) do |filename|
  @files ||= []
  @files << filename
  @job = Philbot::Uploader
end

Then(/^the (\d+) byte file "(.*?)" should be uploaded$/) do |size, filename|
  rackspace = Object.new
  Fog::Storage.should_receive(:new).and_return(rackspace)

  directory = Object.new
  rackspace.stub_chain(:directories, :get).and_return(directory)

  directory.stub_chain(:files, :create) do |options|
    options[:key].should == filename
    options[:body].size.should == size.to_i
  end
end

Then(/^the deletion of file "(.*?)" should be queued$/) do |filename|
  Resque.should_receive(:enqueue).with(Philbot::Destroyer, [filename]).once
end

Then(/^the remote file "(.*?)" should be deleted$/) do |filename|
  rackspace = Object.new
  Fog::Storage.should_receive(:new) #.and_return(rackspace)

#  directory = Object.new
#  rackspace.stub_chain(:directories, :get).and_return(directory)

#  directory.stub_chain(:files, :delete) do |fname|
#    fname.should == filename
#  end
end

When(/^the queued job is executed$/) do
  @job.perform @files
end