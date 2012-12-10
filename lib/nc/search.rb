class Nc
  class Search
    attr_accessor :regex, :positive

    def initialize(regex_or_string, positive)
      self.regex = to_regex regex_or_string
      self.positive = positive
    end

    # might be worth making this more sophisticated such that it can take flags or w/e
    def to_regex(regex_or_string)
      return regex_or_string if regex_or_string.kind_of? Regexp
      Regexp.new regex_or_string
    end

    def match?(string)
      (regex === string) == positive
    end
  end
end

