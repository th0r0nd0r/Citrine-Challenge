class Unit < ApplicationRecord
  def self.convert(units)
    UNIT_CONVERSIONS = {
      "min": "s",
      "h": "s",
      "d": "s",
      "°": "rad",
      "‘": "rad",
      "“": "rad",
      "ha": "m2",
      "L": "m3",
      "t": "kg"
    }

    VALUE_CONVERSIONS = {
      "min": "60.0",
      "h": "3600.0",
      "d": "86400.0",
      "°": (Math::PI / 180).to_s,
      "‘": (Math::PI / 10800).to_s,
      "“": (Math::PI / 648000).to_s,
      "ha": "10000.0",
      "L": "0.001",
      "t": "1000.0"
    }

    # sample values for 'units' argument
    # "degree/minute"
    # "(degree(minute/hectare))"


    # splitting the input into an array of units and an array of operators
    freedom_units = units.split(/[()*\/]/)
    operators = units.split(/[^()*\/]/)

    # creating arrays for si units and values
    si_units = freedom_units.map { |unit| unit_conversions[unit] }
    converted_values = freedom_units.map { |unit| value_conversions[unit] }

    # figuring out whether to start zipping with units or operators
    first_char = units[0]

    # zipping units and values up with operators, and converting to final data types
    # string and float
    if operators.include?(first_char)
      unit_name = operators.zip(si_units).flatten.join
      m_f = eval(operators.zip(converted_values).flatten.join)
    else
      unit_name = si_units.zip(operators).flatten.join
      m_f = eval(converted_values.zip(operators).flatten.join)
    end)

    # rounding the multiplication factor to 14 decimal places
    multiplication_factor = Integer(m_f * (10**14)) / Float(10**14)


    [unit_name, multiplication_factor]
  end

end
