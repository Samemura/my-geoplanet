require 'geoplanet'
require 'json'
require 'yaml'
require 'pp'

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

def place_to_yml_as_tree(place)
  {
    place.woeid => {
      type: place.placetype,
      name: place.name
    }
  }
end

def get_children_tree(place, parent)
  $place_num += 1
  puts "fetching : " + place.name + ", " + place.placetype
  puts "place num : " + $place_num.to_s
  children = place.children(type: [7, 8, 9], count:0, lang:'ja')
  yml = place_to_yml(place, parent, children)
  if children
    children.each do |c|
      yml.merge!(get_children_tree(c, place))
    end
  end
  return yml
end

def get_children_tree_as_tree_hash(place, _hash)
  $place_num += 1
  puts "fetching : " + place.name + ", " + place.placetype
  puts "place num : " + $place_num.to_s
  _hash.merge!(place_to_yml_as_tree(place))

  children = place.children(type: [7, 8], count:0, lang:'ja')
  if children
    children.each do |c|
      get_children_tree_as_tree_hash(c, _hash[place.woeid])
    end
  end
end

GeoPlanet.appid = ENV['APPID']
GeoPlanet.debug = true

japan = GeoPlanet::Place.new(JAPAN_WOEID, lang:'ja')
# geo_yml = get_children_tree(japan, nil)
geo_yml = {}
get_children_tree_as_tree_hash(japan, geo_yml)

# File.write(Dir.pwd + "/geoplanet.yml", geo_yml.to_yaml)
File.write(Dir.pwd + "/geoplanet_tree.yml", geo_yml.to_yaml)