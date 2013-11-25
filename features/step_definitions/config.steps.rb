When(/^I create a new Philbot::Config object using file "(.*?)"$/) do |yaml|
  Philbot::Config.instance.configure full_path yaml
end

Then(/^looking up "(.*?)" on the object should yield "(.*?)"$/) do |key, value|
  Philbot::Config.instance[key].should == value
end

Given(/^a dummy config object$/) do
  steps %{
    Given a file named "conf/philbot.yaml" with:
    """
    provider:  Rackspace
    username:  fake_philbot_user
    api_key:   fake_philbot_key
    region:    lon
    container: philbot
    """
    When I create a new Philbot::Config object using file "conf/philbot.yaml"
  }
end

When(/^the admin monitor is watching "(.*?)"$/) do |directory|
  Philbot::Monitors::AdminMonitor.run full_path(directory)
end