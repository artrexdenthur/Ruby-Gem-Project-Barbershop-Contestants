# competitors have many competitions through performances and vice versa
class Performance
  attr_accessor :competiton, :competitor, :score, :place, :year

  @@all = []

<<<<<<< HEAD
  def initialize(data_hash)
    self.year = data_hash[:year].to_i
=======
  def initialize(arg_hash)
    self.year = arg_hash[:year] if arg_hash[:year]
>>>>>>> eb8e33879e8e26fa16d144cf4f618d028e6f1624
  end

  def save
    @@all << self
  end

<<<<<<< HEAD
  def self.create(args)
    performance = self.new(args)
=======
  def self.create(arg_hash)
    performance = self.initialize(arg_hash)
>>>>>>> eb8e33879e8e26fa16d144cf4f618d028e6f1624
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
