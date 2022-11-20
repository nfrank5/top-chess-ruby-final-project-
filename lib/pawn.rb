require_relative './piece'

class Pawn < Piece
  DIRECTIONS_PAWN = { 'white' => [[-1, -1], [-1, 1], [-1, 0], [-2, 0]], 'black' => [[1, -1], [1, 1], [1, 0], [2, 0]]}.freeze
  attr_accessor :first_move
  attr_accessor :en_passant

  def initialize(color, position)
    super(color, position, color == 'white' ? "\u2659" : "\u265F")
    @first_move = true
    @en_passant = false
  end

  def valid_moves(board)
    @moves = []

    DIRECTIONS_PAWN[color].map do |direction|
      new_position = update_new_position(position.slice(0..-1), direction)
      next if board.outside_board?(new_position)

      if board.empty?(new_position) && [[-1, 0], [1, 0]].include?(direction)
        @moves.push(new_position)
      elsif first_move && [[-2, 0], [2, 0]].include?(direction) && board.empty?(new_position) &&
            board.empty?(color == 'white' ? [5, new_position[1]] : [2, new_position[1]])
        @moves.push(new_position)
      elsif [[-1, -1], [-1, 1], [1, -1], [1, 1]].include?(direction) && board.enemy_piece?(position, new_position)
        @moves.push(new_position)
      end
    end
    @moves.push(@en_passant) if @en_passant
  end
end
