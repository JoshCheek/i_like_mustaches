class Nc
  class Console
    def initialize(nc, argv, stdin, stdout, stderr)
      @nc, @argv, @stdin, @stdout, @stderr =
       nc,  argv,  stdin,  stdout,  stderr
    end

    def call
      searches = @argv.map do |arg|
        positive = true
        if arg.start_with? '~'
          positive = false
          arg      = arg[1..-1]
        end
        Search.new arg, positive
      end
      @nc.each_collection_for searches do |collection|
        Nc::Printer.new(collection, @stdout).call
      end
    end
  end
end
