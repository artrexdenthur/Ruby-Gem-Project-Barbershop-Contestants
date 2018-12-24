# simple (reusable) scraper class that calls Nokogiri and dumps
# the requested site
class Scraper
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

  def self.scrape_quartet_champs
    puts "Scraping quartet champs"
    doc = load_cache || scrape_or_load(QUARTET_CHAMPS_SITE)
    # puts "Scraping local copy of site"
    # TODO: reinstate real scraping functionality when in wifi
    # binding.pry
    champ_table = doc.css(".wikitable tbody tr") # get the champs table
    champ_table.shift # get rid of the headers (can't figure out how to differentiate them with css)
    champ_table
  end

  def self.scrape_and_create_quartet_champs
    scrape_quartet_champs.each do |row|
      # binding.pry
      row_data = row.text.split("\n")
      q_champs_hash = {
        year: row_data[1],
        name: row_data[2],
        score: row_data[3],
        district: row_data[4],
        comments: row_data[5],
        members: row_data[7],
        place: 1, # champions definitionally are first place
        type: "quartet"
      }
      Performance.create_q_performance(q_champs_hash)
      # binding.pry
    end
  end

  def self.scrape_chorus_champs
    puts "Scraping chorus champs"
    doc = scrape_or_load(CHORUS_CHAMPS_SITE)
    champ_table = doc.css(".wikitable")[1].css("tr")
    champ_table.shift # remove header line
    champ_table
  end

  def self.scrape_and_create_chorus_champs
    # binding.pry
    scrape_chorus_champs.each do |row|
      # build a hash
      row_data = row.text.split("\n")
      # binding.pry
      c_champs_hash = {
        year: row_data[1],
        name: row_data[2],
        hometown_and_district: row_data[3],
        number_on_stage: row_data[4],
        score: row_data[5],
        place: 1, # champions definitionally are first place
        type: "chorus"
      }
      Performance.create_c_performance(c_champs_hash)
    end
  end

end
