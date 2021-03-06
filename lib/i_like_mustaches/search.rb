class ILikeMustaches
  class Search
    attr_accessor :regex, :positive

    def initialize(regex_or_string, positive)
      self.regex = to_regex regex_or_string
      self.positive = positive
    end

    # might be worth making this more sophisticated such that it can take flags or w/e
    def to_regex(regex_or_string)
      return regex_or_string if regex_or_string.kind_of? Regexp
      Regexp.new regex_or_string, Regexp::IGNORECASE
    end

    def match?(strings)
      positive == strings.any? { |string| regex === string }
    end

    def ==(search)
      positive == search.positive && regex == search.regex
    end
  end
end

