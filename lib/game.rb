require_relative '../lib/board'
require_relative '../lib/player'


class Game
  attr_reader :current_board, :current_player, :player_one, :player_two

  def initialize
    @player_one = Player.new('white')
    @player_two = Player.new('black')
    @current_board = Board.new
    @current_player = player_one
    @other_player = player_two
  end

  def play
    introduction
    @player_one.players_name
    @player_two.players_name
    moving_pieces
    ending
  end

  def introduction
    update_board
    current_board.print_board
  end

  def moving_pieces
    until current_board.winner?(current_player) do
      break 

    end
  end

  def ending
    1
  end

  def update_board
    player_one.pieces.each do |piece|
      current_board.current_board[piece.position[0]][piece.position[1]] = piece
    end
    player_two.pieces.each do |piece|
      current_board.current_board[piece.position[0]][piece.position[1]] = piece
    end
  end

end