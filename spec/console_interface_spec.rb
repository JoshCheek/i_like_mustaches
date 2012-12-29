require 'spec_helper'
require 'stringio'

describe ILikeMustaches::Console do
  described_class.execute_with { |command| 1 }

  it 'interprets ~ as negation of a search' do
    search1, search2, *rest = described_class.new(nil, wiring_for(argv: %w[a ~b])).searches
    rest.should be_empty
    search1.should == ILikeMustaches::Search.new('a', true)
    search2.should == ILikeMustaches::Search.new('b', false)
  end

  let(:instream)  { StringIO.new }
  let(:outstream) { StringIO.new }
  let(:errstream) { StringIO.new }
  let(:config)    { ILikeMustaches::Configuration.new }

  def wiring_for(options)
    options = {argv: [], instream: instream, outstream: outstream, errstream: errstream}.merge(options)
    ILikeMustaches::Console::Wiring.new options[:argv], options[:instream], options[:outstream], options[:errstream], config
  end

  it 'pulls the searches from argv and prints the matching notes' do
    i_like_mustaches = ILikeMustaches.new do |mustache|
      mustache.quick_note 'a', 'a'
      mustache.quick_note 'a', 'b'
    end

    console = described_class.new(i_like_mustaches, wiring_for(argv: %w[a ~b]))
    console.call.should == 0

    instream.string.should be_empty
    errstream.string.should be_empty
    outstream.string.should include 'a'
    outstream.string.should_not include 'b'
  end

  it 'prints the help screen when given the -h or --help flags' do
    %w[-h --help].each do |flag|
      i_like_mustaches = ILikeMustaches.new do |mustache|
        mustache.description = "something\nor\nother"
        mustache.quick_note '-h', 'this should not match'
        mustache.quick_note '--help', 'this should not match'
      end
      described_class.new(i_like_mustaches, wiring_for(argv: [flag])).call.should == 0
      instream.string.should be_empty
      errstream.string.should be_empty
      outstream.string.should_not include 'this should not match'
      outstream.string.should include "  something\n  or\n  other"
      outstream.string.should include 'Usage'
      outstream.string.should include '-h'
      outstream.string.should include '--help'
      outstream.string.should include '-e'
      outstream.string.should include '--execute'
    end
  end

  describe 'colouring output' do
    let(:i_like_mustaches) { ILikeMustaches.new }

    it 'sets configuration.should_colour to true when given -c or --colour' do
      %w[-c --colour].each do |flag|
        config.should_colour = false
        described_class.new(i_like_mustaches, wiring_for(argv: [flag])).call
        config.should_colour.should == true
      end
    end

    it 'sets configuration.should_colour to false when given -C or --no-colour' do
      %w[-C --no-colour].each do |flag|
        config.should_colour = true
        described_class.new(i_like_mustaches, wiring_for(argv: [flag])).call
        config.should_colour.should == false
      end
    end
  end

  describe 'executing' do
    let(:i_like_mustaches) {
      ILikeMustaches.new do |mustache|
        mustache.quick_note 'key1', "ruby -e '$stderr.puts %q(err); $stdout.puts $stdin.read*2'", executable: true
        mustache.quick_note 'key2', 'some value'
        mustache.quick_note 'executable', 'cd somewhere'
      end
    }

    def run(*argv)
      ILikeMustaches::Console.new(i_like_mustaches, wiring_for(argv: argv)).call
    end

    it 'errors if multiple notes are matched' do
      described_class.execute_with { |command| 1 }
      run('key', '-e').should == 1
      outstream.string.should be_empty
      errstream.string.should include "key1"
      errstream.string.should include "key2"
      errstream.string.should include "Cannot execute due to multiple matches"
    end

    it 'errors if no notes are matched' do
      run('matchesnothing', '-e').should == 1
      outstream.string.should be_empty
      errstream.string.should_not include "key"
      errstream.string.should include "Cannot execute as there are no matches."
    end

    it 'executes, forwarding stdin/stderr/stdout and retaining exit status' do
      executed = nil
      described_class.execute_with { |command| executed = command; 123 }
      run('executable', '-e').should == 123
      executed.should == 'cd somewhere'
    end

    it 'executes for -e and --execute' do
      executed = nil
      described_class.execute_with { |command| executed = command; 123 }
      run('executable', '-e').should == 123
      executed.should == 'cd somewhere'
      executed = nil
      run('executable', '--execute').should == 123
    end
  end
end
