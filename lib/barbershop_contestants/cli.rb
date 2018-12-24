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
    # Scraper.scrape_and_create_chorus_champs
    request_command
    input_loop
  end

  def self.input_loop
    x = ""
    while x.to_s != "quit"
      x = process_command
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
    verbs = ["quar", "chor", "help", "quit"]
    command_verb = verbs.find { |v| commands[0].start_with?(v) }
    if command_verb # verb used
      # first check for the champion path
      case command_verb
      when "quit"
        puts "Goodbye!"
        return "quit"
      when "help"
        puts "You've selected 'help'"
        puts "No extra commands have yet been added."
        puts "Repeating command selection prompt:"
        request_command
      when "quar"
        if commands.drop(1).any? { |c| c.start_with?("cham") }
          puts "You've selected 'Quartet Champions'"
        else # looking for a year
          year = commands.drop(1).find { |c| (1939..2018).include?(c.to_i) }
          if year
            puts "You've selected 'Quartet Contest for' #{year}"
          end
        end
      when "chor"
        if commands.drop(1).any? { |c| c.start_with?("cham") }
          puts "You've selected 'Chorus Champions'"
        else # looking for a year
          year = commands.drop(1).find { |c| (1939..2018).include?(c.to_i) }
          if year
            puts "You've selected 'Chorus Contest for #{year}'"
          end
        end
    else # no verb used, try to search by name

    end

    # The following is the start of a "case parser" that may not be
    # the actual easiest solution
    # case
    # when commands[0].start_with?("quartet")
    #   case
    #   when commands[1].start_with?("champions")
    #     puts "You've selected 'quartet champions'."
    #   when commands.drop(1).any? { |c| (1939..2018).include?(c) }
    #     # do the year thing
    #     year = commands.drop(1).find { |c| (1939..2018).include?(c) }
    #     puts "You've selected"
    #   end
    # when commands[0].start_with?("chorus")
    #   case
    #   when commands[1].start_with?("champions")
    #     puts "You've selected 'chorus champions'."
    #   end
    # when commands[0].start_with?("quit")
    #   puts "Goodbye!"
    #   return "quit"
    # end
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
