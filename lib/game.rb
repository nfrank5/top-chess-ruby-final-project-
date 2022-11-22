require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/utilities'
require_relative '../lib/en_passant'
require_relative '../lib/input'
require_relative '../lib/castling'
require_relative '../lib/data'


class Game
  include Utilities
  include EnPassant
  include Input
  include Castling
  include Data
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
    unless load_game
      @player_one.players_name
      @player_two.players_name
    end
    clear_screen
    update_game
    current_board.print_board
    type_of_end = moving_pieces
    ending(type_of_end)
  end

  def introduction
    puts 'Welcome to Chess by Nfrank5!'
    puts 'If you want to save during the game write "Save" instead of a move'
  end

  def moving_pieces
    until continue_game?
      successful_move = false
      until successful_move
        current_position_and_target = input_move
        if current_position_and_target == 'save'
          save_games
          next
        end
        successful_move = move(current_position_and_target[0], current_position_and_target[1])
      end
      checks_and_updates_after_move(current_position_and_target[1])
    end
    continue_game?
  end

  def checks_and_updates_after_move(target)
    first_move_update(target)
    active_en_passant(target)
    update_game
    pawn_promotion
    switch_turn
    clear_screen
    check_warning
    current_board.print_board
  end

  def check_warning
    puts "#{current_player.color.capitalize} King is in Check!" if current_board.check?(other_player, current_player)
  end

  def continue_game?
    current_player.pieces.each do |piece|
      piece.moves.each do |move|
        there_is_no_scape = temp_position_to_verify_check(piece, move)
        return false unless there_is_no_scape
      end
    end
    current_board.check?(other_player, current_player) ? 'winner' : 'stalemate'
  end

  def temp_position_to_verify_check(piece, move)
    current = piece.position
    temp = switch_positions(current, move)
    there_is_no_scape = current_board.check?(other_player, current_player)
    undo_switch_positions(current, move, temp, true)
    there_is_no_scape
  end

  def ending(type_of_end)
    puts type_of_end == 'winner' ? "Ending: #{other_player.name} won!" : 'Stalemate'
  end

  def move(current, target)
    castling = attempting_castling?(current, target)
    en_passant = attempting_en_passant?(current, target)
    if valid_en_passant?(current, target) && valid_move?(current, target) && valid_castling?(current, target) 
      temp = switch_positions(current, target)
      unless current_board.check?(other_player, current_player)
        switch_positions(TOWER_MOVE_FOR_CASTLING[target][0], TOWER_MOVE_FOR_CASTLING[target][1]) if castling
        remove_en_passant_pawn_from_board(target) if en_passant
        return true
      end
      undo_switch_positions(current, target, temp)
    end
    false
  end

  def update_game
    current_board.update_board(player_one)
    current_board.update_board(player_two)
    player_one.update_valid_moves(current_board)
    player_two.update_valid_moves(current_board)
  end

  def valid_move?(current, target)
    return true if correct_player_piece_color(current) && valid_target(current, target) && !current_board.piece_by_position(current).nil?

    puts "#{current_player.name}, you are #{current_player.color}"
    puts 'Choose a piece of your color'
    false
  end

  def switch_positions(current, target)
    current_board.piece_by_position(current).position = target
    other_player.remove_piece(target)
    current_board.current_board[current[0]][current[1]] = nil
    temp = current_board.piece_by_position(target)
    update_game
    temp
  end

  def undo_switch_positions(current, target, temp, checkin_for_winner = false)
    puts 'You can\'t move there: Check!' unless checkin_for_winner
    other_player.pieces.push(temp) unless temp.nil?
    current_board.piece_by_position(target).position = current
    current_board.current_board[target[0]][target[1]] = nil
    update_game
  end

  def switch_turn
    temp = @current_player
    @current_player = @other_player
    @other_player = temp
  end

  def correct_player_piece_color(current)
    return false if current_board.piece_by_position(current).nil?

    current_player.color == current_board.piece_by_position(current).color
  end

  def valid_target(current, target)
    return true if current_board.piece_by_position(current).moves.include?(target)

    puts 'Choose a valid move'
    false
  end

  def first_move_update(target)
    if [King, Rook, Pawn].include? current_board.piece_by_position(target).class
      current_board.piece_by_position(target).first_move = false
    end
  end

  def pawn_promotion
    (current_board.current_board[0] + current_board.current_board[7]).any? do |piece|
      if piece.instance_of?(Pawn)
        select_pawn_promotion(current_player, piece)
        current_player.pieces.delete(piece)
        update_game
      end
    end
  end
end




