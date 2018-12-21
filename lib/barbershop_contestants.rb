require_all "./lib"

# QUARTET_CHAMPS_SITE = "https://www.barbershopwiki.com/wiki/BHS_International_Quartet_Champions"

module BarbershopContestants
  class Error < StandardError; end
  # Your code goes here
end

doc = Scraper.scrape_quartet_champs
doc.each_with_index do |row, index|
  binding.pry
  if index > 0
    row_data = row.text.split("\n") # sic. Literal "\n"'s rather than newline characters.
    q_champs_hash = {
      year: row_data[1],
      quartet_name: row_data[2],
      score: row_data[3],
      district: row_data[4],
      comments: row_data[5],
      members: row_data[7],
      place: 1 # champions definitionally are first place
    }
    Performance.create_champs(q_champs_hash)

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
