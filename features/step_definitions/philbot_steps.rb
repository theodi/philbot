When(/^the monitor is watching "(.*?)"$/) do |directory|
  Philbot.run "tmp/aruba/%s" % directory
end

Then(/^the upload of file "(.*?)" should be queued$/) do |filename|
  Resque.should_receive(:enqueue)#.with(Philbot::Uploader, filename).once
end

When(/^I wait for the monitor to notice$/) do
  sleep 1
end