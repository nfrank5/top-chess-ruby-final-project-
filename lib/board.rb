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

  def can_be_taken?(origin, destiny)
    @current_board[origin[0]][origin[1]].different_color?(current_board[destiny[0]][destiny[1]])
  end

  def outside_board?(new_position)
    !new_position[0].between?(0, 7) || !new_position[1].between?(0, 7)
  end


  def winner?(current_player)



  end

  def check?(current_player, other_player)
    all_pieces_moves = []
    current_player.pieces.each do |piece|
      all_pieces_moves = piece.moves | all_pieces_moves
      
    end
    return true if all_pieces_moves.include?(other_player.players_king.position)

    false
  end


  def print_board
    puts '   0 1 2 3 4 5 6 7'
    @current_board.each_with_index do |row, i|
      if i.even?
        puts "#{i}  "+"#{format_square(row[0])}".bg_blue + "#{format_square(row[1])}".bg_green + "#{format_square(row[2])}".bg_blue+"#{format_square(row[3])}".bg_green + "#{format_square(row[4])}".bg_blue+"#{format_square(row[5])}".bg_green + "#{format_square(row[6])}".bg_blue + "#{format_square(row[7])}".bg_green
      else
        puts "#{i}  "+"#{format_square(row[0])}".bg_green + "#{format_square(row[1])}".bg_blue + "#{format_square(row[2])}".bg_green+"#{format_square(row[3])}".bg_blue + "#{format_square(row[4])}".bg_green + "#{format_square(row[5])}".bg_blue + "#{format_square(row[6])}".bg_green+"#{format_square(row[7])}".bg_blue
      end
    end
    puts "\n\t"
  end

  def format_square(piece)
    !piece.nil? ? "#{piece.unicode} " : '  '
  end

end
