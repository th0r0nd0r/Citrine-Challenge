class Unit < ApplicationRecord
  UNIT_CONVERSIONS = {
    "minute": "s",
    "min": "s",
    "hour": "s",
    "h": "s",
    "day": "s",
    "d": "s",
    "degree": "rad",
    "°": "rad",
    "‘": "rad",
    "second": "rad",
    "“": "rad",
    "hectare": "m2",
    "ha": "m2",
    "litre": "m3",
    "L": "m3",
    "tonne": "kg",
    "t": "kg"
  }

  VALUE_CONVERSIONS = {
    "minute": "60.0",
    "min": "60.0",
    "hour": "3600.0",
    "h": "3600.0",
    "day": "86400.0",
    "d": "86400.0",
    "degree": (Math::PI / 180).to_s,
    "°": (Math::PI / 180).to_s,
    "‘": (Math::PI / 10800).to_s,
    "second": (Math::PI / 648000).to_s,
    "“": (Math::PI / 648000).to_s,
    "hectare": "10000.0",
    "ha": "10000.0",
    "litre": "0.001",
    "L": "0.001",
    "tonne": "1000.0",
    "t": "1000.0"
  }


  # this method creates a hash that maps every unit and operator from
  # the query string to its proper order
  # ex: 
  # query = "degree/minute"
  # units = ["degree", "minute"]
  # operators = ["/"]
  # 
  # self.location_map(units, operators, query) ==>
  # {0 => "degree", 1 => "/", 2 => "minute"}

  def self.location_map(units, operators, query)
    map_idx = 0
    locations = {}

    while query.length > 0
      first_char = query[0]
      if first_char == operators[0]
        current_item = operators[0]
        operators.shift
      else
        current_item = units[0]
        units.shift
      end
      
      locations[map_idx] = current_item

      slice_length = current_item.length
      query = query[slice_length..-1]
      map_idx += 1
    end

    locations
  end


  # takes the result of a self.location_map
  # and uses either the conversion constantsto replace freedom units 
  # with either si units or conversion factors.
  # it returns a string, like "m3/s", or "0.001/60.0"
  # it takes advantage of the fact that the ordering of Ruby hash literals is preserved
  def self.location_to_string(locations, conversion_hash)
    new_units = locations.values.map do |item|
      key = item.to_sym
      if conversion_hash.keys.include?(key)
        conversion_hash[key]
      else
        item
      end
    end

    new_units.join
  end

  def self.convert(units)
    # splitting the input into an array of units and an array of operators
    freedom_units = units.split(/[()*\/]/)
    freedom_units.reject! { |el| el.length == 0}
    operators = units.gsub(/[^()*\/]/, '').split('')


    # validation check to sanitize input so we can't eval anything but 
    # units and operators
    freedom_units.each do |unit|
      return "Invalid Unit" unless UNIT_CONVERSIONS.keys.include?(unit.to_sym)
    end

    # mapping units and operators in order of appearance
    locations = self.location_map(freedom_units, operators, units)
    
    unit_name = self.location_to_string(locations, UNIT_CONVERSIONS)
    m_f = eval(self.location_to_string(locations, VALUE_CONVERSIONS))


    # rounding the multiplication factor to 14 decimal places
    multiplication_factor = Integer(m_f * (10**14)) / Float(10**14)


    {"unit_name": unit_name, "multiplication_factor": multiplication_factor}
  end

end
