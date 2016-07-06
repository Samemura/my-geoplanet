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

def get_children_tree(place, parent)
  $place_num += 1
  puts "fetching : " + place.name
  puts "place num : " + $place_num.to_s
  children = place.children(type: [7, 8, 9, 10], count:0, lang:'ja')
  yml = place_to_yml(place, parent, children)
  if children
    children.each do |c|
      yml.merge!(get_children_tree(c, place))
    end
  end
  return yml
end

GeoPlanet.appid = ENV['APPID']
GeoPlanet.debug = true

japan = GeoPlanet::Place.new(JAPAN_WOEID, lang:'ja')
geo_yml = get_children_tree(japan, nil)

File.write(Dir.pwd + "/geoplanet.yml", geo_yml.to_yaml)