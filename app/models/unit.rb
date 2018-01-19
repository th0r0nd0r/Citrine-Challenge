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

  def self.convert(units)
    byebug
    # sample values for 'units' argument
    # "degree/minute"
    # "(degree(minute/hectare))"
    p UNIT_CONVERSIONS
    p VALUE_CONVERSIONS

    # splitting the input into an array of units and an array of operators
    freedom_units = units.split(/[()*\/]/)
    operators = units.gsub(/[^()*\/]/, '').split('')

    # creating arrays for si units and values
    si_units = freedom_units.map { |unit| UNIT_CONVERSIONS[unit] }
    converted_values = freedom_units.map { |unit| VALUE_CONVERSIONS[unit] }

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
