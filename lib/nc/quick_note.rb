class Nc
  class QuickNote
    class Collection
      def add(*args)
        notes << QuickNote.new(*args)
        self
      end

      # is this right?
      def filter(*searches)
        notes.select do |note|
          searches.all? do |search|
            note.each_field.any? { |field| search.match? field }
          end
        end
      end

      def max_key_width
        notes.inject 0 do |width, note|
          [note.max_key_width, width].max
        end
      end

      def each(&block)
        notes.each &block
      end

      private

      def notes
        @notes ||= []
      end
    end
  end


  class QuickNote
    attr_accessor :key, :value, :tags

    def initialize(key, value, *tags)
      self.key, self.value, self.tags = remove_leading(key), remove_leading(value), tags
    end

    def each_field(&block)
      return to_enum :each_field unless block
      block.call key
      block.call value
      tags.each &block
      self
    end

    def tags=(tags)
      @tags = tags.map(&:to_str)
    rescue NoMethodError
      offender = tags.find { |tag| !tag.respond_to?(:to_str) }
      raise ArgumentError, "QuickNote tags should respond to to_str, but `#{offender.inspect}` does not."
    end

    def max_key_width
      key.each_line.map(&:size).max
    end

    def remove_leading(string)
      leading = string.scan(/^\s*/).min_by(&:size)
      string = string.gsub /^#{leading}/, ''
      string
    end
  end
end


require 'nc/printer'
Nc::Printer.register_format_string_for Nc::QuickNote::Collection do |collection|
  "%-#{collection.max_key_width}s    %s\n"
end

Nc::Printer.register_fields_finder_for Nc::QuickNote do |note, &block|
  Nc::LineYielder.new(note.key, note.value).each(&block)
end

