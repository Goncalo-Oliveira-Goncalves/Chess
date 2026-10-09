require_relative "../lib/interface"

RSpec.describe Interface do
  let(:interface) { Interface.new() }

  describe '#input' do
    # make sure to test for P1 and P2
    context 'when it is P1\'s turn' do
      let(:turn) { 0 }
      let(:players) { {
        0 => { 
          "NAME" => "Tony Robbings",
          "COLOR" => "RED" 
        },
        1 => {
          "NAME" => "Yellow Kid",
          "COLOR" => "YELLOW"
        }
      } }
      let(:screenshot) { double("Screenshot") }

      before do
        # define screenshot double
        allow(screenshot).to receive(:to_s).and_return(
          "<Screenshot:ID @turn=#{turn} @players=#{players} @board=[<Piece:ID ...>, ...]>"
        )
        allow(screenshot).to receive(:turn).and_return(
          turn
        )
        allow(screenshot).to receive(:players).and_return(
          players
        )
      end

      it 'receives the data correctly from GameObject', focus: true do
        allow(interface).to receive(:validate_input).and_return(true)
        test_output = "\nCURRENT TURN: #{screenshot.turn}\nPLAYER HASH: " + screenshot.players.to_s + "\nSCREENSHOT: " + screenshot.to_s + "\n\nTEST MODE? ACTIVE"
        allow(interface).to receive(:puts)
        expect(interface).to receive(:puts).with(test_output).ordered
        interface.input(screenshot: screenshot, test_mode: true)
      end
      it 'asks for the correct user to input' do
        allow(interface).to receive(:validate_input).and_return(true)
        player_text_output = "Tony Robbings \e[31m(P1)\e[0m Please Move:\n\n"
        expect(interface).to receive(:puts).with(player_text_output)
        interface.input(screenshot: screenshot, test_mode: false)
      end
      it 'correctly handles a syntatically incorrect input case' do
        # e.g: inputs "Hello", instead of right input
        allow(interface).to receive(:gets).and_return("Hello")
        allow(interface).to receive(:validate_input).and_return("ERR_SYNTAX", true)
        allow(interface).to receive(:puts)
        expect(interface).to receive(:puts).with("Syntax Error. Try again or type 'Help' for Syntax Info\n\n")
        interface.input(screenshot: screenshot, test_mode: false)  
      end
      describe 'when you type' do
        help_text = <<~TEXT
        The Syntax is as follows: 'PIECE to FILERANK'
        (e.g: KNIGHT to F3)
        
        If multiple pieces of same type can move to that position, specify.
        (e.g: KNIGHT on B-FILE to F3)
        
        You can also specify pieces to take instead of positions.
        (e.g: KNIGHT takes PAWN on B-FILE)
        
        To perform a Castle or En Passant, simply pass the position you want the piece to move to."
        TEXT

        before do
          allow(interface).to receive(:puts)
          allow(interface).to receive(:validate_input).and_return("HELP", true)
        end

        specify '"help", it helps with syntax' do
          allow(interface).to receive(:gets).and_return("help")
          expect(interface).to receive(:puts).with(help_text)
        end
        specify '"HELP", it helps with syntax' do
          allow(interface).to receive(:gets).and_return("HELP")
          expect(interface).to receive(:puts).with(help_text)
        end
        specify '"Help", it helps with syntax' do
          allow(interface).to receive(:gets).and_return("Help")
          expect(interface).to receive(:puts).with(help_text)
        end

        after do
          interface.input(screenshot: screenshot, test_mode: false)
        end
        
      end  
      it 'returns game logic error, when wrong by game logic:' do
        # e.g: moves horse like a bishop.
        allow(interface).to receive(:puts)
        allow(interface).to receive(:validate_input).and_return("ERR_GAMELOGIC", true)
        expect(interface).to receive(:puts).with("Game Logic Error. Move Invalid. Please confirm input.\n\n")
        interface.input(screenshot: screenshot, test_mode: false)
      end
      
      it 'sends the input correctly to GameObject' do
        move_hash = {
          ""
        }

        allow(interface).to receive(:validate_input).and_return(move_hash, true)
        expect(interface.input(screenshot: screenshot, test_mode: false)).to eq(move_hash)
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
