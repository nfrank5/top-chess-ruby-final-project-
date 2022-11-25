require_relative '../lib/game'

describe Game do
  describe '#moving_pieces' do
    subject(:game_moving_pieces) { described_class.new }
    context 'when there is a winner' do
      before do
        allow(game_moving_pieces).to receive(:stop_game?).and_return('winner')
      end
      it 'breaks the loop' do
        expect(game_moving_pieces).not_to receive(:input_move)
        game_moving_pieces.moving_pieces
      end
    end

    context 'when the game is saved' do
      let(:board_moving_pieces) { instance_double(Board) }
      before do
        game_moving_pieces.instance_variable_set(:@current_board, board_moving_pieces)
        allow(game_moving_pieces).to receive(:input_move).and_return([6, 4], 'save')
        allow(game_moving_pieces).to receive(:stop_game?).and_return(false)
        allow(game_moving_pieces).to receive(:save_games).and_return(false, true)
        allow(board_moving_pieces).to receive(:print_board)
      end
      it 'breaks the loop' do
        expect(game_moving_pieces).to receive(:move).once
        game_moving_pieces.moving_pieces
      end
    end
  end
  
  describe '#pawn_promotion' do
    subject(:game_pawn_promotion) { described_class.new }
    let(:player_pawn_promotion) { instance_double(Player) }
    let(:pawn_pawn_promotion) { instance_double(Pawn) }

    context 'when there is a pawn in the last row' do
      before do
        game_pawn_promotion.instance_variable_set(:@current_player, player_pawn_promotion)
        allow(game_pawn_promotion).to receive(:verify_pawns_in_last_row).and_return(pawn_pawn_promotion)
        allow(player_pawn_promotion).to receive(:promoted_pawn_creation)
      end
      it 'calls the promoted_pawn_creation method on the current player' do
        expect(player_pawn_promotion).to receive(:promoted_pawn_creation).once
        game_pawn_promotion.pawn_promotion
      end
    end
 
    context "when there isn't a pawn in the last row" do
      before do
        game_pawn_promotion.instance_variable_set(:@current_player, player_pawn_promotion)
        allow(game_pawn_promotion).to receive(:verify_pawns_in_last_row).and_return(false)
        allow(player_pawn_promotion).to receive(:promoted_pawn_creation)
      end
      it "doesn't call the promoted_pawn_creation method on the current player" do
        expect(player_pawn_promotion).not_to receive(:promoted_pawn_creation)
        game_pawn_promotion.pawn_promotion
      end
    end
  end

  describe '#verify_pawns_in_last_row' do 
    subject(:game_verify_pawns_in_last_row) { described_class.new }
    let(:pawn_verify_pawns_in_last_row) { instance_double(Pawn) }
    context 'when there is a pawn in the last row' do
      before do
        allow(game_verify_pawns_in_last_row).to receive(:top_and_bottom_rows).and_return([pawn_verify_pawns_in_last_row])
        allow(pawn_verify_pawns_in_last_row).to receive(:instance_of?).and_return(true)
      end
      it 'returns the pawn' do
        expect(game_verify_pawns_in_last_row.verify_pawns_in_last_row).to be pawn_verify_pawns_in_last_row
      end
    end

    context 'when there is a no pawn in the last row' do
      before do
        allow(game_verify_pawns_in_last_row).to receive(:top_and_bottom_rows).and_return([nil, nil])
      end
      it 'returns false' do
        expect(game_verify_pawns_in_last_row.verify_pawns_in_last_row).to eql(false)
      end
    end
  end
end
