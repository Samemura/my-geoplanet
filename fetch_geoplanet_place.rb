require 'geoplanet'
require 'yaml'
require 'pry'

# Constant
APPID = ENV['GEOPLANET_APPID']
PLACE_FILTER = {
  lang: 'ja',
  count: 0,
  type: [8,12],
  select: 'long'
}
JAPAN_WOEID = 23424856

# Argument
place_woeid = (ARGV[0] || JAPAN_WOEID).to_i
file_name = (ARGV[1] || "geoplanet.yml")
debug_mode = (ARGV[2] || false)

class MyGeoPlanetPlace < GeoPlanet::Place
  class << self
    attr_accessor :place_filter
  end

  attr_accessor :parent, :chidlren, :hash

  def to_h
    @hash ||= { self.woeid => Hash[instance_variables.map {|i| [i.to_s.sub("@", ""), instance_variable_get(i)] }] }
  end

  def children(*args)
    (super(*args) || []).map {|c| c.parent = self.woeid; c }
  end

  def descendants
    @children = {}
    self.children(self.class.place_filter).each do |c|
      if c
        @children.merge!(c.to_h)
        c.descendants {|place| yield place if block_given?}
      end
    end
    yield self.to_h if block_given?
  end
end

# main
GeoPlanet.appid = APPID
GeoPlanet.debug = debug_mode

MyGeoPlanetPlace.place_filter = PLACE_FILTER
root_place = MyGeoPlanetPlace.new(
  place_woeid,
  [PLACE_FILTER.assoc(:lang), PLACE_FILTER.assoc(:select)].to_h
)

file_path = Dir.pwd + "/" + file_name
file = File.open(file_path, 'w')
hash = {}
$place_num = 1
root_place.descendants { |place_hash|
  puts "fetching (" + $place_num.to_s + "): " + place_hash.values.first["name"] + ", " + place_hash.values.first["placetype"]
  hash.merge!(place_hash)
  file.write(place_hash.to_yaml)
  $place_num += 1
}
file.close
binding.pry
# File.write(file_path, hash.to_yaml)

puts file_path + " successfully generated."
