require_relative './utilities'
require_relative './king'
require_relative './queen'

class Player
  include Utilities

  attr_reader :color, :pieces, :name

  def initialize(color)
    @color = color
    @name = nil
    @pieces = [King.new(color), Queen.new(color)]
  end

  def players_name
    puts "Insert name of #{color} player"
    @name = player_input(/^[A-Za-z0-9]{3,10}$/, 'Please insert a alphanumeric name between 3 and 10 characters')
  end

  def players_king
    pieces.each do |piece|
      return piece if piece.instance_of(King)
    end
  end
end