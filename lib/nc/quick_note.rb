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

      private

      def notes
        @notes ||= []
      end
    end
  end


  class QuickNote
    attr_accessor :key, :value, :tags

    def initialize(key, value, *tags)
      self.key, self.value, self.tags = key, value, tags
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
  end
end

