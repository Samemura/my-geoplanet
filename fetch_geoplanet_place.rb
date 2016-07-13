require 'geoplanet'
require 'yaml'
require 'pry'

# Constant
JAPAN_WOEID = 23424856
PLACE_LANGUAGE = 'ja'
PLACE_COUNT = 0
PLACE_TYPE = [8]
PLACE_SELECT = 'long'

# Argument
place_woeid = (ARGV[0] || JAPAN_WOEID).to_i
file_name = (ARGV[1] || "geoplanet.yml")
debug_mode = (ARGV[2] || false)

# method
def place_to_hash(place, parent)
  {
    place.woeid => {
      type: place.placetype,
      type_code: place.placetype_code,
      postal: place.postal,
      name: place.name,
      country: place.country,
      admin1: place.admin1,
      admin2: place.admin2,
      admin3: place.admin3,
      uri: place.uri,
      latitude: place.latitude,
      longitude: place.longitude,
      bounding_box: place.bounding_box,
      area_rank: place.area_rank,
      parent: parent ? parent.woeid : nil,
      children: {}
    }
  }
end

def get_children_tree(place, parent, _array, _tree)
  yield place if block_given?

  hash = place_to_hash(place, parent)
  _array.merge!(hash)
  _tree.merge!(hash)

  children = place.children(select: PLACE_SELECT, type: PLACE_TYPE, count: PLACE_COUNT, lang: PLACE_LANGUAGE) || []
  children.each do |c|
    get_children_tree(c, place, _array, _tree[place.woeid][:children]) {|place| yield place if block_given?}
  end
end

# main
GeoPlanet.appid = ENV['GEOPLANET_APPID']
GeoPlanet.debug = debug_mode

place = GeoPlanet::Place.new(place_woeid, lang:'ja')

array_hash = {}
tree_hash = {}
$place_num = 0
get_children_tree(place, nil, array_hash, tree_hash) { |place|
  $place_num += 1
  puts "fetching (" + $place_num.to_s + "): " + place.name + ", " + place.placetype
}

file_path = Dir.pwd + "/" + file_name
File.write(file_path, array_hash.to_yaml)

puts file_path + " successfully generated."
