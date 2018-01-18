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

    unit_hash = {

    }

  end

end
