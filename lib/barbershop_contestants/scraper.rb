# simple (reusable) scraper class that calls Nokogiri and dumps
# the requested site
class Scraper
  # site storage
  LOCATIONS = {
    base:  {
      web: "https://www.barbershopwiki.com/wiki/",
      local: "./sites/"
    },
    q_champs: {
      web: "BHS_International_Quartet_Champions",
      local: "BHS International Quartet Champions - Barbershop Wiki Project.html",
    },
    c_champs: {
      web: "BHS_International_Chorus_Champions",
      local: "BHS International Chorus Champions - Barbershop Wiki Project.html"
    },
    q_year: {
      web: ["BHS_Intl_Quartet_Contest_", ""],
      local: ["BHS Intl Quartet Contest ", " - Barbershop Wiki Project.html"]
    },
    c_year: {
      web: ["BHS_Intl_Chorus_Contest_", ""],
      local: ["BHS Intl Chorus Contest ", " - Barbershop Wiki Project.html"]
    },
    q_page: {
      web: "",
      local: ""
    },
    c_page: {
      web: "",
      local: ""
    },
  }
  QUARTET_CHAMPS_SITE = "https://www.barbershopwiki.com/wiki/BHS_International_Quartet_Champions"
  CHORUS_CHAMPS_SITE = "https://www.barbershopwiki.com/wiki/BHS_International_Chorus_Champions"
  LOCAL_SITES = {
    quartet_champs: "./sites/BHS International Quartet Champions - Barbershop Wiki Project.html",
    chorus_champs: "./sites/BHS International Chorus Champions - Barbershop Wiki Project.html",
    chorus_2018: "./sites/BHS Intl Chorus Contest 2018 - Barbershop Wiki Project.html",
    quartet_2018: "./sites/BHS Intl Quartet Contest 2018 - Barbershop Wiki Project.html"
  }
  CACHE_LOCATIONS = {
    qchamps: "./sites/qchamps.txt",
    cchamps: "./sites/cchamps.txt"
  }

  @years_scraped = { "quartet" => [], "chorus" => [] }

  def self.scrape_or_load(page)
    load_cache || Nokogiri::HTML(open(page))
  end
  # scraper should know what it's scraping,
  # but should not worry about the data classes'
  # architecture

  def self.load_cache
    # loaded = {}
    # CACHE_LOCATIONS.each do |key, loc|
    #   # load loc
    #   # loaded[key] = fopen(loc)
    # end
    nil
    # I'll have to figure this out later :/
    # try to get these to work:
    ##### doc = Nokogiri(string_or_io)
    ##### node.write_to(io, *options)
    ##### or
    ##### node.to_s / .to_html / .to_xml
  end

  def self.scrape_quartet_champs(source)
    # binding.pry
    puts "Scraping Quartet Champs"
    location = LOCATIONS[:base][source] + LOCATIONS[:q_champs][source]
    doc = load_cache || scrape_or_load(location)
    # puts "Scraping local copy of site"
    # TODO: reinstate real scraping functionality when in wifi
    # binding.pry
    champ_table = doc.css(".wikitable tbody tr") # get the champs table
    champ_table.shift # get rid of the headers (can't figure out how to differentiate them with css)
    champ_table
  end

  def self.scrape_and_create_quartet_champs(source)
    scrape_quartet_champs(source).each do |row|
      # binding.pry
      row_data = row.text.split("\n")
      q_champs_hash = {
        year: row_data[1].to_i,
        name: row_data[2],
        score: row_data[3],
        district: row_data[4],
        comments: row_data[5],
        members: row_data[7],
        place: 1, # champions definitionally are first place
        type: "quartet"
      }
      Performance.find_or_create(q_champs_hash, "quartet")
      # binding.pry
    end
    system "clear" or system "cls"
  end

  def self.scrape_chorus_champs(source)
    puts "Scraping Chorus Champs"
    location = LOCATIONS[:base][source] + LOCATIONS[:c_champs][source]
    doc = load_cache || scrape_or_load(location)
    champ_table = doc.css(".wikitable")[1].css("tr")
    champ_table.shift # remove header line
    champ_table
  end

  def self.scrape_and_create_chorus_champs(source)
    # binding.pry
    scrape_chorus_champs(source).each do |row|
      # build a hash
      row_data = row.text.split("\n")
      # binding.pry
      c_champs_hash = {
        year: row_data[1].to_i,
        name: row_data[2],
        hometown_and_district: row_data[3],
        director: row_data[4],
        number_on_stage: row_data[5],
        score: row_data[6],
        place: 1, # champions definitionally are first place
        type: "chorus"
      }
      Performance.find_or_create(c_champs_hash, "chorus")
    end
    system "clear" or system "cls"
  end

  def self.scrape_and_create_year(source, year, type)
    if @years_scraped[type].include?(year)
      # puts "#{year} already scraped" # for debugging
      return true
    end
    @years_scraped[type] << year
    scrape_year(source, year, type).each do |t|
      # binding.pry
      t.each do |tr|
        row_data = tr.text.split("\n")
        # binding.pry
        year_hash = {
          year: year,
          place: row_data[1],
          name: row_data[2],
          district: row_data[3],
          score: row_data[4]
        }
        year_hash[:number_on_stage] = row_data[5] if type == "chorus"
        Performance.find_or_create(year_hash, type)
      end
    end
    system "clear" or system "cls"
  end

  def self.scrape_year(source, year, type)
    puts "Scraping #{type.capitalize} Contest for #{year}"
    location = LOCATIONS[:base][source] + \
               LOCATIONS[(type[0] + "_year").to_sym][source].join(year.to_s)
    doc = load_cache || scrape_or_load(location)
    tables_node = doc.css(".wikitable")
    tables_arr = []
    tables_node.each do |t|
      # binding.pry
      unless t.css("tr").first.text.include?("Admin")
        tables_arr << t.css("tr").drop(1)
      end
    end
    tables_arr
    # binding.pry
  end

end
