require_relative '../lib/king'

describe King do
  describe '#valid_moves' do
    subject(:king_valid_moves) { described_class.new('white') }
    let(:board_valid_moves) { Board.new }
    context 'when the Board is empty' do
      it 'returns the correct array of valid moves' do
        king_valid_moves.valid_moves(board_valid_moves)
        expect(king_valid_moves.moves).to match_array([[6, 3], [6, 4], [6, 5], [7, 3], [7, 5]])
      end
    end
  end
end