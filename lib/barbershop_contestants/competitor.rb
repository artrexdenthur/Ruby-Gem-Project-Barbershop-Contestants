# comprises two types: quartet and chorus
# each has an m-to-m relationship with Contest::Quartet
# and Contest::Chorus, respectively
class Competitor
  attr_accessor :performances, :district, :name, :type

  @@all = []

  def save
    Competitor.all << self
  end

  def self.find_or_create(arg_hash)
    self.all.find { |x| x.name == arg_hash[:name] } || self.create(arg_hash)
  end

  def self.create(arg_hash)
    competitor = self.new(arg_hash)
    competitor.save
    competitor
  end

  def self.all
    @@all
  end

end

class Quartet < Competitor

  attr_accessor :tenor, :lead, :baritone, :bass, :comments, :members

  def initialize(arg_hash)
    self.name = arg_hash[:name]
    self.type = 'quartet'
    self.district = arg_hash[:district]
    self.performances = (arg_hash[:performances] || [])
    self.comments = arg_hash[:comments]
    self.members  = self.format_members(arg_hash[:members])
  end

  def format_members(member_string)
    self.members = member_string
    # TODO: modify to pull out the members and put them in their own hashes
  end

end

class Chorus < Competitor

end
