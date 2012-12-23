%w[endpoint quick_note search line_yielder console]
  .each { |file| require "i_like_mustaches/#{file}" }

class ILikeMustaches
  def initialize(&constructor)
    self.quick_notes = QuickNote::Collection.new
    constructor && constructor.call(self)
  end

  attr_writer :description
  def description
    @description || ""
  end

  def quick_note(*args)
    quick_notes.add(*args)
    self
  end

  def quick_notes_for(searches)
    quick_notes.filter searches
  end

  def each_collection_for(searches)
    return to_enum :each_collection_for, searches unless block_given?
    yield quick_notes_for searches
  end

  private

  attr_accessor :quick_notes
end


__END__
nc = Nc.new do |nc|
  nc.quick_note "6854259", "George's account_id", "database", "db", "production", "identity" # there are more of these
  nc.quick_note "1", "George's person_id", "database", "db", "production", "identity" # there are more of these
end
nc.instance_eval do
  p quick_notes.filter Nc::Search.new('68', true)
end


