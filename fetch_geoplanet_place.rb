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

class MyPlace < GeoPlanet::Place
  class << self
    attr_accessor :place_filter
  end

  attr_accessor :parent, :chidlren

  def to_h
    { self.woeid => Hash[instance_variables.map {|i| [i.to_s.sub("@", ""), instance_variable_get(i)] }] }
  end

  def children(*args)
    arr = (super(*args) || [])
    out = []
    (0..arr.length-1).each do |i|
      arr[i].parent = self.woeid
      out += {arr[i].woeid, arr[i]}
    end
    @children = out
    # @children = .map {|c|
    #   c.parent = self.woeid
    #   [c.woeid, c]
    # }.to_h
  end

  def get_descendants
    self.children(self.class.place_filter).each do |key, val|
      val.get_descendants {|place| yield place if block_given?} if val
    end

    yield self if block_given?
  end
end

# main
GeoPlanet.appid = APPID
GeoPlanet.debug = debug_mode

MyPlace.place_filter = PLACE_FILTER
root_place = MyPlace.new(place_woeid, [PLACE_FILTER.assoc(:lang), PLACE_FILTER.assoc(:select)].to_h )

hash = {}
$place_num = 1
root_place.get_descendants { |place|
  puts "fetching (" + $place_num.to_s + "): " + place.name + ", " + place.placetype
  hash.merge!(place.to_h)
  $place_num += 1
}

file_path = Dir.pwd + "/" + file_name
File.write(file_path, hash.to_yaml)

puts file_path + " successfully generated."
