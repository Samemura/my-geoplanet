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

  def to_h(parent)
    {
      self.woeid => Hash[instance_variables.map {|i| [i.to_s.sub("@", ""), instance_variable_get(i)] }]
    }
    # hash[self.woeid].merge! Hash[instance_variables.map {|i| [i.to_s.sub("@", ""), instance_variable_get(i)] }]
    # return hash
  end

  def children(*args)
    p "do children"
    # @children ||= super(*args).map {|c| c.parent = self.woeid}
    children = super(*args)
    @children = children.map {|c| [c.woeid, c] }.to_h
    return children
  end
end

def get_children_tree(place, parent, _array, _tree)
  yield place if block_given?

  place.children
  place.parent = parent ? parent.woeid : nil
  hash = place.to_h(parent)

  binding.pry

  _array.merge!(hash)
  _tree.merge!(hash)

  children = place.children(PLACE_ATTR) || []
  children.each do |c|
    get_children_tree(c, place, _array, _tree[place.woeid]["children"]) {|place| yield place if block_given?}
  end
end

# main
GeoPlanet.appid = APPID
GeoPlanet.debug = debug_mode

place = MyPlace.new(place_woeid, [PLACE_ATTR.assoc(:lang), PLACE_ATTR.assoc(:select)].to_h )
binding.pry

array_hash = {}
tree_hash = {}
$place_num = 0
get_children_tree(place, nil, array_hash, tree_hash) { |place|
  $place_num += 1
  puts "fetching (" + $place_num.to_s + "): " + place.name + ", " + place.placetype
}

file_path = Dir.pwd + "/" + file_name
File.write(file_path, array_hash.to_yaml)

puts file_path + " successfully generated."
