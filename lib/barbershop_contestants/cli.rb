# command line interface
# responsible for starting the scraping/org process
# and providing the user with an interface
class CLI
  # Contest::Quartets.scrape_contests

  @@welcome_message = "Welcome to the Barbershop Contestants CLI!"

  def self.start
    # welcome the user and show command list
    # have the bin file call this method
    # scrape data from here
    puts @@welcome_message
    self.request_command
    self.input_loop
  end

  def self.input_loop

  end

  def self.request_command
    puts "Please enter a command."
    puts "To see all entries in a contest, enter the type of contest (quartet or chorus) and the year (1939-2018 for quartets, 1953-present for choruses)"
    puts "To see all performances by a group, enter the name of the group"
    puts "To see a list of all champions for a contest type, enter 'quartet champions' or 'chorus champions'"
    puts "For other commands enter 'help'"
    self.process_command(gets)
  end

  def self.process_command(command)
    commands = command.downcase.split
    case
    when commands[0].start_with?("quartet")
      case
      when commands[1].start_with?("champions")
      end
    when commands[0].start_with?("chorus")
      case
      when commands[1].start_with?("champions")
      end
    end
  end

  def self.print_help
    puts "This is the help function"
    # TODO help function
  end

  def self.print_quartet_champs_by_year
    Performance.q_champs_by_year.each do |champ|
      puts [champ.year, champ.competitor.name].join("\t")
    end
  end



end
