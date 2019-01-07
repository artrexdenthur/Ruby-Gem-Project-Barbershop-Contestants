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

  def self.fill_find_or_create(arg_hash)
    if self.all.find { |c| c.name == arg_hash[:name] }
      self.fill(arg_hash)
    else
      self.create(arg_hash)
    end
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

  def self.all
    @@all.find_all { |c| c.type == "quartet" }
  end
end

class Chorus < Competitor

  attr_accessor :hometown, :director

  def initialize(arg_hash)
    self.name = arg_hash[:name]
    self.type = 'chorus'
    self.district = arg_hash[:district]
    format_hometown_and_district(arg_hash[:hometown_and_district])
    self.performances = (arg_hash[:performances] || [])
    self.director = arg_hash[:director]
  end

  def current_director
    performances.max { |p| p.year.to_i }.director
  end

  def format_hometown_and_district(hometown_and_district)
    # TODO: plug this logic in
    if hometown_and_district
      h_d_match = /(?<h>.*) \((?<d>.*)\)/.match(hometown_and_district)
      self.hometown = h_d_match[:h]
      self.district = h_d_match[:d]
    end
  end

  def self.all
    @@all.find_all { |c| c.type == "chorus" }
  end

end
