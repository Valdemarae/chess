module SaveLoad
  def save_game
    name = "#{@first_player.name} vs #{@second_player.name}"
    data_array = YAML.load_stream(File.read('saved_games/saved_data.yml'))
    changed = false
    data_array.each_with_index do |saved_data, index|
      if saved_data[:name] == name
        data_array[index][:board] = @board
        data = YAML.dump(data_array[0])
        File.open('saved_games/saved_data.yml', 'w') {|f| f.write data}
        changed = true
      end
    end
    if changed
      for i in 1...data_array.length do
        data = YAML.dump(data_array[i])
        File.open('saved_games/saved_data.yml', 'a') {|f| f.write data}
      end
    else
      data = YAML.dump({name: name, board: @board, player1: @first_player, player2: @second_player})
      File.open('saved_games/saved_data.yml', 'a') {|f| f.write data}
    end
    puts "\e[32mThe game has been saved and named as '#{name}'.\e[0m"
    puts "\e[32mNow you can type 'exit' and continue the game next time.\e[0m"
  end

  def load_game
    data_array = YAML.load_stream(File.read('saved_games/saved_data.yml'))
    data = get_game_data(data_array)
    @board = data[:board]
    @first_player = data[:player1]
    @second_player = data[:player2]
  end

  def get_game_data(data_array)
    data_array.each_with_index do |data, index|
      puts "[#{index + 1}] #{data[:name]}"
    end
    index = nil
    loop do
      print 'Choose your saved game number: '
      index = gets.chomp.to_i - 1
      break if index.between?(0, data_array.length - 1)
    end
    print_line
    data_array[index]
  end
end