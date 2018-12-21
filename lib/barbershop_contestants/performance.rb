# competitors have many competitions through performances and vice versa
class Performance
  attr_accessor :competiton, :competitor, :score, :place

  @@all = []

  def initialize(arg_hash)
    self.year = arg_hash[:year] if arg_hash[:year]
  end

  def save
    @@all << self
  end

  def self.create(arg_hash)
    performance = self.initialize(arg_hash)
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
