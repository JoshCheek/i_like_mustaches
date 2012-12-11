class Nc
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

    def initialize(collection, stdout)
      self.collection = collection
      self.stdout     = stdout
    end

    def call
      collection.each do |element|
        self.class.each_fields_for element do |fields|
          stdout.printf self.class.format_string_for(collection), *fields
        end
      end
    end

    private

    attr_accessor :collection, :stdout
  end
end
