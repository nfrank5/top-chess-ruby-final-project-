require_relative './piece'
require_relative './board'

class King < Piece
  DIRECTIONS_KING = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]

  attr_accessor :first_move

  def initialize(color)
    super(color, color == 'white' ? [7, 4] : [0, 4], color == 'white' ? "\u2654" : "\u265A")
    @first_move = true
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_KING.map do |direction|
      new_position = update_new_position(position.slice(0..-1), direction)
      next if board.outside_board?(new_position)

      if board.empty?(new_position)
        @moves.push(new_position)
      elsif board.enemy_piece?(position, new_position)
        @moves.push(new_position)
        next
      else
        next
      end
    end

    if first_move #castling
      [[0, 0], [0, 7], [7, 0], [7, 7]].each do |corner|
        piece = board.piece_by_position(corner)
        if !piece.nil? && piece.instance_of?(Rook) && piece.color == color && piece.first_move
          case corner
          when [0, 0]
            if board.current_board[0][3].nil? && board.current_board[0][2].nil? && board.current_board[0][1].nil?
              @moves.push([0, 2])
            end
          when [0, 7]
            if board.current_board[0][5].nil? && board.current_board[0][6].nil?
              @moves.push([0, 6])
            end
          when [7, 0]
            if board.current_board[7][3].nil? && board.current_board[7][2].nil? && board.current_board[7][1].nil?
              @moves.push([7, 2])
            end
          when [7, 7]
            if board.current_board[7][5].nil? && board.current_board[7][6].nil?
              @moves.push([7, 6])
            end
          end
        end
      end
    end
  end
end

