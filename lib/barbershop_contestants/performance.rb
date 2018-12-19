# competitors have many competitions through performances and vice versa
class Performance
  attr_accessor :competiton, :competitor, :score, :place

  @all = []

  def initialize(year:)
    self.year = year.to_i
  end

  def save
    @all < self
  end

  def self.all
    @all
  end

  def self.clear
    @all.clear
  end
end
