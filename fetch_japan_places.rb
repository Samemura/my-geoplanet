require 'geoplanet'
require 'json'
require 'yaml'
require 'pp'

def place_to_yml(place)
  yml = {}
  yml[place.woeid] = {
    name: place.name,
    type: place.placetype
  }
  yml
end

GeoPlanet.appid = ENV['APPID']
GeoPlanet.debug = true

geo_yml = {}

japan = GeoPlanet::Place.search("japan", type:12, lang:'ja').first
geo_yml.merge!(place_to_yml(japan))

region = japan.children(type: "Colloquial", count:0, lang:'ja').select! {|r| r.name.index('地方')}
# japan.children has many other type of places.
# Colloquial includes peninsula somehow.
region.each do |r|
  geo_yml.merge!(place_to_yml(r))
  # p r.children(count:0)
end

File.write(Dir.pwd + "/geoplanet.yml", geo_yml.to_yaml)
pp geo_yml