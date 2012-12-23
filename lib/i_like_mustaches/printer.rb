class ILikeMustaches
  class Printer
    class << self
      def register_format_string_for(klass, &block)
        format_strings[klass] = block
      end

      def register_fields_finder_for(klass, &block)
        fields_finders[klass] = block
      end

      def format_string_for(collection)
        format_strings[collection.class].call collection
      end

      def each_fields_for(element, &block)
        fields_finders[element.class].call element, &block
      end

      private

      def format_strings
        @format_strings ||= {}
      end

      def fields_finders
        @fields_finders ||= {}
      end
    end

    def initialize(collection, stdout, options={})
      self.collection    = collection
      self.stdout        = stdout
      self.should_colour = options.fetch :colour, false
    end

    def call
      collection.each do |element|
        self.class.each_fields_for element do |fields|
          colour do
            stdout.printf self.class.format_string_for(collection), *fields
          end
        end
        advance_colour
      end
    end

    private

    attr_accessor :collection, :stdout, :should_colour

    def colour(&block)
      return block.call unless should_colour
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
