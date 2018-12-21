require_all "./lib"

# QUARTET_CHAMPS_SITE = "https://www.barbershopwiki.com/wiki/BHS_International_Quartet_Champions"

module BarbershopContestants
  class Error < StandardError; end
  # Your code goes here
end

doc = Scraper.scrape_quartet_champs
doc.css(".wikitable tbody tr").each_with_index do |row, index|
  binding.pry
  if index > 0
    row_data = row.text.split('\n')
    q_champs_hash = {
      year: row_data[0],
      quartet_name: row_data[1],
      score: row_data[2],
      district: row_data[3],
      comments: row_data[4],
      members: row_data[5]
    }
    Performance.create

  end
end
### Remember this pattern: ###

# properties.each do |k, v|
#   # k = properties
#   # v = values
#   class.send("#{k}=", v)
# end

# A line of text

# rake install local to
