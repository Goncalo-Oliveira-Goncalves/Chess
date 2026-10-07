require_relative "../lib/interface"

RSpec.describe Interface do
  let(:interface) { Interface.new() }

  describe '#input' do
    # make sure to test for P1 and P2
    context 'when it is P1\'s turn' do
      let(:turn) { 0 }
      let(:players) { {
        1 => "White",
        2 => "Black"
      } }
      let(:screenshot) { double("Screenshot") }

      before do
        # define screenshot double
      end

      it 'receives the data correctly from GameObject' do
        test_data = ["do later"]
        expect(interface.input(current_turn: turn, player_hash: players, screenshot: last_screenshot, test_mode: true)).to receive(:p).with(test_data)
      end
      it 'asks for the correct user to input' do
        expect(subject).to matcher
      end
      it 'correctly handles a syntatically incorrect input case' do
        # e.g: inputs "Hello", instead of: 
      end
      it 'correctly handles a logically incorrect (game logic) input case' do
        # e.g: moves horse like a bishop.
      end
      context 'when on a new game with default configuration' do
        it 'corretly captures the "KNIGHT to F3" input' do
          
        end
        it 'corretly captures the "KNIGHT on B-FILE to F3" input' do
          
        end
        it 'corretly captures the "PAWN on B-FILE to B3" input' do
          
        end
        it 'corretly captures the "PAWN on B-FILE to B4" input' do
          
        end
        it 'it reprompts when impossible to do the move "QUEEN to F7" input' do
          
        end
      end
      context 'when in the middle of a game with a non default configuration' do
        # put game state here to test stuff out with queen, bishop and rook.
      
        it 'corretly captures the "QUEEN to F7" input' do
          
        end
        it 'corretly captures the "ROOK to A1" input' do
          
        end
        it 'it reprompts when move possible by many pieces, asking for more info "ROOK to F1" input' do
          
        end
      end
      
      it 'sends the input correctly to GameObject' do
        
      end
    end
  end

  describe '#display_status' do
    # function needed arguments:
    # + last_screenshot
    # + turn
    # + players hash
    # + win_state

    context 'when called' do
      it 'grabs the Screenshot, and turns it into the string of the board correctly' do
        # seperate internal function "display_board(screenshot)"
      end
      it 'grabs the next player to have a turn' do
        # direct argument operation done *in-function* (@turn & @players, from GameState)
      end
      it 'shows the 50-move-rule counter' do
        # seperate internal function "display_50_moves(screenshot)"
      end
      it 'displays the win state correctly' do
        # seperate internal function "display_win_state(win_state)"
      end
    end
    
  end
end
