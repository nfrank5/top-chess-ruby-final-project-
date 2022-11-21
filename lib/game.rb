require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/utilities'

TOWER_MOVE_FOR_CASTLING = { [0, 2] => [[0, 0], [0, 3]],
                            [0, 6] => [[0, 7], [0, 5]],
                            [7, 2] => [[7, 0], [7, 3]],
                            [7, 6] => [[7, 7], [7, 5]] }.freeze
PASSING_KING_SQUARES_CASTLING = { [0, 2] => [0, 3],
                                  [0, 6] => [0, 5],
                                  [7, 2] => [7, 3],
                                  [7, 6] => [7, 5] }.freeze

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
    clear_screen
    update_game
    current_board.print_board
    type_of_end = moving_pieces
    ending(type_of_end)
  end

  def introduction
    1
  end

  def moving_pieces
    until winner_stalemate? do
      successful_move = false
      until successful_move
        current_position_and_target = input_move
        successful_move = move(current_position_and_target[0], current_position_and_target[1])
      end
      first_move_update(current_position_and_target[1])
      active_en_passant(current_position_and_target[1])
      update_game
      pawn_promotion
      switch_turn
      clear_screen
      puts "#{current_player.color.capitalize} King is in Check!" if current_board.check?(other_player, current_player)
      current_board.print_board
    end
    winner_stalemate?
  end

  def winner_stalemate?

    current_player.pieces.each do |piece|
      piece.moves.each do |move|
        current = piece.position
        temp = switch_positions(current, move)
        update_game
        there_is_no_scape = current_board.check?(other_player, current_player)
        undo_switch_positions(current, move, temp, true)
        update_game

        return false unless there_is_no_scape
      end
    end
    current_board.check?(other_player, current_player) ? 'winner' : 'stalemate'
  end

  def input_move
    puts "#{current_player.name} choose a piece and move it selecting its origin and destiny" 
    puts 'For example 64 44, write the row first and then column'
    current_position_and_target = player_input(/^[0-7]{2} {1,3}[0-7]{2}$/, 'Please insert your move using two digits followed by a space and then two more digits')
    format_input_move(current_position_and_target)
  end

  def format_input_move(current_position_and_target)
    current_position_and_target.split(' ').inject([]) do |formatted, str| 
      str = str.split('') 
      formatted.push([str[0].to_i, str[1].to_i])
    end
  end


  def ending(type_of_end)
    puts type_of_end == 'winner' ? "Ending: #{other_player.name} won!" : 'Stalemate'
  end

  def move(current, target)
    castling = attempting_castling?(current, target)
    en_passant = attempting_en_passant?(current, target)
    if valid_en_passant?(current, target) && valid_move?(current, target) && valid_castling?(current, target) 
      temp = switch_positions(current, target)
      update_game
      unless current_board.check?(other_player, current_player)
        switch_positions(TOWER_MOVE_FOR_CASTLING[target][0], TOWER_MOVE_FOR_CASTLING[target][1]) if castling
        remove_en_passant_pawn(target) if en_passant
        return true
      end
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

  def valid_castling?(current, target)
    if attempting_castling?(current, target) && (current_board.check?(other_player, current_player) ||
                           other_player.all_pieces_moves.include?(PASSING_KING_SQUARES_CASTLING[target]))
      puts 'Invalid castling'
      return false
    end
    true
  end

  def attempting_en_passant?(current, target)
    return false unless current_board.piece_by_position(current).instance_of?(Pawn) &&
                        (current[1] - target[1]).abs == 1 &&
                        current[0] == (current_player.color == 'white' ? 3 : 4) &&
                        target[0] == (current_player.color == 'white' ? 2 : 5) &&
                        current_board.piece_by_position(target).nil?

    true
  end

  def valid_en_passant?(current, target)
    return false if attempting_en_passant?(current, target) && !current_board.piece_by_position(current).en_passant

    true
  end

  def remove_en_passant_pawn(target)
    other_player.remove_piece([other_player.color == 'black' ? 3 : 4, target[1]])
    current_board.current_board[other_player.color == 'black' ? 3 : 4][target[1]] = nil
  end

  def valid_move?(current, target)
    return true if correct_player_piece_color(current) && valid_target(current, target) && !current_board.piece_by_position(current).nil?

    puts "#{current_player.name}, you are #{current_player.color}"
    puts 'Choose a piece of your color'
    false
  end

  def attempting_castling?(current, target)
    current_board.piece_by_position(current).class
    return true if current_board.piece_by_position(current).instance_of?(King) && (current[1] - target[1]).abs > 1

    false
  end

  def switch_positions(current, target)
    current_board.piece_by_position(current).position = target
    other_player.remove_piece(target)
    current_board.current_board[current[0]][current[1]] = nil
    current_board.piece_by_position(target)
  end

  def undo_switch_positions(current, target, temp, checkin_for_winner = false)
    puts 'You can\'t move there: Check!' unless checkin_for_winner
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

  def active_en_passant(target)
    clean_previous_en_passant
    current_board.current_board[current_player.color == 'black' ? 3 : 4].each do |piece|
      if current_player.color == 'black' && !piece.nil? && piece.color == 'white' && piece.instance_of?(Pawn)
        if current_board.piece_by_position(target).instance_of?(Pawn) && target[0] == 3 
          if current_board.piece_by_position([3, target[1] - 1]).instance_of?(Pawn) &&
             current_board.piece_by_position([3, target[1] - 1]).color == 'white'
            current_board.piece_by_position([3, target[1] - 1]).en_passant = [2, target[1]]
          end
          if current_board.piece_by_position([3, target[1] + 1]).instance_of?(Pawn) &&
             current_board.piece_by_position([3, target[1] + 1]).color == 'white'
            current_board.piece_by_position([3, target[1] + 1]).en_passant = [2, target[1]]
          end
        end
      end 

      if current_player.color == 'white' && !piece.nil? && piece.color == 'black' && piece.instance_of?(Pawn)
        if current_board.piece_by_position(target).instance_of?(Pawn) && target[0] == 4
          if current_board.piece_by_position([4, target[1] - 1]).instance_of?(Pawn) &&
             current_board.piece_by_position([4, target[1] - 1]).color == 'black'
            current_board.piece_by_position([4, target[1] - 1]).en_passant = [5, target[1]]
          end
          if current_board.piece_by_position([4, target[1] + 1]).instance_of?(Pawn) &&
             current_board.piece_by_position([4, target[1] + 1]).color == 'black'
            current_board.piece_by_position([4, target[1] + 1]).en_passant = [5, target[1]]
          end
        end
      end
    end
  end

  def clean_previous_en_passant
    current_board.current_board.each do |row|
      row.each do |piece|
        piece.en_passant = false if piece.instance_of?(Pawn)
      end
    end
  end

  def pawn_promotion
    (current_board.current_board[0] + current_board.current_board[7]).any? do |piece|
      if piece.instance_of?(Pawn)
        selected = false
        puts 'Select a Rook, Bishop, Queen or Knight'
        until selected do
          promote_to = player_input(/^[a-z]{4,6}$/i, "#{current_player.name} write the name of a piece to promote your pawn")
          gets
          case promote_to.downcase
          when 'rook'
            current_player.pieces.push(Rook.new(current_player.color, piece.position))
            selected = true
          when 'knight'
            current_player.pieces.push(Knight.new(current_player.color, piece.position))
            selected = true
          when 'queen'
            current_player.pieces.push(Queen.new(current_player.color, piece.position))
            selected = true
          when 'bishop'
            current_player.pieces.push(Bishop.new(current_player.color, piece.position))
            selected = true
          else
            selected == false
          end
          current_player.pieces.delete(piece)
          update_game
        end
      end
    end

  end
end




