class ILikeMustaches
  class Console
    def initialize(nc, argv, instream=$stdin, outstream=$stdout, errstream=$stderr)
      self.nc, self.argv, self.instream, self.outstream, self.errstream = nc, argv, instream, outstream, errstream
    end

    def call
      nc.each_collection_for searches do |collection|
        ILikeMustaches::Printer.new(collection, outstream).call
      end
    end

    def searches
      @searches ||= argv.map do |arg|
        positive = true
        if arg.start_with? '~'
          positive = false
          arg      = arg[1..-1]
        end
        Search.new arg, positive
      end
    end

    private

    attr_accessor :nc, :argv, :instream, :outstream, :errstream
  end
end
