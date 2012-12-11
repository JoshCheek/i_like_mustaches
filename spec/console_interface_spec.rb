require 'spec_helper'
require 'stringio'

describe ILikeMustaches::Console do
  it 'interprets ~ as negation of a search' do
    search1, search2, *rest = described_class.new(nil, %w[a ~b]).searches
    rest.should be_empty
    search1.should == ILikeMustaches::Search.new('a', true)
    search2.should == ILikeMustaches::Search.new('b', false)
  end

  let(:instream)  { StringIO.new }
  let(:outstream) { StringIO.new }
  let(:errstream) { StringIO.new }

  it 'pulls the searches from argv and prints the matching notes' do
    nc = ILikeMustaches.new do |nc|
      nc.quick_note 'a', 'a'
      nc.quick_note 'a', 'b'
    end

    console = described_class.new(nc, %w[a ~b], instream, outstream, errstream)
    console.call

    instream.string.should be_empty
    errstream.string.should be_empty
    outstream.string.should include 'a'
    outstream.string.should_not include 'b'
  end
end
