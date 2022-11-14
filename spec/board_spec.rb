require_relative '../lib/board'

describe Board do
  describe '#empty?' do
    subject(:board_empty) { described_class.new }
    context 'when the space is empty' do
      it 'returns true' do
        expect(board_empty.empty?([0,0])).to be true
      end
    end

    context 'when the space is not empty' do
      before do
        board_empty.current_board[0][0] = 1
      end
      it 'returns false' do
        expect(board_empty.empty?([0,0])).to be false
      end
    end
  end

  describe '#can_be_taken?' do
    subject(:board_empty) { described_class.new }
    context 'when the pieces are different color' do
      it 'returns true' do
        expect(board_empty.empty?([0,0])).to be true
      end
    end

    context 'when the pieces are the same color' do
      before do
        board_empty.current_board[0][0] = 1
      end
      it 'returns false' do
        expect(board_empty.empty?([0,0])).to be false
      end
    end
  end
end