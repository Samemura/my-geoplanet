require 'geoplanet'
require 'yaml'
require 'pry'

place_woeid = (ARGV[0] ? ARGV[0].to_i : 23424856)
file_name = (ARGV[1] ? ARGV[1] : "geoplanet.yml")

def place_to_yml(place, parent)
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
      bounding_box: place.bounding_box,
      area_rank: place.area_rank,
      parent: parent ? parent.woeid : nil,
      children: {}
    }
  }
end

def get_children_tree(place, parent, _array, _tree)
  $place_num += 1
  puts "fetching (" + $place_num.to_s + "): " + place.name + ", " + place.placetype

  children = place.children(select: 'long', type: [7, 8, 9], count:0, lang:'ja')

  hash = place_to_yml(place, parent)
  _array.merge!(hash)
  _tree.merge!(hash)

  if children
    children.each do |c|
      get_children_tree(c, place, _array, _tree[place.woeid][:children])
    end
  end
end

GeoPlanet.appid = ENV['GEOPLANET_APPID']
# GeoPlanet.debug = true

place = GeoPlanet::Place.new(place_woeid, lang:'ja')

array_hash = {}
tree_hash = {}
$place_num = 0
get_children_tree(place, nil, array_hash, tree_hash)

file_path = Dir.pwd + "/" + file_name
File.write(file_path, array_hash.to_yaml)
puts file_path + " successfully generated."