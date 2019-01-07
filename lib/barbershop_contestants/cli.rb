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
    command_arr = command.downcase.split
    if command_arr[0] # the user typed something
      parse_command_verb(command_arr) || show_competitor(command) || no_command
    else
      no_command
    end
  end

  def self.parse_command_verb(commands)
    verb = @command_verb_hash.find { |k, _| commands[0].start_with?(k) }
    # binding.pry
    verb ? send(verb[1][0], verb[1][1], commands.drop(1)) : false
  end

  def self.display(type, commands)
    # type contains competitor type string (chorus or quartet)
    # commands contains remainder of user input as string array
    if commands.any? { |c| c.start_with?("cham") } # check for champs command
      display_champs(type)
      true
    elsif (year = commands.find { |c| @type_years_hash[type].include? c.to_i })
      display_year(year.to_i, type)
      true
    else
      false
    end
  end

  def self.display_champs(type)
    champs_arr = Performance.filter_all(place: 1, type: type)
    title = "BHS International #{type.capitalize} Champions"
    headers = ["Year", type.capitalize, "District", "Score"]
    rows = champs_arr.map do |p|
      disp_arr = []
      disp_arr.push(p.year, p.competitor.name, p.competitor.district, p.score)
    end
    true
  end

  def self.display_year(year, type)
    Scraper.scrape_and_create_year(@source, year, type)
    year_arr = Performance.filter_all(year: year, type: type)
    title = "BHS International #{type.capitalize} Competition #{year}"
    headers = ["Place", type.capitalize, "District", "Score"]
    rows = year_arr.map do |p|
      disp_arr = []
      disp_arr.push(p.place, p.competitor.name, p.competitor.district, p.score)
    end
    print_tty_table(title: title, headers: headers, rows: rows)
  end

  def self.help(*_)
    request_command
  end

  def self.quit(*_)
    puts "Goodbye!"
    IRB.start(__FILE__)
    exit
  end

  def self.show_competitor(name)
    c = Competitor.all.find{ |c| c.name.downcase == name }
    if c
      puts c.name, c.type.capitalize, "District: #{c.district}"
      if c.type == "quartet"
        c.comments && (puts "Comments: #{c.comments}")
        c.members && (puts "Members: #{c.members}")
      else
        c.director && (puts "Director: #{c.director}")
        c.hometown && (puts "Hometown: #{c.hometown}")
      end
    end


    puts "You've chosen to display #{name}"
    true
  end

  def self.print_tty_table(title: nil, headers: nil, rows:)
    puts title if title
    if headers
      table = TTY::Table.new headers, rows
    else
      table = TTY::Table.new rows
    end
    puts table.render(:ascii, padding: [0,1,0,1])
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
