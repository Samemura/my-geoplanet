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
  attr_accessor :parent, :chidlren

  def to_h
    { self.woeid => Hash[instance_variables.map {|i| [i.to_s.sub("@", ""), instance_variable_get(i)] }] }
  end

  def fetch_children(*args)
    children = (self.children(*args) || []).map{|c| c.parent = self.woeid; c}
    @children = children.map {|c| [c.woeid, nil] }.to_h
    return children
  end

  def get_children_tree
    children = self.fetch_children(PLACE_FILTER)

    yield self if block_given?

    children.each do |c|
      c.get_children_tree {|place| yield place if block_given?}
    end
  end
end

# main
GeoPlanet.appid = APPID
GeoPlanet.debug = debug_mode

root_place = MyPlace.new(place_woeid, [PLACE_FILTER.assoc(:lang), PLACE_FILTER.assoc(:select)].to_h )

array_hash = {}
$place_num = 1
root_place.get_children_tree { |place|
  puts "fetching (" + $place_num.to_s + "): " + place.name + ", " + place.placetype
  array_hash.merge!(place.to_h)
  $place_num += 1
}

binding.pry
file_path = Dir.pwd + "/" + file_name
File.write(file_path, array_hash.to_yaml)

puts file_path + " successfully generated."
