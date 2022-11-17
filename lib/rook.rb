require_relative './piece'
DIRECTIONS_ROOK = [[1, 0], [0, 1], [-1, 0], [0, -1]]

class Rook < Piece
  def initialize(color, position)
    super(color, position, color == 'white' ? "\u2656" : "\u265C")
    @first_move = true
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_ROOK.map do |direction|
      new_position = position.slice(0..-1)
      loop do
        new_position = update_new_position(direction, new_position)
        break if board.outside_board?(new_position)

        if board.empty?(new_position)
          @moves.push(new_position)
        elsif board.enemy_piece?(position, new_position)
          @moves.push(new_position)
          break
        else
          break
        end
      end 
    end
  end
end