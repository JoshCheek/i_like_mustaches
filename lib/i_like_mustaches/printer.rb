class ILikeMustaches
  class Printer
    class << self
      def format_string_for(collection, config)
        case collection
        when ILikeMustaches::QuickNote::Collection
          "%-#{collection.max_key_width}s#{config.quick_note_separator}%s\n"
        else
          raise "No format string for #{collection.inspect}"
        end
      end

      def each_fields_for(element, &block)
        case element
        when ILikeMustaches::QuickNote
          ILikeMustaches::LineYielder.new(element.key, element.value).each(&block)
        else
          raise "Don't know how to yield fields for #{element.inspect}"
        end
      end
    end

    def initialize(collection, stdout, config)
      self.collection = collection
      self.stdout     = stdout
      self.config     = config
    end

    def call
      collection.each do |element|
        self.class.each_fields_for element do |fields|
          colour do
            stdout.printf format_string_for(collection), *fields
          end
        end
        advance_colour
      end
    end

    private

    attr_accessor :collection, :stdout, :config

    def format_string_for(collection)
      self.class.format_string_for collection, config
    end

    def colour(&block)
      return block.call unless config.should_colour?
      stdout.write colours.first
      block.call
      stdout.write "\e[0m"
    end

    def colours
      @colours ||= ["\e[37m", "\e[32m"]
    end

    def advance_colour
      colours.rotate!
    end
  end
end
