# command line interface
# responsible for starting the scraping/org process
# and providing the user with an interface
class CLI
  # Contest::Quartets.scrape_contests

  @welcome_message = "Welcome to the Barbershop Contestants CLI!"

  @command_verb_hash = {
    "quar" => [:display, "quartet"],
    "chor" => [:display, "chorus"],
    "help" => [:help, ""],
    "quit" => [:quit, ""]
  }

  @type_years_hash = {
    "quartet" => (1939..2018),
    "chorus" => (1953..2018)
  }

  def self.start
    # welcome the user and show command list
    # have the bin file call this method
    # scrape data from here, logic primarily in scraper
    puts @welcome_message
    @source = choose_source
    Scraper.scrape_and_create_quartet_champs(@source)
    Scraper.scrape_and_create_chorus_champs(@source)
    Scraper.scrape_and_create_year(@source, 2018, "quartet") # remove in final
    Scraper.scrape_and_create_year(@source, 2018, "chorus") # remove in final
    request_command
    input_loop
  end

  def self.choose_source
    return :web
    # loop do
      # puts "Enter web or local:"
      # entry = gets.chomp
      # return entry.to_sym if %w[web local].include?(entry)
    # end
    ### Reverse the comments in this method to be offered a choice at launch
    ### between web scraping and local scraping.
  end

  def self.input_loop
    # binding.pry
    loop do
      puts "\nEnter a command:"
      process_command(gets.chomp)
    end
  end

  def self.request_command
    puts "Please enter a command."
    puts "To see all entries in a contest, enter the type of contest " \
          "(quartet or chorus) and the year (1939-2018 for quartets, " \
          "1953-2018 for choruses)"
    puts "To see all performances by a group, enter the name of the group"
    puts "To see a list of all champions for a contest type, enter " \
        "'quartet champions' or 'chorus champions'"
    puts "To quit, enter 'quit'"
    puts "To see this info again, enter 'help'"
  end

  def self.process_command(command)
    # parses the given input between command types.
    # full "quartet" and "chorus" parsing is in other methods.
    system "clear" or system "cls"
    commands = command.downcase.split
    # TODO: uncomment next line when new command system is ready
    # parse_command_verb(commands) || show_competitor(commands) || no_command
    command_verb_hash = {
      "quar" => :quartet,
      "chor" => :chorus,
      "help" => :help,
      "quit" => :quit
    }
    # binding.pry
    # TODO: refactor to include a verb parsing method and a
    # competitor finding method
    command_verb = command_verb_hash.keys.find { |v| commands[0].start_with?(v) }
    competitor = Competitor.all.find { |c| c.name.downcase == command.downcase }
    if command_verb
      send(command_verb_hash[command_verb], commands.drop(1))
    elsif competitor
      print_competitor(competitor)
    else
      no_command
    end
  end

  def self.parse_command_verb(commands)
    verb = @command_verb_hash.keys.find { |v| commands[0].start_with?(v) }
    verb ? send(verb[0], verb[1], commands.drop(1)) : false
  end

  def self.display(type, commands)
    # type contains competitor type string (chorus or quartet)
    # commands contains remainder of user input as string array
    if commands.any? { |c| c.start_with?("cham") } # check for champs command
      display_champs(type)
    elsif (year = commands.find { |c| type_years_hash[type].contains? c.to_i }.to_i)
      display_year(year, type)
    else
      false
    end
  end

  def self.display_champs(type)
    champs_arr = Peformance.filter_all(place: 1, type: type)
  end

  def self.display_year(year, type)

  end

  def self.help(*_)
    request_command
  end

  def self.quit(*_)
    puts "Goodbye!"
    IRB.start(__FILE__)
    exit
  end

  def self.no_command
    puts "Sorry, that command was not recognized\n"
    request_command
  end

  def self.quartet(args_arr) # deprecated to display command
    year = args_arr.find { |c| (1939..2018).include?(c.to_i) }
    if args_arr.any? { |c| c.start_with?("cham") }
      # binding.pry
      # Performance.all.find_all do |p|
      #   p.place == 1 && p.competitor.type == "quartet"
      # end.sort_by { |p| p.year }.each do |p|
      Performance.filter_all(year: year, place: 1, type: "quartet").each do |p|
        puts "Year: #{p.year}\tName: #{p.competitor.name}\tScore: #{p.score}"
      end
    elsif year # looking for a year
      puts "Scraping Quartet Competition for #{year}"
      Scraper.scrape_and_create_quartet_year(@source, year)
      Performance.all.find_all do |p|
        p.year == year && p.competitor.type == "quartet"
      end.sort_by { |p| p.place.to_i }.each do |p|
        puts "Place: #{p.place}\t" \
              "Name: #{p.competitor.name}\t" \
              "District: #{p.competitor.district}\t" \
              "Score: #{p.score}\t"
      end
    else
      no_command
    end
  end

  def self.chorus(args_arr) # branches a 'chorus' verb
    year = args_arr.find { |c| (1953..2018).include?(c.to_i) }
    if args_arr.any? { |c| c.start_with?("cham") }
      Performance.all.find_all do |p|
        p.place == 1 && p.competitor.type == "chorus"
      end.sort_by { |p| p.year }.each do |p|
        puts "Year: #{p.year}\tName: #{p.competitor.name}\tScore: #{p.score}"
      end
    elsif year # looking for a year
      puts "You've selected 'Chorus Contest for #{year}'"
    else
      no_command
    end
  end

  def self.print_chorus_year_table(year)
    title = "International Chorus Competition #{year}"
    headers = ["Place", "Chorus", "District", "Score"]
    Performance.all.find_all do |p|
      p.year == year
    end
  end

  def self.print_champ_type_by_year(type)
    table = Terminal::Table.new header: ["year", type, "score"]
    Performance.champs_type_by_year(type).each do |p|
      table.add_row [p.year, p.competitor.name, p.score]
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
      puts "Director: #{competitor.current_director}"
      puts "Hometown: #{competitor.hometown}"
      print_performances_by_competitor(competitor)
    end
  end

  def self.print_performances_by_competitor(competitor)
    puts "Contests:"
    chorus = (competitor.type == 'chorus')
    competitor.performances.each do |p|
      if p.contest.city
        puts "\t#{p.contest.year} International at #{p.contest.city}"
      else
        puts "\t#{p.contest.year} International"
      end
      # contest, score, place
      puts "\t\tDirector: #{p.director}" if chorus
      puts "\t\tScore: #{p.score}"
      puts "\t\tPlace: #{p.place}"
      puts "\t\tNumber on stage: #{p.number_on_stage}" if chorus && p.number_on_stage.to_i > 0
    end
  end
end
