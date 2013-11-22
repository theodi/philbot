When(/^I create a new Philbot::Config object using file "(.*?)"$/) do |yaml|
  @config = Philbot::Config.new full_path yaml
end

Then(/^looking up "(.*?)" on the object should yield "(.*?)"$/) do |key, value|
  @config[key].should == value
end