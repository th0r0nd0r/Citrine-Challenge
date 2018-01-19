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

  def self.location_map(units, operators, query)
    map_idx = 0
    locations = {}

    while query.length > 0
      first_char = query[0]
      if first_char == operators[0]
        current_item = operators[0]
      else
        current_item = units[0]
      end
      
      locations[current_item] = map_idx

      slice_length = current_item.length
      query = query[slice_length..-1]
      map_idx += 1
    end

    locations
  end

  def self.convert(units)
    # sample values for 'units' argument
    # "degree/minute"
    # "(degree(minute/hectare))"

    # splitting the input into an array of units and an array of operators
    freedom_units = units.split(/[()*\/]/)
    freedom_units.reject! { |el| el.length == 0}
    operators = units.gsub(/[^()*\/]/, '').split('')


    # validation check to sanitize input so we can't eval anything but 
    # units and operators
    freedom_units.each do |unit|
      return "Invalid query" unless UNIT_CONVERSIONS.keys.include?(unit.to_sym)
    end


    # creating arrays for si units and values
    si_units = freedom_units.map { |unit| UNIT_CONVERSIONS[unit.to_sym] }
    converted_values = freedom_units.map { |unit| VALUE_CONVERSIONS[unit.to_sym] }

    byebug
    locations = self.location_map(si_units, operators, units)
    

    # figuring out whether to start zipping with units or operators
    first_char = units[0]


    # zipping units and values up with operators, and converting to final data types
    # (string and float)
    if operators.include?(first_char)
      unit_name = operators.zip(si_units).flatten.join
      m_f = eval(operators.zip(converted_values).flatten.join)
    else
      unit_name = si_units.zip(operators).flatten.join
      m_f = eval(converted_values.zip(operators).flatten.join)
    end


    # rounding the multiplication factor to 14 decimal places
    multiplication_factor = Integer(m_f * (10**14)) / Float(10**14)


    {"unit_name": unit_name, "multiplication_factor": multiplication_factor}
  end

end
