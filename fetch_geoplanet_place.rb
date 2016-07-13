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
module GeoPlanet
  class Place
    def to_hash(parent)
      {
        self.woeid => {
          type: self.placetype,
          type_code: self.placetype_code,
          postal: self.postal,
          name: self.name,
          country: self.country,
          admin1: self.admin1,
          admin2: self.admin2,
          admin3: self.admin3,
          uri: self.uri,
          latitude: self.latitude,
          longitude: self.longitude,
          bounding_box: self.bounding_box,
          area_rank: self.area_rank,
          parent: parent ? parent.woeid : nil,
          children: {}
        }
      }
    end
  end
end

def get_children_tree(place, parent, _array, _tree)
  yield place if block_given?

  hash = place.to_hash(parent)
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
