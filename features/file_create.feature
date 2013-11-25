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

  Scenario: Dotfiles should not be uploaded
    Given a directory named "watchme/"
    Then the upload of file ".dot_file" should not be queued
    When the monitor is watching "watchme/"
    And I write to "watchme/.dot_file" with:
    """
    REGGIE WATTS
    """
    And I wait for the monitor to notice

  Scenario: Dotfiles inside subdirs should not be uploaded
    Given a directory named "watchme/"
    Then the upload of file "subdir/.dot_file" should not be queued
    When the monitor is watching "watchme/"
    And I write to "watchme/subdir/.dot_file" with:
    """
    LOUIS CK
    """
    And I wait for the monitor to notice

  Scenario: Queue and upload with complete (relative) path
    Given a directory named "watchme/"
    Then the upload of file "subdir/file_03" should be queued
    When the monitor is watching "watchme/"
    And I write to "watchme/subdir/file_03" with:
    """
    MITCH HEDBERG
    """
    And I wait for the monitor to notice

  Scenario:  Queue file when created and do the right thing with trailing slash
    Given a directory named "watchme/"
    Then the upload of file "file_04" should be queued
    When the monitor is watching "watchme/" including the trailing slash
    And I write to "watchme/file_04" with:
    """
    GEORGE CARLIN
    """
    And I wait for the monitor to notice
