Then(/^the upload of file "(.*?)" should be queued$/) do |filename|
  Resque.should_receive :enqueue, {:file => filename}
end