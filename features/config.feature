@config
Feature: Generate a config object

  Scenario: Create config from file
    Given a file named "conf/philbot.yaml" with:
    """
    provider:  Rackspace
    username:  fake_philbot_user
    api_key:   fake_philbot_key
    region:    lon
    container: philbot
    """
    When I create a new Philbot::Config object using file "conf/philbot.yaml"
    Then looking up "username" on the object should yield "fake_philbot_user"
    And looking up "container" on the object should yield "philbot"

  Scenario: Config object should be a singleton
