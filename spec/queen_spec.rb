require_relative '../lib/queen'

describe Queen do
  describe '#valid_moves' do
    subject(:queen_valid_moves) { described_class.new('white') }
    let(:board_valid_moves) { Board.new }
    context 'when the Board is empty' do
      it 'returns the correct array of valid moves' do
        queen_valid_moves.valid_moves(board_valid_moves)
        expect(queen_valid_moves.moves).to match_array([[7, 4], [7, 5],[7, 6],[7, 7],[0, 3], [1, 3], [2, 3], [3, 3], [3, 7], [4, 0], [4, 3], [4, 6], [5, 1], [5, 3], [5, 5], [6, 2], [6, 3], [6, 4], [7, 0], [7, 1], [7, 2]])
      end
    end
  end
end