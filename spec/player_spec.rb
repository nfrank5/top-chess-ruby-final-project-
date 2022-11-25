require_relative '../lib/player'

describe Player do
  describe '#player_input' do
    subject(:player_player_input) { described_class.new('white') }
    context 'when user input is wrong once and then fullfill regex' do
      before do
        allow(player_player_input).to receive(:gets).and_return('Wrong123!@#!@#', 'Correct')
      end
      it 'returns the user input' do
        error_message = 'Please insert correct info'
        regex = /^[A-Za-z]{3,7}$/
        expect(player_player_input).to receive(:puts).with(error_message).once
        expect(player_player_input.player_input(regex, error_message)).to eq('Correct')
      end
    end
  end

  describe '#remove_piece' do
    subject(:player_remove_piece) { described_class.new('white') }
    context 'when the piece has the position' do
      it 'removes it from the pieces array' do
        expect { player_remove_piece.remove_piece([7, 4]) }.to change(player_remove_piece.pieces, :count).by(-1)
      end
    end
  end

  describe '#all_pieces_moves' do
    subject(:player_all_pieces_moves) { described_class.new('white') }
    let(:king_all_pieces_moves) { instance_double(King, moves: [[1, 2], [3, 4]])}
    let(:queen_all_pieces_moves) { instance_double(Queen, moves: [[5, 6], [7, 8]])}

    context 'when the game begins' do
      before do
        allow(player_all_pieces_moves).to receive(:pieces).and_return([queen_all_pieces_moves, king_all_pieces_moves])

      end
      it 'returns the sum off all potential moves of the pieces' do
        expect(player_all_pieces_moves.all_pieces_moves).to match([[1, 2], [3, 4], [5, 6], [7, 8]])
      end
    end
  end
end
