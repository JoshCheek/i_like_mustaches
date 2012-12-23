require 'spec_helper'
require 'stringio'

describe 'when printing' do
  context 'colour' do
    let(:qns) { ILikeMustaches::QuickNote::Collection.new.add("a", "b\nc").add("a", "d").add("e\nf", "a") }


    it 'can be turned on or off' do
      # on
      stdout  = StringIO.new
      ILikeMustaches::Printer.new(qns, stdout, colour: true).call
      coloureds = stdout.string.scan /\e\[37m.*?\e\[0m/m
      %w[b c e f].each do |char|
        coloureds.find { |coloured| coloured =~ /#{char}/ }.should_not be_nil, "Expected #{coloureds.inspect} to have a line for #{char}"
      end
      coloureds = stdout.string.scan /\e\[32m.*?\e\[0m/m
      coloureds.size.should == 1
      coloureds.first.should include "d"
      coloureds.first.should_not include "b"

      # off
      stdout = StringIO.new
      ILikeMustaches::Printer.new(qns, stdout, colour: false).call
      stdout.string.should_not include "\e["
    end

    it 'is off by default' do
      stdout = StringIO.new
      ILikeMustaches::Printer.new(qns, stdout).call
      stdout.string.should_not include "\e["
    end
  end

  context 'quicknotes' do
    it 'lines everything up all pretty-like, even multilines, and strips leading whitespace' do
      qns = ILikeMustaches::QuickNote::Collection.new
      qns.add 'key', 'value'
      qns.add <<-KEY, 'and a value'
        This is
          some key
      KEY
      qns.add 'this is a long key', <<-VALUE
          And a
            multiline
        value
      VALUE
      qns.add <<-KEY, <<-VALUE
        multiline
        key
      KEY
        multiline
        value
      VALUE

      stdout  = StringIO.new
      ILikeMustaches::Printer.new(qns, stdout).call

      # pipes to preserve whitespace at end of the line
      stdout.string.should ==
<<OUT.gsub('|', '')
key                   value|
This is               and a value|
  some key            |
this is a long key      And a|
                          multiline|
                      value|
multiline             multiline|
key                   value|
OUT
    end

    example 'apps' do
      pending
    end
  end
end
