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
    doc = self.scrape_HTML(QUARTET_CHAMPS_SITE)
  end
end
