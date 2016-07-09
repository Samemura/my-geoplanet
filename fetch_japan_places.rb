require 'geoplanet'
require 'json'
require 'yaml'
require 'pry'

JAPAN_WOEID = 23424856
$place_num = 0

def place_to_yml(place, parent, children)
  {
    place.woeid => {
      type: place.placetype,
      name: place.name,
      parent: parent ? parent.woeid : nil,
      children: children ? children.map {|c| c.woeid} : nil
    }
  }
end

def get_children_tree(place, parent, _array, _tree)
  $place_num += 1
  puts "fetching : " + place.name + ", " + place.placetype
  puts "place num : " + $place_num.to_s

  children = place.children(type: [8], count:0, lang:'ja')

  hash = place_to_yml(place, parent, children)
  _array.merge!(hash)
  # hash[place.woeid][:children] = {}
  # _tree.merge!(hash)

# binding.pry

  if children
    children.each do |c|
      # get_children_tree(c, place, _array, _tree[place.woeid][:children])
      get_children_tree(c, place, _array, nil)
    end
  end
end

GeoPlanet.appid = ENV['APPID']
GeoPlanet.debug = true

japan = GeoPlanet::Place.new(JAPAN_WOEID, lang:'ja')

array_hash = {}
tree_hash = {}
get_children_tree(japan, nil, array_hash, tree_hash)


File.write(Dir.pwd + "/geoplanet.yml", array_hash.to_yaml)
File.write(Dir.pwd + "/geoplanet_tree.yml", tree_hash.to_yaml)