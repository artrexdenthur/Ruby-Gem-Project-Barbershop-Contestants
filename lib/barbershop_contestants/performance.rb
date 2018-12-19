# competitors have many competitions through performances and vice versa
class Performance
  attr_accessor :competiton, :competitor, :score, :place, :year

  @@all = []

  def initialize(data_hash)
    self.year = data_hash[:year].to_i
  end

  def save
    @@all << self
  end

  def self.create(args)
    performance = self.new(args)
    performance.save
    performance
  end

  def self.all
    @@all
  end

  def self.clear
    @@all.clear
  end
end
