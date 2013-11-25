@delete
Feature: Delete remote file on local delete

  Scenario: Delete remote file when deleted locally
    Given a directory named "watchme/"
    Then the upload of file "file_01" should be queued
    When the monitor is watching "watchme/"
    And I write to "watchme/file_01" with:
    """
    BILL HICKS
    """
    And I wait for the monitor to notice
    And the upload of "file_01" has been queued
    Then the 10 byte file "file_01" should be uploaded
    When the queued job is executed

    And the deletion of file "file_01" should be queued
    When I remove the file "watchme/file_01"
    And I wait for the monitor to notice

    And the deletion of remote file "file_01" has been queued
    Then the remote file "file_01" should be deleted
    When the queued job is executed
