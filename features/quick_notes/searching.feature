Feature: Searching
  I got some quick notes, but I only want to see some of em,
  so Imma pass the searches on the command line to filter em out.

  Background:
    Given the config file:
    """
      ILikeMustaches.configure do |config|
        config.console do |console|
          console.should_colour = false
          console.quick_note_separator = "|"
        end
      end
    """
    And the mustache:
    """
      require 'i_like_mustaches'
      mustache = ILikeMustaches.new do |m|
        m.quick_note 'key1', 'value1', 'tag1'
        m.quick_note 'key2', 'value2', 'tag2'
        m.quick_note 'key3', 'value3', 'tag3'
      end
      exit ILikeMustaches::Console.new(mustache).call
    """

  Scenario: Matching keys
    When I ride the mustache with 'key ~2'
    Then stderr is empty
    And the exit status is 0
    And I see:
    """
      key1|value1
      key3|value3
    """

  Scenario: Matching values
    When I ride the mustache with 'value2'
    Then stderr is empty
    And the exit status is 0
    And I see:
    """
      key2|value2
    """

  Scenario: Matching tags
    When I ride the mustache with 'tag3'
    Then stderr is empty
    And the exit status is 0
    And I see:
    """
      key3|value3
    """
