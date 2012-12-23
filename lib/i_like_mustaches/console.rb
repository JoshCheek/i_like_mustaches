require 'i_like_mustaches/printer'
ILikeMustaches::Printer.register_format_string_for ILikeMustaches::QuickNote::Collection do |collection|
  "%-#{collection.max_key_width}s    %s\n"
end

ILikeMustaches::Printer.register_fields_finder_for ILikeMustaches::QuickNote do |note, &block|
  ILikeMustaches::LineYielder.new(note.key, note.value).each(&block)
end

class ILikeMustaches
  class Console
    def self.execute_with(&execute_block)
      define_method :execute, &execute_block
    end

    execute_with do |command|
      system command
      $?
    end

    def initialize(nc, argv, instream=$stdin, outstream=$stdout, errstream=$stderr)
      self.nc, self.instream, self.outstream, self.errstream = nc, instream, outstream, errstream
      self.args = parse argv
    end

    def call
      if should_execute? && matches.count != 1
        message = (matches.count == 0 ? "Cannot execute as there are no matches." : "Cannot execute due to multiple matches")
        print_collections_to errstream
        errstream.puts message
        1
      elsif should_execute?
        execute matches.first.to_sh
      else
        print_collections_to outstream
        0
      end
    end

    def print_collections_to(stream)
      collections.each { |match| ILikeMustaches::Printer.new(match, stream).call }
    end

    def searches
      @searches ||= args.map do |arg|
        positive = true
        if arg.start_with? '~'
          positive = false
          arg      = arg[1..-1]
        end
        Search.new arg, positive
      end
    end

    private

    def matches
      @matches ||= collections.map(&:to_a).flatten
    end

    def collections
      @collections ||= nc.each_collection_for searches
    end

    attr_accessor :nc, :args, :instream, :outstream, :errstream, :should_execute

    alias should_execute? should_execute

    def parse(argv)
      args = []
      until argv.empty?
        arg = argv.shift
        case arg
        when '-e', '--execute'
          self.should_execute = true
        else
          args << arg
        end
      end
      args
    end
  end
end
