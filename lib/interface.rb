class Interface
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
    until input_state == true
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
  end
end