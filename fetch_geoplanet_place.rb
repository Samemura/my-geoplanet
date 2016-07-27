require 'geoplanet'
require './lib/my_geoplanet_place'
require 'yaml'
require 'pry'

# Constant
APPID = ENV['GEOPLANET_APPID']
PLACE_FILTER = {
  lang: 'ja',
  count: 0,
  type: [7, 8, 9, 12],
  select: 'long'
}
JAPAN_WOEID = 23424856

# Argument
place_woeid = (ARGV[0] || JAPAN_WOEID).to_i
file_name = (ARGV[1] || "geoplanet.yml")
debug_mode = (ARGV[2] || false)
file_path = Dir.pwd + "/" + file_name


# main
GeoPlanet.appid = APPID
GeoPlanet.debug = debug_mode

MyGeoPlanetPlace.place_filter = PLACE_FILTER
root_place = MyGeoPlanetPlace.new(
  place_woeid,
  [PLACE_FILTER.assoc(:lang), PLACE_FILTER.assoc(:select)].to_h
)

hash = {}
$place_num = 1
root_place.descendants { |place_hash|
  puts "fetching (" + $place_num.to_s + "): " + place_hash.values.first["name"] + ", " + place_hash.values.first["placetype"]
  hash.merge!(place_hash)
  $place_num += 1
}

File.write(file_path, hash.to_yaml)
puts file_path + " successfully generated."
