require_relative './utilities'
require_relative './king'
require_relative './queen'
require_relative './rook'

#require_relative './board'


class Player
  include Utilities

  attr_reader :color, :pieces, :name

  def initialize(color)
    @color = color
    @name = nil
    @pieces = [King.new(color), Queen.new(color), Rook.new(color, color == 'white' ? [7, 0]:[0, 0]), Rook.new(color, color == 'white' ? [7, 7]:[0, 7])]
  end

  def players_name
    puts "Insert name of #{color} player"
    @name = player_input(/^[A-Za-z0-9]{3,10}$/, 'Please insert a alphanumeric name between 3 and 10 characters')
  end

  def players_king
    pieces.each do |piece|
      return piece if piece.instance_of?(King)
    end
  end

  def remove_piece(position)
    pieces.each do |piece|
      if piece.position == position
        pieces.delete(piece) 
        return true
      end
    end
    false
  end

  def all_pieces_moves
    all_moves = []
    pieces.each do |piece|
      all_moves = piece.moves | all_moves
    end
    all_moves
  end

  def update_valid_moves(board)
    pieces.each do |piece|
      piece.valid_moves(board)
    end
  end

end
jugador = Player.new('white')

#tablero = Board.new
#jugador.update_valid_moves(tablero)
#p jugador