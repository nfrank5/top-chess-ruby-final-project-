require_relative '../lib/queen'
require_relative '../lib/board'
require_relative '../lib/pawn'


describe Queen do
  describe '#valid_moves' do
    subject(:queen_valid_moves) { described_class.new('white') }
    let(:board_valid_moves) { instance_double(Board) }
    context 'when the new position is empty' do
      before do
      end
      xit 'push the new position to moves' do
      end
    end
  end
end