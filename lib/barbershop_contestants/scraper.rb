# simple (reusable) scraper class that calls Nokogiri and dumps
# the requested site
class BarbershopContestants::Scraper
  def Self.scrape_HTML(page)
    Nokogiri::HTML(open(page))
  end
end
