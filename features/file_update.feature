@update
Feature: Upload file on change

  Scenario: Queue file when changed
    Given a directory named "watchme/"
    Then the upload of file "file_03" should be queued 2 times
    When the monitor is watching "watchme/"
    Given a file named "watchme/file_03" with:
    """
    MORECAMBE

    """
    And I wait for the monitor to notice
    And I append to "watchme/file_03" with:
    """
    WISE

    """
    And I wait for the monitor to notice

#  Scenario: Update file when changed
#    Given a directory named "watchme/"
#    And a 1024 byte file named "watchme/file_03"
#    And the file upload of "file_03" has been queued
#    Then the 1024 byte file "file_03" should be uploaded
#    When the queued job is executed
#
#    Given a 2048 byte file named "watchme/file_03"
#    And the file upload of "file_03" has been queued
#    Then the 2048 byte file "file_03" should be uploaded
#    When the queued job is executed
