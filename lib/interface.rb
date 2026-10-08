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
    input = gets.chomp
  end
end