require 'spec_helper'

describe Nc::LineYielder do
  it 'omits trailing newlines' do
    described_class.new("abc\n").to_a.should == [['abc']]
  end

  it 'yields each line of each of its strings' do
    described_class.new("a\nb\nc", "d\ne\nf").to_a.should == [['a', 'd'], ['b', 'e'], ['c', 'f']]
  end

  it 'yields empty lines for empty strings when other strings have more lines' do
    described_class.new("a\nb", "").to_a.should == [['a', ''], ['b', '']]
    described_class.new("a", "b\nc").to_a.should == [['a', 'b'], ['', 'c']]
  end
end
