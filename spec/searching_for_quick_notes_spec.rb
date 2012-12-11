require 'spec_helper'

describe 'searching for quick notes' do
  let(:matching_key)           { 'matchingkey' }
  let(:matching_value)         { 'matchingvalue' }
  let(:matching_tags)          { %w[matchingtag] }

  let(:nonmatching_key)        { 'badkey' }
  let(:nonmatching_value)      { 'badvalue' }
  let(:nonmatching_tags)       { ['badtags'] }

  let(:key_nonmatcher)         { Nc::Search.new /badkey/,              true }
  let(:key_matcher)            { Nc::Search.new /matchingkey/,         true }
  let(:value_matcher)          { Nc::Search.new /matchingvalue/,       true }
  let(:tag_matcher)            { Nc::Search.new /matchingtag/,         true }
  let(:key_and_value_matcher)  { Nc::Search.new /matching(key|value)/, true }

  let :nc do
    Nc.new do |nc|
      nc.quick_note matching_key,    nonmatching_value, *nonmatching_tags
      nc.quick_note nonmatching_key, matching_value,    *nonmatching_tags
      nc.quick_note nonmatching_key, nonmatching_value, *matching_tags
      nc.quick_note nonmatching_key, nonmatching_value, *nonmatching_tags
    end
  end

  it 'can match the key' do
    nc.quick_notes_for([key_matcher]).map(&:key).should == [matching_key]
  end

  it 'can match the value' do
    nc.quick_notes_for([value_matcher]).map(&:value).should == [matching_value]
  end

  it 'can match any tag' do
    nc.quick_notes_for([tag_matcher]).map(&:tags).should == [matching_tags]
  end

  specify 'every matching result is returned' do
    first, second, *rest = nc.quick_notes_for([key_and_value_matcher])
    rest.should be_empty
    first.key.should == matching_key
    second.value.should == matching_value
  end

  specify 'every matcher must match' do
    nc.quick_notes_for([key_matcher, key_nonmatcher]).should be_empty
  end

  specify 'it works with positive and negative matchers' do
    Nc.new { |nc| nc.quick_note('a', 'a').quick_note('a', 'b') }
      .quick_notes_for([Nc::Search.new(/a/, true), Nc::Search.new(/b/, false)])
      .map(&:key)
      .should == ['a']
  end
end
