require 'spec_helper'
require 'stringio'

describe 'printing quick notes' do
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
end
