@create
Feature: Upload file on create

  Scenario: Queue file when created
    Given a directory named "watchme/"
    Then the upload of file "file_01" should be queued
    When the monitor is watching "watchme/"
    And I write to "watchme/file_01" with:
    """
    RICHARD PRYOR
    """
    And I wait for the monitor to notice

  Scenario: Upload file when queued
    Given a directory named "watchme/"
    And a 512 byte file named "watchme/file_02"
    And the upload of "file_02" has been queued
    Then the 512 byte file "file_02" should be uploaded
    When the queued job is executed