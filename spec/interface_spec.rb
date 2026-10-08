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
        allow(interface).to receive(:puts)
        allow(interface).to receive(:validate_input).and_return({
          FROM: {
            "KNIGHT": ["F", 1]
          },
          TO: {
            "KNIGHT": ["E", 3]
          }
        })
        expect(interface.input(screenshot: screenshot, test_mode: false)).to eq()
      end
    end
  end

  describe '#validate_input' do
    ### FUNCTION ACCEPTANCE SPECS

    # all this bellow this comment is supposed to go into the other helper function later...

    # test cases we must account for:
    # NOTE: take a piece syntax, is later transformed into MOVE TO syntax at the beggining of the function, but must be accounted for.

    # + PIECE not on specified place must return Logic Error & Mention Reason
    specify "PIECE not on specified place must return Logic Error & Mention Reason"
    # + PIECE to position that is not valid for that piece must return logic error.
    specify "PIECE to position that is not valid for that piece must return logic error."
    # + PIECE trying to go to a position where another piece (SAME COLOR) is at (invalid)
    specify "PIECE trying to go to a position where another piece (SAME COLOR) is at (invalid)"
    # + PIECE trying to move but it puts the king on check
    specify "PIECE trying to move but it puts the king on check"
    # + PIECE trying to take a PIECE that isn't there.
    specify "PIECE trying to take a PIECE that isn't there."
    # + PIECE trying to take a PIECE on the SAME TEAM/COLOR
    specify "PIECE trying to take a PIECE on the SAME TEAM/COLOR"
    # + PIECE trying to take a PIECE but move is not valid
    specify "PIECE not on specified place must return Logic Error & Mention Reason"

    context 'when on a new game with default configuration' do
      describe 'Pawn to e4' do
        it 'corretly evaluates "PAWN to E4"' do
          
        end
        it 'corretly evaluates "PAWN on E-FILE to E4"' do
          
        end
        it 'corretly evaluates "PAWN on RANK-4 to E4"' do
          
        end
      end
      describe 'knight' do
        describe 'Knight to g3' do
          it 'corretly evaluates "KNIGHT to G3"' do
            
          end
          it 'corretly evaluates "KNIGHT on G-FILE to G3" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on RANK-1 to G3" (error throw)' do
            
          end
        end
        describe 'Knight to e2' do
          it 'corretly evaluates "KNIGHT to E2" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on G-FILE to E2" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on RANK-1 to E2" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT takes PAWN on E-FILE" (error throw)' do
            
          end
        end
      end
      describe 'invalid moves' do
        describe 'invalid ranks' do
          it 'corretly evaluates "KNIGHT on RANK-99 to E2" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on RANK-1 to E0" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on RANK-99 to E100" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on RANK-A to EA" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on RANK-A to E0" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on RANK-1 to EA" (error throw)' do
            
          end
        end
        describe 'invalid files' do
          it 'corretly evaluates "KNIGHT takes PAWN on H-FILE" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on H-FILE to E2" (error throw)' do
            
          end
          it 'corretly evaluates "KNIGHT on Z-FILE to E2" (error throw)' do # different kind of problem then H-FILE
            
          end
          it 'corretly evaluates "PAWN on 0-FILE to E4"' do
            
          end
        end
        describe 'invalid syntax' do
          describe 'matchers' do  
            it 'corretly evaluates "PAWN shits-on E4"' do
              
            end
            it 'corretly evaluates "PAWN on E-FILE dumps E4"' do
              
            end
            it 'corretly evaluates "PAWN has-a-party-on RANK-4 all-the-way-to E4"' do # we are including the original matchers here, see if it has any effect
            
            end
            it 'correctly evaluates "PAWN A-FILE A4"' do
            
            end
          end
        end
        describe 'invalid pieces' do
          it 'correctly evaluates "PARROT to E3"' do
            
          end
        end
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
