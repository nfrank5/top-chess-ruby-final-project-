class Piece
  attr_reader :unicode, :color, :moves
  attr_accessor :position
  def initialize(color, unicode, position)
    @color = color
    @unicode = unicode
    @position = position
    @moves = []
  end

  def different_color?(other_piece)
    @color != other_piece.color
  end

  def update_new_position(direction, position)
    [direction[0] + position[0], direction[1] + position[1]]
  end

  def target_included_in_moves(target)
    moves.include?(target)
  end

end

class Rook < Piece
  def initialize
    super
    @first_move = true
  end
end

class Bishop < Piece
end


class Knight < Piece

end

