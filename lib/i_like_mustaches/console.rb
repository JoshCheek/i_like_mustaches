require 'i_like_mustaches/printer'

class ILikeMustaches
  class Console
    Wiring = Struct.new :args, :instream, :outstream, :errstream, :config

    class DefaultWiring < Wiring
      def initialize
        super ARGV, $stdin, $stdout, $stderr, ILikeMustaches.default_config
      end
    end

    # execution is maybe not a console thing, and should probably be moved down into the ILikeMustaches lib
    def self.execute_with(&execute_block)
      define_method :execute, &execute_block
    end

    execute_with do |command|
      system command
      $?
    end

    def initialize(mustache, wiring=DefaultWiring.new, &block)
      self.mustache     = mustache
      self.wiring       = wiring
      self.config       = wiring.config
      self.raw_searches = parse wiring.args
    end

    def call
      if print_help?
        wiring.outstream.puts help_screen
        0
      elsif should_execute? && matches.count != 1
        message = (matches.count == 0 ? "Cannot execute as there are no matches." : "Cannot execute due to multiple matches")
        print_collections_to wiring.errstream
        wiring.errstream.puts message
        1
      elsif should_execute?
        execute matches.first.to_sh
      else
        print_collections_to wiring.outstream
        0
      end
    end

    def print_collections_to(stream)
      collections.each { |match| ILikeMustaches::Printer.new(match, stream, config).call }
    end

    def searches
      @searches ||= raw_searches.map do |arg|
        positive = true
        if arg.start_with? '~'
          positive = false
          arg      = arg[1..-1]
        end
        Search.new arg, positive
      end
    end

    def help_screen
      <<-SCREEN.gsub /^        /, ''
        Usage: #{File.basename $0} [options] [searches]

          #{mustache.description.gsub("\n", "\n  ")}

          Searches:
            Patterns for filtering what information to output.
            Any search that begins with a "~" will be considered
            a negative search (matches when that pattern is not found).

          Options:
            -c, --colour     Turn on coloured output
            -C, --no-colour  Turn off coloured output
            -e, --execute    When searches result in a single note,
                                 That note's value will be executed as bash code.
            -h, --help       This help screen
      SCREEN
    end

    private

    def matches
      @matches ||= collections.map(&:to_a).flatten
    end

    def collections
      @collections ||= mustache.each_collection_for searches
    end

    attr_accessor :mustache, :wiring, :config, :raw_searches
    attr_accessor :should_execute, :print_help

    alias should_execute? should_execute
    alias print_help?     print_help

    def parse(args)
      raw_searches = []
      until args.empty?
        arg = args.shift
        case arg
        when '-e', '--execute'
          self.should_execute = true
        when '-h', '--help'
          self.print_help = true
        when '-c', '--colour'
          config.should_colour = true
        when '-C', '--no-colour'
          config.should_colour = false
        else
          raw_searches << arg
        end
      end
      raw_searches
    end
  end
end
