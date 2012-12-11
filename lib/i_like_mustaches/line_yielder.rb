class ILikeMustaches
  class LineYielder
    include Enumerable

    def initialize(*strings)
      required_number_of_lines = strings.map { |string| string.lines.count }.max
      @lines = strings.map { |string|
        lines = string.each_line.map(&:chomp)
        lines << '' until lines.size == required_number_of_lines
        lines
      }.transpose
    end

    def each(&block)
      @lines.each { |line| block.call line }
    end
  end
end
