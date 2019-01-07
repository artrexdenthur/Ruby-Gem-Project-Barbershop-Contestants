# competitors have many contests through performances and vice versa
class Performance
  attr_accessor :contest, :competitor, :score, :place, :year, :number_on_stage, :director

  @@all = []

  def initialize(arg_hash)
    self.year = arg_hash[:year]
    self.score = arg_hash[:score]
    self.place = arg_hash[:place]
    # the following will generally be nil at this point
    self.contest = arg_hash[:contest]
    self.competitor = arg_hash[:competitor]
    self.number_on_stage = arg_hash[:number_on_stage]
    self.director = arg_hash[:director]
  end

  def save
    @@all << self
  end

  def self.create(arg_hash)
    performance = new(arg_hash)
    performance.save
    performance
  end

  def self.create_q_performance(q_champs_hash)
    performance = create(q_champs_hash)
    performance.competitor = Quartet.find_or_create(q_champs_hash)
    performance.competitor.performances << performance
    performance.contest = Contest.find_or_create(q_champs_hash)
    performance.contest.performances << performance
    performance
  end

  def self.create_c_performance(c_champs_hash)
    performance = create(c_champs_hash)
    performance.competitor = Chorus.find_or_create(c_champs_hash)
    performance.competitor.performances << performance
    performance.contest = Contest.find_or_create(c_champs_hash)
    performance.contest.performances << performance
    performance
  end

  def self.create_performance(arg_hash, type)
    performance = create(arg_hash)
    performance.competitor = \
      (type == "chorus" ? Chorus : Quartet).send :find_or_create, arg_hash
    performance.competitor.performances << performance
    performance.contest = Contest.find_or_create(arg_hash)
    performance.contest.performances << performance
    performance
  end

  def self.find_or_create(arg_hash, type)
    found = self.all.find do |p|
      p.year == arg_hash[:year] && p.competitor.name == arg_hash[:name]
    end
    found || create_performance(arg_hash, type)
  end

  def self.champs_type_by_year(type)
    all.select { |p| p.place == 1 && p.contest.type = type }.sort_by { |p| p.year }
  end

  def self.filter_all(place: nil, year: nil, type: nil, comp_name: nil)
    filter = self.all
    place && filter = filter.select { |p| p.place == place }.sort_by { |p| p.year.to_i }
    year && filter = filter.select { |p| p.year == year }.sort_by { |p| p.place.to_i }
    type && filter = filter.select { |p| p.competitor.type == type }
    comp_name && filter = filter.select { |p| p.competitor.name == name }
    filter
  end

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end
end
