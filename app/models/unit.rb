class Unit < ApplicationRecord
  def self.convert(units)
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

    

    unit_conversions = {
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

    value_conversions = {
      "min": "60",
      "h": "3600",
      "d": "86400",
      "°": (Math::PI / 180).to_s,
      "‘": (Math::PI / 10800).to_s,
      "“": (Math::PI / 648000).to_s,
      "ha": "10000",
      "L": "0.001",
      "t": "1000"
    }

  end

end
