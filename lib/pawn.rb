require_relative './piece'

class Pawn < Piece
  def initialize(color)
    super(color, color == 'white' ? "\u2659" : "\u265F", position)
    @first_move = true
  end
end

#peon_1 = Pawn.new('white', [1,2])
#peon_2 = Pawn.new('black', [1,2])

#p peon_1
#p peon_2
