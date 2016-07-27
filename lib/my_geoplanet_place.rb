require 'geoplanet'

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
        c.descendants {|place| yield place if block_given?}
        @children.merge!(c.to_h)
      end
    end
    yield self.to_h if block_given?
  end
end
