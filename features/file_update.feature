@update
Feature: Upload file on change

  Scenario: Queue file when changed
    Given a directory named "watchme/"
    Then the upload of file "file_01" should be queued 2 times
    When the monitor is watching "watchme/"
    Given a file named "watchme/file_01" with:
    """
    MORECAMBE

    """
    And I wait for the monitor to notice
    And I append to "watchme/file_01" with:
    """
    WISE

    """
    And I wait for the monitor to notice

  Scenario: Update file when changed
    Given a directory named "watchme/"
    And a file named "watchme/file_02" with:
    """
    DEREK

    """
    And the upload of "file_02" has been queued
    Then the 6 byte file "file_02" should be uploaded
    When the queued job is executed
    And I append to "watchme/file_02" with:
    """
    CLIVE

    """
    And the upload of "file_02" has been queued
    Then the 12 byte file "file_02" should be uploaded
    When the queued job is executed
