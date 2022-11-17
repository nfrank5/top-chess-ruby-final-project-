require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/utilities'


class Game
  include Utilities
  attr_reader :current_board, :player_one, :player_two, :current_player, :other_player

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
    update_game
    current_board.print_board
  end

  def moving_pieces
    until current_board.winner?(current_player) do
      successful_move = false
      until successful_move do
        current_target = input_move
        successful_move = move(current_target[0], current_target[1])
      end
      update_game
      switch_turn
      clear_screen
      puts "#{current_player.color} King is in Check!" if current_board.check?(other_player, current_player)
      current_board.print_board
      
    end
  end

  def input_move
    puts "#{current_player.name} choose a piece and move it selecting its origin and destiny" 
    puts 'For example 64 44, row first then column'
    current_target = player_input(/^[0-7]{2} {1,3}[0-7]{2}$/, 'Please insert your move using two digits followed by a space and then two more digits')
    current_target = current_target.split(' ')
    current = [current_target[0].split('')[0].to_i, (current_target[0].split('')[1]).to_i]
    target = [current_target[1].split('')[0].to_i, current_target[1].split('')[1].to_i] 
    [current, target]
  end

  def ending
    1
  end

  def move(current, target)
    if posible_move?(current, target)
      temp = switch_positions(current, target)
      update_game
      return true unless current_board.check?(other_player, current_player)

      undo_switch_positions(current, target, temp)
      update_game
    end
    false
  end

  def update_game
    current_board.update_board(player_one)
    current_board.update_board(player_two)
    player_one.update_valid_moves(current_board)
    player_two.update_valid_moves(current_board)
  end

  def posible_move?(current, target) 
    if !current_board.piece_by_position(current).nil?
      return valid_target(current, target) if correct_player_piece_color(current)
    end
    puts "#{current_player.name}, you are #{current_player.color}"
    puts "Choose a piece of your color" 
    false
  end

  def switch_positions(current, target)
    current_board.piece_by_position(current).position = target
    other_player.remove_piece(target)
    current_board.current_board[current[0]][current[1]] = nil
    current_board.piece_by_position(target)
  end

  def undo_switch_positions(current, target, temp)
    puts 'You can\'t move there: Check!'
    other_player.pieces.push(temp) unless temp.nil?
    current_board.piece_by_position(target).position = current
    current_board.current_board[target[0]][target[1]] = nil
  end

  def switch_turn
    temp = @current_player
    @current_player = @other_player
    @other_player = temp
  end

  def correct_player_piece_color(current)
    current_player.color == current_board.piece_by_position(current).color
  end

  def valid_target(current, target)
    return true if current_board.piece_by_position(current).moves.include?(target)
    
    puts 'Choose a valid move'
    false
  end
end