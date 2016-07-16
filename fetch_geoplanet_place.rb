require 'geoplanet'
require 'yaml'
require 'pry'

# Constant
APPID = ENV['GEOPLANET_APPID']
PLACE_ATTR = {
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

  def children(*args)
    p "do children"
    # @children ||= super(*args).map {|c| c.parent = self.woeid}
    children = super(*args)
    @children = children.map {|c| [c.woeid, c] }.to_h
    return children
  end
end

def get_children_tree(place, parent)
  place.children
  place.parent = parent ? parent.woeid : nil

  yield place if block_given?

  children = place.children(PLACE_ATTR) || []
  children.each do |c|
    get_children_tree(c, place) {|place| yield place if block_given?}
  end
end

# main
GeoPlanet.appid = APPID
GeoPlanet.debug = debug_mode

place = MyPlace.new(place_woeid, [PLACE_ATTR.assoc(:lang), PLACE_ATTR.assoc(:select)].to_h )
binding.pry

array_hash = {}
$place_num = 1
get_children_tree(place, nil) { |place|
  puts "fetching (" + $place_num.to_s + "): " + place.name + ", " + place.placetype
  array_hash.merge!(place.to_h)
  $place_num += 1
}

file_path = Dir.pwd + "/" + file_name
File.write(file_path, array_hash.to_yaml)

puts file_path + " successfully generated."
