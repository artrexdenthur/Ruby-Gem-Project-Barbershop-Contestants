require_all "./lib"

# QUARTET_CHAMPS_SITE = "https://www.barbershopwiki.com/wiki/BHS_International_Quartet_Champions"

module BarbershopContestants
  class Error < StandardError; end
  # Your code goes here
end

<<<<<<< HEAD
# doc = Scraper.scrape_quartet_champs
# doc.each_with_index do |row, index|
=======
doc = Scraper.scrape_quartet_champs
# binding.pry
# doc.each do |row|
>>>>>>> ead516eaf0d53d65ac62ba7b7bc6a3e8d296e4d2
#   # binding.pry
#   row_data = row.text.split("\n")
#   q_champs_hash = {
#     year: row_data[1],
#     name: row_data[2],
#     score: row_data[3],
#     district: row_data[4],
#     comments: row_data[5],
#     members: row_data[7],
#     place: 1, # champions definitionally are first place
#     type: "quartet"
#   }
#   Performance.create_q_champ(q_champs_hash)
<<<<<<< HEAD
#   # binding.pry
#
=======
  # binding.pry

>>>>>>> ead516eaf0d53d65ac62ba7b7bc6a3e8d296e4d2
# end

# binding.pry
CLI.start
### Remember this pattern: ###

# properties.each do |k, v|
#   # k = properties
#   # v = values
#   class.send("#{k}=", v)
# end

# A line of text

# rake install local to
