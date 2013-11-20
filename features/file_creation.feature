Feature: Upload file on create

  Scenario: Queue file when created
    Given a directory named "watchme/"
    Then the upload of file "watchme/file_01" should be queued
    When the monitor is watching "watchme/"
    And I write to "watchme/file_01" with:
    """
    DUMMY TEXT
    """
    And I wait for the monitor to notice
