require 'sqlite3'

require_relative "../lib/song.rb"
require_relative "../config/environment.rb"


song = Song.new(name: "Hello", album: "25")
puts "song name: " + song.name
puts "song album: " + song.album
song.save

DB[:conn].execute("SELECT * FROM songs")

song2 = Song.new(name: "Rolling in the Deep", album: "21")
puts "song name: " + song2.name
puts "song album: " + song2.album
song2.save

Song.find_by_name("Rolling in the Deep")

song3 = Song.new(name: "Someone Like You", album: "21")
puts "song name: " + song3.name
puts "song album: " + song3.album
song3.save

song4 = Song.new(name: "When We Were Young", album: "25")
puts "song name: " + song4.name
puts "song album: " + song4.album
song4.save

song5 = Song.new(name: "Make You Feel My Love", album: "19")
puts "song name: " + song5.name
puts "song album: " + song5.album
song5.save

puts song4
