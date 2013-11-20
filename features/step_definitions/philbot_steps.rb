When(/^the monitor is watching "(.*?)"$/) do |directory|
  Philbot.run aruba_tmp + '/' + directory
end

Then(/^the upload of file "(.*?)" should be queued$/) do |filename|
  Resque.should_receive(:enqueue).with(Philbot::Uploader, [File.expand_path(aruba_tmp + '/' + filename)]).once
end

When(/^I wait for the monitor to notice$/) do
  sleep 1
end