class Nc
  class QuickNote
    class Collection

      def initialize(notes=[])
        @notes = notes
      end

      def add(*args)
        notes << QuickNote.new(*args)
        self
      end

      def filter(searches)
        filtered_notes = notes.select do |note|
          searches.all? do |search|
            search.match? note.all_fields
          end
        end
        self.class.new filtered_notes
      end

      def max_key_width
        notes.inject 0 do |width, note|
          [note.max_key_width, width].max
        end
      end


      include Enumerable

      def each(&block)
        notes.each &block
      end

      # doesn't it seem like Enumerable should add this?
      def empty?
        notes.empty?
      end

      alias to_ary to_a

      private
      attr_reader :notes
    end
  end


  class QuickNote
    attr_accessor :key, :value, :tags

    def initialize(key, value, *tags)
      self.key, self.value, self.tags = remove_leading(key), remove_leading(value), tags
    end

    def all_fields
      [key, value, *tags]
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

