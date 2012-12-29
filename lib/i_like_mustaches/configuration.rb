class ILikeMustaches
  def self.configure(&block)
    block.call configuration
    configuration
  end

  def self.configuration
    @configuraiton ||= Configuration.new
  end

  def self.default_config
    filename = "#{ENV['HOME']}/.i_like_mustaches"
    load filename if File.exist? filename
    configuration
  end
end

class ILikeMustaches
  class Configuration
    def initialize
      yield self if block_given?
    end

    def console(&block)
      @console ||= Console.new(&block)
    end
  end
end

class ILikeMustaches
  class Configuration
    class Console
      attr_accessor :should_colour, :quick_note_separator
      alias should_colour? should_colour

      def initialize
        self.should_colour        = false
        self.quick_note_separator = '    '
        yield self if block_given?
      end
    end
  end
end

