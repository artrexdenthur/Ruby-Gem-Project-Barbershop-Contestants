# competitors have many contests through performances and vice versa
class Performance
  attr_accessor :contest, :competitor, :score, :place, :year, :number_on_stage

  @@all = []

  def initialize(arg_hash)
    self.year = arg_hash[:year]
    self.score = arg_hash[:score]
    self.place = arg_hash[:place]
    # the following will generally be nil at this point
    self.contest = arg_hash[:contest]
    self.competitor = arg_hash[:competitor]
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

  def self.q_champs_by_year
    all.select { |p| p.place == 1 && p.contest.type = "quartet" }.sort_by { |p| p.year }
  end

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end
end
