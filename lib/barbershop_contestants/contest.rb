# holds the data specific to each contest
class Contest
  # now there's text again
  attr_accessor :performances, :year, :city, :type

  @@all = []

  def initialize(arg_hash)
    self.performances = (arg_hash[:performances] || [])
    self.year = arg_hash[:year]
    self.city = arg_hash[:city]
    self.type = arg_hash[:type]
  end

  def save
    Contest.all << self
  end

  def self.find_or_create(arg_hash)
    self.all.find { |x| x.year == arg_hash[:year] && x.type == arg_hash[:type] } || self.create(arg_hash)
  end

  def self.create(arg_hash)
    contest = self.new(arg_hash)
    contest.save
    contest
  end

  def self.all
    @@all
  end

end
