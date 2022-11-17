require_relative '../lib/board'
require_relative '../lib/king'
require_relative '../lib/queen'
require_relative '../lib/player'


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
        expect(board_empty.empty?([0, 0])).to be false
      end
    end
  end

  describe '#enemy_piece?' do
    subject(:board_enemy_piece) { described_class.new }
    let(:queen_enemy_piece) { instance_double(Queen) }
    let(:king_enemy_piece) { instance_double(King) }
    context 'when the pieces are different color' do
      before do
        allow(queen_enemy_piece).to receive(:different_color?).and_return(true)
      end
      it 'returns true' do
        board_enemy_piece.current_board[0][0] = queen_enemy_piece
        board_enemy_piece.current_board[0][1] = king_enemy_piece
        expect(board_enemy_piece.enemy_piece?([0,0], [0,1])).to be true
      end
    end

    context 'when the pieces are the same color' do
      before do
        allow(queen_enemy_piece).to receive(:different_color?).and_return(false)
      end
      it 'returns false' do
        board_enemy_piece.current_board[0][0] = queen_enemy_piece
        board_enemy_piece.current_board[0][1] = king_enemy_piece
        expect(board_enemy_piece.enemy_piece?([0,0], [0,1])).to be false
      end
    end
  end

  describe '#outside_board?' do
    subject(:board_outside) { described_class.new }
    context "when the position is inside the board" do
      it "returns false" do
        expect(board_outside.outside_board?([3, 3])).to be false
      end
    end
    context "when the position is outside the board" do
      it "returns true" do
        expect(board_outside.outside_board?([8, 3])).to be true
      end
    end
  end

  describe '#check?' do
    subject(:board_check) { described_class.new }
    let(:player_one_check) { instance_double(Player) }
    let(:player_two_check) { instance_double(Player) }
    let(:queen_check) { instance_double(Queen) }
    let(:king_check) { instance_double(King) }

    context 'when the other player king is in the current player pieces moves' do
      before do
        allow(player_one_check).to receive(:pieces).and_return([queen_check])
        allow(player_two_check).to receive(:players_king).and_return(king_check)
        allow(player_one_check).to receive(:all_pieces_moves).and_return([[0, 4]])
        allow(king_check).to receive(:position).and_return([0, 4])
      end
      it 'returns true' do
        expect(board_check.check?(player_one_check, player_two_check)).to be true
      end
    end
  end

  describe '#winner?' do
    subject(:board_winner) { described_class.new }
    let(:player_winner) { instance_double(Player) }
    context 'when there is a winner' do
      xit 'returns true' do
        expect(board_winner.winner?(player_winner)).to be true
      end
    end
  end

end