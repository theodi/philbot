Feature: Upload file on create

  Scenario: Queue file when created
    Given a directory named "watchme/"
    When I write to "watchme/file_01" with:
    """
    DUMMY TEXT
    """
   # Then the upload of file "watchme/file_01" should be queued
