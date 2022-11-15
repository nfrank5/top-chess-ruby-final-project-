require_relative '../lib/piece'
require_relative '../lib/king'


describe Piece do
  describe '#different_color?' do
    subject(:piece_different_color) { described_class.new('white',"\u2655",[7, 3]) }
    let(:king_different_color) { instance_double(King) }
    context 'when the two pieces are different color' do
      before do
        allow(king_different_color).to receive(:color).and_return('black')
      end
      it 'returns true' do
        expect(piece_different_color.different_color?(king_different_color)).to be true
      end
    end

    context 'when the two pieces are same color' do
      before do
        allow(king_different_color).to receive(:color).and_return('white')
      end
      it 'returns false' do
        expect(piece_different_color.different_color?(king_different_color)).to be false
      end
    end
  end

  describe '#update_new_position?' do
    subject(:piece_update_new_position) { described_class.new('white',"\u2655",[7, 3]) }
    context 'when the current position is [3, 3]' do
      it 'returns the sum of the direction and the current position [4, 4]' do
        expect(piece_update_new_position.update_new_position([3, 3],[1, 1])).to match_array([4, 4])
      end
    end
  end
  

end