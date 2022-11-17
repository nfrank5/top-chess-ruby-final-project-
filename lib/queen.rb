require_relative './piece'
require_relative './board'



class Queen < Piece
  DIRECTIONS_QUEEN = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]

  def initialize(color)
    super(color, color == 'white' ? "\u2655" : "\u265B", color == 'white' ? [7, 3] : [0, 3])
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_QUEEN.map do |direction|
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
