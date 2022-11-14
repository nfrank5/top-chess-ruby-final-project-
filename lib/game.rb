require_relative '../lib/board'
require_relative '../lib/player'


class Game
  attr_reader :current_board, :current_player, :player_one, :player_two

  def initialize
    @player_one = Player.new('white')
    @player_two = Player.new('black')
    @current_board = Board.new
    @current_player = player_one
  end

  def play
    introduction
    @player_one.players_name
    @player_two.players_name
    moving_pieces
    ending
  end

  def introduction
    current_board.update_board(player_one, player_two)
    current_board.print_board
  end

  def moving_pieces
    1
  end

  def ending
    1
  end

end