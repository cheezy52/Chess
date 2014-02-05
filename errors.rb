class InvalidMoveError < ArgumentError
  def to_s
    super.red
  end
end

class InvalidInputError < ArgumentError
  def to_s
    super.red
  end
end