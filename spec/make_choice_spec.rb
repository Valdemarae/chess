require_relative '../lib/game'

describe Game do
  subject(:game) {described_class.new}

  before do
    allow(game).to receive(:puts)
    allow(game).to receive(:print)
  end
  
  describe '#new_or_existing_game' do
    context 'when invalid inputs' do
      before do
        allow(game).to receive(:gets).and_return('5', '0', '2')
      end

      it 'loops until valid intput is given' do
        expect(game).to receive(:print).with('Choose number: ').thrice
        game.new_or_existing_game
      end
    end

    context 'when new game is chosen' do
      before do
        allow(game).to receive(:gets).and_return('1')
      end

      it 'returns nil' do
        expect(game.new_or_existing_game).to eq(nil)
        game.new_or_existing_game
      end
    end

    context 'when load game is chosen' do
      before do
        allow(game).to receive(:gets).and_return('2')
      end

      it 'returns \'existing\'' do
        expect(game.new_or_existing_game).to eq('existing')
        game.new_or_existing_game
      end
    end
  end

  describe '#choose_enemy' do
    context 'when invalid inputs' do
      before do
        allow(game).to receive(:gets).and_return('5', '0', '1')
      end

      it 'loops until valid intput is given' do
        expect(game).to receive(:print).with('Choose number: ').thrice
        game.choose_enemy
      end
    end

    context 'when friend is chosen' do
      before do
        allow(game).to receive(:gets).and_return('1')
      end

      it 'returns \'Friend\'' do
        expect(game.choose_enemy).to eq('Friend')
        game.choose_enemy
      end
    end

    context 'when computer is chosen' do
      before do
        allow(game).to receive(:gets).and_return('2')
      end

      it 'returns \'Computer\'' do
        expect(game.choose_enemy).to eq('Computer')
        game.choose_enemy
      end
    end
  end

  describe '#get_pawn_promotion_piece' do
    context 'when invalid inputs' do
      before do
        allow(game).to receive(:gets).and_return('5', 'kingdom', 'Harley', 'queen')
      end

      it 'loops until valid intput is given' do
        expect(game).to receive(:puts).with('Wrong input! Try again!').thrice
        game.get_pawn_promotion_piece
      end
    end
  end
end