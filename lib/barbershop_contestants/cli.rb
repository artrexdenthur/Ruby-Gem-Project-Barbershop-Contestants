# command line interface
# responsible for starting the scraping/org process
# and providing the user with an interface
class CLI
  # Contest::Quartets.scrape_contests

  def self.print_quartet_champs_by_year
    Performance.q_champs_by_year.each do |champ|
      puts [champ.year, champ.competitor.name].join("\t")
    end
  end



end
