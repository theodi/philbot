When(/^I create a new Philbot::Config object using file "(.*?)"$/) do |yaml|
  Philbot::Config.instance.configure full_path yaml
end

Then(/^looking up "(.*?)" on the object should yield "(.*?)"$/) do |key, value|
  Philbot::Config.instance[key].should == value
end

