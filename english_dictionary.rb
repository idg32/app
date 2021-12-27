#require 'app/words_array.rb'

# All code in the gem is namespaced under this module.
module EnglishDictionary

	@@words = {}
	@@array = []

	def self.load_words()
		File.open("words.txt") do |file|
			file.each do |line|
		 		@@array << line.chomp
			end
		end
		File.write("words_array.txt", @@array)
		print @@array
	end

	def self.is_word(word)
    File.open("words.txt") do |file|
			file.each do |line|
        if line.slice!(/ /).chomp.include?(word) == true
          puts "true"
        else
          puts "false"
        end
      end
	end	

end
EnglishDictionary.is_word("zygote")



