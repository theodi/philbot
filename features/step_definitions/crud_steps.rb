#When(/^the (.*) monitor is watching "(.*?)"$/) do |monitor, directory|
#  # I'm sure there's a way to extract this from the string
#  Philbot::Monitors::ShareMonitor.run full_path(directory)
#end

When(/^the (.*) monitor is watching "(.*?)"( including the trailing slash)?$/) do |monitor, directory, boolean|
  trailing = ''
  if boolean
    trailing = '/'
  end
  s = 'Philbot::Monitors::%sMonitor' % monitor.capitalize
  Kernel.const_get(s).run full_path(directory + trailing)
#  Philbot::Monitors::ShareMonitor.run full_path(directory) + trailing
end

Then(/^the upload of file "(.*?)" should( not)? be queued$/) do |filename, boolean|
  if boolean
    Resque.should_not_receive(:enqueue).with(Philbot::Workers::Uploader, [filename])
  else
    Resque.should_receive(:enqueue).with(Philbot::Workers::Uploader, [filename]).once
  end
end

Then(/^the upload of file "(.*?)" should be queued (\d+) times$/) do |filename, count|
  Resque.should_receive(:enqueue).with(Philbot::Workers::Uploader, [filename]).exactly(count.to_i).times
end

When(/^I wait for the monitor to notice$/) do
  sleep 2
end

Given(/^the upload of "(.*?)" has been queued$/) do |filename|
  @files ||= []
  @files << filename
  @job = Philbot::Workers::Uploader
end

Given(/^the deletion of remote file "(.*?)" has been queued$/) do |filename|
  @files ||= []
  @files << filename
  @job = Philbot::Workers::Destroyer
end

Then(/^the deletion of file "(.*?)" should be queued$/) do |filename|
  Resque.should_receive(:enqueue).with(Philbot::Workers::Destroyer, [filename]).once
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

Then(/^the remote file "(.*?)" should be deleted$/) do |filename|
  rackspace = Object.new
  Fog::Storage.should_receive(:new).and_return(rackspace)

  directory = Object.new
  rackspace.stub_chain(:directories, :get).and_return(directory)

  directory.stub_chain(:files, :destroy) do |fname|
    fname.should == filename
  end
end

When(/^the queued job is executed$/) do
  @job.perform @files
end