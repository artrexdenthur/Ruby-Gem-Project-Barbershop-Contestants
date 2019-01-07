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
    "quit" => [:quit, ""],
    "load" => [:load, ""]
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
      process_command(gets.chomp.downcase)
    end
  end

  def self.request_command
    puts "Please enter a command."
    puts "To see all entries in a contest, enter the type of contest " \
          "(quartet or chorus) and the year (1939-2018 for quartets, " \
          "1953-2018 for choruses)"
    puts "To see all performances currently in cache by a particular group, " \
          "enter the name of the group"
    puts "To see a list of all champions for a contest type, enter " \
        "'quartet champions' or 'chorus champions'"
    puts "To load all contests, or all contests of one type, " \
        "enter 'load all', 'load quartets', or 'load choruses'"
    puts "To quit, enter 'quit'"
    puts "To see this info again, enter 'help'"
  end

  def self.process_command(command)
    # parses the given input between command types.
    # full "quartet" and "chorus" parsing is in other methods.
    system "clear" or system "cls"
    command_arr = command.split
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

  def self.load(_, commands)
    case commands
    when commands.any? { |c| c.start_with?("quar") }
      type = "quartet"
    when commands.any? { |c| c.start_with?("chor") }
      type = "chorus"
    else
      type = nil
    end
    load_all(type)
    true
  end

  def self.load_all(type)
    if type
      @type_years_hash[type].each do |y|
        Scraper.scrape_and_create_year(@source, y, type)
      end
    else
      @type_years_hash.each do |type, year_range|
        year_range.each do |year|
          Scraper.scrape_and_create_year(@source, year, type)
        end
      end
    end
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
    comp = Competitor.all.find{ |c| c.name.downcase == name }
    # binding.pry
    if comp
      puts comp.name, comp.type.capitalize, "District: #{comp.district}"
      if comp.type == "quartet"
        comp.comments && (puts "Comments: #{comp.comments}")
        comp.members && (puts "Members: #{comp.members}")
      else
        comp.director && (puts "Director: #{comp.director}")
        comp.hometown && (puts "Hometown: #{comp.hometown}")
      end
      show_competitor_performances(comp)
    else
      false
    end
    true
  end

  def self.show_competitor_performances(com)
    title = "Performances"
    headers = ["Year", "Place", "Score"]
    headers << "# On Stage" if com.type == "chorus"
    com.performances.sort { |p| p.year }
    rows = com.performances.map do |p|
      disp_arr = []
      disp_arr.push(p.number_on_stage) if com.type == "chorus"
      disp_arr.unshift(p.year, p.place, p.score)
    end
    # binding.pry
    print_tty_table(title: title, headers: headers, rows: rows)
  end

  def self.print_tty_table(title: nil, headers: nil, rows:)
    puts title if title
    # binding.pry
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

end
