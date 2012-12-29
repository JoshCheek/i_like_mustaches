require_relative 'command_line_helpers'

class Recluse < BasicObject
  def initialize(message)
    @message = message
  end

  def inspect
    "Recluse.new(#{@message.inspect})"
  end

  def method_missing(name, *)
    ::Kernel.raise "Tried to invoke the method `#{name}`. #@message"
  end
end

CommandLineHelpers.make_proving_grounds

Before do
  @last_invocation = Recluse.new "Should have executed something on the command line before trying to access methods on the @last_invocation"
  CommandLineHelpers.set_proving_grounds_as_home
  CommandLineHelpers.kill_config_file
  CommandLineHelpers.kill_mustache_file
end

module GeneralHelpers
  def strip_leading(string)
    leading_size = string.scan(/^\s*/).map(&:size).max
    string.gsub /^\s{#{leading_size}}/, ''
  end
end

World GeneralHelpers
