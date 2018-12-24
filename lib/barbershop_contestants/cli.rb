# command line interface
# responsible for starting the scraping/org process
# and providing the user with an interface
class CLI
  # Contest::Quartets.scrape_contests

  @@welcome_message = "Welcome to the Barbershop Contestants CLI!"

  def self.start
    # welcome the user and show command list
    # have the bin file call this method
    # scrape data from here, logic primarily in scraper
    puts @@welcome_message
    Scraper.scrape_and_create_quartet_champs
    Scraper.scrape_and_create_chorus_champs
    request_command
    input_loop
  end

  def self.input_loop
    # binding.pry
    while true
      puts "\nEnter a command:"
      process_command(gets.chomp)
    end
  end

  def self.request_command
    puts "Please enter a command."
    puts "To see all entries in a contest, enter the type of contest (quartet or chorus) and the year (1939-2018 for quartets, 1953-2018 for choruses)"
    puts "To see all performances by a group, enter the name of the group"
    puts "To see a list of all champions for a contest type, enter 'quartet champions' or 'chorus champions'"
    puts "To quit, enter 'quit'"
    # puts "For more information enter 'help'"
  end

  def self.process_command(command)
    commands = command.downcase.split
    verbs = {
      "quar" => :quartet,
      "chor" => :chorus,
      "help" => :help,
      "quit" => :quit
    }
    # binding.pry
    command_verb = verbs.keys.find { |v| commands[0].start_with?(v) }
    competitor = Competitor.all.find { |c| c.name.downcase == command.downcase }
    if command_verb
      send(verbs[command_verb], commands.drop(1))
    elsif competitor
      print_competitor(competitor)
    else
      no_command
    end
  end

  def self.help(_ = nil)
    request_command
  end

  def self.quit(_ = nil)
    puts "Goodbye!"
    IRB.start(__FILE__)
    exit
  end

  def self.no_command
    puts "Sorry, that command was not recognized"
  end

  def self.quartet(args_arr)
    year = args_arr.find { |c| (1939..2018).include?(c.to_i) }
    if args_arr.any? { |c| c.start_with?("cham") }
      puts "You've selected 'Quartet Champions'"
    elsif year # looking for a year
      puts "You've selected 'Quartet Contest for' #{year}"
    else
      no_command
    end
  end

  def self.chorus(args_arr)
    year = args_arr.find { |c| (1953..2018).include?(c.to_i) }
    if args_arr.any? { |c| c.start_with?("cham") }
      puts "You've selected 'Chorus Champions'"
    elsif year # looking for a year
      puts "You've selected 'Chorus Contest for #{year}'"
    else
      no_command
    end
  end

  #### Print methods

  def self.print_quartet_champs_by_year
    Performance.q_champs_by_year.each do |champ|
      puts [champ.year, champ.competitor.name].join("\t")
    end
  end

  def self.print_competitor(competitor)
    puts "Name: #{competitor.name}"
    if competitor.type == 'quartet'
      puts "Type: #{competitor.type.capitalize}"
      puts "District: #{competitor.district}"
      puts "Comments: #{competitor.comments}" if competitor.comments
      puts "Members: #{competitor.members}"
      print_performances_by_competitor(competitor)
    elsif competitor.type == 'chorus'
      puts "Type: #{competitor.type.capitalize}"
      puts "need more chorus stuff"
    end
  end

  def self.print_performances_by_competitor(competitor)
    puts "Contests:"
    competitor.performances.each do |p|
      if p.contest.city
        puts "\t#{p.contest.year} International at #{p.contest.city}"
      else
        puts "\t#{p.contest.year} International"
      end
      # contest, score, place
      puts "\t\tScore: #{p.score}"
    end
  end
end
