%w[endpoint quick_note search]
  .each { |file| require "nc/#{file}" }

class Nc
  def initialize(&constructor)
    self.quick_notes = QuickNote::Collection.new
    constructor && constructor.call(self)
  end

  def quick_note(*args)
    quick_notes.add(*args)
    self
  end

  def quick_notes_for(*searches)
    quick_notes.filter *searches
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


