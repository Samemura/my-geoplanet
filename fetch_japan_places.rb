require 'geoplanet'
require 'json'
require 'yaml'
require 'pp'

GeoPlanet.appid = ENV['APPID']
GeoPlanet.debug = true

japan = GeoPlanet::Place.search("japan", type:12).first
region = japan.children(type: "Colloquial", count:0).select! {|r| r.name.index('Region')}

pp region.to_yaml
p region.length

region.each do |r|
  p r.children(count:0)
end

File.write(Dir.pwd + "/geoplanet.yml", region.to_yaml)
