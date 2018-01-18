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

    # "degree/minute"
    # "(degree(minute/hectare))"

    # solving strategy:
    # create unit hash and value hash
    # split the units query on ( / * and ) with regex
    # split the inverse of the query, creating array with operators
    # use hashes to map input units to an array of si units and an array of values
    # use a conditional statment to figure out whether the first character in query was an operator or unit
    # zip both new arrays with the array of operators, and flatten
    # join both, call eval method on value string to get the multiplication factor

    freedom_units = units.split(/[()*\/]/)
    operators = units.split(/[^()*\/]/)

    si_units = freedom_units.map { |unit| unit_conversions[unit] }
    converted_values = freedom_units.map { |unit| value_conversions[unit] }

    first_char = units[0]

    if operators.include?(first_char)
      unit_name = operators.zip(si_units).flatten.join
      multiplication_factor = eval(operators.zip(converted_values).flatten.join)
    else
      unit_name = si_units.zip(operators).flatten.join
      multiplication_factor = eval(converted_values.zip(operators).flatten.join)
    end)


    [unit_name, multiplication_factor]
  end

end
