class Interface
  public

  def input(
    screenshot:,
    test_mode: false
  )
    if test_mode
      puts "\nCURRENT TURN: #{screenshot.turn}\nPLAYER HASH: " + screenshot.players.to_s + "\nSCREENSHOT: " + screenshot.to_s + "\n\nTEST MODE? ACTIVE"
    end

    # make global variable later...
    colors = {
      "RESET" => "\e[0m",
      "RED" => "\e[31m",
      "YELLOW" => "\e[33m"
    }

    player_to_play = screenshot.turn % screenshot.players.length
    player_data = screenshot.players[player_to_play]

    puts "#{player_data["NAME"]} #{colors[player_data["COLOR"]]}(P#{player_to_play+1})#{colors["RESET"]} Please Move:\n\n"
    print "→ "
    input = gets.chomp

    input_state = validate_input(input, screenshot)
    until Hash === input_state
      if input_state == "HELP"
        puts <<~TEXT
        The Syntax is as follows: 'PIECE to FILERANK'
        (e.g: KNIGHT to F3)
        
        If multiple pieces of same type can move to that position, specify.
        (e.g: KNIGHT on B-FILE to F3)
        
        You can also specify pieces to take instead of positions.
        (e.g: KNIGHT takes PAWN on B-FILE)
        
        To perform a Castle or En Passant, simply pass the position you want the piece to move to."
        TEXT
      end
      if input_state == "ERR_SYNTAX"
        puts "Syntax Error. Try again or type 'Help' for Syntax Info\n\n"
      end
      if input_state == "ERR_GAMELOGIC"
        puts "Game Logic Error. Move Invalid. Please confirm input.\n\n"
      end
      print "→ "
      input = gets.chomp
      input_state = validate_input(input, screenshot)
    end

    return validate_input(input)
  end

  private

  def validate_input(input, board)
    # First thing we must do to tackle this is to think of possible inputs:
    # 
    # KNIGHT to F3
    # KNIGHT on B-FILE to F3
    # KNIGHT on RANK-2 to F3
    # KNIGHT on B2 to F3
    #
    # NOTE: assumes piece stops when other piece is consumed, do a check on functionality of the subclass before this
    # KNIGHT takes PAWN on B-FILE
    # KNIGHT takes PAWN on RANK-2
    # KNIGHT takes PAWN (if only one KNIGHT can eat one PAWN)
    # KNIGHT on RANK-2 takes PAWN
    # KNIGHT on B-FILE takes PAWN
    # KNIGHT on B-FILE takes PAWN on RANK-2

    # From these examples, I can make the following templates:
    # + "ON" TEMPLATE
    #   + "on X-FILE"
    #   + "on Y-RANK"
    #   + Behavior: filters results of PIECE mentioned RIGHT BEFORE this.
    # + "TO" TEMPLATE
    #   + "to F3"
    #   + Behavior: gives hash output to rest of expression. ALWAYS at the end.
    # + "TAKES" TEMPLATE
    #   + "takes PIECE"
    #   + Behavior: gives hash output to rest of expression if alone. 
    #     Else filters possibilities and is chained up with other expressions.
    #
    # PIECE is not a template. It is a filter. So if we give the whole board, we want an ENUM of the KNIGHTS.
    # The templates then filter these expressions, until we obtain one result on the enum at the end of the expression.
    # If there are more then one option available we return an error.
    # Anything wrong in the middle of the expression returns an error aswell.
    #
    # This should ideally return a modification hash. So we can combine the input hash function with the validate_input function.
    # And make it more efficient... If you are reading this, and no #input_to_hash function exists. Now you know I was planning to make them
    # seperate.

    # since each thing that is happening is seperated by a space:
    command_array = input.split(' ')

    # modify command array to make it easier to work with:
    command_array = command_array.map do |command|
      case
        when command.include?("FILE")
          unless ("A".."H").include?(command[0])
            puts "GAMELOGIC ERR: Invalid FILE - #{command}"
            return "ERR_GAMELOGIC"
          end

          # only the first letter
          # B-FILE -> B
          command[0]
        when command.include?("RANK")
          unless ("1".."8").include?(command[-1])
            puts "GAMELOGIC ERR: Invalid RANK - #{command}"
            return "ERR_GAMELOGIC"
          end

          # only the digit
          # RANK-7 -> 7
          command[-1].to_i
      end
    end

    command_array.reduce(command_array) do |acc, command|
      case
        when command == "Help" # how do we say help in any form, as in HELP, help or Help or even helP?
          return "HELP"
        when command == "on"
          # Board is a HashMap, here's the board:
          # {
          #   "a1" => nil,
          #   "a2" => piece_object,
          #   ...
          #   "h8" => nil
          # }
          acc = board.filter do |piece|
            if ("A".."H").include?(next_command)
              piece.position[:FILE] == next_command
              # find a way to skip next command
            elsif ("1".."8").include?(next_command)
              piece.position[:RANK] == next_command
              # find a way to skip next command
            else
              puts "UNKNOWN ERROR"
            end
          end
        when command == "to"
          acc.each do |piece|
            if piece.available_positions.include?(next_command)
              return true
            end
          end
          puts "GAME LOGIC ERR: Position piece wanted to go: Not Permited for Said Piece Class: #{"find a way to print piece class"}"
          return "ERR_GAMELOGIC"
        when command == "takes"
          unless board.any? {|piece| next_command_subclass === piece}
            puts "GAME LOGIC ERR: Piece #{next_command_subclass} cannot be found on board"
          end

          get_all_targets = board.filter do |piece|
            next_command_subclass === piece # I have a string with the name of a subclass in all caps, how do I compare it?            
          end
          # we only want their position
          get_all_targets = get_all_tagets.map do |piece|
            piece.position
          end


          filtered_acc = acc.filter do |piece|
            if piece == last_command_subclass # I have a string with the name of a subclass in all caps, how do I compare it?
              true if piece.available_positions.any? {|position| get_all_targets.include?(position)}
            end
          end
          unless filtered_acc.length == 0
            puts "GAME LOGIC ERR: No #{last_command_subclass} can directly take a #{next_command_subclass} piece."
            return "ERR_GAMELOGIC"
          end

          return true if filtered_acc.length == 1
          acc = filtered_acc # else
      end
    end
  end

  def input_to_hash(input)
    # e.g: KNIGHT to F3 becomes:
    # {
    #   FROM: {
    #   "KNIGHT": ["F", 1]
    #   }
    #   TO: {
    #     "KNIGHT": ["E", 3]
    #   }
    # }
    # 
    # Note: it has another hash for en passent and castling scenarious (plus any custom ones.):
    # 
    # CASTLING:
    # {
    #   FROM: {
    #     "KING": ["E", 8]
    #     "ROOK": ["H", 8]
    #   }
    #   TO: {
    #     "KING": ["G", 8]
    #     "ROOK": ["F", 8]
    #   }
    # }
    # 
    # EN PASSENT:
    # {
    #   FROM: {
    #     "PAWN": ["D", 5]
    #     "PAWN": ["E", 5]
    #   }
    #   TO: {
    #     "PAWN": ["E", 4]
    #     "PAWN": nil
    #   }
    # }
    # 
    # NOTE: Nil represents pieces "OUT OF THE BOARD"
  end
end