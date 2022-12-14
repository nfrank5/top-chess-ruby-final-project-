require_relative './utilities'
require_relative './king'
require_relative './queen'
require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './knight'
require_relative '../lib/input'

PAWN_PROMOTION_CLASSES = { rook: Rook, knight: Knight, queen: Queen, bishop: Bishop}.freeze

class Player
  include Utilities
  include Input
  attr_reader :color, :pieces, :name

  def initialize(color)
    @color = color
    @name = nil
    @pieces = [King.new(color), Queen.new(color),
               Rook.new(color, color == 'white' ? [7, 0] : [0, 0]),
               Rook.new(color, color == 'white' ? [7, 7] : [0, 7]),
               Pawn.new(color, color == 'white' ? [6, 0] : [1, 0]),
               Pawn.new(color, color == 'white' ? [6, 1] : [1, 1]),
               Pawn.new(color, color == 'white' ? [6, 2] : [1, 2]),
               Pawn.new(color, color == 'white' ? [6, 3] : [1, 3]),
               Pawn.new(color, color == 'white' ? [6, 4] : [1, 4]),
               Pawn.new(color, color == 'white' ? [6, 5] : [1, 5]),
               Pawn.new(color, color == 'white' ? [6, 6] : [1, 6]),
               Pawn.new(color, color == 'white' ? [6, 7] : [1, 7]),
               Bishop.new(color, color == 'white' ? [7, 2] : [0, 2]),
               Bishop.new(color, color == 'white' ? [7, 5] : [0, 5]),
               Knight.new(color, color == 'white' ? [7, 1] : [0, 1]),
               Knight.new(color, color == 'white' ? [7, 6] : [0, 6])
              ]
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

  def promoted_pawn_creation(old_piece)
    selected = 'non_existent'
    selected = input_pawn_promotion(self) while PAWN_PROMOTION_CLASSES[selected.to_sym].nil?
    create_piece(PAWN_PROMOTION_CLASSES[selected.to_sym], color, old_piece.position)
    pieces.delete(old_piece)
  end

  def create_piece(type_of_piece, color, position)
    pieces.push(type_of_piece.new(color, position))
  end
end

