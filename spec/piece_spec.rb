require_relative '../lib/piece'
require_relative '../lib/king'


describe Piece do
  describe '#different_color?' do
    subject(:piece_different_color) { described_class.new('white',"\u2655",[7, 3]) }
    #let(:queen_different_color) { instance_double(Queen) }
    let(:king_different_color) { instance_double(King) }
    context 'when the two pieces are different color' do
      before do
        #allow(queen_different_color).to receive(:color).and_return('white')
        allow(king_different_color).to receive(:color).and_return('black')
      end
      it 'returns true' do
        expect(piece_different_color.different_color?(king_different_color)).to be true
      end
    end

    context 'when the two pieces are same color' do
      before do
        #allow(queen_different_color).to receive(:color).and_return('white')
        allow(king_different_color).to receive(:color).and_return('white')
      end
      it 'returns false' do
        expect(piece_different_color.different_color?(king_different_color)).to be false
      end
    end
  end

end