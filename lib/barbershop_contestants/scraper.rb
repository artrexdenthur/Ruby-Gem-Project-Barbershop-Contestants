# simple (reusable) scraper class that calls Nokogiri and dumps
# the requested site
class Scraper
  QUARTET_CHAMPS_SITE = "https://www.barbershopwiki.com/wiki/BHS_International_Quartet_Champions"

  def self.scrape_HTML(page)
    Nokogiri::HTML(open(page))
  end
  # scraper should know what it's scraping,
  # but should not worry about the data classes'
  # architecture

  def self.scrape_quartet_champs
    doc = scrape_HTML(QUARTET_CHAMPS_SITE) # scrape site
    binding.pry
    # try to get these to work:
    ##### doc = Nokogiri(string_or_io)
    ##### node.write_to(io, *options)
    ##### or
    ##### node.to_s / .to_html / .to_xml
    doc = doc.css(".wikitable tbody tr") # get the champs table
    doc.delete(doc[0]) # get rid of the headers (can't figure out how to differentiate them with css)
    doc.each do |row|
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
      Performance.create_q_champ(q_champs_hash)
      # binding.pry
    end
  end

  def self.scrape_chorus_champs
    doc = scrape_HTML(CHORUS_CHAMPS_SITE)
    doc = doc.css(".wikitable tbody tr")
    doc.delete(doc[0])
  end

end
