require_relative './utilities'

class Board
  ROWS = 8
  COLUMNS = 8
  include Utilities
  attr_accessor :current_board

  def initialize(board = Array.new(ROWS) { Array.new(COLUMNS) })
    @current_board = board
  end

  def empty?(destiny)
    @current_board[destiny[0]][destiny[1]].nil?
  end

  def all_empty?(squares)
    squares.all? do |square|
      empty?(square)
    end
  end

  def enemy_piece?(origin, destiny)
    return false if piece_by_position(destiny).nil?

    piece_by_position(origin).different_color?(piece_by_position(destiny))
  end

  def outside_board?(new_position)
    !new_position[0].between?(0, 7) || !new_position[1].between?(0, 7)
  end

  def piece_by_position(position)
    current_board[position[0]][position[1]]
  end

  def check?(checker, checked)
    return true if checker.all_pieces_moves.include?(checked.players_king.position)

    false
  end

  def update_board(player)
    player.pieces.each do |piece|
      current_board[piece.position[0]][piece.position[1]] = piece
    end
  end

  def print_board
    puts '   0 1 2 3 4 5 6 7'
    @current_board.each_with_index do |row, i|
      if i.even?
        puts "#{i}  "+"#{format_square(row[0])}".bg_green + "#{format_square(row[1])}".bg_blue + "#{format_square(row[2])}".bg_green+"#{format_square(row[3])}".bg_blue + "#{format_square(row[4])}".bg_green + "#{format_square(row[5])}".bg_blue + "#{format_square(row[6])}".bg_green+"#{format_square(row[7])}".bg_blue
      else
        puts "#{i}  "+"#{format_square(row[0])}".bg_blue + "#{format_square(row[1])}".bg_green + "#{format_square(row[2])}".bg_blue+"#{format_square(row[3])}".bg_green + "#{format_square(row[4])}".bg_blue+"#{format_square(row[5])}".bg_green + "#{format_square(row[6])}".bg_blue + "#{format_square(row[7])}".bg_green
      end
    end
    puts "\n\t"
  end

  def format_square(piece)
    !piece.nil? ? "#{piece.unicode} " : '  '
  end

end
